FROM lysender/ubuntu-php
MAINTAINER Matt Dillon <matt.d@pvtl.io>

# Install Apache  and misc tools
RUN apt-get -y install supervisor \ 
    apache2 \
    libapache2-mod-php5 \
    php5-mysql \
    php5-xsl \
    php5-intl \
    composer \
    mysql-client \
    openssl && apt-get clean

# Configure services
ADD ./start.sh /start.sh
ADD ./start-apache2.sh /start-apache2.sh
RUN chmod 755 /*.sh
RUN mkdir -p /etc/supervisor/conf.d
ADD ./supervisor-apache2.conf /etc/supervisor/conf.d/apache2.conf

RUN mkdir -p /files/web
RUN chown -R :www-data /files/web

# Custom php.ini
RUN rm -f /etc/php5/apache2/php.ini
ADD ./php.ini /etc/php5/apache2/php.ini

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
#ADD apache-default.conf /etc/apache2/sites-available/000-default.conf
ADD dev.conf /etc/apache2/sites-available/dev.conf
RUN a2ensite dev.conf
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod deflate
RUN a2enmod env
RUN a2enmod expires
RUN a2enmod vhost_alias

VOLUME ["/var/www/html", "/var/log/apache2"]

EXPOSE 80
EXPOSE 443

CMD ["/bin/bash", "/start.sh"]
