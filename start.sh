#!/bin/sh
echo "10 KANAL BASLIYOR..."
rm -rf /tmp/hls/*
mkdir -p /tmp/hls/cam{1..10}

/app/start_ffmpeg.sh &

echo "FFMPEG BASLADI, NGINX 0.0.0.0:8080 DINLENIYOR..."
# ÖN PLANDA ÇALIŞTIR - Fly için şart
exec nginx -g 'daemon off;'
