FROM alpine:3.19
RUN apk add --no-cache ffmpeg nginx bash
WORKDIR /app
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/
RUN chmod +x /app/start.sh && mkdir -p /app/live
CMD ["/bin/sh","/app/start.sh"]
