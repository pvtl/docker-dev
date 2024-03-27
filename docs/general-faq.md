# General FAQ's


## Using hostnames on your computer

If you have PHP installed on your computer also (ie. outside of Docker Dev) then you may run into occasional issues where your application is configured to use the nice hostnames like "mailpit" or "mysql", but your local computer doesn't know where to find them. You might see connection failed errors or similar.

The solution is to add those hostnames to your hosts file:

```
127.0.0.1   mysql
127.0.0.1   mailpit
...
```


## What is a hosts file?

Normally your device uses DNS servers to lookup the IP address of a domain name. However occasionally you may want to override this and tell your device to use a specific IP address instead. This is what a hosts file does.

Windows, macOS and Linux all use their own forms of hosts files.

Unfortunately, you can't use hosts files on mobile devices (eg. Android, iOS).


## How can I edit my hosts file?

Follow this guide: https://www.hostinger.com/tutorials/how-to-edit-hosts-file


## How can I customise my containers?

Each version of PHP can have its own additional commands that are run when the container is being built.

These commands are run as the `root` user, and you can run almost any shell command you'd like.

1. Simply create a file called `custom_scripts` in the PHP directory of your choice (eg. `/php/83/custom_scripts`). Add a shebang (`#!/bin/zsh`) followed by your shell commands.
1. Rebuild that PHP container: `docker compose build php83-fpm`
1. And start it up: `docker compose up -d`

Here is an example to add a new alias to your shell's RC file:

```
#!/bin/zsh

echo "alias codecheck ='php -d memory_limit=-1 ./vendor/bin/phpcs -s .'" | sudo tee -a /home/${CUSTOM_USER_NAME}/.zshrc
```

NOTE: All Dockerfile arguments are available to use in your commands


## "Container Name already in use" error

In some instances a Docker build may fail due to a `Container Name already in use` error. Follow the "update" instructions in the main README. This will recreate a fresh environment from scratch.
