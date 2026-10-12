#!/bin/sh
echo "NGINX BASLIYOR..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
cat /etc/resolv.conf

rm -rf /app/live/* /tmp/*.log
mkdir -p /app/live /app/logs /tmp
nginx -c /app/nginx.conf -p /app -g "daemon off;" &
sleep 2
echo "10 KANAL BASLIYOR..."

# test için tek kanal - çalışırsa 10'a çıkarırız
ffmpeg -re -user_agent "Mozilla/5.0" -i https://tv.ibb.istanbul/ibb-kabatas-meydan-2/playlist.m3u8 -c:v libx264 -vf scale=640:360 -b:v 800k -c:a aac -b:a 64k -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments /app/live/cam1/playlist.m3u8 > /tmp/cam1.log 2>&1 &

# diğer 9'u şimdilik kapalı, DNS düzelirse açacağız
# ffmpeg ... cam2 ...
# ...

echo "HEPSI BASLADI - 1 KANAL TEST"
wait
