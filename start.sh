#!/bin/sh
echo "=== MP4-LOOP-v3 - $(date) ==="
pkill -9 ffmpeg; pkill -9 nginx; sleep 1
rm -rf /app/live/cam1/*.ts /app/live/cam1/*.m3u8 /app/live/cam3/* /app/live/cam4/* /app/live/cam5/*
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5

find_video(){ find /app -maxdepth 3 -name "$1" | head -n1; }

run_loop(){
  V=$(find_video $1); R=$2; O=$3
  echo "RUN $V + $R -> $O"
  while true; do
    ffmpeg -hide_banner -loglevel error -stream_loop -1 -re -i "$V" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "$R" -map 0:v:0 -map 1:a:0 -c:v libx264 -preset veryfast -b:v 1000k -r 25 -g 50 -c:a aac -b:a 32k -ar 22050 -ac 1 -shortest -f hls -hls_time 4 -hls_list_size 5 -hls_flags delete_segments+independent_segments -hls_segment_filename "$O/%04d.ts" "$O/playlist.m3u8"
    sleep 2; rm -f $O/*.ts $O/*.m3u8
  done &
}

run_loop "fire.mp4" "https://stream.turkiyeradyolari.com:8100/stream" "/app/live/cam1" &
run_loop "forest.mp4" "https://stream.turkiyeradyolari.com:9332/stream" "/app/live/cam3" &
run_loop "ocean.mp4" "https://radyo.yayindakiler.com:4022/" "/app/live/cam4" &
run_loop "rain.mp4" "https://radyo.yayindakiler.com:4026/" "/app/live/cam5" &

sleep 7
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta http-equiv="Cache-Control" content="no-cache"><meta name="viewport" content="width=device-width,initial-scale=1"><title>IPTV MP4 LOOP</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script><style>*{margin:0;padding:0;box-sizing:border-box}body{background:#000;display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:2px;height:100vh} .box{position:relative;background:#111} video{width:100%;height:100%;object-fit:cover} .label{position:absolute;top:0;left:0;background:red;color:#fff;font:700 11px Arial;padding:3px 6px} .url{position:absolute;bottom:0;left:0;right:0;background:rgba(0,0,0,.8);color:#0f0;font:9px monospace;padding:3px}</style></head><body><div class="box"><div class="label">CAM1 Fire + Aksaray'ın Sesi</div><video id="v1" muted autoplay playsinline controls></video></div><div class="box"><div class="label">CAM3 Forest + Aksaray FM</div><video id="v3" muted autoplay playsinline controls></video></div><div class="box"><div class="label">CAM4 Ocean + Radyo 68</div><video id="v4" muted autoplay playsinline controls></video></div><div class="box"><div class="label">CAM5 Rain + Mavi Radyo</div><video id="v5" muted autoplay playsinline controls></video></div><script>var L=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];L.forEach(a=>{let v=document.getElementById(a[0]);if(Hls.isSupported()){let h=new Hls({maxBufferLength:10});h.loadSource(a[1]);h.attachMedia(v);h.on(Hls.Events.ERROR,(e,d)=>{if(d.fatal)h.loadSource(a[1])})}})</script></body></html>
HTML

nginx -g 'daemon off;'
