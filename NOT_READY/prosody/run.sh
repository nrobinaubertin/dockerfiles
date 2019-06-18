#!/bin/sh

sed -i -e "s|<DOMAIN>|${DOMAIN}|g" \
       -e "s|<HTTP_UPLOAD_FILE_SIZE_LIMIT>|${HTTP_UPLOAD_FILE_SIZE_LIMIT}|g" \
       -e "s|<HTTP_UPLOAD_EXPIRE_AFTER>|${HTTP_UPLOAD_EXPIRE_AFTER}|g" \
       -e "s|<HTTP_UPLOAD_QUOTA>|${HTTP_UPLOAD_QUOTA}|g" /prosody/prosody.cfg.lua

mkdir -p /data/certs /data/files

if ! [ -f /data/certs/cert.pem ]; then
    openssl req -new -x509 -days 3650 -nodes \
        -out "/data/certs/cert.pem" -newkey rsa:4096 \
        -keyout "/data/certs/key.pem" -subj "/CN=${DOMAIN}"
fi

chown -R "${UID}:${GID}" /etc/s6.d /data /prosody
chmod 755 -R /data /prosody

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
