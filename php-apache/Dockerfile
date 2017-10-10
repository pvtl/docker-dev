FROM php:5.6-apache

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

COPY php.ini /usr/local/etc/php/
COPY dev.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite vhost_alias headers

# Add required PHP Extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libxslt-dev \
        libicu-dev \
        less \
        nano \
        --no-install-recommends \
    && yes '' | pecl install -f memcache-2.2.7 \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) calendar gd intl mcrypt mysql mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable memcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add NodeJS and NPM (latest versions)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install node \
    && npm i -g grunt-cli

# IonCube
RUN cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_5.6.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_5.6.ini

WORKDIR /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]
