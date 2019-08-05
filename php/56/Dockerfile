FROM php:5.6-fpm

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV PATH /usr/local/go/bin:$PATH

# Required PHP Extensions
RUN apt-get update && apt-get install -y \
        cron \
        git \
        gnupg \
        less \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        nano \
        ssh \
        ssmtp \
        supervisor \
        unzip \
        zip \
        --no-install-recommends \
    && yes '' | pecl install -f memcache redis-4.3.0 xdebug-2.5.5 \
    && docker-php-ext-enable memcache redis xdebug \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) bcmath calendar gd intl mcrypt mysql mysqli opcache pdo_mysql soap xsl zip \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

# Execute shared commands (eg. install of npm, composer etc)
COPY ./shared-all.sh /container-setup.sh
RUN chmod +x /container-setup.sh && /container-setup.sh

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
