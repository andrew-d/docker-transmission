#!/bin/sh

set -e

CONFIG_DIR="/etc/transmission"
SETTINGS="$CONFIG_DIR/settings.json"
TRANSMISSION="/usr/bin/transmission-daemon"

if [ ! -f "${SETTINGS}.bak" ]; then
    if [ -z "$ADMIN_PASS" ]; then
        echo Please provide a password for the 'transmission' user via the ADMIN_PASS enviroment variable.
        exit 1
    fi

    sed -i.bak -e "s/@PASSWORD@/$ADMIN_PASS/" "$SETTINGS"
fi

unset ADMIN_PASS
exec $TRANSMISSION \
    --config-dir "$CONFIG_DIR" \
    --foreground \
    --no-portmap \
    --log-info 
