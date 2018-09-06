#!/bin/sh

chown -R "${UID}:${GID}" /radicale /etc/s6.d

sed -i -e "s|<HTPASSWD_ENCRYPTION>|${HTPASSWD_ENCRYPTION}|g" /radicale/radicale.ini
sed -i -e "s|<HTPASSWD_FILE>|${HTPASSWD_FILE}|g" /radicale/radicale.ini

exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
