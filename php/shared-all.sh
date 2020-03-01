# Dermine which modules we should install, based on the PHP Version
# [ 702 = PHP v7.2.x  | 712 = PHP v7.12.x etc ]
PHP_VERSION=$(php -r '
  $ver = explode(".", phpversion(), 3);
  echo $ver[0] . str_pad($ver[1], 2, '0', STR_PAD_LEFT);
')

APT_SMTP=$([       $PHP_VERSION -ge 700 ] && echo "msmtp"      || echo "ssmtp")
APT_ZIP=$([        $PHP_VERSION -ge 700 ] && echo "libzip-dev" || echo "zip")
PECL_MEMCACHED=$([ $PHP_VERSION -ge 700 ] && echo "memcached"  || echo "memcached-2.2.0")
PECL_REDIS=$([     $PHP_VERSION -ge 700 ] && echo "redis"      || echo "redis-4.3.0")
DI_MYSQL=$([       $PHP_VERSION -ge 700 ] && echo ""           || echo "mysql")
DI_EXIF=$([        $PHP_VERSION -ge 700 ] && echo "exif"       || echo "")
PECL_XDEBUG=$([    $PHP_VERSION -ge 701 ] && echo "xdebug"     || echo "xdebug-2.5.5")
APT_LIBZ=$([       $PHP_VERSION -ge 701 ] && echo "libz-dev"   || echo "")
PECL_MCRYPT=$([    $PHP_VERSION -ge 702 ] && echo "mcrypt"     || echo "")
DI_MCRYPT=$([      $PHP_VERSION -ge 702 ] && echo ""           || echo "mcrypt")

echo "\n Installing PHP Extensions (PHP v${PHP_VERSION})"
echo "========================================================================================== \n"
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
        $APT_LIBZ \
    && yes '' | pecl install -f $PECL_MEMCACHED $PECL_REDIS $PECL_XDEBUG $PECL_MCRYPT \
    && docker-php-ext-install -j$(nproc) bcmath calendar gd $DI_MYSQL $DI_EXIF intl $DI_MCRYPT mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable mcrypt memcached redis xdebug \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

echo "\n Installing GD Library (PHP v${PHP_VERSION})"
echo "========================================================================================== \n"
if [ $PHP_VERSION -ge 704 ] ; then
  docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
else
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
fi

echo "\n Installing Composer (PHP v${PHP_VERSION})"
echo "========================================================================================== \n"
curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer global require hirak/prestissimo \
  && composer clear-cache

echo "\n Installing MailHog (PHP v${PHP_VERSION})"
echo "========================================================================================== \n"
curl -L -o /usr/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x /usr/bin/mhsendmail

echo "\n Setting Up Crons (PHP v${PHP_VERSION})"
echo "========================================================================================== \n"
touch /root/custom_crontab \
  && /usr/bin/crontab -u www-data /root/custom_crontab

# Update site's directory permissions
chown -R www-data /var/www/

# Cleanup
apt clean \
  && rm -rf /var/lib/apt/lists/*
