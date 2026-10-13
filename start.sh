#!/bin/sh
echo "=== FINAL - 4 CAM + 4 RADYO - BEYAZIT IPTAL ==="
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5
rm -f /app/live/cam*/*.ts /app/live/cam*/*.m3u8
rm -rf /app/live/cam2 /app/live/cam6

# CAM1 - Anadolu Hisari + Radyo 1
ffmpeg -fflags +genpts -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 256 -i "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time /app/live/cam1/playlist.m3u8 > /dev/null 2>&1 &

# CAM3 - Sarachane + Radyo 3
ffmpeg -fflags +genpts -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 256 -i "https://kamerayayin.ibb.istanbul/turistikcam/sarachane.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -i "https://stream.turkiyeradyolari.com:9332/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time /app/live/cam3/playlist.m3u8 > /dev/null 2>&1 &

# CAM4 - Taksim + Radyo 4
ffmpeg -fflags +genpts -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 256 -i "https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -i "https://radyo.yayindakiler.com:4022/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time /app/live/cam4/playlist.m3u8 > /dev/null 2>&1 &

# CAM5 - Pierre Loti + Radyo 5
ffmpeg -fflags +genpts -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -thread_queue_size 256 -i "https://kamerayayin.ibb.istanbul/turistikcam/pierreloti.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -i "https://radyo.yayindakiler.com:4026/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time /app/live/cam5/playlist.m3u8 > /dev/null 2>&1 &

sleep 4
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width"><title>4 CAM + 4 Radyo</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script><style>body{margin:0;background:#000;display:flex;flex-wrap:wrap;gap:4px;padding:4px;justify-content:center}.b{width:360px;height:203px;background:#111;position:relative;border:1px solid #222}video{width:100%;height:100%}.t{position:absolute;top:2px;left:2px;background:red;color:#fff;font:10px Arial;padding:2px 6px}</style></head><body>
<div class="b"><div class="t">CAM1 Anadolu + Aksaray'sesi </div><video id="v1" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM3 Sarachane + Aksaray FM</div><video id="v3" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM4 Taksim + Radyo 68 </div><video id="v4" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM5 Pierre Loti + Mavi Radyo </div><video id="v5" controls muted autoplay></video></div>
<script>var L=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];L.forEach(function(a){var v=document.getElementById(a[0]);var h=new Hls({maxBufferLength:20});h.loadSource(a[1]);h.attachMedia(v);});</script></body></html>
HTML
nginx -g 'daemon off;'
