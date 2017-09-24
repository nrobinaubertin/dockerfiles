FROM debian:stable-slim

ARG RFTG_VERSION=0.9.5

WORKDIR /rftg

COPY run.sh /bin/run.sh
COPY Makefile.am /rftg/Makefile.am
COPY configure.ac /rftg/configure.ac

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends make wget openssl ca-certificates default-mysql-server default-libmysqlclient-dev dh-autoreconf automake autoconf m4 perl automake autotools-dev default-mysql-client \
    && wget -qO- https://github.com/bnordli/rftg/archive/${RFTG_VERSION}.tar.gz | tar xz --strip 1 \
    && cp /rftg/Makefile.am /rftg/src/Makefile.am \
    && cp /rftg/configure.ac /rftg/src/configure.ac \
    && rm /rftg/src/Makefile.in \
    && rm /rftg/src/configure \
    && cd /rftg/src \
    && autoreconf --force --install \
    && aclocal \
    && automake \
    && ./configure --enable-server \
    && make clean && make \
    && /etc/init.d/mysql start \
    && mysql < /rftg/sql/server-schema.sql \
    && /etc/init.d/mysql stop \
    && chmod +x /bin/run.sh \
    && mv -t /rftg /rftg/src/rftgserver /rftg/src/cards.txt /rftg/src/ai_client \
    && rm -rf /rftg/3rdparty /rftg/src \ 
    && apt-get remove -y --allow-remove-essential gcc wget openssl dh-autoreconf automake autoconf m4 autotools-dev default-mysql-client iso-codes \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 16309

# CMD ["run.sh"]
