FROM php:8.2-fpm-bullseye

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV PATH /usr/local/go/bin:/root/.composer/vendor/bin:$PATH

RUN apt update && apt install -y --no-install-recommends \
    cron \
    fonts-powerline \
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
    libssl-dev \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libz-dev \
    libzip-dev \
    msmtp \
    nano \
    net-tools \
    powerline \
    ssh \
    sudo \
    supervisor \
    unzip \
    zsh \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# PHP Extensions
RUN yes '' | pecl install -f memcached-3.2.0 redis-5.3.7 xdebug-3.2.1 mcrypt-1.0.6 \
  && docker-php-ext-install -j$(nproc) bcmath calendar exif intl mysqli opcache pdo_mysql soap xsl zip \
  && docker-php-ext-enable mcrypt memcached redis xdebug \
  && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd

# Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer clear-cache

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list >/dev/null \
  && apt update \
  && apt install -y --no-install-recommends yarn \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
  && apt install -y --no-install-recommends nodejs \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Wordpress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# PHPCS
RUN composer global require squizlabs/php_codesniffer wp-coding-standards/wpcs \
  && phpcs --config-set installed_paths /root/.composer/vendor/wp-coding-standards/wpcs \
  && composer clear-cache

# Setup crons
RUN touch /root/custom_crontab \
  && /usr/bin/crontab -u www-data /root/custom_crontab

# Update site's directory permissions
RUN chown -R www-data /var/www/

# Custom PHP.ini config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/zza-custom.ini

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf
RUN touch /etc/supervisor/supervisord.pid

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
