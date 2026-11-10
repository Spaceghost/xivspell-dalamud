local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)
local deck = root .. '/.playtest/cards'
vim.fn.mkdir(deck, 'p')
local path = deck .. '/probe.lua'
require('xivspell').setup({ container = false, deck = deck,
  lua_ls = vim.fn.expand('~/.local/share/xivspell/luals/bin/lua-language-server') })
vim.fn.writefile({ '---@param ctx SpellContext', 'local function probe(ctx)', '  ctx.', 'end' }, path)
vim.cmd.edit(path)
vim.bo.filetype = 'lua'
local client
assert(vim.wait(20000, function()
  client = vim.lsp.get_clients({ name = 'xivspell-lua' })[1]
  return client and client.initialized
end, 100), 'LuaLS did not initialize')
local function complete(line, column)
  local response = client:request_sync('textDocument/completion', {
    textDocument = { uri = vim.uri_from_fname(path) }, position = { line = line, character = column },
    context = { triggerKind = 1 },
  }, 10000, 0)
  assert(response and not response.err, vim.inspect(response))
  local result = response.result or {}
  local labels = {}
  for _, item in ipairs(result.items or result) do labels[item.label:match('^[^(]+')] = true end
  return labels
end
local labels
assert(vim.wait(20000, function()
  labels = complete(2, 6)
  return labels.cast and labels.sequence and labels.state and labels.xiv
end, 200), 'Context completion missing: ' .. vim.inspect(labels))
vim.api.nvim_buf_set_lines(0, 2, 3, false, { '  ctx.xiv.' })
local tools
assert(vim.wait(20000, function()
  tools = complete(2, 10)
  return tools.get_player and tools.get_terminal_status and tools.get_wayfinder_journey
end, 200), 'MCP completion missing: ' .. vim.inspect(tools))
local count = vim.tbl_count(tools)
assert(count >= 170, 'Expected full API completion, got ' .. count)
vim.api.nvim_buf_set_lines(0, 2, 3, false, { '  ctx:cast(163, "")' })
local targetLabels
assert(vim.wait(20000, function()
  targetLabels = {}
  for label in pairs(complete(2, 17)) do targetLabels[label:gsub("[\"']", '')] = true end
  return targetLabels.friendly and targetLabels.party2 and targetLabels.focus and
    targetLabels.enemy and targetLabels.nearest and targetLabels.mob and targetLabels.boss
end, 200), 'Spell target completion missing: ' .. vim.inspect(targetLabels))
print('PASS: party, friendly, focus and enemy target argument completion')
vim.api.nvim_buf_set_lines(0, 0, -1, false, { '---@type SpellUserConfig', 'local config = {', '  hooks = {',
  '    before_cast = function(event)', '      event.', '    end,', '  },', '}' })
local hook
assert(vim.wait(20000, function()
  hook = complete(4, 12)
  return hook.intent and hook.card and hook.context and hook.mode
end, 200), 'Typed hook completion missing: ' .. vim.inspect(hook))
print('PASS: live LuaLS context and hook completion, and ' .. count .. ' MCP methods')
-- The same typed hooks must work in the real configuration buffer, including
-- when setup runs after that buffer's FileType event has already fired.
vim.bo.modified = false
vim.api.nvim_clear_autocmds({group='XivSpell', event='FileType'})
vim.cmd.edit(root .. '/grimoire.lua')
vim.bo.filetype = 'lua'
path = root .. '/grimoire.lua'
assert(#vim.lsp.get_clients({name='xivspell-lua', bufnr=0}) == 0, 'Fixture must start without a configuration client')
vim.fn.delete(deck .. '/probe.lua')
require('xivspell').setup({ container=false, deck=deck,
  lua_ls=vim.fn.expand('~/.local/share/xivspell/luals/bin/lua-language-server') })
assert(vim.wait(10000, function()
  return #vim.lsp.get_clients({name='xivspell-lua', bufnr=0}) > 0
end, 100), 'Configuration buffer did not attach to LuaLS')
vim.api.nvim_buf_set_lines(0, 0, -1, false, { '---@type SpellUserConfig', 'local config = {', '  hooks = {',
  '    before_cast = function(event)', '      event.', '    end,', '  },', '}' })
assert(vim.wait(20000, function()
  hook = complete(4, 12)
  return hook.intent and hook.card and hook.context and hook.mode
end, 200), 'Configuration hook completion missing: ' .. vim.inspect(hook))
vim.bo.modified = false
print('PASS: typed completion in the personal configuration buffer')
vim.api.nvim_buf_set_lines(0, 0, -1, false, {
  "require('xivspell').on('before_cast', function(event)", '  event.', 'end)',
})
assert(vim.wait(20000, function()
  hook = complete(1, 8)
  return hook.intent and hook.card and hook.context and hook.mode
end, 200), 'Direct hook registration completion missing: ' .. vim.inspect(hook))
vim.api.nvim_buf_set_lines(0, 1, 2, false, { '  event.card.' })
assert(vim.wait(20000, function()
  hook = complete(1, 13)
  return hook.id and hook.path and hook.run and hook.phrase
end, 200), 'Loaded card metadata completion missing: ' .. vim.inspect(hook))
vim.api.nvim_buf_set_lines(0, 0, -1, false, {
  "require('xivspell.hooks').on('mcp_after', function(event)", '  event.', 'end)',
})
assert(vim.wait(20000, function()
  hook = complete(1, 8)
  return hook.command and hook.arguments and hook.latencyMs and hook.result
end, 200), 'RPC hook registration completion missing: ' .. vim.inspect(hook))
vim.bo.modified = false
print('PASS: typed direct hook registrations, card metadata and RPC events')
client:stop(true)
vim.cmd.qa({ bang = true })
