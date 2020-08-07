FROM wearepvtl/php-fpm-7.1

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/999-custom.ini

# Copy CRON's
COPY ./71/Dockerfile ./71/custom_crontab* /root/

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
