#!/bin/sh

set -e

CONFIG_DIR="/etc/transmission"
SETTINGS="$CONFIG_DIR/settings.json"
TRANSMISSION="/usr/bin/transmission-daemon"

# Set the password for the transmission user
if [ ! -f "${SETTINGS}.bak" ]; then
    if [ -z "$ADMIN_PASS" ]; then
        echo Please provide a password for the 'transmission' user via the ADMIN_PASS enviroment variable.
        exit 1
    fi

    sed -i.bak -e "s/@PASSWORD@/$ADMIN_PASS/" "$SETTINGS"
fi
unset ADMIN_PASS

# Set the UID/GID of the 'transmission' user.
l_USER_ID="$USER_ID"
l_GROUP_ID="$GROUP_ID"

if [ -z "$l_USER_ID" ]; then
    l_USER_ID=1000
fi
if [ -z "$l_GROUP_ID" ]; then
    l_GROUP_ID=1000
fi

echo "Setting the UID/GID of the 'transmission' user to $l_USER_ID:$l_GROUP_ID..."

sed -E \
    -i.bak \
    -e "s|transmission:x:(\\d*):(\\d*)|transmission:x:$l_USER_ID:$l_GROUP_ID|" \
    /etc/passwd

unset l_USER_ID l_GROUP_ID USER_ID GROUP_ID

# Run the command as the transmission user
exec su -s /bin/sh -c 'exec "$0" "$@"' transmission -- \
    $TRANSMISSION \
        --config-dir "$CONFIG_DIR" \
        --foreground \
        --no-portmap \
        --log-info
