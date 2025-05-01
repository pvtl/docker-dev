# Node.js

The latest LTS version of Node.js is pre-installed the newest PHP container.

This was a deliberate decision in order to keep the PHP containers as small as possible, but still provide the convenience of having these tools available.

If your PHP-based website requires an older PHP, that's ok. Keep running it in the older PHP container and use the newest PHP container for Node.js based tooling.


## Troubleshooting: Node isn't working / not installed

Make sure you are inside the newest PHP container. For example:

```bash
devin 84
```

Then check the version of Node.js:

```bash
node -v
```

If you get an error like `bash: node: command not found`, you're using the wrong command shell. This might also be because you're using outdated aliases.

Follow the "Daily Shortcuts" section again in the README to update your aliases. Then run `devin 84` again and check the Node.js version.

If you're manually running `docker exec -it php84 bash`, you'll need to update the command to `docker exec -it php84 zsh` (ie. use ZSH instead of BASH).



## Node Version Manager (NVM)

It's likely that you'll want to use a range of Node.js version for your projects, so we've pre-installed NVM to make switching between them easy.

List all currently installed versions:

```bash
nvm ls
```

Install an older version (eg. v18.x):

```bash
nvm install 18
```

Start using a specific version (eg. v18.x):

```bash
nvm use 18
```

Check which version is currently active:

```bash
node -v
```

Discover the other features of NVM:

```bash
nvm --help
```


## Can I use the latest (non-LTS) version of Node.js?

Sure, just run:

```bash
nvm install node
```

Please note the latest version may be newer than the current LTS version, so be aware of the potential for breaking changes in your projects.


## How do I run NPM scripts?

```bash
devin 84
cd example-site
npm run dev
```
