#!/bin/sh

set -x

mv -n /wordpress/wp-content-original/* /wordpress/wp-content/

sed -i -e "s|<AUTH_KEY>|$(openssl rand -base64 48)|g" \
       -e "s|<SECURE_AUTH_KEY>|$(openssl rand -base64 48)|g" \
       -e "s|<LOGGED_IN_KEY>|$(openssl rand -base64 48)|g" \
       -e "s|<NONCE_KEY>|$(openssl rand -base64 48)|g" \
       -e "s|<AUTH_SALT>|$(openssl rand -base64 48)|g" \
       -e "s|<SECURE_AUTH_SALT>|$(openssl rand -base64 48)|g" \
       -e "s|<LOGGED_IN_SALT>|$(openssl rand -base64 48)|g" \
       -e "s|<NONCE_SALT>|$(openssl rand -base64 48)|g" /wordpress/wp-config.php

mkdir -p /run/nginx /var/tmp/nginx /run/mysqld
chown -R "${UID}:${GID}" \
  /etc/s6.d \
  /wordpress \
  /etc/php7 \
  /etc/nginx \
  /var/lib/nginx \
  /var/log \
  /run \
  /var/tmp/nginx \
  /etc/phpmyadmin \
  /usr/share/webapps
su-exec "${UID}:${GID}" mysql_install_db --datadir="/wordpress/wp-content/mysql"
(
    sleep 10
    mysqladmin -u root password "root"
    mysqladmin -u root --password="root" create "wordpress"
) &
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
