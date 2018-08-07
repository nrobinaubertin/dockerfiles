FROM alpine:3.7

# ARG PUBLIC_KEY=id_rsa.pub
ENV DOMAIN=git.niels.fr
ENV UID=791 GID=791
ENV USER_EMAIL=""
ENV USER_NAME=""
ENV TITLE=""
ENV DESCRIPTION=""

EXPOSE 8080

COPY s6.d /etc/s6.d
COPY nginx /nginx
COPY run.sh /usr/local/bin/run.sh
COPY cgitrc /etc/cgitrc
# COPY sshd_config /ssh/sshd_config
# COPY $PUBLIC_KEY /ssh/authorized_keys

RUN set -xe \
    && apk add --no-cache -U git nginx s6 su-exec fcgiwrap cgit python3 py3-markdown py3-pygments \
    && adduser -D git -s /usr/bin/git-shell \
    && mkdir -p /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

CMD ["run.sh"]
