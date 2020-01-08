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
    && yes '' | pecl install -f redis memcached mcrypt xdebug \
    && docker-php-ext-install -j$(nproc) bcmath calendar exif gd intl mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable redis exif xdebug mcrypt bcmath calendar gd intl memcached mysqli opcache pdo_mysql soap xsl zip \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
