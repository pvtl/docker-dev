FROM mariadb:11.8

LABEL maintainer.name="Pivotal Agency" \
      maintainer.email="tech@pvtl.io"

# Copy and run custom scripts
COPY ./Dockerfile ./custom_scripts* /root/
RUN if [ -f /root/custom_scripts ]; then chmod +x /root/custom_scripts; fi
RUN if [ -f /root/custom_scripts ]; then bash -c '/root/custom_scripts'; fi
