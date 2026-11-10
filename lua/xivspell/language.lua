-- Small spell language. No load(), Lua evaluation, loops or background casts.
local M = {}
local fields = {
  ['self.hp'] = 'number', ['self.mp'] = 'number', ['target.hp'] = 'number', ['focus.hp'] = 'number',
  ['self.exists'] = 'boolean', ['target.exists'] = 'boolean', ['focus.exists'] = 'boolean',
  ['self.alive'] = 'boolean', ['target.alive'] = 'boolean', ['focus.alive'] = 'boolean',
  ['self.casting'] = 'boolean',
}
local targets = { self=true, friendly=true, current=true, focus=true, targetoftarget=true, role=true, tank=true, healer=true, lowest=true,
  dps=true, melee=true, ranged=true, enemy=true, nearest=true, nearestmob=true, mob=true, boss=true, ally=true }
for i = 1, 8 do targets['party' .. i] = true end
local aliases = {
  me='self', myself='self', i='self', im='self', ["i'm"]='self', ['i’m']='self', my='self', own='self',
  target='current', selected='current', t='current', it='current', them='current',
  ft='focus', ['focus-target']='focus', focus_target='focus', tot='targetoftarget',
  enemies='enemy', foe='enemy', foes='enemy', opponent='enemy', nearest='nearest', ['nearest-enemy']='nearest', nearest_enemy='nearest', closest='nearest', ['nearest-mob']='nearestmob', nearest_mob='nearestmob',
  mobs='mob', trash='mob', add='mob', adds='mob',
  friend='ally', friendly='friendly', teammate='ally', teammates='ally',
  lowesthp='lowest', injured='lowest', hurt='lowest', wounded='lowest',
  mt='tank1', ['main-tank']='tank1', ot='tank2', ['off-tank']='tank2',
}
local function valid_target(target)
  if targets[target] then return true end
  local role, number = target:match('^(%a+)([1-8])$')
  return number and (role == 'tank' or role == 'healer' or role == 'dps' or role == 'melee' or role == 'ranged') or false
end
local function trim(s) return s:match('^%s*(.-)%s*$') end

