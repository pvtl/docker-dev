FROM wearepvtl/php-fpm-5.6

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Setup user (to stay in-sync with the host system's user)
ARG CUSTOM_USER_NAME
ARG CUSTOM_USER_ID
ARG CUSTOM_GROUP_ID
RUN groupadd -g ${CUSTOM_GROUP_ID} ${CUSTOM_USER_NAME} && \
      useradd -m -u ${CUSTOM_USER_ID} -g ${CUSTOM_USER_NAME} -G sudo ${CUSTOM_USER_NAME} && \
      passwd -d ${CUSTOM_USER_NAME}

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/zzb-custom.ini

# CRON's (if they exist)
COPY ./56/Dockerfile ./56/custom_crontab* /root/

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
