FROM alpine:3.11
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG SYNCTHING_VERSION=v1.4.2
ENV UID=791 GID=791

EXPOSE 8384 22000 21027/udp
VOLUME ["/data"]

WORKDIR /data

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && wget -qO- https://github.com/syncthing/syncthing/releases/download/${SYNCTHING_VERSION}/syncthing-linux-amd64-${SYNCTHING_VERSION}.tar.gz | tar xz --strip 1 \
    && mv /data/syncthing /usr/local/bin \
    && chmod -R +x /usr/local/bin /etc/s6.d

HEALTHCHECK --interval=1m --timeout=10s CMD nc -z localhost 8384 || exit 1

CMD ["run.sh"]
