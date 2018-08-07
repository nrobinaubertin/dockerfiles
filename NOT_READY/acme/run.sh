#!/bin/sh

# create cron task
crontab -r
# everyday at 1:07 AM
echo "7 1 * * * /usr/local/bin/renew-certificates" | crontab -

if ! [ -f /certs/dhparams.pem ]; then
    openssl dhparam -out /certs/dhparams.pem 2048
fi
chmod 755 -R /http /var/log
chown "${UID}:${GID}" -R /http /etc/s6.d /certs /acme /var/log
su-exec "${UID}:${GID}" thttpd -d /http -p 8080
echo "Waiting a bit for thttpd..."
sleep 1
if pgrep thttpd > /dev/null; then
    domains="$(echo ";"${DOMAINS} | tr -d '\n' | sed 's/;\+$//' | sed 's/;\+/ -d /g')"
    su-exec "${UID}:${GID}" acme.sh --issue ${domains} -w /http/ --certhome "${CERTHOME}" --home "${HOME}" --debug
    killall thttpd
    exec /bin/s6-svscan /etc/s6.d
else
    echo "thttpd did not start. Aborting."
fi
