FROM wearepvtl/php-fpm-8.3:latest

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Running these commands as the "root" user

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
  && cp /root/.zshrc /home/${CUSTOM_USER_NAME}/.zshrc \
  && chown -R ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /home/${CUSTOM_USER_NAME}/.zshrc \
  && chown -R ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /home/${CUSTOM_USER_NAME}/.oh-my-zsh \
  && sed -i 's^ZSH_THEME="robbyrussell"^ZSH_THEME="bira"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && sed -i 's^# DISABLE_UPDATE_PROMPT="true"^DISABLE_UPDATE_PROMPT="true"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && sed -i 's^# DISABLE_AUTO_UPDATE="true"^DISABLE_AUTO_UPDATE="true"^g' /home/${CUSTOM_USER_NAME}/.zshrc \
  && echo 'export EDITOR="nano"' >> /home/${CUSTOM_USER_NAME}/.zshrc \
  && su - ${CUSTOM_USER_NAME} -c "git config --global oh-my-zsh.hide-info 1"

# Aliases
RUN echo "alias artisan='php artisan'" >> /home/${CUSTOM_USER_NAME}/.zshrc \
  && echo "alias magento='php bin/magento'" >> /home/${CUSTOM_USER_NAME}/.zshrc \
  && echo "alias debug='sudo /usr/local/bin/change_debug_tool.sh'" >> /home/${CUSTOM_USER_NAME}/.zshrc

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/.gitkeep ./conf/custom.ini* /usr/local/etc/php/conf.d/zzb-custom.ini

# Update permissions for supervisor and cron
RUN chown ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /etc/supervisor/supervisord.pid \
  && chmod gu+rw /var/run \
  && chmod gu+s /usr/sbin/cron

# Copy custom scripts and crons
COPY ./83/Dockerfile ./83/custom_crontab* ./83/custom_scripts* /root/
RUN if [ -f /root/custom_crontab ]; then /usr/bin/crontab -u ${CUSTOM_USER_NAME} /root/custom_crontab; fi
RUN if [ -f /root/custom_scripts ]; then chmod +x /root/custom_scripts; fi
RUN if [ -f /root/custom_scripts ]; then zsh -c '/root/custom_scripts'; fi

# Now we're switching to the custom user
USER ${CUSTOM_UID}:${CUSTOM_GID}
SHELL ["/bin/zsh", "-c"]

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]
