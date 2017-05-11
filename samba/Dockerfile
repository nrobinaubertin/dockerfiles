FROM alpine:latest
LABEL Description="Simple, lightweight and secure Samba docker container, based on alpine linux." Version="0.1.1"

ENV USERNAME=samba

# install the required packages
RUN set -xe \
    && mkdir /config \
    && apk add --no-cache -U samba samba-common-tools tini

# copy the config and script files
COPY smb.conf /config/smb.conf
COPY run.sh /usr/local/bin/run.sh

# add the user
RUN set -xe \
    && adduser -D $USERNAME \
    && PASSWORD=$(cat /dev/urandom | tr -dc "a-zA-Z0-9-_" | fold -w 50 | head -n1) \
    && (echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -sa -c /config/smb.conf $USERNAME \
    && chmod +x /usr/local/bin/run.sh \
    && chown -R $USERNAME:$USERNAME /var/log/samba \
    && chown -R $USERNAME:$USERNAME /var/cache/samba \
    && chown -R $USERNAME:$USERNAME /var/lib/samba \
    && chown -R $USERNAME:$USERNAME /var/run/samba

VOLUME /shared

# exposes samba's ports (defaults are : 137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 7137 7138 7139 7445

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["run.sh"]
