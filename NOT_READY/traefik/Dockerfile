FROM alpine:3.9
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG TRAEFIK_VERSION=v1.7.9
ENV EMAIL="admin@example.com"

EXPOSE 80 443
VOLUME ["/data"]

WORKDIR /traefik

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY traefik.toml /config/traefik.toml

RUN set -xe \
    && apk add --no-cache sed openssl curl jq util-linux bash \
    && apk add --no-cache --virtual .build-deps wget ca-certificates \
    && wget -qO- https://github.com/containous/traefik/archive/${TRAEFIK_VERSION}.tar.gz | tar xz --strip 1 \
    && cp contrib/scripts/dumpcerts.sh /usr/local/bin/ \
    && wget -qO /usr/local/bin/traefik https://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_linux-amd64 \
    && rm -rf /traefik \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d

CMD ["run.sh"]
