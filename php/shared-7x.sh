# Required PHP Extensions
apt-get update && apt-get install -y \
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
        --no-install-recommends \
    && yes '' | pecl install -f redis memcached mcrypt xdebug \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) bcmath calendar exif gd intl mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable redis exif xdebug mcrypt bcmath calendar gd intl memcached mysqli opcache pdo_mysql soap xsl zip \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
