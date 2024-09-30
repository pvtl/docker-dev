#!/bin/bash

# Change into this directory
# Required by the relative paths below
cd $(dirname "$0")


# Tag all images (for the Docker Hub) as "latest"
TAG="latest"


# Setup build servers
#   - arm64 is built locally on Apple Silicon
#   - amd64 is built remotely on the dev server on x64/Intel hardware
# (If your local machine is x64/Intel hardware then you can reverse these)
docker buildx rm pvtl 2>/dev/null # Start from a clean slate
docker buildx create --name pvtl --use
docker buildx create --name pvtl --platform linux/amd64 --append ssh://pvtl@192.168.0.5 # Leverage the dev server


# PHP 8.4 (2024)
docker buildx build --no-cache --pull -f 84/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-8.4:latest --push .

if [[ ${TAG} != "latest" ]] ; then
  docker tag wearepvtl/php-fpm-8.4 wearepvtl/php-fpm-8.4:${TAG}
  docker push wearepvtl/php-fpm-8.4:${TAG}
fi


# PHP 8.3 (2023)
docker buildx build --no-cache --pull -f 83/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-8.3:latest --push .

if [[ ${TAG} != "latest" ]] ; then
  docker tag wearepvtl/php-fpm-8.3 wearepvtl/php-fpm-8.3:${TAG}
  docker push wearepvtl/php-fpm-8.3:${TAG}
fi


# PHP 8.2 (2022)
docker buildx build --no-cache --pull -f 82/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-8.2:latest --push .

if [[ ${TAG} != "latest" ]] ; then
  docker tag wearepvtl/php-fpm-8.2 wearepvtl/php-fpm-8.2:${TAG}
  docker push wearepvtl/php-fpm-8.2:${TAG}
fi


# PHP 8.1 (2021)
docker buildx build --no-cache --pull -f 81/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-8.1:latest --push .

if [[ ${TAG} != "latest" ]] ; then
  docker tag wearepvtl/php-fpm-8.1 wearepvtl/php-fpm-8.1:${TAG}
  docker push wearepvtl/php-fpm-8.1:${TAG}
fi


# PHP 8.0 (2020)
# docker buildx build --no-cache --pull -f 80/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-8.0:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-8.0 wearepvtl/php-fpm-8.0:${TAG}
#   docker push wearepvtl/php-fpm-8.0:${TAG}
# fi


# PHP 7.4 (2019)
# docker buildx build --no-cache --pull -f 74/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-7.4:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-7.4 wearepvtl/php-fpm-7.4:${TAG}
#   docker push wearepvtl/php-fpm-7.4:${TAG}
# fi


# PHP 7.3 (2018)
# docker buildx build --no-cache --pull -f 73/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-7.3:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-7.3 wearepvtl/php-fpm-7.3:${TAG}
#   docker push wearepvtl/php-fpm-7.3:${TAG}
# fi


# PHP 7.2 (2017)
# docker buildx build --no-cache --pull -f 72/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-7.2:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-7.2 wearepvtl/php-fpm-7.2:${TAG}
#   docker push wearepvtl/php-fpm-7.2:${TAG}
# fi


# PHP 7.1 (2016)
# docker buildx build --no-cache --pull -f 71/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-7.1:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-7.1 wearepvtl/php-fpm-7.1:${TAG}
#   docker push wearepvtl/php-fpm-7.1:${TAG}
# fi


# PHP 7.0 (2015)
# docker buildx build --no-cache --pull -f 70/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-7.0:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-7.0 wearepvtl/php-fpm-7.0:${TAG}
#   docker push wearepvtl/php-fpm-7.0:${TAG}
# fi


# PHP 5.6 (2014)
# docker buildx build --no-cache --pull -f 56/Dockerfile --platform linux/arm64,linux/amd64 -t wearepvtl/php-fpm-5.6:latest --push .

# if [[ ${TAG} != "latest" ]] ; then
#   docker tag wearepvtl/php-fpm-5.6 wearepvtl/php-fpm-5.6:${TAG}
#   docker push wearepvtl/php-fpm-5.6:${TAG}
# fi


# Tear down build servers
docker buildx rm pvtl
