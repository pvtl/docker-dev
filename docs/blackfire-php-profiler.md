# Blackfire

Blackfire is a PHP profiler that helps you analyse the performance of your code. It's a paid service, but you can get a free trial at [blackfire.io](https://blackfire.io).

We only support PHP 8.1+ for Blackfire. The extension is disabled by default.


## How it works

Blackfire works by profiling your code as it runs.

A PHP extension must be installed into your PHP container. While the code is running, the PHP extension sends the profiling data to the (local) Blackfire agent container. The agent container processes the data and uploads it to the Blackfire.io website (where you can view the results).


## Enabling Blackfire

1. Edit your `.env` file
    - Fill in all Blackfire environment variables
    - Enable the agent container by adding `opt/blackfire.yml` to the `COMPOSE_FILE` list
1. Enable the Blackfire extension for PHP:

```
# Choose the PHP version you want
devin 84
debug --enable blackfire
exit
docker-compose restart
```

## Disabling Blackfire

Similar to above. Simply run "debug --disable-all":

```
# Choose the PHP version you want
devin 84
debug --disable-all
exit
docker-compose restart
```


## How do I use Blackfire?

Make sure you've enabled the Blackfire extension for PHP as per the instructions above. You can confirm it's enabled by using `phpinfo()` in your browser.

1. Sign into [blackfire.io](https://blackfire.io)
1. Install the Blackfire extension in your browser. Here's one for [Google Chrome](https://chrome.google.com/webstore/detail/blackfire-profiler/miefikpgahefdbcgoiicnmpbeeomffld?utm_source=chrome-ntp-icon)
1. Navigate to the site/page you'd like to profile
1. Click the 'Profile' button in the Blackfire browser extension


## Troubleshooting common Blackfire issues

1. Check the Blackfire extension is installed in your PHP container. Use `phpinfo()` to confirm.
1. Check the Blackfire agent (container) is running. Use `docker compose ps` to confirm.
1. Check your Blackfire environment variables are correct in `.env`.


## How do I interpret the results?

The [Blackfire documentation](https://blackfire.io/docs/) should have the answers you are looking for.
