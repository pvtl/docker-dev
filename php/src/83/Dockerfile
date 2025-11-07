FROM php:8.3-fpm-trixie

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV PATH=/usr/local/go/bin:/root/.composer/vendor/bin:$PATH

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
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

# PIE
COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie

# PHP Extensions
RUN pie install php-memcached/php-memcached \
  && pie install phpredis/phpredis \
  && pie install xdebug/xdebug \
  && pie install pecl/pcov \
  && pie install pecl/mcrypt \
  && docker-php-ext-install -j$(nproc) bcmath calendar exif intl mysqli opcache pdo_mysql soap xsl zip \
  && docker-php-ext-enable mcrypt memcached redis xdebug pcov \
  && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLED \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd

# Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
  && architecture=$(uname -m) \
  && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/$architecture/$version \
  && mkdir -p /tmp/blackfire \
  && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
  && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
  && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
  && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Helper script for switching PHP debugging tools (PCOV, Xdebug, Blackfire)
# Disable all by default
COPY ./change_debug_tool.sh /usr/local/bin/change_debug_tool.sh
RUN chmod +x /usr/local/bin/change_debug_tool.sh \
  && /usr/local/bin/change_debug_tool.sh --disable-all

# Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer clear-cache

# Mailpit
# (so we can use it's "sendmail" compatible binary)
COPY --from=axllent/mailpit:latest /mailpit /usr/bin/mailpit

# Update site's directory permissions
RUN chown -R www-data /var/www/

# Custom PHP.ini config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/zza-custom.ini

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf
RUN touch /etc/supervisor/supervisord.pid

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
