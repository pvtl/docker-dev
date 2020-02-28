# Dermine Xdebug version (PHP 7.0- requires < xdebug-2.6.1)
PHP_VERSION=$(php -r "echo substr(str_replace('.', '', phpversion()), 0, 3);")
[ $PHP_VERSION -gt 710 ] && XDEBUG_MODULE="xdebug" || XDEBUG_MODULE="xdebug-2.6.1"

# Required PHP Extensions
apt update && apt install -y --no-install-recommends \
        cron \
        git \
        gnupg \
        iputils-ping \
        less \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        nano \
        net-tools \
        ssh \
        msmtp \
        supervisor \
        unzip \
        libzip-dev \
        libz-dev \
    && yes '' | pecl install -f redis memcached mcrypt $XDEBUG_MODULE \
    && docker-php-ext-install -j$(nproc) bcmath calendar exif gd intl mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable redis exif xdebug mcrypt bcmath calendar gd intl memcached mysqli opcache pdo_mysql soap xsl zip \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
