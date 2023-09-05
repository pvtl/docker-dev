# PHP Docker Images

This folder contains the PHP (only) Docker images that are pushed to Docker Hub.

The images are built for AMD64 (Intel) and ARM64 (Apple Silicon) CPU architectures.


## Why?

Building the base PHP images takes a lot of time. Multiply that for each version of PHP you need. So it doesn't make sense that each end-user should need to do this.

We're publishing pre-built images on the Docker Hub so users can simply pull and go. Users can still easily layer on any modifications as needed.


## What's in these images?

We use the [official PHP images](https://hub.docker.com/_/php) and add:

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
- Mailpit
- Node/NPM/Yarn (PHP Latest)
- PHPCS (PHP Latest)
- Wordpress CLI (PHP Latest)


## How do I make updates?

### Step 1: Edit the dockerfile

Each PHP version has it's own dockerfile (eg. `php/80/Dockerfile` for PHP 8.0).

Simply edit it and make the changes you need.

### Step 2: Distribute to Docker Hub

Automated builds aren't available at the moment, so you'll need to manually build and push to Docker Hub.

Before you start, make sure you can use `docker` on your CLI, and that you're logged into the Docker registry (Run: `docker login`).

1. Run `php/src/build-n-push.sh`
1. Hit <kbd>Enter</kbd> to select the default tag (ie. "latest") and wait for the build to finish

Behind the scenes this script is building our PHP images for multiple platforms (AMD64 and ARM64).

This script assumes the build process is being run on an ARM64 (Apple Silicon) CPU, and that a remote AMD64 (Intel) Docker instance is available via SSH to run the AMD64 build. You may need to adjust the script if you're running it on an AMD64 (Intel) device.

Older unsupported versions of PHP have been commented out, but you can temporarily enable them again if needed.

### Step 3: Make use of the new image

Once the images have landed in Docker Hub you'll be able to build/run a fresh version of your LDE (see instructions in the main README).


## Config & PHP.ini

Each version of PHP shares the global config from `php/src/conf/custom.ini`. This config is baked into the Docker images we publish on Docker Hub.

Those using the published Docker images can override their PHP config in `php/conf/custom.ini`.


## Commands

> Must be run inside the `php/src/` folder

| Command | Description |
| --- | --- |
| `docker build -f 80/Dockerfile . -t wearepvtl/php-fpm-8.0` | Builds the PHP 8.0 image |
| `docker login --username=yourhubusername` | Login to Docker Hub |
| `docker push wearepvtl/php-fpm-8.0` | Pushes the PHP 8.0 image to Docker Hub |
| `docker run wearepvtl/php-fpm-8.0` | Opens the PHP 8.0 Container |
| `docker image prune -a` | Delete all images to start from scratch |
