FROM python:3.11-alpine
RUN apk add --no-cache ffmpeg bash
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD ["/bin/sh", "/app/start.sh"]
