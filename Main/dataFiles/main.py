# This comes from "https://flaviocopes.com/python-http-server/"
# Contains changes

from http.server import BaseHTTPRequestHandler, HTTPServer
import sys

class handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()

        message = "Hello, World from Galena!"
        self.wfile.write(bytes(message, "utf8"))

if len(sys.argv) != 2:
    print("too many or little arguments. Just add number for your port.")
    exit(1)

try:
    port = int(sys.argv[1])
except:
    print("That's not port number!")
    exit(1)

with HTTPServer(('', port), handler) as server:
    server.serve_forever()