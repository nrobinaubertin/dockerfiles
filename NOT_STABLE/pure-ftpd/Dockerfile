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

VOLUME ["/data", "/config"]
EXPOSE 2121 50000-50009

ENV PURE_PASSWDFILE="/config/pure-ftpd.passwd"
ENV PURE_CONFIGFILE="/config/pure-ftpd.conf"
ENV PURE_PDBFILE="/config/pure-ftpd.pdb"
ENV PURE_QUOTA="1000:10"
ENV UID=791 GID=791
ENV PURE_PASSIVIP=bridge
ENV PURE_CERTFILE=
ENV PURE_KEYFILE=
ENV DOMAIN=localhost

COPY s6.d /etc/s6.d
COPY pure-ftpd.conf /etc/pure-ftpd.conf
COPY run.sh /usr/local/bin/run.sh
COPY addpureuser /usr/local/bin/addpureuser
COPY updatepuredb /usr/local/bin/updatepuredb
RUN chmod -R +x /usr/local/bin/* /etc/s6.d

CMD ["run.sh"]
