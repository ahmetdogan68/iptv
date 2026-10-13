#!/bin/bash
mkdir -p /tmp/hls/cam{1..10}

# İBB Kameraları - 10 tane (URL'leri güncel)
# İstersen buradaki İBB linklerini değiştir

ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb_1/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam1/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_2/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam2/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_3/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam3/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_4/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam4/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_5/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam5/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_6/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam6/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_7/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam7/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_8/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam8/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_9/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam9/playlist.m3u8 > /dev/null 2>&1 &
ffmpeg -re -i "https://istsehir.istbulbul.com.tr/ibb/ibb_10/playlist.m3u8" -c:v libx264 -preset veryfast -b:v 800k -c:a aac -b:a 64k -hls_time 4 -hls_list_size 6 -hls_flags delete_segments /tmp/hls/cam10/playlist.m3u8 > /dev/null 2>&1 &

wait
