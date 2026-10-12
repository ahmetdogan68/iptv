#!/bin/sh
mkdir -p /app/live /app/logs
touch /app/logs/error.log /app/logs/access.log
rm -f /app/live/*.m3u8 /app/live/*.ts
echo "10 KANAL BASLIYOR..."

# Kanal fonksiyonu
baslat() {
  isim=$1
  youtube=$2
  resim=$3
  while true; do
    url=$(yt-dlp -g "$youtube" 2>/dev/null | head -n1)
    if [ -n "$url" ]; then
      ffmpeg -re -loop 1 -i "$resim" -i "$url" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 128k -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" -hls_time 4 -hls_list_size 5 -hls_flags delete_segments -hls_segment_filename "/app/live/${isim}_%03d.ts" "/app/live/${isim}.m3u8" -loglevel error
    fi
    sleep 5
  done &
}

# 10 KANALINI BURAYA EKLE - örnek linkler, sen kendi linklerinle değiştir
baslat kanal1 "https://www.youtube.com/watch?v=jfKfPfyJRdk" "/app/img/1.jpg"
baslat kanal2 "https://www.youtube.com/watch?v=5qap5aO4i9A" "/app/img/2.jpg"
baslat kanal3 "https://www.youtube.com/watch?v=86YLFOog4GM" "/app/img/3.jpg"
baslat kanal4 "https://www.youtube.com/watch?v=DWcJFNfaw9c" "/app/img/4.jpg"
baslat kanal5 "https://www.youtube.com/watch?v=Qh1a4g3th-o" "/app/img/5.jpg"
baslat kanal6 "https://www.youtube.com/watch?v=FjHGZj2IjBk" "/app/img/6.jpg"
baslat kanal7 "https://www.youtube.com/watch?v=S_MOd40zlYU" "/app/img/7.jpg"
baslat kanal8 "https://www.youtube.com/watch?v=1tXvCNQF8uI" "/app/img/8.jpg"
baslat kanal9 "https://www.youtube.com/watch?v=21LGv8Cf0us" "/app/img/9.jpg"
baslat kanal10 "https://www.youtube.com/watch?v=lTRiuFIWV54" "/app/img/10.jpg"

nginx -c /app/nginx.conf -g 'daemon off;' &
sleep 3
echo "HEPSI BASLADI"
tail -f /app/logs/error.log
