# PCOV

PCOV is a lightweight PHP extension for code coverage analysis.

We only support PHP 8.1+ for PCOV. The extension is disabled by default.


## How it works

It works by hooking into the PHP executor to record which lines of code are executed during runtime. PCOV is designed to be significantly faster than Xdebug for collecting line coverage information, with minimal impact on code execution speed.

Check the documentation for your testing framework to see how you can use PCOV. For example, with Laravel and [Pest](https://pestphp.com/docs/test-coverage), you can run `php artisan test --coverage`.


## Enabling PCOV

Exec into the desired PHP container, run "debug --enable pcov", then restart the container:

```
# Choose the PHP version you want
devin 84
debug --enable pcov
exit
docker-compose restart
```

## Disabling PCOV

Same as above, but run "debug --disable-all":

```
# Choose the PHP version you want
devin 84
debug --disable-all
exit
docker-compose restart
```
