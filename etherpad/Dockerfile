FROM alpine:3.13
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG ETHERPAD_VERSION=1.8.14
ENV UID=791 GID=791
ENV WELCOME_TEXT="Welcome to Etherpad!\n\nThis pad text is synchronized as you type, so that everyone viewing this page sees the same text. This allows you to collaborate seamlessly on documents!\n\nGet involved with Etherpad at http:\/\/etherpad.org\n"
ENV ETH_SKIN="no-skin"
ENV ETH_TITLE="Etherpad"

EXPOSE 9001

WORKDIR /etherpad

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache nodejs \
    && apk add --no-cache --virtual .build-deps wget ca-certificates gzip curl python3 openssl-dev build-base npm \
    && wget -qO- https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz | tar xz --strip 1 \
    && npm config set unsafe-perm true \
    && bin/installDeps.sh \
    && npm install sqlite3 \
    && npm cache clean --force \
    && rm -rf doc tests bin \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d

COPY settings.json /etherpad/settings.json

VOLUME ["/etherpad/data"]
CMD ["run.sh"]
