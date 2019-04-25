#!/bin/sh

root_url="https://github.com/ytdl-org/youtube-dl"
latest_url="$root_url/releases/latest"
version="$(curl -Ls -o /dev/null -w '%{url_effective}' $latest_url | rev | cut -d'/' -f1 | rev)"

cd /usr/local/bin/youtube-dl || exit
wget -qO- "$root_url/releases/download/$version/youtube-dl-$version.tar.gz" | tar xz --strip 1
chmod +x -R /usr/local/bin
