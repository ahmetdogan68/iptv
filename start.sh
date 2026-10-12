#!/bin/sh
mkdir -p /app/live/cam6 /app/live/cam7 /app/live/cam8 /app/live/cam9 /app/live/cam10 /app/logs
rm -rf /app/live/cam*/*.ts /app/live/cam*/*.m3u8
touch /app/logs/error.log /app/logs/access.log
echo "5 KANAL BASLIYOR..."

ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam6/playlist.m3u8 > /tmp/cam6.log 2>&1 &
ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/beyazitkulesi2.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4036/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam7/playlist.m3u8 > /tmp/cam7.log 2>&1 &
ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/sarachane.stream/playlist.m3u8" -i "https://stream.turkiyeradyolari.com:9332/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam8/playlist.m3u8 > /tmp/cam8.log 2>&1 &
ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4022/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam9/playlist.m3u8 > /tmp/cam9.log 2>&1 &
ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i "https://kamerayayin.ibb.istanbul/turistikcam/pierreloti.stream/playlist.m3u8" -i "https://radyo.yayindakiler.com:4026/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 96k -f hls -hls_time 6 -hls_list_size 10 -hls_flags delete_segments+append_list /app/live/cam10/playlist.m3u8 > /tmp/cam10.log 2>&1 &

echo "FFMPEG OK, NGINX BASLIYOR"
nginx -c /app/nginx.conf -p /app -g 'daemon off;' &
sleep 2
echo "HEPSI BASLADI"
tail -f /app/logs/error.log
