FROM alpine:3.9
RUN apk add --no-cache -U su-exec tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG CRYPTPAD_VERSION=2.18.0
ENV UID=791 GID=791
ENV DOMAIN=https://localhost:3000/

EXPOSE 3000
VOLUME /cryptpad/datastore /cryptpad/customize
WORKDIR /cryptpad

COPY run.sh /usr/local/bin/run.sh
COPY config.js /cryptpad/config.js

RUN set -xe \
    && apk add --no-cache nodejs \
    && apk add --no-cache --virtual .build-deps git tar nodejs-npm ca-certificates openssl python2 make g++ \
    && mkdir -p /cryptpad/pins \
    && wget -qO- https://github.com/xwiki-labs/cryptpad/archive/${CRYPTPAD_VERSION}.tar.gz | tar xz --strip 1 \
    && npm config set unsafe-perm true \
    && npm install \
    && npm install -g bower \
    && bower install --allow-root \
    && chmod +x /usr/local/bin/run.sh \
    && npm uninstall -g bower \
    && apk del .build-deps

CMD ["run.sh"]
