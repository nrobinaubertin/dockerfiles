#!/bin/sh

mkdir -p /data/files

if [ -z "${SSL_CERT}" ] || [ -z "${SSL_KEY}" ]; then
	mkdir -p /data/certs
	SSL_CERT="/data/certs/cert.pem"
	SSL_KEY="/data/certs/key.pem"
fi

# generate selfsigned certificate if needed
if ! [ -f "${SSL_CERT}" ] || ! [ -f "${SSL_KEY}" ]; then
	openssl req -new -x509 -days 3650 -nodes \
		-out "${SSL_CERT}" -newkey rsa:4096 \
		-keyout "${SSL_KEY}" -subj "/CN=${DOMAIN}"
fi

sed -i -e "s|<DOMAIN>|${DOMAIN}|g" \
       -e "s|<HTTP_UPLOAD_FILE_SIZE_LIMIT>|${HTTP_UPLOAD_FILE_SIZE_LIMIT}|g" \
       -e "s|<HTTP_UPLOAD_EXPIRE_AFTER>|${HTTP_UPLOAD_EXPIRE_AFTER}|g" \
       -e "s|<SSL_CERT>|${SSL_CERT}|g" \
       -e "s|<SSL_KEY>|${SSL_KEY}|g" \
       -e "s|<ADMIN_EMAIL>|${ADMIN_EMAIL}|g" \
       -e "s|<ADMIN_XMPP>|${ADMIN_XMPP}|g" \
       -e "s|<MUC_SUBDOMAIN>|${MUC_SUBDOMAIN}|g" \
       -e "s|<HTTP_UPLOAD_QUOTA>|${HTTP_UPLOAD_QUOTA}|g" /prosody/prosody.cfg.lua

chown -R "${UID}:${GID}" /etc/s6.d /data /prosody
chmod 755 -R /data /prosody

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
