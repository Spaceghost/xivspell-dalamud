import importlib.util
import io
import json
from pathlib import Path
import unittest
from unittest.mock import patch
import wave

spec = importlib.util.spec_from_file_location('voice_relay', Path(__file__).resolve().parents[1] / 'tools/voice_relay.py')
voice = importlib.util.module_from_spec(spec)
spec.loader.exec_module(voice)


def recording(rate=16000, frames=1600, channels=1):
    data = io.BytesIO()
    with wave.open(data, 'wb') as wav:
        wav.setnchannels(channels); wav.setsampwidth(2); wav.setframerate(rate)
        wav.writeframes(b'\0\0' * frames * channels)
    return data.getvalue()


class VoiceTests(unittest.TestCase):
    def test_transcript_is_text_only(self):
        def request(req, timeout):
            self.assertIn(b'RIFF', req.data)
            self.assertEqual(timeout, 45)
            return io.BytesIO(json.dumps({'text': ' on nearest enemy ruin.\n'}).encode())
        self.assertEqual(voice.transcribe(recording(), request), 'on nearest enemy ruin.')

    def test_rejects_invalid_audio_before_inference(self):
        for audio in (recording(48000), recording(frames=100), recording(channels=2)):
            with self.assertRaises(ValueError): voice.transcribe(audio, lambda *_: self.fail('must not call model'))

    def test_rejects_silence_and_overlong_text(self):
        for text in ('', '[BLANK_AUDIO]', 'x' * 256):
            with self.assertRaises(ValueError):
                voice.transcribe(recording(), lambda *_, **__: io.BytesIO(json.dumps({'text': text}).encode()))

    def test_rpc_escapes_transcript_without_shell(self):
        with patch.object(voice.subprocess, 'run') as run:
            run.return_value.stdout = '{"ok":true}'
            self.assertEqual(voice.rpc('deliver', {'text': "I'm using `ruin` $(echo x)", 'generation': 2}), {'ok': True})
            argv = run.call_args.args[0]
            self.assertIsInstance(argv, list)
            self.assertIn("I''m", argv[-1])
            self.assertNotIn('shell', run.call_args.kwargs)


if __name__ == '__main__': unittest.main()
