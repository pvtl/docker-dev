#!/bin/sh

set -eu

envsubst '$$PORT$$HOST_IP' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
cat /etc/nginx/nginx.conf
nginx
