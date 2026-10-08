import requests

VIDEO_ID = "Lr0kzGOOD4s"

# YouTube'a değmeden Piped üzerinden m3u8 alıyoruz
try:
    r = requests.get(f"https://pipedapi.kavin.rocks/streams/{VIDEO_ID}", timeout=20)
    data = r.json()
    m3u8 = data.get("hls")  # Bu zaten .m3u8 linki
    print(f"Bulunan m3u8: {m3u8}")
except Exception as e:
    print(f"Hata: {e}")
    m3u8 = ""

with open("playlist.m3u", "w", encoding="utf-8") as f:
    f.write("#EXTM3U\n")
    f.write('#EXTINF:-1 tvg-name="AKSARAY IN SESI" group-title="Canli",AKSARAY IN SESI - Anadolu Hisari\n')
    if m3u8:
        f.write(m3u8 + "\n")
    else:
        f.write(f"https://www.youtube.com/watch?v={VIDEO_ID}\n")
