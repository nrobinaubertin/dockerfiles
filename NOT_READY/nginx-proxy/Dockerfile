FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ENV UID=791 GID=791
VOLUME ["/certs"]
EXPOSE 8080 8443

COPY s6.d /etc/s6.d
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh
COPY genProxyConfig.py /usr/local/bin/genProxyConfig
COPY getLastStartEvent.py /usr/local/bin/getLastStartEvent
COPY watchContainers /usr/local/bin/watchContainers

RUN set -xe \
    && apk add --no-cache ca-certificates nginx openssl python3 docker-py \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

CMD ["run.sh"]
