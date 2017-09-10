FROM alpine:3.6

ARG CONVERSE_VERSION=v3.2.0

ENV UID=791 GID=791
ENV DOMAIN=localhost
ENV ADMIN=admin@localhost
ENV CERTIFICATE=fullchain.pem
ENV KEY=privkey.pem

EXPOSE 5000 5222 5280 5281
VOLUME ["/certs", "/data"]

COPY prosody_modules /prosody_modules
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY index.html /www/index.html
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua

RUN set -xe \
    && apk add --no-cache -U prosody su-exec s6 ca-certificates openssl \
    && apk add --no-cache --virtual .build-deps nodejs nodejs-npm make ruby ruby-bundler ruby-rdoc ruby-irb git \
    && mkdir -p /converse /www/dist \
    && cd /converse \
    && wget -qO- https://github.com/jcbrand/converse.js/archive/${CONVERSE_VERSION}.tar.gz | tar xz --strip 1 \
    && make build \
    && cp -r /converse/dist/inverse.js /www/dist/inverse.js \
    && cp -r /converse/css /www/ \
    && cp -r /converse/fonticons /www/ \
    && rm -rf /converse \
    && rm -rf /root/.bundle \
    && rm -rf /root/.npm \
    && rm -rf /root/.gem \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin/run.sh /etc/s6.d /prosody_modules

CMD ["run.sh"]
