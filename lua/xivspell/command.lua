local M = { expansions = {}, chain = 0 }
local fn = vim.fn
local hooks = require('xivspell.hooks')
local store = fn.stdpath('state') .. '/xivspell/expansions.json'

local function normalize(text) return vim.trim(text):lower():gsub('%s+', ' ') end
local function spell() return require('xivspell') end
local function name(card) return card.command or card.phrase or card.name:lower() end

function M.expand(short, full, persist)
  assert(type(short) == 'string' and type(full) == 'string' and short ~= '' and full ~= '')
  M.expansions[normalize(short)] = normalize(full)
  if persist then
    fn.mkdir(fn.fnamemodify(store, ':h'), 'p')
    fn.writefile({ vim.json.encode(M.expansions) }, store)
  end
end

function M.setup()
  if fn.filereadable(store) == 1 then
    local ok, saved = pcall(vim.json.decode, table.concat(fn.readfile(store), '\n'))
    if ok and type(saved) == 'table' then M.expansions = saved end
  end
end

function M.resolve(text)
  local context = { text = normalize(text) }
  if not hooks.emit('before_parse', context) then return nil, 'Cancelled by before_parse hook' end
  local visited = {}
  for _ = 1, 8 do
    local replacement = M.expansions[context.text]
    if not replacement then break end
    if visited[context.text] then return nil, 'Expansion cycle' end
    visited[context.text] = true
    hooks.emit('expand', { from = context.text, to = replacement })
    context.text = replacement
  end
  for _, card in ipairs(spell().cards) do
    if context.text == normalize(name(card)) or context.text == card.id then context.card = card; break end
    for _, alias in ipairs(card.aliases or {}) do if context.text == normalize(alias) then context.card = card; break end end
    if context.card then break end
  end
  hooks.emit('after_parse', context)
  return context.card, context.card and nil or 'Unknown spell. Press Tab for names and expansions.'
end

function M.candidates(prefix)
  prefix = normalize(prefix)
  local choices, seen = {}, {}
  for _, card in ipairs(spell().cards) do
    local full = name(card)
    local initials = full:gsub('(%S)%S*%s*', '%1')
    if prefix == '' or full:sub(1, #prefix) == prefix or card.id:sub(1, #prefix) == prefix or initials:sub(1, #prefix) == prefix then
      choices[#choices + 1] = { word = full, abbr = full, menu = '→ ' .. card.target, info = card.source }; seen[full] = true
    end
  end
  for short, full in pairs(M.expansions) do
    if short:sub(1, #prefix) == prefix and not seen[full] then
      choices[#choices + 1] = { word = full, abbr = short .. ' → ' .. full, menu = 'expansion' }; seen[full] = true
    end
  end
  table.sort(choices, function(a, b) return a.word < b.word end)
  return choices
end

M.normalize = normalize
function M.compile(text)
  return require('xivspell.language').compile(text, M.resolve)
end
return M
