FROM wearepvtl/php-fpm-7.0:latest

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Setup user (to stay in-sync with the host system's user)
ARG CUSTOM_USER_NAME
ARG CUSTOM_UID
ARG CUSTOM_GID
RUN groupadd -g ${CUSTOM_GID} ${CUSTOM_USER_NAME} \
  && useradd -m -u ${CUSTOM_UID} -g ${CUSTOM_USER_NAME} -G sudo ${CUSTOM_USER_NAME} \
  && passwd -d ${CUSTOM_USER_NAME} \
  && echo "${CUSTOM_USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Aliases
RUN echo "alias artisan='php artisan'" >> /home/${CUSTOM_USER_NAME}/.bashrc \
  && echo "alias magento='php bin/magento'" >> /home/${CUSTOM_USER_NAME}/.bashrc

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/.gitkeep ./conf/custom.ini* /usr/local/etc/php/conf.d/zzb-custom.ini

# Update permissions for supervisor and cron
RUN chown ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /etc/supervisor/supervisord.pid \
  && chmod gu+rw /var/run \
  && chmod gu+s /usr/sbin/cron

# Copy and run custom scripts
# Copy and enable CRON/s
COPY ./70/Dockerfile ./70/custom_crontab* ./70/custom_scripts* /root/
RUN /usr/bin/crontab -u ${CUSTOM_USER_NAME} /root/custom_crontab
RUN chmod +x /root/custom_scripts
ARG RUN_CUSTOM_SCRIPT_CMD="bash -c '/root/custom_scripts'"
RUN if [ -f /root/custom_scripts ]; then $RUN_CUSTOM_SCRIPT_CMD; fi

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
