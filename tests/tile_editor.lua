local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)
local spell = require('xivspell')
local editor = require('xivspell.tile_editor')
local path = vim.fn.tempname() .. '.lua'
local original = 'return {name="Test", phrase="test", action=163, run=function(ctx) ctx:cast(163) end}'
vim.fn.writefile({ original }, path)
local id = 'tile-test-' .. tostring(vim.uv.hrtime())
local synced, reloaded = 0, 0
local mock = { cards={ {id=id, path=path} }, loadcard=spell.loadcard,
  sync=function() synced=synced+1 end, reload=function() reloaded=reloaded+1 end }
local function request(source, base) return {id=id, source=source, original=base or original} end
local function disk() return table.concat(vim.fn.readfile(path), '\n') end
local good = original:gsub('name="Test"', 'name="Edited"')
assert(editor.save(request(good), mock).ok)
assert(disk() == good and synced == 1 and reloaded == 1, 'valid tile save replaces file and reloads the deck')
assert(not editor.save(request(original), mock).ok and disk() == good, 'conflicting editor cannot overwrite another saved revision')
for _, bad in ipairs({ 'return {', 'while true do end', 'return os.execute("false")',
  'return {name="Bad",phrase="bad",action=0,run=function() end}' }) do
  assert(not editor.save(request(bad, good), mock).ok and disk() == good, 'invalid tile code preserves the last valid file')
end
assert(not editor.save({id='../ruin',source=good,original=good}, mock).ok, 'tile saves only loaded spell ids')
assert(not editor.save(request(string.rep('x', 16385), good), mock).ok, 'tile source is bounded')
assert(synced == 1 and reloaded == 1, 'rejected candidates never replace the running card')
local backups = vim.fn.glob(vim.fn.stdpath('state') .. '/xivspell/backups/' .. id .. '-*.lua', false, true)
assert(#backups == 1 and table.concat(vim.fn.readfile(backups[1]), '\n') == original, 'save preserves a recoverable backup')
for _, backup in ipairs(backups) do vim.fn.delete(backup) end
vim.fn.delete(path)
spell.setup({ runtime=true, container=false, silent=true })
local routes = {}
---@diagnostic disable-next-line: duplicate-set-field -- Replace the transport with a test recorder.
spell.transport = function(method, payload, callback)
  routes[#routes+1] = { method=method, payload=payload }; callback({ ok=true, message='ready' })
end
local buffers = #vim.api.nvim_list_bufs()
spell.edit('ruin')
assert(routes[1].method == 'editor_open' and routes[1].payload.cardId == 'ruin')
assert(spell.editor_command(':e ruin'))
assert(routes[2].method == 'editor_command' and routes[2].payload.text == ':e ruin')
assert(spell.editor_command(':w'))
assert(#vim.api.nvim_list_bufs() == buffers, 'runtime editor routes never open external Neovim buffers')
print('PASS runtime edit and editor commands route to the in-game tile')
print('PASS in-game tile save, bounded validation, conflict checks, live reload and backups')
vim.cmd.qa({ bang=true })
