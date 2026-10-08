FROM jrottenberg/ffmpeg:6.0-ubuntu
RUN apt-get update && apt-get install -y python3
RUN mkdir -p /app/live
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
ENTRYPOINT []
CMD ["/bin/sh", "/app/start.sh"]
