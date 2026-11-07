-- The in-game tile sends a spell id, never a filesystem path. Candidate code
-- uses the existing bounded card compiler and is installed only after it passes.
local M = {}
local function source(path) return table.concat(vim.fn.readfile(path), '\n') end
function M.save(request, spell)
  spell = spell or require('xivspell')
  if type(request) ~= 'table' or type(request.id) ~= 'string' or type(request.source) ~= 'string' or #request.source > 16384 or type(request.original) ~= 'string' then
    return { ok=false, message='Use a spell source up to 16 KiB' }
  end
  local card
  for _, item in ipairs(spell.cards) do if item.id == request.id then card = item; break end end
  if not card then return { ok=false, message='Unknown spell · reopen it from the spellbook' } end
  local original = source(card.path)
  if original ~= request.original then return { ok=false, message='This file changed elsewhere · reopen the tile before saving' } end
  local temporary = vim.fn.tempname()
  vim.fn.writefile(vim.split(request.source, '\n', { plain=true }), temporary)
  local candidate, err = spell.loadcard(temporary)
  vim.fn.delete(temporary)
  if not candidate then return { ok=false, message=tostring(err) } end
  if type(candidate.action) ~= 'number' or candidate.action < 1 or candidate.action ~= math.floor(candidate.action) then
    return { ok=false, message='Set action to a valid actions.NAME or action id' }
  end
  if source(card.path) ~= request.original then return { ok=false, message='The file changed during validation · reopen the tile' } end
  local backup = vim.fn.stdpath('state') .. '/xivspell/backups'
  vim.fn.mkdir(backup, 'p')
  vim.fn.writefile(vim.fn.readfile(card.path), backup .. '/' .. card.id .. '-' .. tostring(vim.uv.hrtime()) .. '.lua')
  local pending = card.path .. '.grimoire-pending'
  vim.fn.writefile(vim.split(request.source, '\n', { plain=true }), pending)
  local ok, failure = vim.uv.fs_rename(pending, card.path)
  if not ok then vim.fn.delete(pending); return { ok=false, message=tostring(failure) } end
  spell.reload(); spell.sync()
  return { ok=true, message='Saved ' .. candidate.name .. ' · spell reloaded' }
end
function M.handle(event)
  local spell = require('xivspell')
  local ok, request = pcall(vim.json.decode, event.card)
  local success, result
  if ok then success, result = pcall(M.save, request, spell) end
  if not success then result = { ok=false, message=ok and tostring(result) or 'Invalid editor save request' } end
  spell.transport('editor_result', { requestId=event.requestId, accepted=result.ok, text=result.message }, function() end)
end
return M
