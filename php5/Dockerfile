FROM php:5.6-apache

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

COPY php.ini /usr/local/etc/php/
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Set umask to make generated files accessible on local machine
RUN echo "umask 002" >> /etc/apache2/envars

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
    && yes '' | pecl install -f memcache-2.2.7 \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) calendar gd intl mcrypt mysql mysqli opcache pdo_mysql soap xsl zip \
    && docker-php-ext-enable memcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Mail server
RUN apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

# IonCube
RUN cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_5.6.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_5.6.ini

# LDAP
RUN \
  apt-get update && \
  apt-get install libldap2-dev -y && \
  rm -rf /var/lib/apt/lists/* && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
  docker-php-ext-install ldap

WORKDIR /var/www/html/

EXPOSE 8056
CMD ["apache2-foreground"]
