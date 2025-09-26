<div align="center">
  <img src="docs/logo.jpg" alt="LAMP LDE" style="width:100%" />
  <p></p>
  <h1>LAMP Local Development Environment on Docker</h1>
  <p></p>
  <p align="center">
    <a href="#-intro"><b>What is this?</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#installation-"><b>Installation</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#common-commands-"><b>Usage</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#helpful-info"><b>Docs</b></a>
  </p>
  <br />
</div>

__An everyday local development environment for PHP Developers.__ At [Pivotal Agency](https://www.pivotalagency.com.au/), we've done a _buuunnnch_ of R&D to find the best local dev tools for our team. This is the result of our hard work. This tool has been put to its paces everyday by our team, we hope it can also help yours.


## Intro 👋

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) for developing locally. It's perfect for local development because you can very simply add new sites to specified folder and they're magically accessible as a subdomain of your chosen hostname (eg. `~/Projects/example` maps to `http://example.localhost/`).

It includes all the required dependencies for everyday PHP development with common tools like Laravel, Wordpress and Magento (1 & 2). Specifically:

**Default Services**

- Apache (including HTTPS)
- PHP 8.4
    - Composer (latest)
    - Node.js (latest LTS) & NPM (latest)*
    - Yarn (latest of 1.x)*
    - PHPCS (with Wordpress code standards added)*
    - Wordpress CLI*
    - ZSH*
- Mailpit
- MariaDB 11.4 LTS

<p><i>* Available in latest PHP container</i></p>

**Optional Services**

