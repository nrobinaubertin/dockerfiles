FROM alpine:3.10
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG TRAEFIK_VERSION=v1.7.14
ENV EMAIL="admin@example.com"

EXPOSE 80 443
VOLUME ["/data"]

WORKDIR /traefik

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY traefik.toml /config/traefik.toml
COPY logrotate.conf /config/logrotate.conf
COPY dumpcerts.sh /usr/local/bin/dumcerts.sh

RUN set -xe \
    && apk add --no-cache sed openssl curl jq util-linux bash logrotate \
    && apk add --no-cache --virtual .build-deps wget ca-certificates \
    && wget -qO /usr/local/bin/traefik https://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_linux-amd64 \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d

CMD ["run.sh"]
