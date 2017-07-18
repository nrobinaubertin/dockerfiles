FROM alpine:3.6

ARG VERSION=1.10.1

ENV UID=791 GID=791

EXPOSE 3000
VOLUME /cryptpad/datastore /cryptpad/customize
WORKDIR /cryptpad

COPY run.sh /usr/local/bin/run.sh
COPY config.js /cryptpad/config.js

RUN set -xe \
    && apk -U add --no-cache su-exec nodejs \
    && apk add --no-cache --virtual .build-deps git tar nodejs-npm ca-certificates openssl \
    && wget -qO- https://github.com/xwiki-labs/cryptpad/archive/${VERSION}.tar.gz | tar xz --strip 1 \
    && npm install \
    && npm install -g bower \
    && bower install --allow-root \
    && chmod +x /usr/local/bin/run.sh \
    && npm uninstall -g bower \
    && apk del .build-deps

CMD ["run.sh"]
