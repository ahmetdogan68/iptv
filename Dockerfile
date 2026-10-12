FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash dos2unix
WORKDIR /app
COPY . /app
RUN mkdir -p /app/live /app/logs && dos2unix /app/start.sh /app/nginx.conf 2>/dev/null; sed -i 's/\r$//' /app/start.sh /app/nginx.conf; chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
