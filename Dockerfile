FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash dos2unix
WORKDIR /app
COPY . /app
RUN mkdir -p /app/live /app/logs && sed -i 's/\r$//' /app/*.sh /app/*.conf && chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
