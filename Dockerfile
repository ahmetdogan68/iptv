FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash dos2unix yt-dlp python3
WORKDIR /app
COPY . /app
RUN mkdir -p /app/live /app/logs && sed -i 's/\r$//' /app/start.sh /app/nginx.conf && chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
