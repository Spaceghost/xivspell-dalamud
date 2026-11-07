local root = vim.fn.getcwd()
vim.opt.runtimepath:prepend(root)
local E = require('xivspell.editor')
local path = vim.fn.tempname() .. '.lua'
vim.fn.writefile({ 'return {}' }, path)
assert(E.action('edit', path, 'Test spell').ok)
local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { 'return { name = "Saved" }' })
assert(not E.action('quit', path, 'Test spell').ok, 'quit must preserve unsaved changes')
assert(E.action('write', path, 'Test spell').ok)
assert(vim.fn.readfile(path)[1] == 'return { name = "Saved" }')
assert(E.action('quit', path, 'Test spell').ok)
vim.fn.delete(path)
print('PASS opening spell buffers, explicit saves and unsaved-edit protection')
local deck = vim.fn.tempname()
vim.fn.mkdir(deck, 'p')
local id = "quoted's spell"
local cardpath = deck .. '/' .. id .. '.lua'
vim.fn.writefile({'return {name="Remote",phrase="remote",action=163,run=function() end}'}, cardpath)
require('xivspell').setup({container=false, silent=true, deck=deck, lua_ls='/nonexistent-luals'})
local socket = vim.fn.tempname() .. '.sock'
vim.fn.serverstart(socket)
---@type {ok: boolean, message: string}?
local response
E.remote(socket, id, function(result) response = result end)
assert(vim.wait(5000, function() return response ~= nil end), 'Remote editor did not finish')
assert(assert(response).ok, vim.inspect(response))
local remote_buffer = vim.fn.bufnr(cardpath)
assert(remote_buffer >= 0 and #vim.fn.win_findbuf(remote_buffer) > 0, 'Remote action displays the resolved source buffer')
vim.api.nvim_buf_set_lines(remote_buffer, 0, -1, false, {'-- unsaved work'})
response = nil
E.remote(socket, id, function(result) response = result end)
assert(vim.wait(5000, function() return response ~= nil end) and assert(response).ok)
assert(#vim.fn.win_findbuf(remote_buffer) == 1 and vim.bo[remote_buffer].modified, 'Remote reopening preserves the unsaved buffer')
assert(vim.api.nvim_buf_get_lines(remote_buffer, 0, 1, false)[1] == '-- unsaved work')
response = nil
E.remote(socket .. '.missing', id, function(result) response = result end)
assert(vim.wait(5000, function() return response ~= nil end) and not assert(response).ok, 'Missing editor reports a bounded failure')
assert(vim.fn.readfile(cardpath)[1]:find('name="Remote"', 1, true), 'Opening source never saves or casts')
local spell = require('xivspell')
spell.setup({runtime=true, container=false, silent=true, deck=deck, editor_socket=socket, lua_ls='/nonexistent-luals'})
local feedback
---@diagnostic disable-next-line: duplicate-set-field -- Observe the native feedback without contacting a game.
spell.transport = function(method, payload, callback)
  assert(method == 'feedback', 'Neovim source requests never cast or open the legacy tile')
  feedback = payload.text; callback({ok=true})
end
assert(spell.editor_command(':nvim remote'), 'Native source command resolves a spell phrase')
assert(vim.wait(5000, function() return feedback ~= nil end))
assert(feedback == 'Editing Remote', tostring(feedback))
assert(spell.last_edited == id and vim.bo[remote_buffer].modified)
vim.api.nvim_buf_delete(remote_buffer, {force=true})
vim.fn.serverstop(socket)
vim.fn.delete(deck, 'rf')
print('PASS asynchronous Neovim RPC, quoted spell ids, unsaved-buffer reuse and missing editor')
vim.cmd.qa({ bang=true })
