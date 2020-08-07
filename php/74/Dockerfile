FROM wearepvtl/php-fpm-7.4

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Install Blackfire
# RUN curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;') \
#   && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#   && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#   && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/999-custom.ini

# Copy CRON's
COPY ./74/Dockerfile ./74/custom_crontab* /root/

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
