FROM debian:stable-slim

ARG RFTG_VERSION=0.9.5

WORKDIR /rftg

COPY Makefile.am /rftg/Makefile.am
COPY configure.ac /rftg/configure.ac

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends make wget openssl ca-certificates default-libmysqlclient-dev dh-autoreconf automake autoconf m4 perl automake autotools-dev unzip \
    && apt-get install -y --no-install-recommends default-mysql-server default-mysql-client \
    # && wget -qO- https://github.com/bnordli/rftg/archive/${RFTG_VERSION}.tar.gz | tar xz --strip 1 \
    && wget https://github.com/bnordli/rftg/archive/master.zip \
    && unzip master.zip \
    && rm master.zip \
    && mv -t /rftg /rftg/rftg-master/* \
    && cp /rftg/Makefile.am /rftg/src/Makefile.am \
    && cp /rftg/configure.ac /rftg/src/configure.ac \
    && rm /rftg/src/Makefile.in /rftg/src/configure \
    && cd /rftg/src \
    && autoreconf --force --install \
    && aclocal \
    && automake \
    && ./configure --enable-server \
    && make clean && make

RUN set -xe \
    && mkdir -p /var/run/mysqld \
    && sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/* /etc/mysql/mariadb.conf.d/* \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld \
    && /usr/bin/mysql_install_db --user=mysql \
    && /etc/init.d/mysql start \
    && mysql < /rftg/sql/server-schema.sql \
    && /etc/init.d/mysql stop \
    && mv -t /rftg /rftg/src/rftgserver /rftg/src/cards.txt /rftg/src/ai_client /rftg/sql/server-schema.sql /rftg/src/network \
    && rm -rf /rftg/3rdparty /rftg/src \ 
    && apt-get remove -y --allow-remove-essential gcc wget openssl dh-autoreconf automake autoconf m4 autotools-dev iso-codes unzip default-mysql-client \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /bin/run.sh

RUN set -xe \
    && chmod +x /bin/run.sh

EXPOSE 16309

VOLUME /var/lib/mysql

CMD ["run.sh"]
