FROM alpine:3.19
RUN apk add --no-cache ffmpeg python3 bash ttf-dejavu
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
