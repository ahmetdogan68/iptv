FROM jrottenberg/ffmpeg:6.0-ubuntu
RUN apt-get update && apt-get install -y python3 && mkdir -p /app/live
WORKDIR /app
CMD sh -c "ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 -i https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8 -i https://stream.turkiyeradyolari.com:8100/stream -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 128k -f hls -hls_time 6 -hls_list_size 12 -hls_flags delete_segments+append_list /app/live/playlist.m3u8 & python3 -m http.server 10000 --directory /app/live"
