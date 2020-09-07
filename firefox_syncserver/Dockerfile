FROM alpine:3.12
RUN apk add --no-cache -U su-exec tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG SYNC_VERSION=1.8.0
ENV UID=791 GID=791

# This must be edited to point to the public URL of your server,
# i.e. the URL as seen by Firefox.
ENV URL=localhost

# Set this to "true" to work around a mismatch between public_url and
# the application URL as seen by python, which can happen in certain reverse-
# proxy hosting setups.  It will overwrite the WSGI environ dict with the
# details from public_url.  This could have security implications if e.g.
# you tell the app that it's on HTTPS but it's really on HTTP, so it should
# only be used as a last resort and after careful checking of server config.
ENV FORCE_WSGI=false

EXPOSE 5000

WORKDIR /sync

COPY run.sh /usr/local/bin/run.sh
COPY get-pip-20.2.1.py /usr/local/bin/get-pip-20.2.1.py

RUN set -xe && apk add --no-cache python2 make libstdc++ openssl sqlite

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        bash \
        g++ \
        gcc \
        libffi-dev \
        mariadb-connector-c-dev \
        ncurses-dev \
        openssl \
        openssl-dev \
        patch \
        py2-setuptools \
        python2-dev \
        readline \
        sqlite-dev \
    && python /usr/local/bin/get-pip-20.2.1.py \
    && pip install virtualenv \
    && wget -qO- https://github.com/mozilla-services/syncserver/archive/${SYNC_VERSION}.tar.gz | tar xz --strip 1 \
    && sed -i 's/--no-site-packages //' Makefile \
    && echo "urllib3==1.21.1" >> requirements.txt \
    && echo "chardet==3.0.4" >> requirements.txt \
    && echo "pysqlite==2.8.3" >> requirements.txt \
    && make build \
    && apk del .build-deps \
    && chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
