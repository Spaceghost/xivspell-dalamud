-- A single long-lived worker beside Wine: no subprocess startup per keystroke or poll.
local M = { pending = {}, sequence = 0 }
local hooks = require('xivspell.hooks')
local config
local partial = ''

function M.setup(opts) config = opts end

local function fail_all(reason)
  local pending = M.pending; M.pending = {}; M.job = nil
  for _, callback in pairs(pending) do vim.schedule(function() callback(nil, reason) end) end
end

local function start()
  if M.job then return true end
  local argv = { 'python3', config.root .. '/tools/bridge.py', 'worker' }
  if config.container then argv = { 'sudo', '-n', 'incus', 'exec', config.container, '--', 'runuser', '-u', 'player', '--',
    'python3', '/opt/xivspell/tools/bridge.py', 'worker' } end
  partial = ''
  M.job = vim.fn.jobstart(argv, {
    on_stdout = function(_, chunks)
      for index, chunk in ipairs(chunks) do
        partial = partial .. chunk
        if index < #chunks then
          local ok, response = pcall(vim.json.decode, partial); partial = ''
          if ok then
            local callback = M.pending[response.id]
            M.pending[response.id] = nil
            if callback then vim.schedule(function() callback(response.result, response.ok and nil or response.error) end) end
          end
        end
      end
    end,
    on_exit = function() fail_all('Game transport disconnected; run :SpellSync to reconnect.') end,
  })
  if M.job <= 0 then M.job = nil; return false end
  return true
end

function M.call(command, payload, callback)
  payload = payload or vim.empty_dict()
  local event = { command = command, arguments = payload }
  if not hooks.emit('mcp_before', event) then callback(nil, 'Cancelled by mcp_before hook'); return end
  if not start() then callback(nil, 'Could not start game transport'); return end
  M.sequence = M.sequence + 1
  local id = M.sequence
  local started = vim.uv.hrtime()
  M.pending[id] = function(result, error)
    hooks.emit('mcp_after', { command = command, arguments = payload, result = result, error = error,
      latencyMs = (vim.uv.hrtime() - started) / 1e6 })
    callback(result, error)
  end
  vim.fn.chansend(M.job, vim.json.encode({ id = id, command = command, payload = payload }) .. '\n')
  vim.defer_fn(function()
    local waiting = M.pending[id]
    if waiting then M.pending[id] = nil; waiting(nil, 'Request timed out; outcome unknown. No automatic retry.') end
  end, command == 'tool' and 40000 or 8000)
end

function M.stop()
  if M.job then vim.fn.jobstop(M.job) end
end
return M
