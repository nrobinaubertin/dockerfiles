FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG SEND_VERSION=v2.5.5
ENV UID=791 GID=791
EXPOSE 1443

WORKDIR /send

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U redis nodejs npm \
    && apk add --no-cache --virtual .build-deps wget tar ca-certificates openssl git yarn \
    && git clone https://github.com/mozilla/send.git . \
    && git checkout tags/${SEND_VERSION} \
    && yarn \
    && yarn build \
    && rm -rf node_modules \
    && yarn install --production \
    && yarn cache clean \
    && rm -rf .git \
    && apk del .build-deps \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
