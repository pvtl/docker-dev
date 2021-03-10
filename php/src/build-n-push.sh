#!/bin/bash

# Change into this directory
# Required by the relative paths below
cd $(dirname "$0")

echo -e "\n  ➤  Which tag would you like to push to? [default: latest]"
read -p "== " TAG

if [[ -z "$TAG" ]]; then
  TAG="latest"
fi

if [[ ${TAG} != "latest" ]] ; then
  echo -e "\n  ➤  Would you additionally like to push to `latest` branch? [y/n]"
  read -p "== " LATEST
fi
[ "$LATEST" != "${LATEST#[Yy]}" ] && LATEST=1 || LATEST=0

docker build --pull -f 80/Dockerfile . -t wearepvtl/php-fpm-8.0
docker tag wearepvtl/php-fpm-8.0 wearepvtl/php-fpm-8.0:${TAG}
docker push wearepvtl/php-fpm-8.0:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-8.0:latest
fi

docker build --pull -f 74/Dockerfile . -t wearepvtl/php-fpm-7.4
docker tag wearepvtl/php-fpm-7.4 wearepvtl/php-fpm-7.4:${TAG}
docker push wearepvtl/php-fpm-7.4:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-7.4:latest
fi

docker build --pull -f 73/Dockerfile . -t wearepvtl/php-fpm-7.3
docker tag wearepvtl/php-fpm-7.3 wearepvtl/php-fpm-7.3:${TAG}
docker push wearepvtl/php-fpm-7.3:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-7.3:latest
fi

docker build --pull -f 72/Dockerfile . -t wearepvtl/php-fpm-7.2
docker tag wearepvtl/php-fpm-7.2 wearepvtl/php-fpm-7.2:${TAG}
docker push wearepvtl/php-fpm-7.2:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-7.2:latest
fi

docker build --pull -f 71/Dockerfile . -t wearepvtl/php-fpm-7.1
docker tag wearepvtl/php-fpm-7.1 wearepvtl/php-fpm-7.1:${TAG}
docker push wearepvtl/php-fpm-7.1:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-7.1:latest
fi

docker build --pull -f 70/Dockerfile . -t wearepvtl/php-fpm-7.0
docker tag wearepvtl/php-fpm-7.0 wearepvtl/php-fpm-7.0:${TAG}
docker push wearepvtl/php-fpm-7.0:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-7.0:latest
fi

docker build --pull -f 56/Dockerfile . -t wearepvtl/php-fpm-5.6
docker tag wearepvtl/php-fpm-5.6 wearepvtl/php-fpm-5.6:${TAG}
docker push wearepvtl/php-fpm-5.6:${TAG}

if [[ ${LATEST} == 1 ]] ; then
  docker push wearepvtl/php-fpm-5.6:latest
fi
