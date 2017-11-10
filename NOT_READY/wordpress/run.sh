#!/bin/sh

mv -n /wordpress/wp-content-original/* /wordpress/wp-content/
mkdir -p /var/lib/nginx/logs /nginx/logs /nginx/tmp

AUTH_KEY=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<AUTH_KEY>|${AUTH_KEY}|g" /wordpress/wp-config.php
SECURE_AUTH_KEY=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<SECURE_AUTH_KEY>|${SECURE_AUTH_KEY}|g" /wordpress/wp-config.php
LOGGED_IN_KEY=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<LOGGED_IN_KEY>|${LOGGED_IN_KEY}|g" /wordpress/wp-config.php
NONCE_KEY=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<NONCE_KEY>|${NONCE_KEY}|g" /wordpress/wp-config.php
AUTH_SALT=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<AUTH_SALT>|${AUTH_SALT}|g" /wordpress/wp-config.php
SECURE_AUTH_SALT=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<SECURE_AUTH_SALT>|${SECURE_AUTH_SALT}|g" /wordpress/wp-config.php
LOGGED_IN_SALT=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<LOGGED_IN_SALT>|${LOGGED_IN_SALT}|g" /wordpress/wp-config.php
NONCE_SALT=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)
sed -i -e "s|<NONCE_SALT>|${NONCE_SALT}|g" /wordpress/wp-config.php

chown -R "${UID}:${GID}" /php /nginx /etc/s6.d /run /wordpress /var/lib/nginx /var/tmp/nginx /var/log/nginx
su-exec "${UID}:${GID}" run2.sh
