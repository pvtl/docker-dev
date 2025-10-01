# PHP

We use the [official PHP Docker images](https://hub.docker.com/_/php) and add a few extra features to make them nicer for everyday use.


## Which versions are available?
We offer 5.6, all 7.x and all 8.x. The default version is PHP 8.4.

See the `/php` and `/php/src` folders for more details.


## How do I use a specific version?
If you're happy with the default version of PHP 8.4 then you simply:

- Use `https://<folder>.test` in your browser
- Use `devin 84` to jump into the 8.4 container and run PHP commands (eg. composer, artisan)

There are two extra steps if you want a different version of PHP. Let's assume you want PHP 7.4:

1. Add the PHP version to the `COMPOSE_FILE` list in `.env`
  - eg. `COMPOSE_FILE=docker-compose.yml:opt/php74.yml`
1. Update your Docker containers: `docker compose up -d --remove-orphans`

Now use `https://<folder>.php74.test` in your browser or `devin 74` in your terminal.

You can enable as many versions of PHP as you like, but note that starting or updating the containers will take a little longer.


## Why is `<xyz tool>` missing?

Only the latest version of PHP has these tools installed:

- Node.js (latest LTS) & NPM (latest)
- Yarn (latest of 1.x)
- PHPCS (with Wordpress code standards added)
- Wordpress CLI
- ZSH

All other PHP containers will only have Composer installed.

This was a deliberate decision in order to keep the PHP containers as small as possible, but still provide the convenience of having these tools available.

If you want to install your own tools then see "How can I customise my containers?" in the [General FAQ](general-faq.md).


## How do I run CRONs?

Each version of PHP can have it's own scheduled CRON jobs.

1. Create a file called `custom_crontab` in the PHP folder of your choice (eg. `php/84/custom_crontab`).
1. Add your scheduled commands into `custom_crontab`
1. Rebuild that PHP image (eg. for PHP 8.4): `docker compose build php84-fpm`
1. Use the new image: `docker compose up -d`

Your CRON entries should look something like this:

```
* * * * * cd /var/www/html/my-laravel-site/ && php artisan schedule:run >> /dev/null 2>&1
```

CRONs will only run while your Docker Dev containers are running.


## How do I get BrowserSync working from inside a container?

BrowserSync works by proxying a host and auto-refreshing the browser when a file was updated. When run from within a container, it needs to proxy the PHP site through the apache container (to get the same result that you see).

We have 2 options for this.

### 1. Adjust your site's config

We have a (wildcard) DNS redirect setup at `*.lde.pvtl.io` which points to the apache container's IP address. This is for convenience, so that our docker container can use that hostname to find the IP. Simply adjust your BrowserSync config to use this hostname:

1. BrowserSync config: Instead of using the hostname `<folder>.pub.test`, use `<folder>.pub.lde.pvtl.io`
1. (optional) .env: Adjust your site's hostname (usually in `.env`) to use the same `.lde.pvtl.io` alternative
    - Primarily relevant in Wordpress sites, because Wordpress will redirect to `WP_HOME`

### 2. Adjust the hosts file (inside the container)

Follow the instructions in the section below (HTTP requests from one LDE site to another).


## HTTP requests from one LDE site to another

**Good news!** As of our latest update, HTTP requests between sites work automatically thanks to our DNS configuration.

PHP containers are configured to use an internal DNS server that resolves `*.test` domains to the Apache container's IP address. This means:

- ✅ WordPress cron jobs work automatically
- ✅ Laravel queue callbacks work
- ✅ One site can make API calls to another site
- ✅ Self-referencing HTTP requests work

**No manual configuration needed!** Just ensure your OS is configured to use our DNS server (see [DNS Setup Guide](dns-setup.md)).


## Customising PHP (.ini)

1. Add your settings into `php/conf/custom.ini`
1. Rebuild and restart all containers `docker compose up -d --build`.

Your config changes will take effect in all PHP containers.


## Installing PHP extensions

> Need to connect to Microsoft SQL Server? Read the next FAQ.

A great selection of extensions are pre-installed, but you can add your own too.

We are using the [official PHP Docker images](https://hub.docker.com/_/php) and they include a script which assists with installing and enabling PHP extensions.

Here's how you could install the "sockets" extension:

```bash
devin 84
sudo -E docker-php-ext-install sockets
exit
docker-compose restart
```

Or here is how you can install a PIE extension (for PHP 8.1+):

```bash
devin 84
sudo -E pie install swoole/swoole
exit
docker-compose restart
```

For older PHP versions (8.0 and below), you can still use PECL:

```bash
devin 80
sudo -E pecl install -f swoole-5.1.3
sudo -E docker-php-ext-enable swoole
exit
docker-compose restart
```

> Your extensions will need to be re-installed after you rebuild or upgrade your Docker containers. If you want your changes to persist, consider using the "custom_scripts" feature (see the [General FAQ](general-faq.md#how-can-i-customise-my-containers)).

Some extensions (like ImageMagick) depend on operating system packages.

```bash
devin 84
sudo apt-get update
sudo apt-get install libmagickwand-dev imagemagick
sudo -E pie install imagick/imagick
exit
docker-compose restart
```

If you're ever unsure which path ImageMagick has been installed into, run `whereis convert`. It should return something like `convert: /usr/bin/convert`.


## Connecting to Microsoft SQL Server

Our modern PHP images use Debian 13 (Trixie) under the hood. These instructions are specific to that version of Debian.

### Step 1: Switch to the root user
```bash
sudo su
```

### Step 2: Install dependencies from the Microsoft APT repository
```bash
curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
  && curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
  && apt update \
  && ACCEPT_EULA=Y apt-get install -y unixodbc-dev msodbcsql18 mssql-tools18
```

### Step 3: Install PIE/PECL extensions

For PHP 8.1+:
```bash
pie install microsoft/sqlsrv microsoft/pdo_sqlsrv
```

For PHP 8.0 and below:
```bash
pecl install sqlsrv pdo_sqlsrv
```

### Step 4: Exit the root user
```bash
exit
```

### Step 5: Enable extensions
```bash
sudo -E docker-php-ext-enable sqlsrv pdo_sqlsrv
```

### Step 6: Confirm the extensions are installed
```bash
php -m | grep sqlsrv
```

> Your extensions will need to be re-installed after you rebuild or upgrade your Docker containers. If you want your changes to persist, consider using the "custom_scripts" feature (see the [General FAQ](general-faq.md#how-can-i-customise-my-containers)).


## Using Valkey as a session handler

Did you know that PHP sessions will block concurrent requests (for the same session) until the first request is finished? This is done to prevent race conditions when writing to the session file.

You can improve your concurrency performance (at the risk of race conditions) by using Valkey as your session handler.

1. Enable the Valkey service by adding `opt/valkey.yml` to the `COMPOSE_FILE` list in `.env`
2. Create a `php/conf/custom.ini` file (if it doesn't already exist)
3. Append the following lines

```
[PHP]
session.save_handler = valkey
session.save_path = "tcp://valkey:6379"
```

4. Rebuild `docker compose up -d --build`


## How do I change the default version of PHP?

The default version of PHP is typically the latest stable version.

But perhaps you want to use PHP 7.4 for all URLs which do not specify a PHP version (like `<folder>.test` and `<folder>.pub.test`).

1. Ensure the PHP 7.4 image is added to the `COMPOSE_FILE` list in `.env` (ie. `opt/php74.yml`)
1. Cut the `ServerAlias *.pub.*` line from `apache/sites/pub.test/php<LATEST_VERSION>.conf`
1. Paste into `apache/sites/pub.test/php74.conf` (after the first `ServerAlias ..` line)
1. Cut the `ServerAlias *.*` line from `apache/sites/test/php<LATEST_VERSION>.conf`
1. Paste into `apache/sites/test/php74.conf` (after the first `ServerAlias ..` line)
1. Rebuild Apache `docker compose build apache`
1. Bring it back up `docker compose up -d --remove-orphans`
