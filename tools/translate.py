#!/usr/bin/env python3
"""Local Ollama text-to-spell translator. Produces text only; never calls the game."""
import json
import os
import re
import sys
import time
import urllib.request

ENDPOINT = os.environ.get('XIVSPELL_MODEL_URL', 'http://127.0.0.1:11434/api/chat')
MODEL = os.environ.get('XIVSPELL_MODEL', 'qwen3.5:9b')


def translate(payload, request=urllib.request.urlopen):
    text = payload.get('text', '').strip().lstrip('?').strip()
    if not text or len(text) > 255:
        raise ValueError('Use 1–255 characters')
    spells = payload.get('spells', [])
    if not isinstance(spells, list) or not spells or len(spells) > 64:
        raise ValueError('A loaded spellbook is required')
    names = [item['phrase'] for item in spells]
    prompt = (
        'Translate the request to ONE Grimoire line. Return JSON {"line":"..."}. '
        'Never execute it. Preserve requested conditions and targets. '
        'Use ONLY these spells: ' + ', '.join(names) + '. '
        'Syntax: [if CONDITION then] [on TARGET] SPELL [else [on TARGET] SPELL]. '
        'TARGET: self,current,focus,targetOfTarget,tank,tank2,healer,dps,lowest,ally,enemy,nearest,nearestmob,mob,boss,party1..party8, or a quoted exact character name. '
        'CONDITION: self.hp, self.mp, target.hp, focus.hp with < <= > >= == != and a number or percentage; '
        'self.alive,target.alive,focus.alive,target.exists,focus.exists,self.casting; combine with and/or/not/parentheses. '
        'Examples: heal me below half health => if self.hp < 50% then on self physick; '
        'attack nearest enemy => on nearest ruin; attack my target => on current ruin; shield myself => on self radiant aegis; '
        'heal the tank if my health is below half => if self.hp < 50% then on tank physick. '
        'If the request needs an unavailable spell, is ambiguous, or asks for a loop, return {"line":""}.'
    )
    body = {
        'model': MODEL, 'messages': [{'role': 'system', 'content': prompt}, {'role': 'user', 'content': text}],
        'stream': False, 'think': False, 'keep_alive': '10m',
        'format': {'type': 'object', 'properties': {'line': {'type': 'string', 'maxLength': 255}}, 'required': ['line'], 'additionalProperties': False},
        'options': {'temperature': 0, 'num_predict': 100, 'num_ctx': 2048, 'num_thread': 4},
    }
    started = time.monotonic()
    req = urllib.request.Request(ENDPOINT, json.dumps(body).encode(), {'Content-Type': 'application/json'})
    with request(req, timeout=40) as response:
        result = json.load(response)
    generated = json.loads(result.get('message', {}).get('content', ''))
    line = generated.get('line')
    if not isinstance(line, str) or not line.strip() or len(line) > 255:
        raise ValueError('Could not translate unambiguously; use an explicit spell line')
    if re.search(r'\b(if|when|unless|below|above|under|less than|more than)\b', text, re.I) and not line.lower().startswith('if '):
        raise ValueError('The model dropped your condition; use an explicit if line')
    for target in ['tank', 'healer', 'focus']:
        if re.search(r'\b' + target + r'\b', text, re.I) and not re.search(r'\bon\s+' + target + r'\b', line, re.I):
            raise ValueError('The model dropped your target; use an explicit on line')
    return {'line': line.strip(), 'model': MODEL, 'milliseconds': round((time.monotonic() - started) * 1000)}


def main():
    try:
        payload = sys.stdin.read(32769)
        if len(payload) > 32768:
            raise ValueError('Translation request is too large')
        print(json.dumps({'ok': True, **translate(json.loads(payload))}))
    except Exception as error:
        print(json.dumps({'ok': False, 'error': str(error)}))
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
