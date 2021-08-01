#!/bin/sh

chown -R "${UID}:${GID}" /etherpad /etc/s6.d
sed -i -e "s|<ETH_TITLE>|${ETH_TITLE}|g" \
       -e "s|<WELCOME_TEXT>|${WELCOME_TEXT}|g" \
       -e "s|<ETH_SKIN>|${ETH_SKIN}|g" /etherpad/settings.json
exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
