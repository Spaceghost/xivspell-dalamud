import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest import mock
import io
import threading
import concurrent.futures
import sys
import subprocess

spec = importlib.util.spec_from_file_location('bridge', Path(__file__).resolve().parents[1] / 'tools/bridge.py')
bridge = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bridge)


class BridgeTests(unittest.TestCase):
    def test_target_tool_only_prepares_a_future_rune(self):
        class Native:
            def __init__(self): self.calls=[]
            def spell(self, request):
                self.calls.append(request)
                return {'nextTarget':request['target']}
        native=Native()
        result=bridge.mcp_local('spellbook_target',{'target':'party2'},Path('.'),native)
        self.assertEqual(result,{'nextTarget':'party2'})
        self.assertEqual(native.calls,[{'method':'weave_target','target':'party2'}])

    def test_parallel_upstream_calls_share_session_and_unique_ids(self):
        barrier = threading.Barrier(4)
        requests = []
        initialized = []

        class SharedGame(bridge.Game):
            def request(self, url, payload, headers):
                if payload['method'] == 'initialize':
                    initialized.append(payload['id'])
                    self.headers['Mcp-Session-Id'] = 'one-session'
                    return {'result': {}}
                requests.append((payload['id'], headers['Mcp-Session-Id']))
                barrier.wait(2)
                return {'result': {'id': payload['id']}}

        with tempfile.TemporaryDirectory() as temp:
            Path(temp, 'XivMcp.json').write_text(json.dumps({'BearerToken': 'fixture'}))
            game = SharedGame(temp)
            with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
                results = list(executor.map(lambda _: game.rpc('tools/list', {}), range(4)))
        self.assertEqual(len(initialized), 1)
        self.assertEqual({session for _, session in requests}, {'one-session'})
        self.assertEqual(len({r['id'] for r in results}), 4)

    def test_container_demultiplexes_out_of_order_responses(self):
        program = '''import sys,json
requests=[json.loads(sys.stdin.readline()),json.loads(sys.stdin.readline())]
for request in reversed(requests):
 print(json.dumps({'id':request['id'],'ok':True,'result':request['payload']}),flush=True)
for line in sys.stdin: pass
'''
        real_popen = subprocess.Popen
        with mock.patch.object(bridge.subprocess, 'Popen', side_effect=lambda *a, **kw: real_popen([sys.executable, '-u', '-c', program], **kw)) as start:
            game = bridge.ContainerGame('fixture', timeout=2)
            try:
                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
                    results = list(executor.map(lambda n: game.execute('tool', {'marker': n}), (1, 2)))
                self.assertEqual(results, [{'marker': 1}, {'marker': 2}])
                self.assertEqual(start.call_count, 1)
            finally:
                game.close()

    def test_late_timed_out_response_cannot_satisfy_next_request(self):
        program = '''import sys,json,time
for line in sys.stdin:
 request=json.loads(line)
 if request['payload']['marker']=='old': time.sleep(.15)
 print(json.dumps({'id':request['id'],'ok':True,'result':request['payload']}),flush=True)
'''
        real_popen = subprocess.Popen
        with mock.patch.object(bridge.subprocess, 'Popen', side_effect=lambda *a, **kw: real_popen([sys.executable, '-u', '-c', program], **kw)) as start:
            game = bridge.ContainerGame('fixture', timeout=.03)
            try:
                with self.assertRaisesRegex(RuntimeError, 'no automatic retry'):
                    game.execute('tool', {'marker': 'old'})
                game.timeout = 2
                self.assertEqual(game.execute('tool', {'marker': 'new'}), {'marker': 'new'})
                self.assertEqual(start.call_count, 1)
            finally:
                game.close()

    def test_slow_mod_does_not_block_spellbook_or_control(self):
        started, release = threading.Event(), threading.Event()
        connections, closed = [], []

        class SlowGame:
            def __init__(self):
                connections.append(self)

            def rpc(self, method, params):
                started.set()
                if not release.wait(2):
                    raise RuntimeError('Spellbook read was blocked by the slow mod')
                return {'content': [{'type': 'text', 'text': 'slow result'}]}

            def close(self):
                closed.append(self)

        original = bridge.mcp_local
        shared_game = SlowGame()

        def local(name, args, deck, game):
            self.assertIs(game, shared_game)
            self.assertTrue(started.wait(2))
            result = original(name, args, deck, game)
            release.set()
            return result

        requests = [
            {'jsonrpc': '2.0', 'id': 'slow', 'method': 'tools/call', 'params': {'name': 'slow_mod'}},
            {'jsonrpc': '2.0', 'id': 'source', 'method': 'tools/call', 'params': {'name': 'spellbook_list'}},
            {'jsonrpc': '2.0', 'method': 'notifications/initialized'},
            {'jsonrpc': '2.0', 'id': 'ping', 'method': 'ping'},
        ]
        with tempfile.TemporaryDirectory() as temp:
            output = io.StringIO()
            with mock.patch('sys.stdin', io.StringIO(''.join(json.dumps(r) + '\n' for r in requests))), \
                    mock.patch('sys.stdout', output), mock.patch.object(bridge, 'mcp_local', side_effect=local):
                bridge.serve(Path(temp), lambda: shared_game)
            responses = {r['id']: r for r in map(json.loads, output.getvalue().splitlines())}
        self.assertEqual(set(responses), {'slow', 'source', 'ping'})
        self.assertEqual(responses['slow']['result']['content'][0]['text'], 'slow result')
        self.assertFalse(responses['source']['result'].get('isError', False))
        self.assertEqual(responses['ping']['result'], {})
        self.assertEqual(connections, [shared_game])
        self.assertCountEqual(closed, connections)

    def test_concurrent_server_keeps_file_saves_in_arrival_order(self):
        requests = [
            {'id': 1, 'method': 'tools/call', 'params': {'name': 'spellbook_save', 'arguments': {'id': 'ruin', 'source': 'first'}}},
            {'id': 2, 'method': 'tools/call', 'params': {'name': 'spellbook_save', 'arguments': {'id': 'ruin', 'source': 'second'}}},
            {'id': 3, 'method': 'tools/call', 'params': {'name': 'spellbook_read', 'arguments': {'id': 'ruin'}}},
        ]
        with tempfile.TemporaryDirectory() as temp:
            deck = Path(temp)
            output = io.StringIO()
            with mock.patch('sys.stdin', io.StringIO(''.join(json.dumps(r) + '\n' for r in requests))), mock.patch('sys.stdout', output):
                bridge.serve(deck, lambda: object())
            responses = {r['id']: r for r in map(json.loads, output.getvalue().splitlines())}
            self.assertEqual(json.loads(responses[3]['result']['content'][0]['text'])['source'], 'second')
            self.assertEqual(next((deck / '.history').glob('*.lua')).read_text(), 'first')
            self.assertEqual(list(deck.glob('*.pending')), [])

    def test_card_roundtrip_and_history(self):
        with tempfile.TemporaryDirectory() as temp:
            deck = Path(temp)
            save = lambda source: bridge.mcp_local('spellbook_save', {'id': 'ruin', 'source': source}, deck, None)
            self.assertFalse(save('return {}')['executed'])
            save('return {name="Ruin"}')
            self.assertEqual(bridge.mcp_local('spellbook_read', {'id': 'ruin'}, deck, None)['source'], 'return {name="Ruin"}')
            self.assertEqual(len(list((deck / '.history').glob('*.lua'))), 1)

    def test_reject_paths_and_symlinks(self):
        with tempfile.TemporaryDirectory() as temp:
            deck = Path(temp)
            for name in ['../secret', '/tmp/secret', 'a/b', 'A', '', 'x' * 49]:
                with self.assertRaises(ValueError): bridge.card_path(deck, name)
            (deck / 'ruin.lua').symlink_to(deck / 'target.lua')
            with self.assertRaises(ValueError): bridge.card_path(deck, 'ruin')

    def test_live_catalogue_is_paginated(self):
        class Fake:
            def rpc(self, method, params):
                if not params: return {'tools': [{'name': 'first'}], 'nextCursor': 'second'}
                self.params = params
                return {'tools': [{'name': 'last'}]}
        game = Fake()
        self.assertEqual(len(bridge.dispatch(game, 'catalogue', {})['tools']), 2)
        self.assertEqual(game.params, {'cursor': 'second'})

    def test_nested_schema_and_reserved_field(self):
        tool = {'name': 'example', 'description': 'Example', 'inputSchema': {'type': 'object', 'properties': {
            'package': {'type': 'object', 'properties': {'mode': {'type': 'string', 'enum': ['one', 'two']}}}
        }}}
        with tempfile.TemporaryDirectory() as temp:
            bridge.generate({'tools': [tool]}, Path(temp))
            text = (Path(temp) / 'xiv.lua').read_text()
            self.assertIn('---@field ["package"] Xiv_example_args_package|nil', text)
            self.assertIn('"one"|"two"', text)
            self.assertIn('function M.example(args, callback)', text)


if __name__ == '__main__': unittest.main()
