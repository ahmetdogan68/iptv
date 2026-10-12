#!/bin/sh
echo "NGINX BASLIYOR..."
rm -rf /app/live/* /tmp/*.log
mkdir -p /app/live/cam1 /app/live/cam2 /app/live/cam3 /app/live/cam4 /app/live/cam5 /app/live/cam6 /app/live/cam7 /app/live/cam8 /app/live/cam9 /app/live/cam10 /app/logs /tmp
nginx -c /app/nginx.conf -p /app -g "daemon off;" &
sleep 2
echo "10 KANAL BASLIYOR..."

# CALISANLAR
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam1/playlist.m3u8 > /tmp/cam1.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/kizkulesi.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam3/playlist.m3u8 > /tmp/cam3.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/eminonu.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam4/playlist.m3u8 > /tmp/cam4.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam5/playlist.m3u8 > /tmp/cam5.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/uskudar.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam7/playlist.m3u8 > /tmp/cam7.log 2>&1 &

# GECICI KLONLAR - hepsi aktif olsun diye
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam2/playlist.m3u8 > /tmp/cam2.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/kizkulesi.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam6/playlist.m3u8 > /tmp/cam6.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/eminonu.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam8/playlist.m3u8 > /tmp/cam8.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam9/playlist.m3u8 > /tmp/cam9.log 2>&1 &
ffmpeg -re -user_agent "Mozilla/5.0" -i https://kamerayayin.ibb.istanbul/turistikcam/uskudar.stream/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam10/playlist.m3u8 > /tmp/cam10.log 2>&1 &

echo "HEPSI BASLADI"
wait
