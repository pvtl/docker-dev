FROM httpd:2.4

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Set umask to make generated files accessible on local machine
RUN echo "umask 002" >> /usr/local/apache2/envvars

# Enable Modules
RUN echo "LoadModule vhost_alias_module modules/mod_vhost_alias.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule ssl_module modules/mod_ssl.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule proxy_module modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf \
    && echo "LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so" >> /usr/local/apache2/conf/httpd.conf

# Enable Sites
RUN mkdir /usr/local/apache2/conf/sites/ \
    && echo "Include conf/sites/pvtl.io.conf" >> /usr/local/apache2/conf/httpd.conf
