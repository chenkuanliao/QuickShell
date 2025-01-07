import http.server
import socketserver
import os

PORT = 8000
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=PROJECT_DIR, **kwargs)

    def translate_path(self, path):
        # Ensure the path is within PROJECT_DIR
        path = super().translate_path(path)
        if os.path.commonpath([path, PROJECT_DIR]) != PROJECT_DIR:
            return None
        return path

Handler = CustomHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving files from {PROJECT_DIR} at port {PORT}")
    httpd.serve_forever()
