FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx bash curl

WORKDIR /app
COPY . /app

RUN mkdir -p /app/live/cam1 /app/live/cam3 /app/live/cam4 /app/live/cam5 /var/log/nginx /var/lib/nginx/tmp && \
    chmod +x /app/start.sh && \
    rm -f /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
CMD ["/bin/sh", "/app/start.sh"]
