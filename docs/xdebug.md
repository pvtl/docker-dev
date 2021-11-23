# XDebug

XDebug is available for all versions of PHP, but it's disabled by default as it makes everything run much slower.


## How it works

XDebug works by initiating a connection from the PHP-FPM container out to port 9000 on the host machine's IP where it hopes to find an IDE listening on that port. If an IDE is not listening then the script will continue to run normally without XDebug. The performance penalty will still exist though, so it's recommended you disable XDebug when you're not using it.

PHP 5.6, 7.0 and 7.1 use older versions of XDebug 2.x, while PHP 7.2 and above use XDebug 3.x. There are php.ini config differences between XDebug 2.x and 3.x, so we've added reasonable default settings for both.


## Enabling / Disabling
You can enable XDebug as needed by exec'ing into the desired PHP container, moving the XDebug config file into place, and restarting that container:

```
docker-compose exec php80-fpm bash
sudo mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
docker-compose restart php80-fpm
```

When you have finished using XDebug, simply reverse the process to disable it again:

```
docker-compose exec php80-fpm bash
sudo mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE
docker-compose restart php80-fpm
```


## Connecting to your IDE
XDebug expects the debugging client (eg. VS Code or PHPStorm) to be running on port `9000` of the host machine. Make sure you set your IDE to start listening for XDebug connections.

It also uses the special Docker hostname of `host.docker.internal` to locate the host machine's IP address. This feature is only available on recent versions of Docker Desktop for Windows and Mac. Linux is not currently supported. As a work-around you can exec into your PHP container, edit `/usr/local/etc/php/conf.d/zza-custom.ini` and put your host machine's IP there instead.

### VS Code

1. Install the [XDebug Extension](https://github.com/felixfbecker/vscode-php-debug) extension in VS Code
1. Click the "Run and Debug" icon in the left sidebar
1. Click "create a launch.json file" and choose "PHP"
1. In the `launch.json` file, change the port number to `9000` and add your own pathmappings array (pointed at your project folder)

In the end your config should look similar to this:

```
...
{
    "name": "Listen for Xdebug",
    "type": "php",
    "request": "launch",
    "port": 9000,
    "pathMappings": {
        "/var/www/html/": "/Users/alice/Projects/"
    }
},
...
```

### PHPStorm

See the guide at: [PHPStorm - Remote Debug (Docker Compose)](https://www.jetbrains.com/help/phpstorm/configuring-remote-php-interpreters.html#d36845e650).


## Triggering a debug session
The easiest way to trigger a debugging session is to use this [Google Chrome extension](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc).

Just open the code in your IDE and set a breakpoint, enable debug mode in the Google Chrome extension and reload the page.

Alternatively, if you're using Postman, cURL or another HTTP client simply send `XDEBUG_SESSION_START=session_name` as a GET or POST parameter. XDEBUG_SESSION_START is the most important bit... the session name can be whatever you want.
