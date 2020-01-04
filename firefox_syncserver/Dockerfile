FROM alpine:3.10
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

RUN set -xe \
    && apk add --no-cache python2 make libstdc++ openssl \
    && apk add --no-cache --virtual .build-deps py2-pip g++ gcc python2-dev openssl libffi-dev openssl-dev \
    && pip install virtualenv \
    && wget -qO- https://github.com/mozilla-services/syncserver/archive/${SYNC_VERSION}.tar.gz | tar xz --strip 1 \
    && make build \
    && apk del .build-deps \
    && chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
