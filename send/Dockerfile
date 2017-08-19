FROM node:8-alpine

ARG SEND_VERSION=v1.1.2

ENV UID=791 GID=791

EXPOSE 1443

COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

WORKDIR /send

RUN set -xe \
    && apk add --no-cache -U su-exec redis s6 \
    && apk add --no-cache --virtual .build-deps wget tar ca-certificates openssl git \
    && wget -qO- https://github.com/mozilla/send/archive/${SEND_VERSION}.tar.gz | tar xz --strip 1 \
    && npm install \
    && npm run build \
    && rm -rf node_modules \
    && npm install --production \
    && npm cache clean --force \
    && apk del .build-deps \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
