FROM alpine:3.6

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

ENV NGINX_VERSION 1.13.5

# Generate a cert
RUN apk add --no-cache openssl nginx gettext \
    && mkdir -p /etc/nginx/ssl/ \
    && openssl req -new -x509 -sha256 -newkey rsa:2048 -days 365 -nodes -out /etc/nginx/ssl/nginx.pem -keyout /etc/nginx/ssl/nginx.key -subj "/C=AU/ST=ALD/L=Brisbane/O=PVTL/OU=dev/CN=localhost" \
    && mkdir -p /run/nginx/

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY entrypoint.sh .

EXPOSE 443
STOPSIGNAL SIGTERM

ENTRYPOINT sh entrypoint.sh
