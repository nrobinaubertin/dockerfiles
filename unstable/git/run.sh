#!/bin/sh

# ssh-keygen -N "" -t rsa -b 4096 -f /ssh/ssh_host_rsa_key
# ssh-keygen -N "" -t ed25519 -f /ssh/ssh_host_ed25519_key
# exec /usr/sbin/sshd -D -e -f /ssh/sshd_config
echo "git:$(tr -dc "a-zA-Z0-9-_" < /dev/urandom | fold -w 50 | head -n1)" | chpasswd

sed -i -e "s|<title>|${TITLE}|g" /etc/cgitrc
sed -i -e "s|<description>|${DESCRIPTION}|g" /etc/cgitrc

git init --bare --shared /git/test
git clone --bare https://github.com/nrobinaubertin/dockerfiles.git /git/dockerfiles
git clone --bare https://github.com/so-fancy/diff-so-fancy.git /git/diff-so-fancy
git config --system http.receivepack true
git config --system http.uploadpack true
git config --system user.email "${USER_EMAIL}"
git config --system user.name "${USER_NAME}"

# chown -R "${UID}:${GID}" /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx /usr/libexec/git-core/ /git /run /usr/lib/cgit
# su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
chown -R "git:git" /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx /usr/libexec/git-core/ /git /run /usr/lib/cgit
su-exec "git:git" /bin/s6-svscan /etc/s6.d
