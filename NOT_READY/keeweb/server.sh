#!/bin/sh
PORT=8080
FILE=/keeweb/index.html
CONTENT_TYPE=text/html

while true; do
BODY=$(cat $FILE | sed 's/manifest="manifest.appcache"//')
RESPONSE=$(cat <<EOF
HTTP/1.0 200 OK
Content-Type: ${CONTENT_TYPE}
Content-Length: $((${#BODY}+1))
Connection: close

${BODY}
EOF
)
echo "---$((X=X+1))---"
echo "$RESPONSE" | nc -N -l -p $PORT
done
