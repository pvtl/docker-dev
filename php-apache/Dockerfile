FROM php:5.6-apache

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

COPY php.ini /usr/local/etc/php/
COPY dev.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite vhost_alias

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libxslt-dev \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) mcrypt mysql mysqli opcache pdo_mysql zip calendar soap intl xsl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]