local function condition(text)
  local tokens, at = {}, 1
  while at <= #text do
    local rest = text:sub(at)
    local space = rest:match('^%s+')
    if space then at = at + #space else
      local token = rest:match('^[<>!=~]=') or rest:match('^[<>()]') or rest:match('^%d+%.?%d*%%?') or rest:match('^[%a_][%w_%.]*')
      if not token then error('Unexpected condition text: ' .. rest:sub(1, 20)) end
      tokens[#tokens + 1] = token:lower(); at = at + #token
      if #tokens > 64 then error('Condition is too long') end
    end
  end
  local i, depth = 1, 0
  local expression
  local function atom()
    depth = depth + 1
    if depth > 8 then error('Condition is too deeply nested') end
    local node
    if tokens[i] == '(' then
      i = i + 1; node = expression()
      if tokens[i] ~= ')' then error('Missing closing parenthesis') end
      i = i + 1
    else
      local field = tokens[i]; i = i + 1
      if not fields[field] then error('Unknown condition field: ' .. tostring(field)) end
      node = { field = field }
      local op = tokens[i]
      if op == '<' or op == '>' or op == '<=' or op == '>=' or op == '==' or op == '!=' or op == '~=' then
        i = i + 1
        local value = tokens[i]; i = i + 1
        if fields[field] == 'boolean' then
          if (op ~= '==' and op ~= '!=' and op ~= '~=') or (value ~= 'true' and value ~= 'false') then error('Boolean fields compare with true or false') end
          node = { op=op, field=field, value=value == 'true' }
        else
          if not value then error('Missing comparison value') end
          local percent = value:sub(-1) == '%'
          local number = tonumber(percent and value:sub(1, -2) or value)
          if not number or number < 0 or number > 4294967295 or percent and number > 100 then error('Invalid comparison value') end
          node = { op=op, field=field, value=number, percent=percent }
        end
      elseif fields[field] ~= 'boolean' then error('Numeric fields need a comparison') end
    end
    depth = depth - 1
    return node
  end
  local function negation()
    if tokens[i] == 'not' then
      i = i + 1
      -- Bound runs of unary not separately from parenthesis recursion.
      local n = 1
      while tokens[i] == 'not' do n = n + 1; i = i + 1; if n > 8 then error('Too many negations') end end
      local node = atom()
      return n % 2 == 1 and { op='not', a=node } or node
    end
    return atom()
  end
  local function conjunction()
    local node = negation()
    while tokens[i] == 'and' do i = i + 1; node = { op='and', a=node, b=negation() } end
    return node
  end
  expression = function()
    local node = conjunction()
    while tokens[i] == 'or' do i = i + 1; node = { op='or', a=node, b=conjunction() } end
    return node
  end
  local node = expression()
  if i <= #tokens then error('Unexpected condition token: ' .. tokens[i]) end
  return node
end

local function normalize_target_prefix(text)
  local prefix, rest = text:match('^(%S+)%s+(.+)$')
  if prefix and prefix:lower() == 'target' then text = 'on ' .. rest end
  for _, word in ipairs({ 'nearest', 'closest' }) do
    for _, kind in ipairs({ 'enemy/mob', 'enemies', 'enemy', 'mobs', 'mob' }) do
      local from = 'on ' .. word .. ' ' .. kind .. ' '
      if text:sub(1, #from):lower() == from then
        return 'on ' .. (kind:find('mob', 1, true) and 'nearestmob' or 'nearest') .. ' ' .. text:sub(#from + 1)
      end
    end
  end
  return text
end

function M.target_command(text)
  if type(text) ~= 'string' then return nil end
  local selector = text:lower():match('^target%s+(.+)$')
  if not selector then return nil end
  selector = trim(selector)
  local normalized = normalize_target_prefix('on ' .. selector .. ' __target__')
  selector = normalized:match('^on%s+(%S+)%s+__target__$')
  selector = selector and (aliases[selector] or selector)
  if selector and valid_target(selector) then return selector == 'targetoftarget' and 'targetOfTarget' or selector end
end

local function statement(text, lookup)
  text = trim(text)
  local target
  text = normalize_target_prefix(text)
  -- Normalize a multiword selector only at the statement's target prefix;
  -- quoted character names and spell text retain their exact meaning.
  text = text:gsub('^([Oo][Nn]%s+)[Nn][Ee][Aa][Rr][Ee][Ss][Tt]%s+[Ee][Nn][Ee][Mm][Yy]%s+', '%1nearest ')
  text = text:gsub('^[Nn][Ee][Aa][Rr][Ee][Ss][Tt]%s+[Ee][Nn][Ee][Mm][Yy]%s+', 'on nearest ')
  text = text:gsub('^([Oo][Nn]%s+)[Cc][Ll][Oo][Ss][Ee][Ss][Tt]%s+[Ee][Nn][Ee][Mm][Yy]%s+', '%1nearest ')
  if text:lower():match('^i%s+am%s+') then text = 'on self ' .. text:gsub('^%S+%s+%S+%s+', '', 1) end
  if not text:lower():match('^on%s') then
    local prefix, rest = text:match('^(%S+)%s+(.+)$')
    local selector = prefix and (aliases[prefix:lower()] or prefix:lower())
    if selector and valid_target(selector) and not lookup(text) then text = 'on ' .. selector .. ' ' .. rest end
  end
  if text:sub(1, 3):lower() == 'on ' then
    local rest = trim(text:sub(4))
    local name, tail = rest:match('^"([^"]+)"%s+(.+)$')
    if name then target, text = 'name:' .. name, tail
    else
      local selector, body = rest:match('^(%S+)%s+(.+)$')
      if not selector then error('Use: on TARGET SPELL') end
      selector = selector:lower(); target, text = aliases[selector] or selector, body
      if not valid_target(target) then error('Unknown target: ' .. target) end
      if target == 'targetoftarget' then target = 'targetOfTarget' end
    end
  end
  local card, err = lookup(trim(text))
  if not card then error(err or ('Unknown spell: ' .. text)) end
  return { card=card, target=target }
end

function M.compile(text, lookup)
  if type(text) ~= 'string' or #text == 0 or #text > 255 then return nil, 'Use 1–255 characters' end
  if text:find('[%z\1-\31\127]') then return nil, 'Use a single line without control characters' end
  local ok, result = pcall(function()
    local program = { line = trim(text) }
    local source = program.line
    if source:sub(1, 3):lower() == 'if ' then
      local start, finish = source:lower():find('%s+then%s+')
      if not start then error('Use: if CONDITION then SPELL [else SPELL]') end
      program.conditionText = trim(source:sub(4, start - 1)):lower()
      program.condition = condition(program.conditionText)
      source = source:sub(finish + 1)
      local a, b = source:lower():find('%s+else%s+')
      if a then program.otherwise = statement(source:sub(b + 1), lookup); source = source:sub(1, a - 1) end
    end
    program.call = statement(source, lookup)
    local function format(call)
      local target = call.target
      if target and target:sub(1, 5) == 'name:' then target = '"' .. target:sub(6) .. '"' end
      return (target and 'on ' .. target .. ' ' or '') .. (call.card.command or call.card.phrase or call.card.id)
    end
    program.line = (program.condition and 'if ' .. program.conditionText .. ' then ' or '') .. format(program.call)
      .. (program.otherwise and ' else ' .. format(program.otherwise) or '')
    return program
  end)
  if ok then return result end
  return nil, tostring(result):gsub('^.-:%d+: ', '')
end

local function field_value(field, state, percent)
  local actor, name = field:match('^(%a+)%.(%a+)$')
  local prefix = actor == 'self' and '' or actor
  local hp = state[prefix == '' and 'hp' or prefix .. 'Hp']
  local maximum = state[prefix == '' and 'maxHp' or prefix .. 'MaxHp']
  local exists = actor == 'self' and state.playerName ~= nil or state[prefix .. 'Id'] ~= nil
  if name == 'exists' then return exists end
  if name == 'alive' then return exists and hp ~= nil and hp > 0 end
  if name == 'casting' then return state.isCasting == true end
  if name == 'mp' then hp, maximum = state.mp, state.maxMp or 10000 end
  if percent then return hp and maximum and maximum > 0 and hp * 100 / maximum or nil end
  return hp
end

local function evaluate(node, state)
  if node.op == 'and' then return evaluate(node.a, state) and evaluate(node.b, state) end
  if node.op == 'or' then return evaluate(node.a, state) or evaluate(node.b, state) end
  if node.op == 'not' then return not evaluate(node.a, state) end
  local value = field_value(node.field, state, node.percent)
  if not node.op then return value == true end
  if value == nil then return false end
  if node.op == '==' then return value == node.value end
  if node.op == '!=' or node.op == '~=' then return value ~= node.value end
  if node.op == '<' then return value < node.value end
  if node.op == '>' then return value > node.value end
  if node.op == '<=' then return value <= node.value end
  if node.op == '>=' then return value >= node.value end
  return false
end

function M.select(program, state)
  if program.condition then
    local passed = evaluate(program.condition, state or {})
    return passed and program.call or program.otherwise, passed
  end
  return program.call, nil
end

return M
