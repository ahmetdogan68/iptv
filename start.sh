#!/bin/sh
mkdir -p /app/live/cam1 /app/live/cam2 /app/live/cam3 /app/live/cam4 /app/live/cam5
rm -f /app/live/cam*/*.ts

ffmpeg -fflags +genpts+discardcorrupt -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -thread_queue_size 256 -analyzeduration 0 -probesize 32k -i "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "https://stream.turkiyeradyolari.com:8100/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -shortest -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time+independent_segments /app/live/cam1/playlist.m3u8 > /dev/null 2>&1 &

ffmpeg -fflags +genpts+discardcorrupt -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -thread_queue_size 256 -analyzeduration 0 -probesize 32k -i "https://kamerayayin.ibb.istanbul/turistikcam/beyazitkulesi2.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "https://radyo.yayindakiler.com:4036/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -shortest -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time+independent_segments /app/live/cam2/playlist.m3u8 > /dev/null 2>&1 &

ffmpeg -fflags +genpts+discardcorrupt -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -thread_queue_size 256 -analyzeduration 0 -probesize 32k -i "https://kamerayayin.ibb.istanbul/turistikcam/sarachane.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "https://stream.turkiyeradyolari.com:9332/stream" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -shortest -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time+independent_segments /app/live/cam3/playlist.m3u8 > /dev/null 2>&1 &

ffmpeg -fflags +genpts+discardcorrupt -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -thread_queue_size 256 -analyzeduration 0 -probesize 32k -i "https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "https://radyo.yayindakiler.com:4022/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -shortest -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time+independent_segments /app/live/cam4/playlist.m3u8 > /dev/null 2>&1 &

ffmpeg -fflags +genpts+discardcorrupt -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -thread_queue_size 256 -analyzeduration 0 -probesize 32k -i "https://kamerayayin.ibb.istanbul/turistikcam/pierreloti.stream/playlist.m3u8" -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 10 -i "https://radyo.yayindakiler.com:4026/" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 32k -shortest -f hls -hls_time 6 -hls_list_size 4 -hls_flags delete_segments+program_date_time+independent_segments /app/live/cam5/playlist.m3u8 > /dev/null 2>&1 &

sleep 4
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width"><title>5'li Kucuk</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script><style>body{margin:0;background:#000;display:flex;flex-wrap:wrap;gap:4px;padding:4px;justify-content:center}.b{width:280px;height:158px;background:#111;position:relative;border:1px solid #222}video{width:100%;height:100%}.t{position:absolute;top:2px;left:2px;background:red;color:#fff;font:10px Arial;padding:2px 5px;z-index:10}</style></head><body>
<div class="b"><div class="t">CAM1</div><video id="v1" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM2</div><video id="v2" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM3</div><video id="v3" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM4</div><video id="v4" controls muted autoplay></video></div>
<div class="b"><div class="t">CAM5</div><video id="v5" controls muted autoplay></video></div>
<script>var L=[["v1","/cam1/playlist.m3u8"],["v2","/cam2/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];L.forEach(function(a){var v=document.getElementById(a[0]);var h=new Hls({maxBufferLength:20,liveSyncDurationCount:3,maxMaxBufferLength:30});h.loadSource(a[1]);h.attachMedia(v);});</script></body></html>
HTML
nginx -g 'daemon off;'
