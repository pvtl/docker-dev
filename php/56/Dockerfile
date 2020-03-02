FROM php:5.6-fpm

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV PATH /usr/local/go/bin:$PATH

# Execute shared commands (eg. install PHP modules, composer etc)
COPY ./shared.sh /container-setup.sh
RUN chmod +x /container-setup.sh && /container-setup.sh

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/999-custom.ini

# CRON's (if they exist)
COPY ./56/Dockerfile ./56/custom_crontab* /root/

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
