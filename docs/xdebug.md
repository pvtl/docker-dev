# Xdebug

Xdebug is a PHP extension that allows you to step-debug your code. It also offers code coverage analysis, though we prefer [PCOV](./pcov.md) because it's faster.

All versions of PHP support Xdebug. The extension is disabled by default.

> Note: As of March 2024, Xdebug seems to be incompatible with Blackfire and causes segmentation faults. You can avoid this issue by following the enable/disable instructions below to ensure only one tool is enabled at a time.


## How it works

Xdebug works by initiating a connection from the PHP-FPM container out to port 9000 on the host machine's IP where it hopes to find an IDE listening on that port. If an IDE is not listening then the script will continue to run normally without Xdebug. The performance penalty will still exist though, so it's recommended you disable Xdebug when you're not using it.

PHP 5.6, 7.0 and 7.1 use older versions of Xdebug 2.x, while PHP 7.2 and above use Xdebug 3.x. There are php.ini config differences between Xdebug 2.x and 3.x, so we've added reasonable default settings for both.


## Enabling Xdebug

Exec into the desired PHP container, run "debug --enable xdebug", then restart the container:

```
# Choose the PHP version you want
devin 83
debug --enable xdebug
exit
docker-compose restart
```

## Disabling Xdebug

Same as above, but run "debug --disable-all":

```
# Choose the PHP version you want
devin 83
debug --disable-all
exit
docker-compose restart
```


## Connecting to your IDE
Xdebug expects the debugging client (eg. VS Code or PHPStorm) to be running on port `9000` of the host machine. Make sure you set your IDE to start listening for Xdebug connections.

It also uses the special Docker hostname of `host.docker.internal` to locate the host machine's IP address. This feature is only available on recent versions of Docker Desktop for Windows and Mac. Linux is not currently supported. As a work-around you can exec into your PHP container, edit `/usr/local/etc/php/conf.d/zza-custom.ini` and put your host machine's IP there instead.

### VS Code

1. Install the [Xdebug Extension](https://github.com/felixfbecker/vscode-php-debug) extension in VS Code
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
