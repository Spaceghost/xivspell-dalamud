package.path = 'lua/?.lua;' .. package.path
local calls = {}
package.loaded.xivspell = { transport = function(method, payload, done)
  calls[#calls + 1] = { method=method, payload=payload }
  done({ revision=12 })
end }
local voice = require('xivspell.voice')
local first = voice.start(); assert(first.phase == 'listening' and voice.revision == 12)
assert(voice.stop().phase == 'transcribing')
assert(voice.deliver({ generation=first.generation, text='on nearest enemy ruin.' }).ok)
assert(calls[#calls].method == 'speech' and calls[#calls].payload.text == 'on nearest enemy ruin')
assert(calls[#calls].payload.revision == 12 and voice.phase == 'idle', 'speech preserves initial draft revision')
assert(voice.deliver({ generation=first.generation, text='ruin' }).discarded, 'transcript is consumed once')
local cancelled = voice.start(); voice.cancel()
assert(voice.deliver({ generation=cancelled.generation, text='ruin' }).discarded, 'cancelled microphone cannot write a draft')
local live = voice.start()
assert(voice.fail({ generation=cancelled.generation, message='late error' }).discarded and voice.phase == 'listening')
assert(not voice.deliver({ generation=live.generation, text=string.rep('x', 256) }).ok)
assert(voice.phase == 'idle')
print('PASS voice session cancellation, one-shot delivery, draft revision and bounded speech')
