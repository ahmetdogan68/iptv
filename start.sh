#!/bin/sh
echo "=== 4LU MP4 LOOP + ADRES GOSTERIM ==="
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5
rm -rf /app/live/cam2 /app/live/cam6 /app/live/cam7 /app/live/cam8
rm -f /app/live/cam*/*.ts /app/live/cam*/*.m3u8

# Video dosyaları nerede olursa olsun bul
find_video() { find /app -maxdepth 3 -name "$1" | head -n1; }

run_loop() {
  NAME=$1; VIDEO=$2; RADIO=$3; OUT=$4
  [ -z "$VIDEO" ] && VIDEO=$(find_video "$NAME.mp4")
  while true; do
    ffmpeg -hide_banner -loglevel error \
    -stream_loop -1 -re -i "$VIDEO" \
    -thread_queue_size 1024 -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "$RADIO" \
    -map 0:v:0 -map 1:a:0 \
    -c:v libx264 -preset veryfast -tune zerolatency -b:v 1200k -maxrate 1500k -bufsize 3000k -r 25 -g 50 -pix_fmt yuv420p \
    -c:a aac -b:a 32k -ar 22050 -ac 1 \
    -max_muxing_queue_size 1024 \
    -f hls -hls_time 6 -hls_list_size 8 -hls_flags delete_segments+program_date_time+independent_segments -hls_segment_filename "$OUT/%04d.ts" "$OUT/playlist.m3u8"
    sleep 2; rm -f $OUT/*.ts $OUT/*.m3u8
  done &
}

# 4 Video -> 4 Farklı Radyo (Aksaray)
run_loop "fire"   "$(find_video fire.mp4)"   "https://stream.turkiyeradyolari.com:8100/stream" "/app/live/cam1" &
run_loop "forest" "$(find_video forest.mp4)" "https://stream.turkiyeradyolari.com:9332/stream" "/app/live/cam3" &
run_loop "ocean"  "$(find_video ocean.mp4)"  "https://radyo.yayindakiler.com:4022/" "/app/live/cam4" &
run_loop "rain"   "$(find_video rain.mp4)"   "https://radyo.yayindakiler.com:4026/" "/app/live/cam5" &

sleep 8
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>IPTV - MP4 Loop 4 Ekran</title>
<script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{background:#000;width:100vw;height:100vh;overflow:hidden;display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:2px}
.box{position:relative;background:#111;overflow:hidden}
video{width:100%;height:100%;object-fit:cover;display:block}
.label{position:absolute;top:0;left:0;background:rgba(255,0,0,0.9);color:#fff;font:700 12px Arial;padding:4px 8px;z-index:10}
.url{position:absolute;bottom:0;left:0;right:0;background:rgba(0,0,0,0.8);color:#0f0;font:10px monospace;padding:4px 6px;z-index:10;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
</style></head><body>
<div class="box"><div class="label">CAM1 Fire Loop + Aksaray'ın Sesi</div><div class="url">https://iptv-radyo.fly.dev/cam1/playlist.m3u8 | Radyo: Aksaray'ın Sesi</div><video id="v1" controls muted autoplay playsinline></video></div>
<div class="box"><div class="label">CAM3 Forest Loop + Aksaray FM</div><div class="url">https://iptv-radyo.fly.dev/cam3/playlist.m3u8 | Radyo: Aksaray FM</div><video id="v3" controls muted autoplay playsinline></video></div>
<div class="box"><div class="label">CAM4 Ocean Loop + Radyo 68</div><div class="url">https://iptv-radyo.fly.dev/cam4/playlist.m3u8 | Radyo: Radyo 68 Aksaray</div><video id="v4" controls muted autoplay playsinline></video></div>
<div class="box"><div class="label">CAM5 Rain Loop + Mavi Radyo</div><div class="url">https://iptv-radyo.fly.dev/cam5/playlist.m3u8 | Radyo: Mavi Radyo</div><video id="v5" controls muted autoplay playsinline></video></div>
<script>
var L=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];
L.forEach(function(a){
  var v=document.getElementById(a[0]);
  if(Hls.isSupported()){
    var h=new Hls({maxBufferLength:20,liveSyncDurationCount:3});
    h.loadSource(a[1]); h.attachMedia(v);
    h.on(Hls.Events.ERROR,function(e,d){ if(d.fatal) h.startLoad(); });
  } else { v.src=a[1]; }
  v.muted=true; v.play().catch(()=>{});
});
</script></body></html>
HTML
nginx -g 'daemon off;'
