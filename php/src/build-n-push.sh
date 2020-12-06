#!/bin/bash

# Change into this directory
# Required by the relative paths below
cd $(dirname "$0")

docker build --pull --no-cache -f 80/Dockerfile . -t wearepvtl/php-fpm-8.0
docker push wearepvtl/php-fpm-8.0

docker build --pull --no-cache -f 74/Dockerfile . -t wearepvtl/php-fpm-7.4
docker push wearepvtl/php-fpm-7.4

docker build --pull --no-cache -f 73/Dockerfile . -t wearepvtl/php-fpm-7.3
docker push wearepvtl/php-fpm-7.3

docker build --pull --no-cache -f 72/Dockerfile . -t wearepvtl/php-fpm-7.2
docker push wearepvtl/php-fpm-7.2

docker build --pull --no-cache -f 71/Dockerfile . -t wearepvtl/php-fpm-7.1
docker push wearepvtl/php-fpm-7.1

docker build --pull --no-cache -f 70/Dockerfile . -t wearepvtl/php-fpm-7.0
docker push wearepvtl/php-fpm-7.0

docker build --pull --no-cache -f 56/Dockerfile . -t wearepvtl/php-fpm-5.6
docker push wearepvtl/php-fpm-5.6
