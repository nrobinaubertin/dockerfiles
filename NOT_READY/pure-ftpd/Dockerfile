FROM alpine:3.12 as builder

RUN apk --update --no-cache add \
        autoconf \
        automake \
        binutils \
        build-base \
        curl \
        libsodium \
        openssl-dev \
        tar

ENV PUREFTPD_VERSION="1.0.49"

WORKDIR /tmp/pure-ftpd
RUN wget -qO- "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${PUREFTPD_VERSION}.tar.gz" | tar xz --strip 1 \
    && ./configure \
        --prefix=/pure-ftpd \
        --without-humor \
        --without-inetd \
        --with-altlog \
        --with-cookie \
        --with-ftpwho \
        --with-puredb \
        --with-quotas \
        --with-ratios \
        --with-throttling \
        --with-tls \
        --with-uploadscript \
    && make install-strip

FROM alpine:3.12
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

RUN apk --update --no-cache add \
        bind-tools \
        libsodium \
        openssl \
        tzdata \
        zlib

COPY --from=builder /pure-ftpd /
VOLUME ["/data"]

ENV PURE_PASSWDFILE="/data/pure-ftpd/config/pureftpd.passwd"
ENV PURE_CONFIGFILE="/data/pure-ftpd/config/pure-ftpd.conf"
ENV PURE_QUOTA="1000:10"
ENV UID=791 GID=791
ENV PURE_PASSIVIP=
ENV PURE_CERTFILE=
ENV PURE_KEYFILE=
ENV DOMAIN=localhost
ENV PURE_USER=
ENV PURE_PASSWD=

COPY s6.d /etc/s6.d
COPY pure-ftpd.conf $PURE_CONFIGFILE
COPY run.sh /usr/local/bin/run.sh
RUN set -xe \
    && chmod -R +x /usr/local/bin /etc/s6.d

EXPOSE 2121 50000-55000

CMD ["run.sh"]
