#!/bin/sh

sed -i -e "s|DOMAIN|${DOMAIN}|g" /www/index.html

sed -i -e "s|<DOMAIN>|${DOMAIN}|g" \
       -e "s|<SUBDOMAIN>|${SUBDOMAIN}|g" \
       -e "s|<ADMIN>|${ADMIN}|g" /etc/prosody/prosody.cfg.lua

openssl req -new -x509 -days 365 -nodes \
    -out "/etc/prosody/certs/${DOMAIN}.crt" -newkey rsa:2048 \
    -keyout "/etc/prosody/certs/${DOMAIN}.key" -subj "/CN=${DOMAIN}"

openssl req -new -x509 -days 365 -nodes \
    -out "/etc/prosody/certs/${SUBDOMAIN}.${DOMAIN}.crt" -newkey rsa:2048 \
    -keyout "/etc/prosody/certs/${SUBDOMAIN}.${DOMAIN}.key" -subj "/CN=${SUBDOMAIN}.${DOMAIN}"

mkdir -p /var/run/prosody
chown -R "${UID}:${GID}" /etc/s6.d /data /var/lib/prosody /etc/prosody /var/run/prosody /usr/lib/prosody/modules /www
chmod 755 -R /data /var/lib/prosody /etc/prosody /www

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
