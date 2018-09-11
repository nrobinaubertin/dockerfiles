#!/bin/sh

sed -i -e "s/DOMAIN/${SUBDOMAIN}.${DOMAIN}/g" /www/index.html

echo '

admins = { "'"${ADMIN}"'" }

ssl = {
    certificate = "/etc/prosody/certs/'"${DOMAIN}"'.crt";
    key = "/etc/prosody/certs/'"${DOMAIN}"'.key";
    protocol = "tlsv1+"
}

Component "${SUBDOMAIN}.'"${DOMAIN}"'" "muc"
    restrict_room_creation = false;
    max_history_messages = 50;

VirtualHost "'"${DOMAIN}"'"
	enabled = true
    http_host = "${SUBDOMAIN}.'"${DOMAIN}"'"

' >> /etc/prosody/prosody.cfg.lua

openssl req -new -x509 -days 365 -nodes \
    -out "/etc/prosody/certs/${DOMAIN}.crt" -newkey rsa:2048 \
    -keyout "/etc/prosody/certs/${DOMAIN}.key" -subj "/CN=${DOMAIN}"

openssl req -new -x509 -days 365 -nodes \
    -out "/etc/prosody/certs/${SUBDOMAIN}.${DOMAIN}.crt" -newkey rsa:2048 \
    -keyout "/etc/prosody/certs/${SUBDOMAIN}.${DOMAIN}.key" -subj "/CN=${SUBDOMAIN}.${DOMAIN}"

chown -R "${UID}:${GID}" /etc/s6.d /data /var/lib/prosody /www /etc/prosody
chmod 755 -R /data /var/lib/prosody /www /etc/prosody

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
