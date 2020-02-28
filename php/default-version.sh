# Install Yarn
curl -sS 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update \
  && apt install -y --no-install-recommends yarn

# Install Node
curl -sL https://deb.nodesource.com/setup_13.x | bash - \
  && apt install -y --no-install-recommends nodejs

# Wordpress CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Blackfire PHP Profiler
# version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
#   && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
#   && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#   && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#   && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini
