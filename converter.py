import yt_dlp

PLAYLIST_URL = "https://www.youtube.com/playlist?list=PLd9UYE5KWtgsPfXRae7puW1inYgAwgSvn"

# Render'da dosya yoksa hata vermesin diye
try:
    with open('playlist.m3u', 'r', encoding='utf-8') as f:
        old_content = f.read()
    # eğer eski içerikte zaten #EXTM3U yoksa ekle
    if not old_content.startswith("#EXTM3U"):
        old_content = "#EXTM3U\n" + old_content
except FileNotFoundError:
    old_content = "#EXTM3U\n"

print("YouTube playlist çekiliyor...")

ydl_opts = {
    'quiet': True,
    'extract_flat': True,  # HIZLI mod, her videoyu tek tek indirme
    'skip_download': True,
}

new_entries = ""
with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    info = ydl.extract_info(PLAYLIST_URL, download=False)
    count = 0
    for entry in info.get('entries', []):
        if not entry:
            continue
        vid = entry.get('id')
        title = entry.get('title', f'Video {count+1}').replace(',', ' ').strip()
        if vid:
            # Bu linki VLC / TiviMate YouTube eklentisi olan oynatıcılar direkt açar
            # Render'da direkt mp4 linki istersen 2. yöntemi kullanacağız
            new_entries += f'#EXTINF:-1 group-title="YouTube" tvg-logo="https://i.ytimg.com/vi/{vid}/hqdefault.jpg",{title}\nhttps://www.youtube.com/watch?v={vid}\n'
            count += 1
    print(f"{count} video bulundu")

# youtube'ları en alta ekle, üsttekileri koru
with open('playlist.m3u', 'w', encoding='utf-8') as out:
    out.write(old_content.rstrip() + "\n\n")
    out.write("# --- YOUTUBE PLAYLIST ---\n")
    out.write(new_entries)

print(f"Tamam! playlist.m3u güncellendi: {count} video eklendi")
