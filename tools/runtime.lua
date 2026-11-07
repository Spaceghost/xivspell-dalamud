-- Gameplay lives in the native Dalamud bar. This process only hosts its Lua programs.
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h')
vim.opt.runtimepath:prepend(root)
local spell = require('xivspell')
spell.setup({ container = 'ffxiv', runtime = true, silent = true,
  editor_socket = vim.env.XDG_RUNTIME_DIR .. '/nvim-spaceghost.sock' })
spell.sync()

local debounce
local watchers = {}
local function changed(_, filename)
  if filename and filename:sub(-4) ~= '.lua' and filename ~= 'expansions.json' then return end
  vim.schedule(function()
    if debounce then debounce:stop(); debounce:close() end
    debounce = vim.uv.new_timer()
    debounce:start(180, 0, vim.schedule_wrap(function()
      debounce:close(); debounce = nil
      spell.configure(); spell.reload(); spell.sync()
    end))
  end)
end
local state = vim.fn.stdpath('state') .. '/xivspell'
vim.fn.mkdir(state, 'p')
for _, path in ipairs({ root .. '/cards', root, state }) do
  local watcher = vim.uv.new_fs_event()
  watcher:start(path, {}, changed)
  watchers[#watchers + 1] = watcher
end
local reconnect = vim.uv.new_timer()
reconnect:start(3000, 3000, vim.schedule_wrap(function() if not spell.connected then spell.sync() end end))
vim.api.nvim_create_autocmd('VimLeavePre', { callback = function()
  reconnect:stop(); reconnect:close()
  for _, watcher in ipairs(watchers) do watcher:stop(); watcher:close() end
  if debounce then debounce:stop(); debounce:close() end
end })
