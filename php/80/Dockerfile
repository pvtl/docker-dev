FROM wearepvtl/php-fpm-8.0:latest

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Setup user (to stay in-sync with the host system's user)
ARG CUSTOM_USER_NAME
ARG CUSTOM_UID
ARG CUSTOM_GID
RUN groupadd -g ${CUSTOM_GID} ${CUSTOM_USER_NAME} \
  && useradd -m -u ${CUSTOM_UID} -g ${CUSTOM_USER_NAME} -G sudo -s /usr/bin/zsh ${CUSTOM_USER_NAME} \
  && passwd -d ${CUSTOM_USER_NAME} \
  && echo "${CUSTOM_USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ZSH & config
RUN ZSH="/home/${CUSTOM_USER_NAME}/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" chsh -s $(which zsh) ${CUSTOM_USER_NAME} \
  && mv /root/.zshrc /home/${CUSTOM_USER_NAME}/.zshrc \
  && chown -R ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /home/${CUSTOM_USER_NAME}/.oh-my-zsh \
  && sed -i 's^ZSH_THEME="robbyrussell"^ZSH_THEME="bira"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && sed -i 's^# DISABLE_UPDATE_PROMPT="true"^DISABLE_UPDATE_PROMPT="true"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && sed -i 's^# DISABLE_AUTO_UPDATE="true"^DISABLE_AUTO_UPDATE="true"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && echo 'export EDITOR="nano"' >> /home/${CUSTOM_USER_NAME}/.zshrc \
  && su - ${CUSTOM_USER_NAME} -c "git config --global oh-my-zsh.hide-info 1"

# Install Blackfire
# RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
#   && architecture=$(uname -m) \
#   && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/$architecture/$version \
#   && mkdir -p /tmp/blackfire \
#   && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
#   && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
#   && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
#   && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Aliases
RUN echo "alias artisan='php artisan'" >> /home/${CUSTOM_USER_NAME}/.zshrc \
  && echo "alias magento='php bin/magento'" >> /home/${CUSTOM_USER_NAME}/.zshrc

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/.gitkeep ./conf/custom.ini* /usr/local/etc/php/conf.d/zzb-custom.ini

# Update permissions for supervisor and cron
RUN chown ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /etc/supervisor/supervisord.pid \
  && chmod gu+rw /var/run \
  && chmod gu+s /usr/sbin/cron

# Copy and run custom scripts
# Copy and enable CRON/s
COPY ./80/Dockerfile ./80/custom_crontab* ./80/custom_scripts* /root/
RUN /usr/bin/crontab -u ${CUSTOM_USER_NAME} /root/custom_crontab
RUN if [ -f /root/custom_scripts ]; then chmod +x /root/custom_scripts; fi
RUN if [ -f /root/custom_scripts ]; then zsh -c '/root/custom_scripts'; fi

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
