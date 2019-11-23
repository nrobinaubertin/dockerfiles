FROM node:10 AS builder

ARG SQUOOSH_VERSION=v1.8.1
WORKDIR /build

RUN set -xe \
    && apt install openssl \
    && adduser --disabled-password --gecos '' builder \
    && chown -R builder: /build

USER builder

RUN set -xe \
    && wget -qO- https://github.com/GoogleChromeLabs/squoosh/archive/${SQUOOSH_VERSION}.tar.gz | tar xz --strip 1 \
    && sed -i '/google-analytics.com/d' src/index.ts \
    && npm install \
    && npm run build

FROM node:10-alpine
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ENV UID=791 GID=791

EXPOSE 8081
WORKDIR /squoosh

COPY --from=builder /build .
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
