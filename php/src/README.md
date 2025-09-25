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
    - Valkey/Redis
    - Xdebug
    - PCOV
    - Blackfire
- Composer
- GD Library
- Mailpit
- Node/NPM/Yarn (PHP Latest)
- Wordpress CLI (PHP Latest)


## How do I make updates?

### Step 1: Edit the dockerfile

Each PHP version has it's own dockerfile (eg. `php/src/84/Dockerfile` for PHP 8.4).

### Step 2: Distribute to Docker Hub

We now use GitHub Actions to automatically build and push multi-platform PHP Docker images to Docker Hub. The workflow:

- Builds images for both AMD64 (Intel) and ARM64 (Apple Silicon) architectures
- Creates multi-platform manifest lists for seamless cross-platform usage
- Supports latest PHP versions
- Must be triggered manually

To trigger a new build:

1. Go to https://github.com/pvtl/docker-dev/actions/
2. Select the "Build and Push PHP Docker Images" workflow
3. Click "Run workflow" and leave the tag as the default (`latest`)
4. Wait for the build to complete (typically ~5 minutes)

For detailed setup instructions, configuration, and troubleshooting, see the [GitHub Actions Workflow README](../../.github/workflows/README.md).

### Step 3: Make use of the new image

Once the images have landed in Docker Hub you'll be able to build/run a fresh version of your LDE (see instructions in the main README).


## Config & PHP.ini

Each version of PHP shares the global config from `php/src/conf/custom.ini`. This config is baked into the Docker images we publish on Docker Hub.

Those using the published Docker images can override their PHP config in `php/conf/custom.ini`.
