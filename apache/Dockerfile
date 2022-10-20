# Generate new SSL certificate and key files (used by Apache below)
FROM alpine:3
WORKDIR /tmp/
RUN apk add --no-cache openssl
RUN openssl req -new -x509 -sha256 -newkey rsa:2048 -days 365 -nodes -out /tmp/server.crt -keyout /tmp/server.key -subj "/C=AU/ST=ALD/L=Brisbane/O=PVTL/OU=dev/CN=localhost"


# Build Apache container
FROM httpd:2.4

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Set umask to make generated files accessible on local machine
RUN echo "umask 002" >> /usr/local/apache2/envvars

# Add SSL certificate and key files
COPY --from=0 /tmp/server.crt /usr/local/apache2/conf/server.crt
COPY --from=0 /tmp/server.key /usr/local/apache2/conf/server.key

# Remove the default HTTPS virtual host. We'll use our own.
# Keep all the other server-wide defaults though.
RUN sed -i '/SSL Virtual Host Context/Q' conf/extra/httpd-ssl.conf

# Enable the modules we need
RUN sed -i \
  -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
  -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
  -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
  -e 's/^#\(LoadModule .*mod_vhost_alias.so\)/\1/' \
  -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
  -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
  -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
  /usr/local/apache2/conf/httpd.conf

# Enable all sites
RUN echo "Include conf/sites/*.conf" >> /usr/local/apache2/conf/httpd.conf

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS
