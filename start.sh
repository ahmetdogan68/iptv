#!/bin/sh
echo "=== BUILD: $(date) - MP4 LOOP VERSION v2 ==="
pkill -9 ffmpeg || true
pkill -9 nginx || true
rm -rf /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5
rm -f /app/live/cam*/*.ts /app/live/cam*/*.m3u8

find_video() { find /app -maxdepth 4 -name "$1" -type f | head -n1; }

run_loop() {
  VNAME=$1; RADIO=$2; OUT=$3
  VIDEO=$(find_video "$VNAME")
  echo "Starting $OUT -> $VIDEO + $RADIO"
  if [ -z "$VIDEO" ]; then echo "VIDEO NOT FOUND $VNAME"; return; fi
  while true; do
    ffmpeg -hide_banner -loglevel error -stream_loop -1 -re -i "$VIDEO" \
    -thread_queue_size 512 -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "$RADIO" \
    -map 0:v:0 -map 1:a:0 -c:v libx264 -preset veryfast -b:v 1000k -r 25 -g 50 \
    -c:a aac -b:a 32k -ar 22050 -ac 1 -shortest \
    -f hls -hls_time 4 -hls_list_size 4 -hls_flags delete_segments+independent_segments -hls_segment_filename "$OUT/%04d.ts" "$OUT/playlist.m3u8"
    sleep 2; rm -f $OUT/*.ts $OUT/*.m3u8
  done &
}

run_loop "fire.mp4" "https://stream.turkiyeradyolari.com:8100/stream" "/app/live/cam1" &
run_loop "forest.mp4" "https://stream.turkiyeradyolari.com:9332/stream" "/app/live/cam3" &
run_loop "ocean.mp4" "https://radyo.yayindakiler.com:4022/" "/app/live/cam4" &
run_loop "rain.mp4" "https://radyo.yayindakiler.com:4026/" "/app/live/cam5" &

sleep 6
# index.html'i her deploy'da yenile
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta http-equiv="Cache-Control" content="no-cache"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>IPTV - MP4 v2</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script>
<style>*{margin:0;padding:0;box-sizing:border-box}body{background:#000;display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:2px;height:100vh} .box{position:relative;background:#111;overflow:hidden} video{width:100%;height:100%;object-fit:cover} .label{position:absolute;top:0;left:0;background:red;color:#fff;font:700 11px Arial;padding:3px 6px;z-index:9} .url{position:absolute;bottom:0;left:0;right:0;background:rgba(0,0,0,.8);color:#0f0;font:9px monospace;padding:3px;z-index:9}</style>
</head><body>
<div class="box"><div class="label">CAM1 Fire + Aksaray'ın Sesi</div><div class="url">/cam1/playlist.m3u8</div><video id="v1" muted autoplay playsinline controls></video></div>
<div class="box"><div class="label">CAM3 Forest + Aksaray FM</div><div class="url">/cam3/playlist.m3u8</div><video id="v3" muted autoplay playsinline controls></video></div>
<div class="box"><div class="label">CAM4 Ocean + Radyo 68</div><div class="url">/cam4/playlist.m3u8</div><video id="v4" muted autoplay playsinline controls></video></div>
<div class="box"><div class="label">CAM5 Rain + Mavi Radyo</div><div class="url">/cam5/playlist.m3u8</div><video id="v5" muted autoplay playsinline controls></video></div>
<script>
var L=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];
L.forEach(a=>{
 let v=document.getElementById(a[0]);
 let h=new Hls({maxBufferLength:15,liveSyncDurationCount:2});
 h.loadSource(a[1]); h.attachMedia(v);
 h.on(Hls.Events.ERROR,(e,d)=>{ if(d.fatal) setTimeout(()=>h.loadSource(a[1]),2000); });
});
</script></body></html>
HTML

# nginx cache kapatma
echo "add_header Cache-Control 'no-store, no-cache, must-revalidate'; " >> /etc/nginx/conf.d/no-cache.conf || true

nginx -g 'daemon off;'
