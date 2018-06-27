#!/bin/sh

openssl dhparam -out /certs/dhparams.pem 2048
chmod 755 -R /http
chown "${UID}:${GID}" -R /http /etc/s6.d /certs /acme
su-exec "${UID}:${GID}" thttpd -d /http -p 8080
echo "Waiting a bit for thttpd..."
sleep 1
if pgrep thttpd > /dev/null; then
    domains=$(echo ";"${DOMAINS} | tr -d '\n' | sed 's/;\+$//' | sed 's/;\+/ -d /g')
    su-exec "${UID}:${GID}" acme.sh --issue ${domains} -w /http/ --certhome "${CERTHOME}" --home "${HOME}" --debug
    killall thttpd
    su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
else
    echo "thttpd did not start. Aborting."
fi
