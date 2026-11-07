-- Remote microphone sessions stage editable spell text. Neither a transcript
-- nor a speech control event authorizes playback on a new encounter target.
local M = { generation = vim and vim.uv and math.floor(vim.uv.hrtime() / 1000000) or os.time() * 1000, phase = 'idle', message = 'Microphone ready', revision = nil }
local function spell() return require('xivspell') end
function M.state() return { generation=M.generation, phase=M.phase, message=M.message } end
local function status(message)
  M.message = message
  local generation = M.generation
  spell().transport('speech_state', { after=M.generation, text=message, mode=M.phase }, function(result)
    if generation == M.generation and result and result.revision then M.revision = result.revision end
  end)
end
function M.start()
  M.generation = M.generation + 1; M.phase = 'listening'; M.revision = nil
  status('Listening on streaming client · microphone to finish')
  return M.state()
end
function M.stop()
  if M.phase == 'listening' then M.phase = 'transcribing'; status('Transcribing your spell…') end
  return M.state()
end
function M.cancel()
  M.generation = M.generation + 1; M.phase = 'idle'; M.revision = nil
  status('Microphone cancelled'); return M.state()
end
function M.toggle() if M.phase == 'listening' then return M.stop() else return M.start() end end
function M.deliver(input)
  if input.generation ~= M.generation or M.phase ~= 'transcribing' and M.phase ~= 'listening' then return { discarded=true } end
  if type(input.text) == 'string' then input.text = input.text:gsub('[%.!?,]+$', '') end
  if type(input.text) ~= 'string' or #input.text == 0 or #input.text > 255 then return M.fail({ generation=M.generation, message='Use a shorter spoken spell' }) end
  M.phase = 'idle'; M.message = 'Speech ready · Enter / A to weave'
  spell().transport('speech', { text=input.text, after=M.generation, revision=M.revision or -1 }, function() end)
  return { ok=true }
end
function M.fail(input)
  if input.generation ~= M.generation then return { discarded=true } end
  M.phase = 'idle'; status(tostring(input.message):sub(1, 160)); return { ok=false }
end
return M
