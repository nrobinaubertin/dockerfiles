#!/bin/sh

set -x

sed -i -e "s|<DOMAIN>|${DOMAIN}|g" /cryptpad/config/config.example.js

# Create some directories
mkdir -p customize cfg config blobstage datastore data block blob

# Populating customize folder
[ -z "$(ls -A customize)" ] && echo "Populating customize folder" && cp -R customize.dist/* customize/

# Linking config.js
#[ ! -L cfg/config.js ] && echo "Linking cfg/config.js" && ln -s /cryptpad/config.js cfg/config.js
#[ ! -L config/config.js ] && echo "Linking config/config.js" && ln -s /cryptpad/config.js config/config.js

chown -R "$UID:$GID" /cryptpad
su-exec "$UID:$GID" node ./server.js
