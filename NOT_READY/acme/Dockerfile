FROM alpine:3.7

ARG ACMESH_VERSION=2.7.8
ENV UID=791 GID=791
ENV HOME=/acme CONFIGHOME=/acme/data CERTHOME=/certs
ENV DOMAINS="example.com;test.example.org"

EXPOSE 8080
VOLUME ["/certs"]

WORKDIR /acme

RUN set -xe \
    && apk add --no-cache -U s6 su-exec thttpd openssl curl sed \
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
COPY domains /acme
RUN set -xe && chmod -R +x /usr/local/bin /etc/s6.d /etc/periodic

CMD ["run.sh"]
