# PHP Docker Images

This folder contains the PHP (only) Docker images that are pushed to Docker Hub.

## What are these?

They are PHP images, customised to include features such as:

- Helpful OS tools such as:
    - Git
    - Nano
    - Net-tools
    - SSH
    - Zip
- PHP Dependencies such as:
    - Bcmath
    - Mcrypt
    - Memcached
    - Opcache
    - Redis
    - Xdebug
- Composer
- GD Library
- Mailhog
- Node/NPM/Yarn (PHP Latest)
- PHPCS (PHP Latest)
- Wordpress CLI (PHP Latest)

## How do I make updates?

You'll notice in that `/php/7*/Dockerfile`, that the first line says something like: `FROM wearepvtl/php-fpm-7.*`.
This is saying that the LDE we build/run, is using the Pivotal PHP 7.* image.

Therefore, if you need to make a change (eg. add a new dependency), update the `/php/src/7*` image, build and push it to Docker Hub.

Once that's landed in Docker Hub, you'll be able to build/run your LDE again, which will pull the latest PHP 7.* image (the one you just updated).

## Why?

This architecture allows us to more quickly and easily build and run LDEs, because the images are pre-built in Docker Hub. Therefore they only require that we download and run.

## Commands

*Must be run from `/php/src/`

| Command | Description |
| --- | --- |
| `docker build -f 74/Dockerfile . -t wearepvtl/php-fpm-7.4` | Builds the PHP 7.4 image |
| `docker login --username=yourhubusername` | Login to Docker Hub |
| `docker push wearepvtl/php-fpm-7.4` | Pushes the PHP 7.4 image to Docker Hub |
| `docker run wearepvtl/php-fpm-7.4` | Opens the PHP 7.4 Container |
| `docker image prune -a` | Delete all images to start from scratch |

## Build and push all

```bash
docker build -f 74/Dockerfile . -t wearepvtl/php-fpm-7.4
docker push wearepvtl/php-fpm-7.4
docker build -f 73/Dockerfile . -t wearepvtl/php-fpm-7.3
docker push wearepvtl/php-fpm-7.3
docker build -f 72/Dockerfile . -t wearepvtl/php-fpm-7.2
docker push wearepvtl/php-fpm-7.2
docker build -f 71/Dockerfile . -t wearepvtl/php-fpm-7.1
docker push wearepvtl/php-fpm-7.1
docker build -f 70/Dockerfile . -t wearepvtl/php-fpm-7.0
docker push wearepvtl/php-fpm-7.0
docker build -f 56/Dockerfile . -t wearepvtl/php-fpm-5.6
docker push wearepvtl/php-fpm-5.6
```
