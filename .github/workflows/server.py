from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

YOUTUBE_URL = "https://www.youtube.com/watch?v=Lr0kzGOOD4s"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/playlist.m3u":
            try:
                cmd = ["yt-dlp", "-g", "-f", "b", YOUTUBE_URL]
                m3u8 = subprocess.check_output(cmd, text=True).strip().split('\n')[0]
            except:
                m3u8 = YOUTUBE_URL

            content = f"#EXTM3U\n#EXTINF:-1,AKSARAY IN SESI\n{m3u8}\n"
            self.send_response(200)
            self.send_header('Content-type', 'audio/x-mpegurl')
            self.end_headers()
            self.wfile.write(content.encode())
        else:
            self.send_response(404)
            self.end_headers()

print("m3u server http://localhost:8080/playlist.m3u adresinde")
HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
