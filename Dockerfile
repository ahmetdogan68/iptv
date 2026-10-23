FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash
WORKDIR /app
COPY . /app
RUN chmod +x /app/start.sh && mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5 /run/nginx
EXPOSE 8080
CMD ["sh", "/app/start.sh"]
