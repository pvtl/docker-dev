FROM wearepvtl/php-fpm-7.3:latest

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
COPY ./73/Dockerfile ./73/custom_crontab* ./73/custom_scripts* /root/
RUN /usr/bin/crontab -u ${CUSTOM_USER_NAME} /root/custom_crontab
RUN if [ -f /root/custom_scripts ]; then chmod +x /root/custom_scripts; fi
RUN if [ -f /root/custom_scripts ]; then bash -c '/root/custom_scripts'; fi

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
