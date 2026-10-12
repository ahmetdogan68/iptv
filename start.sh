#!/bin/sh
mkdir -p /app/live/cam1 /app/live/cam2 /app/live/cam3 /app/live/cam4 /app/live/cam5 /app/live/cam6  /app/logs
rm -rf /app/live/cam*/*.ts /app/live/cam*/*.m3u8
touch /app/logs/error.log
echo "6 KANAL BASLIYOR..."

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/bogaz2.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam1/playlist.m3u8 > /tmp/cam1.log 2>&1 &
sleep 4

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/kadikoy.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4036/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam2/playlist.m3u8 > /tmp/cam2.log 2>&1 &
sleep 4

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/uskudar.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:9332/stream" -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam3/playlist.m3u8 > /tmp/cam3.log 2>&1 &
sleep 4

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/15temmuz2.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4022/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam4/playlist.m3u8 > /tmp/cam4.log 2>&1 &
sleep 4

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/eminonu2.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4026/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam5/playlist.m3u8 > /tmp/cam5.log 2>&1 &
sleep 4

ffmpeg -loglevel error -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 512 -i "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam6/playlist.m3u8 > /tmp/cam6.log 2>&1 &
sleep 4


echo "FFMPEG OK, NGINX BASLIYOR"
nginx -c /app/nginx.conf -p /app -g 'daemon off;' &
sleep 2
echo "HEPSI BASLADI - 6 KANAL"
tail -f /app/logs/error.log
