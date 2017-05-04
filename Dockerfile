FROM ubuntu:trusty

MAINTAINER Matt Dillon <matt.d@pvtl.io>

ENV DEBIAN_FRONTEND noninteractive

# PHP PPA
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update

# Install Apache  and misc tools
RUN apt-get -y install supervisor \ 
    apache2 \
    php5.6 \
    php5.6-mysql php5.6-mbstring php5.6-mcrypt php5.6-xml php5.6-zip \
    php5.6-curl php5.6-xsl php5.6-gd php5.6-soap php5.6-intl \
    mysql-client \
    mailutils \
    nano \
    cron \
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
RUN rm -f /etc/php/5.6/cli/php.ini
ADD ./php.ini /etc/php/5.6/cli/php.ini

RUN rm -f /etc/php/5.6/apache2/php.ini
ADD ./php.ini /etc/php/5.6/apache2/php.ini

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
