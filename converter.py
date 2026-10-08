import subprocess
import json

YOUTUBE_URL = "https://www.youtube.com/watch?v=Lr0kzGOOD4s"

def get_m3u8():
    try:
        # 1. Yöntem: Direkt link al
        cmd = ["yt-dlp", "--no-warnings", "-g", "-f", "b", YOUTUBE_URL]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.stdout.strip():
            return result.stdout.strip().split('\n')[0]

        # 2. Yöntem: JSON'dan bul
        cmd = ["yt-dlp", "-j", "--no-warnings", YOUTUBE_URL]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        data = json.loads(result.stdout)
        for fmt in data.get('formats', []):
            url = fmt.get('url', '')
            if 'm3u8' in url:
                return url
        return data.get('url', '')
    except Exception as e:
        print(f"Hata: {e}")
        return ""

m3u8 = get_m3u8()
print(f"Bulunan: {m3u8}")

with open("playlist.m3u", "w", encoding="utf-8") as f:
    f.write("#EXTM3U\n")
    f.write('#EXTINF:-1 tvg-name="AKSARAY IN SESI" group-title="Canli",AKSARAY IN SESI - Anadolu Hisari\n')
    if m3u8:
        f.write(m3u8 + "\n")
    else:
        # Yedek: YouTube direkt link
        f.write("https://www.youtube.com/watch?v=Lr0kzGOOD4s\n")
