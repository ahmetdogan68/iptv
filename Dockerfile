FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash
WORKDIR /app
COPY. /app
RUN chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
