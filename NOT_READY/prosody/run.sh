#!/bin/sh

sed -i -e "s|<DOMAIN>|${DOMAIN}|g" \
       -e "s|<HTTP_UPLOAD_FILE_SIZE_LIMIT>|${HTTP_UPLOAD_FILE_SIZE_LIMIT}|g" \
       -e "s|<HTTP_UPLOAD_EXPIRE_AFTER>|${HTTP_UPLOAD_EXPIRE_AFTER}|g" \
       -e "s|<HTTP_UPLOAD_QUOTA>|${HTTP_UPLOAD_QUOTA}|g" \
       -e "s|<ADMIN>|${ADMIN}|g" /etc/prosody/prosody.cfg.lua

openssl req -new -x509 -days 3650 -nodes \
    -out "/etc/prosody/certs/cert.pem" -newkey rsa:2048 \
    -keyout "/etc/prosody/certs/key.pem" -subj "/CN=${DOMAIN}"

mkdir -p /var/run/prosody
chown -R "${UID}:${GID}" /etc/s6.d /data /var/lib/prosody /etc/prosody /var/run/prosody /usr/lib/prosody/modules
chmod 755 -R /data /var/lib/prosody /etc/prosody

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
