-- Exercise the native event wire format: JSON null is truthy vim.NIL in Lua.
local state_dir = vim.fn.tempname()
vim.env.XDG_STATE_HOME = state_dir
vim.opt.runtimepath:prepend(vim.fn.getcwd())
local spell = require('xivspell')
spell.setup({ container = false, silent = true })

local function command(text, target, expected, explicit)
  local sent, cast = false, nil
  spell.transport = function(method, payload, callback)
    if method == 'events' then
      local events = {}
      if not sent then
        sent = true
        events = {{ kind = 'command', card = text, target = target,
          requestId = 'weave-target-test', time = os.time() * 1000, seconds = 0 }}
      end
      callback(vim.json.decode(vim.json.encode({
        sequence = 1, state = { armed = true }, events = events,
      })))
    elseif method == 'cast' then
      cast = vim.json.decode(vim.json.encode(payload))
      callback({ accepted = true, message = 'Confirmed by test transport' })
    else
      assert(method == 'feedback', 'Unexpected transport request: ' .. method)
      callback({ ok = true })
    end
  end
  spell.watch(0)
  local received = vim.wait(1000, function() return cast ~= nil end)
  spell.watcher:stop(); spell.watcher:close(); spell.watcher = nil
  assert(received, 'Native command must request one action: ' .. text)
  assert(cast.target == expected, text .. ': expected target ' .. expected .. ', got ' .. tostring(cast.target))
  assert(cast.targetExplicit == explicit, text .. ': incorrect explicit-target flag')
end

command('ruin', vim.NIL, 'current', false)
assert(spell.last_target_override == nil, 'Absent targets must not be cached as overrides')
command('carbuncle', vim.NIL, 'self', false)
command('physick', vim.NIL, 'friendly', false)
command('burst', vim.NIL, 'self', true) -- The card itself chooses this step's target.
command('physick', 'party3', 'party3', true)
command('.', vim.NIL, 'party3', true) -- A null event must preserve repeat's saved aim.
command('on focus physick', 'party3', 'focus', true)
command('ruin', nil, 'current', false)

local cast
spell.transport = function(method, payload, callback)
  assert(method == 'cast')
  cast = payload
  callback({ accepted = true, message = 'Confirmed by test transport' })
end
assert(spell.cast('physick', nil, nil, 'direct-target-test', vim.NIL))
assert(cast.target == 'friendly' and not cast.targetExplicit, 'Direct casts also normalize an absent JSON target')

print('PASS JSON-null targets preserve card defaults, macro targets, picker aims and repeat behavior')
vim.fn.delete(state_dir, 'rf')
vim.cmd.qa({ bang = true })
