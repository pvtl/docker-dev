# Dermine which modules we should install, based on the PHP Version
# [ 7.2 = PHP 7.2.x | 5.6 = PHP v5.6.x ]
PHP_VERSION_FLOAT=$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')
# [ 72 = PHP v7.2.x  | 56 = PHP v5.6.x etc ]
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;')


echo "\n Installing PHP Extensions (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"

APT_SMTP=$([             $PHP_VERSION -ge 70 ] && echo "msmtp"      || echo "ssmtp")
APT_ZIP=$([              $PHP_VERSION -ge 70 ] && echo "libzip-dev" || echo "zip")
PECL_MEMCACHED=$([       $PHP_VERSION -ge 70 ] && echo "memcached"  || echo "memcached-2.2.0")
PECL_REDIS=$([           $PHP_VERSION -ge 70 ] && echo "redis"      || echo "redis-4.3.0")
DI_MYSQL_PHP5=$([        $PHP_VERSION -ge 70 ] && echo ""           || echo "mysql")
DI_EXIF_PHP7=$([         $PHP_VERSION -ge 70 ] && echo "exif"       || echo "")
PECL_XDEBUG=$([          $PHP_VERSION -ge 71 ] && echo "xdebug"     || echo "xdebug-2.5.5")
APT_LIBZ_PHP71_UP=$([    $PHP_VERSION -ge 71 ] && echo "libz-dev"   || echo "")
PECL_MCRYPT_PHP72_UP=$([ $PHP_VERSION -ge 72 ] && echo "mcrypt"     || echo "")
DI_MCRYPT_PHP71_DOWN=$([ $PHP_VERSION -ge 72 ] && echo ""           || echo "mcrypt")

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
        $APT_SMTP \
        supervisor \
        unzip \
        $APT_ZIP \
        $APT_LIBZ_PHP71_UP \
    && yes '' | pecl install -f $PECL_MEMCACHED $PECL_REDIS $PECL_XDEBUG $PECL_MCRYPT_PHP72_UP \
    && docker-php-ext-install -j$(nproc) bcmath calendar gd $DI_MYSQL_PHP5 $DI_EXIF_PHP7 intl $DI_MCRYPT_PHP71_DOWN mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable mcrypt memcached redis xdebug \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


echo "\n Configure GD Library (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"
if [ $PHP_VERSION -ge 74 ] ; then
  docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
else
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
fi


echo "\n Installing Ioncube (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"
if [ $PHP_VERSION -le 73 ] ; then
  cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_$PHP_VERSION_FLOAT.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_${PHP_VERSION_FLOAT}.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_$PHP_VERSION_FLOAT.ini
fi


echo "\n Installing Composer (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"
curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer global require hirak/prestissimo \
  && composer clear-cache


echo "\n Installing MailHog (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"
curl -L -o /usr/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x /usr/bin/mhsendmail


# Latest PHP Version only
if [ $PHP_VERSION -eq 74 ] ; then
  echo "\n Installing Yarn (PHP v${PHP_VERSION_FLOAT})"
  echo "========================================================================================== \n"
  curl -sS 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt install -y --no-install-recommends yarn


  echo "\n Installing Node (PHP v${PHP_VERSION_FLOAT})"
  echo "========================================================================================== \n"
  curl -sL https://deb.nodesource.com/setup_13.x | bash - \
    && apt install -y --no-install-recommends nodejs


  echo "\n Installing Wordpress CLI (PHP v${PHP_VERSION_FLOAT})"
  echo "========================================================================================== \n"
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


  # echo "\n Installing Blackfire (PHP v${PHP_VERSION_FLOAT})"
  # echo "========================================================================================== \n"
  # curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$PHP_VERSION \
  #   && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
  #   && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
  #   && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini
fi


echo "\n Setting Up Crons (PHP v${PHP_VERSION_FLOAT})"
echo "========================================================================================== \n"
touch /root/custom_crontab \
  && /usr/bin/crontab -u www-data /root/custom_crontab


# Update site's directory permissions
chown -R www-data /var/www/


# Cleanup
apt clean \
  && rm -rf /var/lib/apt/lists/*
