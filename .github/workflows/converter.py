import urllib.request
import json

VIDEO_ID = "Lr0kzGOOD4s"

m3u8 = ""
try:
    url = f"https://pipedapi.kavin.rocks/streams/{VIDEO_ID}"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=20) as response:
        data = json.loads(response.read().decode())
        m3u8 = data.get("hls", "")
        print(f"Bulunan m3u8: {m3u8}")
except Exception as e:
    print(f"Hata: {e}")

with open("playlist.m3u", "w", encoding="utf-8") as f:
    f.write("#EXTM3U\n")
    f.write('#EXTINF:-1 tvg-name="AKSARAY IN SESI" group-title="Canli",AKSARAY IN SESI - Anadolu Hisari\n')
    if m3u8:
        f.write(m3u8 + "\n")
    else:
        # Yedek olarak direkt kamera
        f.write("https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8\n")
