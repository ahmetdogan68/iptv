#!/bin/bash
mkdir -p /app/live/cam1 /app/live/cam2 /app/live/cam3 /app/live/cam4 /app/live/cam5 /app/live/cam6 /app/live/cam7 /app/live/cam8 /app/live/cam9 /app/live/cam10 /app/logs
rm -f /app/nginx.pid

echo "NGINX BASLIYOR..."
nginx -c /app/nginx.conf -p /app -g 'daemon off;' &
NGINX_PID=$!
sleep 2

echo "10 KANAL BASLIYOR..."

ffmpeg -re -i https://tv.ibb.istanbul/ibb-kabatas-meydan-2 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam1/playlist.m3u8 > /tmp/cam1.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-beyazit-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam2/playlist.m3u8 > /tmp/cam2.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-sarachane-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam3/playlist.m3u8 > /tmp/cam3.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-sultanahmet-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam4/playlist.m3u8 > /tmp/cam4.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-kirazli-tulum-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam5/playlist.m3u8 > /tmp/cam5.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-esentepe-sahil-yolu-2 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam6/playlist.m3u8 > /tmp/cam6.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-bakirkoy-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam7/playlist.m3u8 > /tmp/cam7.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-karakoy-karakoy-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam8/playlist.m3u8 > /tmp/cam8.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-sultangazi-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam9/playlist.m3u8 > /tmp/cam9.log 2>&1 &
sleep 4
ffmpeg -re -i https://tv.ibb.istanbul/ibb-taksim-meydan-1 -c:v libx264 -preset ultrafast -tune zerolatency -b:v 400k -maxrate 400k -bufsize 800k -vf scale=640:360 -r 15 -c:a aac -b:a 64k -ac 1 -hls_time 6 -hls_list_size 5 -hls_flags delete_segments+append_list /app/live/cam10/playlist.m3u8 > /tmp/cam10.log 2>&1 &

echo "HEPSI BASLADI - 10 KANAL"
wait $NGINX_PID
