# Required PHP Extensions
apt-get update && apt-get install -y \
        cron \
        supervisor \
        ssmtp \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libicu-dev \
        less \
        nano \
        ssh \
        git \
        zip \
        unzip \
        net-tools \
        gnupg \
        --no-install-recommends \
    && yes '' | pecl install -f redis xdebug \
    && docker-php-ext-enable redis xdebug \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) bcmath calendar gd intl mcrypt mysqli opcache pdo_mysql soap xsl zip \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Memcache
curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz
