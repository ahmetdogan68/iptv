import yt_dlp
import os

PLAYLIST_URL = "https://www.youtube.com/playlist?list=PLd9UYE5KWtgsPfXRae7puW1inYgAwgSvn"

def get_youtube_streams():
    ydl_opts = {
        'quiet': True,
        'extract_flat': False,
        'skip_download': True,
    }
    streams = []
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(PLAYLIST_URL, download=False)
        for entry in info['entries']:
            try:
                # her videonun direkt m3u8'ini al
                video_url = f"https://www.youtube.com/watch?v={entry['id']}"
                v_info = ydl.extract_info(video_url, download=False)
                for f in v_info.get('formats', []):
                    if f.get('ext') == 'mp4' and f.get('acodec') != 'none' and f.get('vcodec') != 'none':
                        streams.append((entry['title'], f['url']))
                        break
            except:
                continue
    return streams

# mevcut playlist.m3u'yu oku
with open('playlist.m3u', 'r', encoding='utf-8') as f:
    old = f.read()

# youtube'ları ekle
with open('playlist.m3u', 'w', encoding='utf-8') as out:
    out.write(old + "\n")
    for title, url in get_youtube_streams():
        clean = title.replace(',', ' ').replace('\n',' ')
        out.write(f'#EXTINF:-1 group-title="YouTube",{clean}\n{url}\n')

print("playlist.m3u guncellendi - youtube eklendi")
