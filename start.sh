#!/bin/sh
echo "V5 START $(date)"
rm -rf /app/live/cam*/*.ts /app/live/cam*/*.m3u8
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5 /run/nginx

ls -lh /app/*.mp4

run(){
  VIDEO="/app/$1"
  RADIO="$2"
  OUT="/app/live/$3"
  echo "RUN $VIDEO $RADIO -> $OUT"
  while true; do
    ffmpeg -hide_banner -loglevel error -stream_loop -1 -re -i "$VIDEO" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 -i "$RADIO" -map 0:v:0 -map 1:a:0 -c:v libx264 -preset ultrafast -b:v 800k -r 25 -g 50 -c:a aac -b:a 32k -ar 22050 -ac 1 -shortest -f hls -hls_time 4 -hls_list_size 4 -hls_flags delete_segments -hls_segment_filename "$OUT/%d.ts" "$OUT/playlist.m3u8"
    sleep 2
  done &
}

run "fire.mp4" "https://stream.turkiyeradyolari.com:8100/stream" "cam1" &
run "forest.mp4" "https://stream.turkiyeradyolari.com:9332/stream" "cam3" &
run "ocean.mp4" "https://radyo.yayindakiler.com:4022/" "cam4" &
run "rain.mp4" "https://radyo.yayindakiler.com:4026/" "cam5" &

sleep 5

cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>IPTV V5</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script><style>body{margin:0;background:#000;display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:2px;height:100vh}video{width:100%;height:100%;object-fit:cover} .box{position:relative;background:#111}</style></head><body>
<div class="box"><video id="v1" muted autoplay controls></video></div>
<div class="box"><video id="v3" muted autoplay controls></video></div>
<div class="box"><video id="v4" muted autoplay controls></video></div>
<div class="box"><video id="v5" muted autoplay controls></video></div>
<script>var a=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];a.forEach(x=>{let v=document.getElementById(x[0]);if(Hls.isSupported()){let h=new Hls();h.loadSource(x[1]);h.attachMedia(v)}})</script>
</body></html>
HTML

echo "STARTING NGINX ON 0.0.0.0:8080"
nginx -g 'daemon off;'
