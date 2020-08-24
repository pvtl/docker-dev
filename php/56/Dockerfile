FROM wearepvtl/php-fpm-5.6

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/zzb-custom.ini

# CRON's (if they exist)
COPY ./56/Dockerfile ./56/custom_crontab* /root/

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
