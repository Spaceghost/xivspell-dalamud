#!/usr/bin/env python3
"""Streaming-client microphone companion. Audio stays on this machine/tailnet.

Run behind HTTPS (tailscale serve), or forward localhost:41807 to the streaming
client. No remote audio is recorded until the user enables that client's mic.
"""
import io
import json
import os
from pathlib import Path
import subprocess
import threading
import urllib.request
import wave
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ROOT = Path(__file__).resolve().parents[1]
PORT = int(os.environ.get('XIVSPELL_VOICE_PORT', '41807'))
PUBLIC_ORIGIN = os.environ.get('XIVSPELL_VOICE_ORIGIN', '')
OWNER = os.environ.get('XIVSPELL_VOICE_USER', '')
SOCKET = os.environ.get('XIVSPELL_RUNTIME_SOCKET', os.environ.get('XDG_RUNTIME_DIR', '/run/user/1000') + '/xivspell-runtime.sock')
WHISPER = os.environ.get('XIVSPELL_WHISPER_URL', 'http://127.0.0.1:41808/inference')
TRANSCRIBE = threading.Lock()
MAX_AUDIO = 1024 * 1024


def rpc(method, value=None):
    if method not in ('state', 'start', 'stop', 'cancel', 'deliver', 'fail'):
        raise ValueError('Invalid voice operation')
    argument = '' if value is None else "json_decode('" + json.dumps(value).replace("'", "''") + "')"
    expression = 'json_encode(luaeval(\'require("xivspell.voice").' + method + '(' + ('_A' if value is not None else '') + ")'" + (', ' + argument if value is not None else '') + '))'
    result = subprocess.run([os.environ.get('XIVSPELL_NVIM', 'nvim'), '--server', SOCKET, '--remote-expr', expression],
                            capture_output=True, text=True, timeout=5, check=True)
    return json.loads(result.stdout)


def transcribe(audio, request=urllib.request.urlopen):
    with wave.open(io.BytesIO(audio)) as wav:
        if wav.getnchannels() != 1 or wav.getsampwidth() != 2 or wav.getframerate() != 16000 or not 1600 <= wav.getnframes() <= 16000 * 30:
            raise ValueError('Record between 0.1 and 30 seconds of mono 16 kHz audio')
    boundary = 'GrimoireAudioBoundary'
    body = (f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="spell.wav"\r\nContent-Type: audio/wav\r\n\r\n'.encode()
            + audio + f'\r\n--{boundary}\r\nContent-Disposition: form-data; name="response_format"\r\n\r\njson\r\n--{boundary}\r\nContent-Disposition: form-data; name="language"\r\n\r\nen\r\n--{boundary}--\r\n'.encode())
    req = urllib.request.Request(WHISPER, body, {'Content-Type': 'multipart/form-data; boundary=' + boundary})
    with request(req, timeout=45) as response:
        result = json.load(response)
    text = ' '.join(result.get('text', '').strip().split())
    if not text or text.startswith('[') or len(text) > 255:
        raise ValueError('No clear spell heard; try again')
    return text


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass  # Audio/transcripts never go to HTTP access logs.

    def reply(self, status, payload, content_type='application/json'):
        body = payload if isinstance(payload, bytes) else json.dumps(payload).encode()
        self.send_response(status)
        self.send_header('Content-Type', content_type)
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.send_header('Permissions-Policy', 'microphone=(self)')
        self.end_headers()
        self.wfile.write(body)

    def allowed(self):
        host = self.headers.get('Host', '')
        origin = self.headers.get('Origin', '')
        local = host in (f'localhost:{PORT}', f'127.0.0.1:{PORT}')
        public = PUBLIC_ORIGIN and host == PUBLIC_ORIGIN.split('://', 1)[-1]
        if not local and not public:
            return False
        if OWNER and public and self.headers.get('Tailscale-User-Login', '') != OWNER:
            return False
        return not origin or origin == PUBLIC_ORIGIN or local and origin in (f'http://localhost:{PORT}', f'http://127.0.0.1:{PORT}')

    def do_GET(self):
        if not self.allowed(): return self.reply(403, {'error': 'Open the paired Grimoire address'})
        try:
            if self.path == '/': return self.reply(200, (ROOT / 'tools/voice-client.html').read_bytes(), 'text/html; charset=utf-8')
            if self.path == '/api/state': return self.reply(200, rpc('state'))
            return self.reply(404, {'error': 'Not found'})
        except Exception:
            return self.reply(503, {'error': 'Grimoire runtime is not connected'})

    def do_POST(self):
        if not self.allowed(): return self.reply(403, {'error': 'Open the paired Grimoire address'})
        generation = None
        try:
            if self.path in ('/api/start', '/api/stop', '/api/cancel'):
                return self.reply(200, rpc(self.path.removeprefix('/api/')))
            if self.path != '/api/audio': return self.reply(404, {'error': 'Not found'})
            size = int(self.headers.get('Content-Length', '0'))
            if not 44 < size <= MAX_AUDIO: raise ValueError('Recording is too long or empty')
            generation = int(self.headers.get('X-Grimoire-Generation', '-1'))
            state = rpc('state')
            if generation != state['generation'] or state['phase'] not in ('listening', 'transcribing'):
                return self.reply(409, {'error': 'Recording session ended; try again'})
            if not TRANSCRIBE.acquire(blocking=False): return self.reply(409, {'error': 'Already transcribing'})
            try:
                audio = self.rfile.read(size)
                if len(audio) != size: raise ValueError('Recording was interrupted')
                text = transcribe(audio)
                result = rpc('deliver', {'generation': generation, 'text': text})
                self.reply(200, {**result, 'text': text})
            finally:
                TRANSCRIBE.release()
        except Exception as error:
            message = str(error) if isinstance(error, ValueError) else 'Speech service unavailable; try again'
            if generation is not None:
                try: rpc('fail', {'generation': generation, 'message': message})
                except Exception: pass
            self.reply(400, {'error': message})


if __name__ == '__main__':
    ThreadingHTTPServer(('127.0.0.1', PORT), Handler).serve_forever()
