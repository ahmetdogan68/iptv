import subprocess
YOUTUBE_URL = "https://www.youtube.com/watch?v=Lr0kzGOOD4s"
def get_m3u8():
    cmd = ["yt-dlp", "-g", "-f", "best[protocol^=m3u8]/best", YOUTUBE_URL]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip().split('\n')[0]
m3u8 = get_m3u8()
with open("playlist.m3u", "w", encoding="utf-8") as f:
    f.write("#EXTM3U\n")
    f.write('#EXTINF:-1 tvg-name="AKSARAY IN SESI",AKSARAY IN SESI\n')
    f.write(m3u8 + "\n")