- PHP 5.6, all 7.x and all 8.x
- Memcached 1.x
- Valkey 8.x (the open source fork of Redis)
- [Blackfire](https://blackfire.io/) (latest)

These optional services (eg. PHP 7.4) can be enabled by adding them to the `COMPOSE_FILE` list in `.env`. See the `.env` file for examples. Make sure you run `docker compose up -d --remove-orphans` after making changes to the `.env` file.


## Prerequisites ⚠️

You'll need to install a modern version of Docker Desktop (or Docker on Linux).


## Domain Mapping 🗺

You can tell Docker Dev which version of PHP to use or whether it should load code from a "public" folder (required for Laravel, WordPress Bedrock and Magento) simply by adjusting your project's URL.

It's assumed that all of your projects are stored as folders in `~/Projects/`. You can use a different folder by changing the `DOCUMENTROOT` variable in your `.env` file.

Here is the the simplest form of domain mapping:

- `https://<folder>.localhost` will use the latest version of PHP and load the code from `~/Projects/<folder>/`

Please note that PHP is upgraded yearly. If you want to use a specific version of PHP, you can specify it in the URL:

* `https://<folder>.php84.localhost` will use PHP 8.4

Or, if you want the code loaded from the "public" folder:

* `https://<folder>.pub.localhost` will use latest version of PHP and load the code from `~/Projects/<folder>/public/`

Lastly, you can combine the two:

* `https://<folder>.php84.pub.localhost` will use PHP 8.4 and load the code from `~/Projects/<folder>/public/`

Some frameworks use a different public folder name (eg. [Wordpress Bedrock](https://roots.io/bedrock/) uses "web"). In these instances we recommend adding a symlink to the public folder:

```bash
cd ~/Projects/<folder>/
ln -s web public
```


## Installation 🚀

> Windows Users: The Docker Dev containers perform best while running inside WSL2. We'll assume your Project folder will be stored inside WSL2, and that you will run these commands in a WSL2 terminal (eg. Ubuntu LTS).

1. Open a terminal window
2. Create a new folder for your projects
```
mkdir ~/Projects
cd ~/Projects
```
**Note**: The `~/` alias points to your home folder (eg. `/home/USERNAME/`)

3. Clone this repo into your projects folder
```
git clone git@github.com:pvtl/docker-dev.git
cd docker-dev
```
4. Copy `.env.example` to `.env` and set `DOCUMENTROOT` to your projects folder (eg. `~/Projects/`)
5. Build and start the Docker containers:
```
docker compose up -d
```

For ease of use we recommend you set up the [Daily Shortcuts](https://github.com/pvtl/docker-dev/#daily-shortcuts-%EF%B8%8F).

Confirm your Docker Dev environment is working correctly using a simple PHP Info file.

1. Create the folder and file: `~/Projects/test/index.php`
1. Edit the file and paste `<?php phpinfo();`
1. In your browser, open https://test.localhost. You should see the PHP Info page.


## Updating 🔄

> Don't worry, your project files and databases live outside of Docker and will be KEPT AS-IS if you follow this update process.

We regularly update this Github project and Docker images with the latest versions of PHP, Apache, MySQL etc.

To install those latest updates, open a terminal window, browse to the `docker-dev` folder and run:

```bash
# 1. Fetch our latest updates
git pull

# 2. Erase previous containers
docker compose down --remove-orphans

# 3. Erase unused Docker builder resources
docker builder prune

# 4. Get latest images from Docker Hub
docker compose pull

# 5. Rebuild Dockerfiles from scratch (inc. pull any parent images)
docker compose build --pull --no-cache --parallel

# 6. Start the updated environment
docker compose up -d --remove-orphans

# 7. Erase any unused containers, images, volumes etc. to free disk space.
docker system prune --volumes
```


## Daily Shortcuts ⚡️

To make your life easier, we recommend setting up aliases in your terminal. You can then start and stop your Docker Dev environment, or jump into a PHP container, with a single command.

If you use ZSH, edit `~/.zshrc`. Otherwise edit `~/.bashrc`. You may need to create the file if it doesn't exist.

1. Paste the code (below) at the bottom of the file
1. Adjust your folder path to suit
1. Close and re-open your terminal to apply the changes
1. Try running `devup`, `devdown` or `devin 84`

```
# Usage: "devup" or "devdown"
alias devup='(cd /home/USERNAME/Projects/docker-dev && docker compose start)'
alias devdown='(cd /home/USERNAME/Projects/docker-dev && docker compose stop)'

# Usage (for PHP 8.4): "devin 84"
# Simply change the numbers for your preferred PHP version (assuming it's installed/enabled)
devin() {
    # Use zsh for PHP 8 and above
    if [[ "${1:0:1}" -ge "8" ]]; then
        docker exec -it php$1 zsh
    else
        docker exec -it php$1 bash
    fi
}
```


## Other Actions 🔥

For those who use Windows or macOS and prefer desktop apps, most of these actions can be done in Docker Desktop. Read on if you prefer using the CLI.

Docker must be running and these commands must be run inside the project root folder (ie. same folder this README is in).

| Command | Description |
|---|---|
| `docker compose start` | Start all containers |
| `docker compose stop`  | Stop all containers (keeps any config changes you've made to the containers) |
| `docker compose up -d --build` | Recreate all containers from scratch |
| `docker compose down --remove-orphans`  | Tear down all containers (MySQL data and project folders are kept) |
| `docker compose exec php84-fpm zsh`  | Open a zsh terminal in the PHP 8.4 container |
| `docker compose logs php84-fpm` | View all logs for PHP-FPM 8.4 |
| `docker compose ps` | Show which containers are running |


## Helpful Info 🤓

- [General FAQ's](docs/general-faq.md)
- [Apache Web Server](docs/apache-web-server.md)
- [PHP](docs/php.md)
    - [PCOV](docs/pcov.md)
    - [Blackfire PHP Profiler](docs/blackfire-php-profiler.md)
    - [Xdebug](docs/xdebug.md)
- [MariaDB / MySQL Database](docs/mariadb-database.md)
- [Mailpit (Email Testing)](docs/mailpit-smtp.md)
- [Node.js](docs/nodejs.md)
- [Valkey (the open source fork of Redis)](docs/valkey.md)
- [Memcached](docs/memcached.md)
