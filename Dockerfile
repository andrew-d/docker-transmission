FROM alpine:3.3
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Install transmission
RUN apk add -U transmission-cli transmission-daemon

# Copy the files to the image
ADD ./files/ /tmp/

# Run the actual build:
#   1. Copy the config file into place
#   2. Copy the run script into place
#   3. Remove all remaining build files and clean our apk cache
RUN mkdir -p /etc/transmission && \
    mkdir -p /opt/transmission/incomplete && \
    mkdir -p /opt/transmission/downloads && \
    sed \
        -e 's|@ROOT_DIR@|/opt/transmission|g' \
        /tmp/settings.json > /etc/transmission/settings.json && \
    mv /tmp/run-transmission.sh /run-transmission.sh && \
    chown -R transmission:transmission /opt/transmission && \
    chown -R transmission:transmission /etc/transmission && \
    rm -rf /tmp/* /var/cache/apk/* 

# Set up the volumes
VOLUME ["/opt/transmission/downloads"]
VOLUME ["/opt/transmission/incomplete"]

# Expose our RPC and bind ports
EXPOSE 9091
EXPOSE 12345

CMD ["/run-transmission.sh"]
