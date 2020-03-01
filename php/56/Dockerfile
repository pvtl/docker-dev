FROM php:5.6-fpm

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV PATH /usr/local/go/bin:$PATH

# Execute shared commands (eg. install PHP modules, composer etc)
COPY ./shared-all.sh /container-setup.sh
RUN chmod +x /container-setup.sh && /container-setup.sh

# IonCube
RUN cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_5.6.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_5.6.ini

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/999-custom.ini

# CRON's (if they exist)
COPY ./56/Dockerfile ./56/custom_crontab* /root/

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
