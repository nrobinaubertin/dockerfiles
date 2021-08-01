#!/bin/sh

set -xe

# create cron task
crontab -r
# everyday at 1:07 AM
echo "\
2 1 * * * /usr/local/bin/carton exec /lutim/script/lutim cron cleanbdd --mode production
4 1 * * * /usr/local/bin/carton exec /lutim/script/lutim cron stats --mode production
6 1 * * * /usr/local/bin/carton exec /lutim/script/lutim cron cleanfiles --mode production" | crontab -

chown -R "${UID}:${GID}" /lutim /etc/s6.d

sed -i -e "s|<SECRET>|$(openssl rand -base64 35)|g" \
       -e "s|<CONTACT>|${CONTACT}|g" \
       -e "s|<MAX_FILE_SIZE>|${MAX_FILE_SIZE}|g" \
       -e "s|<DEFAULT_DELAY>|${DEFAULT_DELAY}|g" \
       -e "s|<MAX_DELAY>|${MAX_DELAY}|g" /lutim/lutim.conf

exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
