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
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) calendar gd intl mcrypt mysql mysqli opcache pdo_mysql soap xsl zip

# Add NodeJS and NPM (latest versions)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install node \
    && npm i -g grunt-cli

WORKDIR /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]
