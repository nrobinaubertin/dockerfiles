#!/bin/sh

mkdir -p /public/stats
cp -r /ut2004/UserLogs/* /public/stats
chown "$UID:$GID" -R /public/stats
chmod 755 -R /public/stats
