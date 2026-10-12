#!/bin/sh
mkdir -p /app/live /app/logs
touch /app/logs/error.log /app/logs/access.log
rm -f /app/live/*.m3u8 /app/live/*.ts
echo "IPTV TEST BASLIYOR"
nginx -c /app/nginx.conf -g 'daemon off;' &
sleep 3
tail -f /app/logs/error.log
