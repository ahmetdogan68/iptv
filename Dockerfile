FROM nginx:alpine
RUN apk add --no-cache ffmpeg bash
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh
COPY start_ffmpeg.sh /app/start_ffmpeg.sh
RUN chmod +x /app/start.sh /app/start_ffmpeg.sh
CMD ["/bin/sh", "/app/start.sh"]
