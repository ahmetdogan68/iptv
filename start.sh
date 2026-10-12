#!/bin/sh
mkdir -p /app/live/cam1 /app/live/cam2 /app/live/cam3 /app/live/cam4 /app/live/cam5

# Logoları temizle
rm -rf /app/live/cam*/*.ts /app/live/cam*/*.m3u8

# 5 KAMERA + 5 RADYO - Senin asıllar

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam1/index.m3u8 > /tmp/cam1.log 2>&1 &

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/beyazitkulesi2.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4036/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam2/index.m3u8 > /tmp/cam2.log 2>&1 &

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/sarachane.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:9332/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam3/index.m3u8 > /tmp/cam3.log 2>&1 &

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4022/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam4/index.m3u8 > /tmp/cam4.log 2>&1 &

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/pierreloti.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4026/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam5/index.m3u8 > /tmp/cam5.log 2>&1 &

# Web server - Fly.io bunu kontrol ediyor
python3 -m http.server 8080 --bind 0.0.0.0 --directory /app/live
