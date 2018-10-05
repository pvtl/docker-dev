FROM php:5.6-fpm

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Required PHP Extensions
RUN apt-get update && apt-get install -y \
        cron \
        supervisor \
        ssmtp \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
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
        gnupg \
        --no-install-recommends \
    && yes '' | pecl install -f memcache redis \
    && docker-php-ext-enable memcache redis \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) calendar gd intl mcrypt mysql mysqli opcache pdo_mysql soap xsl zip bcmath \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install useful NPM CLIs
RUN npm i -g grunt-cli \
    && npm i -g gulp-cli

# Mail server
ENV PATH /usr/local/go/bin:$PATH
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf - \
  && go get github.com/mailhog/mhsendmail \
  && cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

# Wordpress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# IonCube
RUN cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_5.6.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_5.6.ini

# Blackfire PHP Profiler
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Custom PHP.ini Config
COPY ./custom.ini /usr/local/etc/php/conf.d/999-custom.ini

# CRON's
COPY ./crontab /root/custom_crontab
RUN /usr/bin/crontab -u www-data /root/custom_crontab

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf

RUN chown -R www-data /var/www/

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
