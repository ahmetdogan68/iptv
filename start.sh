#!/bin/sh
echo "=== FIXED - 4 CAM DONMA COZUMU ==="
mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5
rm -rf /app/live/cam2 /app/live/cam6
rm -f /app/live/cam*/*.ts /app/live/cam*/*.m3u8

run_cam() {
  NAME=$1
  CAM_URL=$2
  RADIO_URL=$3
  OUT=$4
  while true; do
    ffmpeg -hide_banner -loglevel error -fflags +genpts+discardcorrupt -use_wallclock_as_timestamps 1 \
    -thread_queue_size 512 -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 -i "$CAM_URL" \
    -thread_queue_size 512 -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 -i "$RADIO_URL" \
    -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 24k -ar 22050 -ac 1 \
    -max_muxing_queue_size 1024 \
    -f hls -hls_time 10 -hls_list_size 6 -hls_flags delete_segments+program_date_time+independent_segments -hls_segment_filename "$OUT/%03d.ts" "$OUT/playlist.m3u8"
    echo "$NAME dustu, 3sn sonra yeniden basliyor..."
    sleep 3
    rm -f $OUT/*.ts $OUT/*.m3u8
  done &
}

run_cam "CAM1" "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8" "https://stream.turkiyeradyolari.com:8100/stream" "/app/live/cam1"
run_cam "CAM3" "https://kamerayayin.ibb.istanbul/turistikcam/sarachane.stream/playlist.m3u8" "https://stream.turkiyeradyolari.com:9332/stream" "/app/live/cam3"
run_cam "CAM4" "https://kamerayayin.ibb.istanbul/turistikcam/taksim.stream/playlist.m3u8" "https://radyo.yayindakiler.com:4022/" "/app/live/cam4"
run_cam "CAM5" "https://kamerayayin.ibb.istanbul/turistikcam/pierreloti.stream/playlist.m3u8" "https://radyo.yayindakiler.com:4026/" "/app/live/cam5"

sleep 8
cat > /app/live/index.html <<'HTML'
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width"><title>4 CAM + 4 Radyo - Fixed</title><script src="https://cdn.jsdelivr.net/npm/hls.js@1.5.7/dist/hls.min.js"></script><style>body{margin:0;background:#000;display:flex;flex-wrap:wrap;gap:6px;padding:6px;justify-content:center}.b{width:380px;height:214px;background:#111;position:relative;border:1px solid #222}video{width:100%;height:100%}.t{position:absolute;top:4px;left:4px;background:red;color:#fff;font:11px Arial;padding:3px 7px;z-index:10}</style></head><body>
<div class="b"><div class="t">Anadolu + Aksaray'in Sesi</div><video id="v1" controls muted autoplay playsinline></video></div>
<div class="b"><div class="t">Sarachane + Aksaray FM</div><video id="v3" controls muted autoplay playsinline></video></div>
<div class="b"><div class="t">Taksim + Radyo 68</div><video id="v4" controls muted autoplay playsinline></video></div>
<div class="b"><div class="t">Pierre Loti + Mavi Radyo</div><video id="v5" controls muted autoplay playsinline></video></div>
<script>
var L=[["v1","/cam1/playlist.m3u8"],["v3","/cam3/playlist.m3u8"],["v4","/cam4/playlist.m3u8"],["v5","/cam5/playlist.m3u8"]];
L.forEach(function(a){
  var v=document.getElementById(a[0]);
  if(Hls.isSupported()){
    var h=new Hls({maxBufferLength:30, maxMaxBufferLength:60, liveSyncDuration:10, liveMaxLatencyDuration:20});
    h.loadSource(a[1]); h.attachMedia(v);
  } else if(v.canPlayType('application/vnd.apple.mpegurl')){ v.src=a[1]; }
});
</script></body></html>
HTML
nginx -g 'daemon off;'
