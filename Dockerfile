FROM alpine:latest
RUN apk add --no-cache ffmpeg nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
