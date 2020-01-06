FROM node:10-buster AS builder

ARG SEND_VERSION=v3.0.21
WORKDIR /build

RUN set -xe \
    && apt install git openssl \
    && adduser --disabled-password --gecos '' builder \
    && chown -R builder: /build

USER builder

RUN set -xe \
    && git clone https://github.com/mozilla/send.git . \
    && git checkout tags/${SEND_VERSION}

COPY geodb.patch /build/geodb.patch
RUN set -xe \
    && git apply --stat geodb.patch \
    && git apply --check geodb.patch \
    && git apply geodb.patch \
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

EXPOSE 1443
WORKDIR /send

COPY --from=builder /build .
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U redis \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
