FROM nginx:alpine
RUN apk add --no-cache ffmpeg bash
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
