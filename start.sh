#!/bin/sh
echo "NGINX BASLIYOR..."
rm -rf /app/live/* /tmp/*.log
mkdir -p /app/live/cam1 /app/live/cam2 /app/logs /tmp
nginx -c /app/nginx.conf -p /app -g "daemon off;" &
sleep 2
echo "10 KANAL BASLIYOR (TEST)..."

# test pattern - internet olmadan bile çalışır
ffmpeg -re -f lavfi -i testsrc=size=640x360:rate=25 -f lavfi -i anullsrc -c:v libx264 -b:v 800k -c:a aac -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam1/playlist.m3u8 > /tmp/cam1.log 2>&1 &
ffmpeg -re -f lavfi -i smptebars=size=640x360:rate=25 -f lavfi -i anullsrc -c:v libx264 -b:v 800k -c:a aac -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam2/playlist.m3u8 > /tmp/cam2.log 2>&1 &

echo "HEPSI BASLADI"
wait
