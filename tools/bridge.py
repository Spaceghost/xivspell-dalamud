#!/usr/bin/env python3
"""XivSpell transport, API generator and additive MCP server; Python stdlib only."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import threading
import urllib.error
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[1]


class Game:
    def __init__(self, config=None):
        self.config = Path(config or os.environ.get('XIVSPELL_CONFIG', str(Path.home() / '.xlcore/pluginConfigs')))
        self.headers = {'Content-Type': 'application/json', 'Accept': 'application/json, text/event-stream'}
        self.sequence = 0
        self.initialize_lock = threading.RLock()
        self.sequence_lock = threading.Lock()

    def request(self, url, payload, headers):
        req = urllib.request.Request(url, json.dumps(payload).encode(), headers)
        try:
            with urllib.request.urlopen(req, timeout=35) as response:
                if response.headers.get('Mcp-Session-Id'):
                    self.headers['Mcp-Session-Id'] = response.headers['Mcp-Session-Id']
                raw = response.read().decode()
                if response.headers.get_content_type() == 'text/event-stream':
                    events = [json.loads(line[5:].strip()) for line in raw.splitlines() if line.startswith('data:')]
                    return next(item for item in events if item.get('id') == payload.get('id'))
                return json.loads(raw)
        except urllib.error.HTTPError as exc:
            try:
                message = json.loads(exc.read()).get('error', str(exc))
            except (ValueError, AttributeError):
                message = str(exc)
            raise RuntimeError(message) from None

    def rpc(self, method, params):
        with self.initialize_lock:
            if 'Authorization' not in self.headers:
                config = json.loads((self.config / 'XivMcp.json').read_text(encoding='utf-8-sig'))
                self.headers['Authorization'] = 'Bearer ' + config['BearerToken']
                try:
                    self.rpc('initialize', {'protocolVersion': '2025-06-18', 'capabilities': {}, 'clientInfo': {'name': 'xivspell', 'version': '0.1'}})
                except Exception:
                    self.headers.pop('Authorization', None)
                    self.headers.pop('Mcp-Session-Id', None)
                    raise
        with self.sequence_lock:
            self.sequence += 1
            request_id = self.sequence
        result = self.request('http://127.0.0.1:41800/mcp', {'jsonrpc': '2.0', 'id': request_id, 'method': method, 'params': params}, dict(self.headers))
        if 'error' in result:
            raise RuntimeError(str(result['error']))
        return result.get('result', {})

    def tool(self, name, args):
        result = self.rpc('tools/call', {'name': name, 'arguments': args})
        if result.get('isError'):
            raise RuntimeError('\n'.join(x.get('text', '') for x in result.get('content', [])))
        if 'structuredContent' in result:
            return result['structuredContent']
        texts = [x['text'] for x in result.get('content', []) if x['type'] == 'text']
        try:
            return json.loads(texts[0]) if len(texts) == 1 else texts
        except ValueError:
            return texts

    def spell(self, args):
        config = json.loads((self.config / 'XivSpell.json').read_text(encoding='utf-8-sig'))
        return self.request('http://127.0.0.1:41806/call', args, {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + config['Token']})


class ContainerGame:
    """Keep the spell library on the editor host; forward only game RPC beside Wine."""
    def __init__(self, container, timeout=40):
        self.container = container
        self.timeout = timeout
        self.process = None
        self.sequence = 0
        self.write_lock = threading.RLock()
        self.pending_lock = threading.Lock()
        self.pending = {}

    def read_responses(self, process):
        try:
            for line in process.stdout:
                response = json.loads(line)
                with self.pending_lock:
                    waiting = self.pending.pop((process, response['id']), None)
                if waiting is not None:
                    waiting['response'] = response
                    waiting['event'].set()
        except (ValueError, KeyError, OSError):
            pass
        finally:
            with self.pending_lock:
                lost = [key for key in self.pending if key[0] is process]
                for key in lost:
                    waiting = self.pending.pop(key)
                    waiting['response'] = {'ok': False, 'error': 'Game transport disconnected; outcome unknown'}
                    waiting['event'].set()

    def execute(self, command, payload):
        waiting = {'event': threading.Event()}
        with self.write_lock:
            if self.process is None or self.process.poll() is not None:
                self.process = subprocess.Popen(['sudo', '-n', 'incus', 'exec', self.container, '--', 'runuser', '-u', 'player', '--',
                    'python3', '/opt/xivspell/tools/bridge.py', 'worker'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
                threading.Thread(target=self.read_responses, args=(self.process,), daemon=True).start()
            process = self.process
            self.sequence += 1
            request_id = self.sequence
            with self.pending_lock:
                self.pending[(process, request_id)] = waiting
            try:
                process.stdin.write(json.dumps({'id': request_id, 'command': command, 'payload': payload}) + '\n')
                process.stdin.flush()
            except (BrokenPipeError, OSError):
                with self.pending_lock:
                    self.pending.pop((process, request_id), None)
                raise RuntimeError('Game transport disconnected; outcome unknown') from None
        if not waiting['event'].wait(self.timeout):
            with self.pending_lock:
                self.pending.pop((process, request_id), None)
            raise RuntimeError('Game transport timed out; no automatic retry')
        response = waiting['response']
        if not response.get('ok'):
            raise RuntimeError(response.get('error', 'Game bridge failed'))
        return response['result']

    def rpc(self, method, params):
        if method == 'tools/list': return self.execute('catalogue', {})
        if method == 'tools/call':
            value = self.tool(params['name'], params.get('arguments', {}))
            return {'content': [{'type': 'text', 'text': json.dumps(value)}]}
        return self.execute('rpc', {'method': method, 'params': params})

    def tool(self, name, args):
        return self.execute('tool', {'name': name, 'arguments': args})

    def spell(self, args):
        payload = dict(args)
        command = payload.pop('method')
        return self.execute(command, payload)

    def close(self):
        with self.write_lock:
            process, self.process = self.process, None
        if process is None:
            return
        try:
            process.stdin.close()
        except BrokenPipeError:
            pass
        try:
            process.wait(timeout=2)
        except subprocess.TimeoutExpired:
            process.terminate()
            try:
                process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
        process.stdout.close()


def dispatch(game, command, payload):
    if command == 'rpc':
        return game.rpc(payload['method'], payload.get('params', {}))
    if command == 'tool':
        return game.tool(payload['name'], payload.get('arguments', {}))
    if command == 'catalogue':
        tools = []
        cursor = None
        while True:
            page = game.rpc('tools/list', {'cursor': cursor} if cursor else {})
            tools.extend(page.get('tools', []))
            cursor = page.get('nextCursor')
            if not cursor:
                return {'tools': tools}
    return game.spell({'method': command, **payload})


def typename(schema, name, definitions):
    if 'enum' in schema:
        return '|'.join(json.dumps(x) if isinstance(x, str) else str(x).lower() for x in schema['enum'])
    kind = schema.get('type', 'any')
    if isinstance(kind, list):
        return '|'.join(typename({**schema, 'type': t}, name, definitions) for t in kind)
    if kind == 'array':
        return '(' + typename(schema.get('items', {}), name + '_item', definitions) + ')[]'
    if kind == 'object' and schema.get('properties'):
        fields = []
        for key, value in schema['properties'].items():
            t = typename(value, name + '_' + key, definitions)
            optional = '' if key in schema.get('required', []) else '|nil'
            desc = ' '.join(value.get('description', '').split())
            fields.append(f'---@field [{json.dumps(key)}] {t}{optional} {desc}')
        definitions.append('\n'.join([f'---@class {name}', *fields]))
        return name
    return {'integer': 'integer', 'number': 'number', 'boolean': 'boolean', 'string': 'string', 'null': 'nil', 'object': 'table<string, any>'}.get(kind, 'any')


def generate(catalogue, destination):
    definitions, functions = [], []
    for tool in catalogue['tools']:
        name = tool['name']
        if not name.replace('_', '').isalnum():
            continue
        args = typename(tool.get('inputSchema', {}), 'Xiv_' + name + '_args', definitions)
        result = typename(tool.get('outputSchema', {}), 'Xiv_' + name + '_result', definitions)
        desc = ' '.join(tool.get('description', '').split())
        functions.append(f'---{desc}\n---@param args {args}\n---@param callback? fun(result: {result}|nil, error: string|nil)\nfunction M.{name}(args, callback) end')
    destination.mkdir(parents=True, exist_ok=True)
    (destination / 'xiv.lua').write_text('---@meta\n-- Generated from XivMcp tools/list. Definitions only; runtime uses the bridge.\n' + '\n\n'.join(definitions) + '\n\n---@class XivApi\nlocal M = {}\n\n' + '\n\n'.join(functions) + '\nreturn M\n')
    (destination / 'catalogue.json').write_text(json.dumps(catalogue, indent=2) + '\n')
    return {'tools': len(functions), 'types': len(definitions)}


def local_tools():
    def entry(name, description, properties=None, required=None):
        return {'name': name, 'description': description, 'inputSchema': {'type': 'object', 'properties': properties or {}, 'required': required or [], 'additionalProperties': False}}
    return [
        entry('spellbook_list', 'Read saved Lua spellcards and their source.'),
        entry('spellbook_read', 'Read one Lua spellcard.', {'id': {'type': 'string'}}, ['id']),
        entry('spellbook_save', 'Save Lua source for a card. Never executes it. The player reloads it in Neovim.', {'id': {'type': 'string', 'pattern': '^[a-z][a-z0-9_-]{0,47}$'}, 'source': {'type': 'string', 'maxLength': 16000}}, ['id', 'source']),
        entry('spellbook_status', 'Read live spell bridge arm state and deck. Does not cast.'),
        entry('spellbook_sessions', 'Read recent typing attempts and game request results.'),
        entry('spellbook_api', 'Read the typed API catalogue used by the Lua language server.'),
        entry('spellbook_invoke', 'Invoke a spell name, macro name, expansion, or dot repeat through the same Lua pipeline as the native game bar. Practice mode rehearses; LIVE mode requests a game action. Returns an input request ID; read spellbook_result for the outcome.',
            {'command': {'type': 'string', 'maxLength': 255}, 'requestId': {'type': 'string', 'description': 'Reuse the same ID only to inspect/retry transport of the SAME input; generates an ID when omitted.'}}, ['command']),
        entry('spellbook_result', 'Read the outcome of one input returned by spellbook_invoke.', {'requestId': {'type': 'string'}}, ['requestId']),
        entry('spellbook_follow', 'Submit role-aware or explicitly targeted following through the spell runtime. In practice mode this only rehearses.',
            {'target': {'type': 'string', 'enum': ['role', 'current', 'focus', 'party1', 'party2', 'party3', 'party4', 'party5', 'party6', 'party7', 'party8']}}, ['target']),
        entry('spellbook_stop_follow', 'Stop XivSpell-owned following immediately. Leaves all controller mappings alone.'),
        entry('spellbook_disarm', 'Switch the native bridge to practice and cancel XivSpell-owned movement.'),
        entry('spellbook_expand', 'Save a short expansion for Tab completion and command invocation. The running spellbook reloads it automatically.',
            {'short': {'type': 'string', 'maxLength': 48}, 'command': {'type': 'string', 'maxLength': 255}}, ['short', 'command']),
        entry('spellbook_hooks', 'Read documented Lua lifecycle hook names and cancellation behavior.'),
    ]


def card_path(deck, name):
    import re
    if not isinstance(name, str) or not re.fullmatch('[a-z][a-z0-9_-]{0,47}', name):
        raise ValueError('Invalid card id')
    path = deck / (name + '.lua')
    if path.is_symlink():
        raise ValueError('Card must be a regular file')
    return path


def atomic_write(path, source):
    pending = path.with_name('.' + path.name + '-' + uuid.uuid4().hex + '.pending')
    try:
        with pending.open('x', encoding='utf-8') as stream:
            stream.write(source)
        pending.replace(path)
    finally:
        pending.unlink(missing_ok=True)


def mcp_local(name, args, deck, game):
    if name in ('spellbook_invoke', 'spellbook_follow'):
        command = args['command'] if name == 'spellbook_invoke' else 'follow ' + args['target']
        return game.spell({'method': 'input', 'text': command, 'requestId': args.get('requestId') or uuid.uuid4().hex})
    if name == 'spellbook_result':
        return game.spell({'method': 'command_result', 'requestId': args['requestId']})
    if name == 'spellbook_stop_follow':
        return game.spell({'method': 'unfollow'})
    if name == 'spellbook_disarm':
        return game.spell({'method': 'disarm'})
    if name == 'spellbook_expand':
        short, command = args['short'].strip().lower(), args['command'].strip().lower()
        if not short or not command or len(short) > 48 or len(command) > 255:
            raise ValueError('Expansion requires 1–48 and 1–255 characters')
        path = Path(os.environ.get('XDG_STATE_HOME', str(Path.home() / '.local/state'))) / 'nvim/xivspell/expansions.json'
        path.parent.mkdir(parents=True, exist_ok=True)
        saved = json.loads(path.read_text()) if path.exists() else {}
        saved[short] = command
        atomic_write(path, json.dumps(saved, indent=2) + '\n')
        return {'short': short, 'command': command, 'saved': True}
    if name == 'spellbook_hooks':
        return {'cancellable': ['before_parse', 'before_cast', 'mcp_before'], 'events': [
            'session_start', 'session_end', 'before_compile', 'after_compile', 'deck_loaded', 'buffer_saved',
            'before_parse', 'after_parse', 'expand', 'repeat', 'before_cast', 'after_cast', 'cast_rejected', 'bridge_error',
            'snapshot', 'target_changed', 'mode_changed', 'follow_started', 'follow_stopped', 'controller_override',
            'mcp_before', 'mcp_after']}
    if name == 'spellbook_list':
        return [{'id': p.stem, 'source': p.read_text()} for p in sorted(deck.glob('*.lua')) if not p.is_symlink()]
    if name == 'spellbook_read':
        return {'id': args['id'], 'source': card_path(deck, args['id']).read_text()}
    if name == 'spellbook_save':
        source = args['source']
        if not isinstance(source, str) or len(source.encode()) > 16000:
            raise ValueError('Source exceeds 16000 bytes')
        path = card_path(deck, args['id'])
        deck.mkdir(parents=True, exist_ok=True)
        if path.exists():
            backup = deck / '.history'
            backup.mkdir(exist_ok=True)
            (backup / (path.stem + '-' + uuid.uuid4().hex + '.lua')).write_text(path.read_text())
        atomic_write(path, source)
        return {'saved': args['id'], 'executed': False}
    if name == 'spellbook_status':
        return game.spell({'method': 'snapshot'})
    if name == 'spellbook_sessions':
        log = Path(os.environ.get('XIVSPELL_LOG', str(Path(os.environ.get('XDG_STATE_HOME', str(Path.home() / '.local/state'))) / 'nvim/xivspell/attempts.jsonl')))
        return [json.loads(line) for line in log.read_text().splitlines()[-100:]] if log.exists() else []
    if name == 'spellbook_api':
        return json.loads((ROOT / 'api/catalogue.json').read_text())
    raise ValueError('Unknown tool')


def serve(deck, game_factory):
    """Concurrent JSON-line MCP with correlated responses and ordered saves."""
    import concurrent.futures
    import threading
    local = {tool['name'] for tool in local_tools()}
    state = threading.local()
    output_lock, games_lock = threading.Lock(), threading.Lock()
    games = []

    def connection():
        if not hasattr(state, 'game'):
            state.game = game_factory()
            with games_lock:
                if not any(existing is state.game for existing in games):
                    games.append(state.game)
        return state.game

    def respond(response):
        with output_lock:
            print(json.dumps(response), flush=True)

    def execute(request):
        try:
            method, params = request.get('method'), request.get('params', {})
            if method == 'initialize':
                result = {'protocolVersion': params.get('protocolVersion', '2025-06-18'), 'capabilities': {'tools': {}, 'resources': {}, 'prompts': {}}, 'serverInfo': {'name': 'xivspell', 'version': '0.1.0'}}
            elif method == 'ping':
                result = {}
            elif method == 'tools/list':
                result = dispatch(connection(), 'catalogue', {})
                result['tools'].extend(local_tools())
            elif method == 'tools/call' and params.get('name') in local:
                try:
                    value = mcp_local(params['name'], params.get('arguments', {}), deck, connection())
                    result = {'content': [{'type': 'text', 'text': json.dumps(value)}]}
                except Exception as exc:
                    result = {'content': [{'type': 'text', 'text': str(exc)}], 'isError': True}
            else:
                result = connection().rpc(method, params)
            response = {'jsonrpc': '2.0', 'id': request['id'], 'result': result}
        except Exception as exc:
            response = {'jsonrpc': '2.0', 'id': request.get('id') if isinstance(request, dict) else None, 'error': {'code': -32603, 'message': str(exc)}}
        respond(response)

    try:
        with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
            for line in sys.stdin:
                try:
                    request = json.loads(line)
                except ValueError as exc:
                    respond({'jsonrpc': '2.0', 'id': None, 'error': {'code': -32700, 'message': str(exc)}})
                    continue
                if isinstance(request, dict) and 'id' not in request:
                    continue
                # Control messages bypass slow tools. File mutations remain in
                # arrival order; atomic replacement keeps concurrent reads whole.
                params = request.get('params', {}) if isinstance(request, dict) else {}
                inline = isinstance(request, dict) and (request.get('method') in ('initialize', 'ping') or
                    (request.get('method') == 'tools/call' and
                     isinstance(params, dict) and params.get('name') in ('spellbook_save', 'spellbook_expand')))
                if inline:
                    execute(request)
                else:
                    executor.submit(execute, request)
    finally:
        for game in games:
            if hasattr(game, 'close'):
                game.close()


def worker(config=None):
    import concurrent.futures
    import threading
    game = Game(config)
    lock = threading.Lock()

    def execute(request):
        try:
            result = dispatch(game, request['command'], request.get('payload', {}))
            response = {'id': request['id'], 'ok': True, 'result': result}
        except Exception as exc:
            response = {'id': request.get('id'), 'ok': False, 'error': str(exc)}
        with lock: print(json.dumps(response), flush=True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        for line in sys.stdin:
            if len(line) > 2 * 1024 * 1024: continue
            try: request = json.loads(line)
            except ValueError: continue
            executor.submit(execute, request)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--container', help='Run transport beside the game inside this Incus container')
    parser.add_argument('--config')
    parser.add_argument('--deck', type=Path, default=ROOT / 'cards')
    parser.add_argument('command', choices=['worker', 'rpc', 'tool', 'catalogue', 'snapshot', 'cast', 'follow', 'unfollow', 'disarm', 'cards', 'events', 'feedback', 'input', 'compiled', 'translated', 'cast_result', 'target', 'speech', 'speech_state', 'editor_result', 'editor_open', 'editor_command', 'visuals', 'command_result', 'generate', 'mcp'])
    parser.add_argument('payload', nargs='?', default='{}')
    args = parser.parse_args()
    try:
        if args.command == 'worker':
            worker(args.config)
            return 0
        if args.container and args.command == 'mcp':
            game = ContainerGame(args.container)
            serve(args.deck, lambda: game)
            return 0
        if args.container and args.command not in ('generate',):
            # The matching source tree is installed at this path in the game container.
            command = ['sudo', '-n', 'incus', 'exec', args.container, '--', 'runuser', '-u', 'player', '--', 'python3', '/opt/xivspell/tools/bridge.py', args.command, args.payload]
            if args.command == 'mcp':
                return subprocess.call(command)
            process = subprocess.run(command, capture_output=True, text=True, timeout=40)
            if process.returncode:
                raise RuntimeError(process.stderr.strip() or process.stdout.strip())
            print(process.stdout.strip())
            return 0
        if args.command == 'generate':
            result = generate(json.loads(Path(args.payload).read_text()), ROOT / 'api')
        elif args.command == 'mcp':
            game = Game(args.config)
            serve(args.deck, lambda: game)
            return 0
        else:
            result = dispatch(Game(args.config), args.command, json.loads(args.payload))
        print(json.dumps({'ok': True, 'result': result}))
        return 0
    except Exception as exc:
        print(json.dumps({'ok': False, 'error': str(exc)}))
        return 1


if __name__ == '__main__':
    sys.exit(main())
