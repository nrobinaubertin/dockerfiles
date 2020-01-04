FROM python:3-alpine3.11
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

EXPOSE 5232
ENV UID=791 GID=791
ENV HTPASSWD_ENCRYPTION=bcrypt
ENV HTPASSWD_FILE=htpasswd

WORKDIR /radicale

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache openssl ca-certificates \
    && apk add --no-cache --virtual .build-deps build-base python3-dev libffi-dev \
	&& pip install --upgrade  --no-cache-dir radicale passlib bcrypt \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d

COPY radicale.ini /radicale/radicale.ini

VOLUME ["/radicale/collections", "/radicale/config"]

CMD ["run.sh"]
