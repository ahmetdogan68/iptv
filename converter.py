import urllib.request, json, os

VIDEO_ID = "Lr0kzGOOD4s"
out = "playlist.m3u"

# Direkt IBB + radyo mantigi - senin PC'deki gibi sesli m3u degil ama stabil olan
# YouTube m3u'sunu cekmeyi dener, olmazsa IBB'yi yazar
m3u8_link = "https://kamerayayin.ibb.istanbul/turistikcam/anadoluhisari.stream/playlist.m3u8"

try:
    # YouTube'u m3u8'e cevirme denemesi
    api = f"https://pipedapi.kavin.rocks/streams/{VIDEO_ID}"
    req = urllib.request.Request(api, headers={"User-Agent":"Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=15) as r:
        j = json.loads(r.read().decode())
        if j.get("hls"):
            m3u8_link = j["hls"]
            print("YouTube m3u8 bulundu")
except Exception as e:
    print(f"YouTube alinamadi, IBB kullaniliyor: {e}")

with open(out, "w", encoding="utf-8") as f:
    f.write("#EXTM3U\n")
    f.write(f'#EXTINF:-1 tvg-name="AKSARAYIN SESI",AKSARAYIN SESI - Canli\n')
    f.write(m3u8_link + "\n")

print(f"Yazildi: {m3u8_link}")
