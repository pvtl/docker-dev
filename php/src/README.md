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
    - XDebug
- Composer
- GD Library
- Mailhog
- Node/NPM/Yarn (PHP Latest)
- PHPCS (PHP Latest)
- Wordpress CLI (PHP Latest)

## How do I make updates?

**1) Make the updates**

You'll notice in that `/php/*/Dockerfile`, that the first line says something like: `FROM wearepvtl/php-fpm-7.*`.
This is saying that the LDE we build/run, is using the Pivotal PHP 7.* image.

Therefore, if you need to make a change (eg. add a new dependency), update the `/php/src/7*` image, build and push it to Docker Hub.

**2) Distribute to Docker Hub**

There are 2 ways to distribute the image/s to Docker Hub:

1. Automatically: Git tag a commit in the SemVer (eg. 2.5.3) format and Docker Hub will build and tag the new version to the major version
    - eg. Git Tag `2.5.3` will build to Docker Tag `2` (which could then be used as `FROM wearepvtl/php-fpm-8.0:2` in a PHP 8.0 image example)
2. Use the `/php/src/build-n-push.sh` script to manually build locally and push to Docker Hub

**3) Make use of the new image**

Once that's landed in Docker Hub, you'll be able to build/run your LDE again, which will pull the latest PHP 7.* image (the one you just updated).

## Why?

This architecture allows us to more quickly and easily build and run LDEs, because the images are pre-built in Docker Hub. Therefore they only require that we download and run.

## Config & PHP.ini

Each version of PHP shares the global config from `php/src/conf/custom.ini`. This config is baked into the Docker images we publish on Docker Hub.

Those using the finished Docker images can override their PHP config in `php/conf/custom.ini`.

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

This script will pull fresh copies of the official parent images and rebuild our Pivotal PHP images from scratch.

`php/src/build-n-push.sh`
