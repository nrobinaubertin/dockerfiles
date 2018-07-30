FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG ACMESH_VERSION=2.7.9
ENV UID=791 GID=791
ENV HOME=/acme CONFIGHOME=/acme/data CERTHOME=/certs
ENV DOMAINS="example.com;test.example.org"

EXPOSE 8080
VOLUME ["/certs"]

WORKDIR /acme

RUN set -xe \
    && apk add --no-cache thttpd openssl curl sed \
    && apk add --no-cache --virtual .build-deps wget ca-certificates \
    && wget -qO- https://github.com/Neilpang/acme.sh/archive/${ACMESH_VERSION}.tar.gz | tar xz --strip 1 \
    && mv acme.sh /usr/local/bin \
    && rm -rf /acme/* \
    && mkdir -p /http \
    && apk del .build-deps \
    && rm -f /var/cache/apk/*

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY renew-certificates /etc/periodic/daily
RUN set -xe && chmod -R +x /usr/local/bin /etc/s6.d /etc/periodic

CMD ["run.sh"]
