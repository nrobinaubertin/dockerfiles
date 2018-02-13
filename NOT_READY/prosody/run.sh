#!/bin/sh

set -xe

sed -i -e "s/DOMAIN/im.${DOMAIN}/g" /www/index.html 

echo '

admins = { "'"${ADMIN}"'" }

ssl = {
    certificate = "/certs/'"${CERTIFICATE}"'";
    key = "/certs/'"${KEY}"'";
    protocol = "tlsv1+"
}

Component "conference.'"${DOMAIN}"'" "muc"
    restrict_room_creation = false;
    max_history_messages = 50;

VirtualHost "'"${DOMAIN}"'"
	enabled = true
    http_host = "im.'"${DOMAIN}"'"

' >> /etc/prosody/prosody.cfg.lua
    
chown -R "${UID}:${GID}" /etc/s6.d /data /var/lib/prosody /www
chmod 755 -R /data /var/lib/prosody

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
