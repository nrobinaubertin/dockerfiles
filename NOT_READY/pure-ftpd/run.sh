#!/bin/sh

set -xe

addgroup -g "$GID" ftpuser
adduser -u "$UID" -G ftpuser -D ftpuser

if [ -z "$PURE_PASSIVIP" ]; then
  PURE_PASSIVIP="$(dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null)"
  [ -z "$PURE_PASSIVIP" ] && PURE_PASSIVIP="127.0.0.1"
fi

if [ -z "${PURE_CERTFILE}" ] || [ -z "${PURE_KEYFILE}" ]; then
    PURE_CERTFILE="/config/certs/cert.pem"
    PURE_KEYFILE="/config/certs/key.pem"
fi

# create missing directories
mkdir -p "$(dirname "$PURE_CERTFILE")"
mkdir -p "$(dirname "$PURE_KEYFILE")"
mkdir -p "$(dirname "$PURE_PASSWDFILE")"
mkdir -p "$(dirname "$PURE_CONFIGFILE")"

# generate selfsigned certificate if needed
if ! [ -f "${PURE_CERTFILE}" ] || ! [ -f "${PURE_KEYFILE}" ]; then
    openssl req -new -x509 -days 3650 -nodes \
        -out "${PURE_CERTFILE}" -newkey rsa:4096 \
        -keyout "${PURE_KEYFILE}" -subj "/CN=${DOMAIN}"
fi

sed -i \
  -e "s|<PURE_PASSIVIP>|${PURE_PASSIVIP}|g" \
  -e "s|<PURE_CERTFILE>|${PURE_CERTFILE}|g" \
  -e "s|<PURE_KEYFILE>|${PURE_KEYFILE}|g" \
  -e "s|<PURE_QUOTA>|${PURE_QUOTA}|g" \
  "$PURE_CONFIGFILE"

if [ -n "$PURE_USER" ] && [ -n "$PURE_PASSWD" ]; then
  echo -ne "$PURE_PASSWD\n$PURE_PASSWD\n" | pure-pw useradd "$PURE_USER" -u ftpuser -d "/data/$PURE_USER"
fi

if [ -f "$PURE_PASSWDFILE" ]; then
  pure-pw mkdb /etc/pureftpd.pdb -f "$PURE_PASSWDFILE"
fi

#chown -R "ftpuser:ftpuser" /data
#chmod -R 755 /data

exec /bin/s6-svscan /etc/s6.d
