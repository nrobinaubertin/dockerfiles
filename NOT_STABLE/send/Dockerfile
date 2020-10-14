FROM node:10-buster AS builder

ARG SEND_VERSION=v3.0.22
WORKDIR /build

RUN set -xe \
    && apt install git openssl \
    && adduser --disabled-password --gecos '' builder \
    && chown -R builder: /build

USER builder

RUN set -xe \
    && git clone https://github.com/mozilla/send.git . \
    && git checkout tags/${SEND_VERSION}

RUN set -xe \
    && sed -i '/puppeteer/d' package.json \
    && rm package-lock.json \
    && npm install \
    && /build/node_modules/.bin/webpack \
    && rm -rf /build/node_modules \
    && npm install --production

FROM node:10-alpine3.11
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ENV UID=791 GID=791
ENV MAX_EXPIRE_DAYS=30

EXPOSE 1443
WORKDIR /send

COPY --from=builder /build .
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY config.js /send/server/config.js

RUN set -xe \
    && apk add --no-cache -U redis \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
