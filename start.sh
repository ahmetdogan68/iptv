#!/bin/sh
mkdir -p /app/live/cam1
echo "test" > /app/live/cam1/index.m3u8
echo "HTTP starting on 8080 - TEST MODE"
exec python3 -m http.server 8080 --bind 0.0.0.0 --directory /app/live
