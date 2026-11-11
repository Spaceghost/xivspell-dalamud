local M = { mode = 'live', cards = {}, state = {}, attempts = {}, busy = false }
local api, fn = vim.api, vim.fn
local hooks = require('xivspell.hooks')
-- Keep explicit signatures here: LuaLS loses callback overloads on a bare alias.
---@overload fun(event: 'session_start', callback: fun(event: {deck: string})): fun()
---@overload fun(event: 'session_end', callback: fun(event: table)): fun()
---@overload fun(event: 'before_compile', callback: fun(event: {path: string})): fun()
---@overload fun(event: 'after_compile', callback: fun(event: {path: string, card: SpellCard})): fun()
---@overload fun(event: 'deck_loaded', callback: fun(event: {cards: SpellCard[], errors: string[]})): fun()
---@overload fun(event: 'buffer_saved', callback: fun(event: {path: string})): fun()
---@overload fun(event: 'before_parse', callback: fun(event: {text: string, card?: SpellCard}): boolean|nil): fun()
---@overload fun(event: 'after_parse', callback: fun(event: {text: string, card?: SpellCard})): fun()
---@overload fun(event: 'expand', callback: fun(event: {from: string, to: string})): fun()
---@overload fun(event: 'repeat', callback: fun(event: {command: string})): fun()
---@overload fun(event: 'before_cast', callback: fun(event: SpellBeforeCast): boolean|nil): fun()
---@overload fun(event: 'after_cast', callback: fun(event: SpellAttempt)): fun()
---@overload fun(event: 'cast_rejected', callback: fun(event: SpellAttempt)): fun()
---@overload fun(event: 'bridge_error', callback: fun(event: SpellAttempt|table)): fun()
---@overload fun(event: 'snapshot', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'target_changed', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'mode_changed', callback: fun(event: {mode: SpellMode})): fun()
---@overload fun(event: 'follow_started', callback: fun(event: SpellSnapshot|table)): fun()
---@overload fun(event: 'follow_stopped', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'controller_override', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'mcp_before', callback: fun(event: SpellRpcEvent): boolean|nil): fun()
---@overload fun(event: 'mcp_after', callback: fun(event: SpellRpcEvent)): fun()
---@param event string
---@param callback fun(context: table): boolean|nil
---@return fun()
function M.on(event, callback) return hooks.on(event, callback) end
local root = fn.resolve(fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h:h'))
local ns = api.nvim_create_namespace('xivspell')
local config = { deck = root .. '/cards', container = 'ffxiv', runtime = false }
local logpath = fn.stdpath('state') .. '/xivspell/attempts.jsonl'
local deckbuf, deckwin

local function notify(text, level)
  if not config.silent then vim.notify(text, level or vim.log.levels.INFO, { title = 'Grimoire' }) end
end
local function clock() return vim.uv.hrtime() / 1e9 end

function M.transport(command, payload, callback)
  require('xivspell.transport').call(command, payload, callback)
end

local function log(attempt)
  M.attempts[#M.attempts + 1] = attempt
  fn.mkdir(fn.fnamemodify(logpath, ':h'), 'p')
  fn.writefile({ vim.json.encode(attempt) }, logpath, 'a')
end

local function limited(f)
  local oldhook, mask, count = debug.gethook()
  local ticks = 0
  debug.sethook(function() ticks = ticks + 1; if ticks > 100 then error('Card instruction budget exceeded') end end, '', 1000)
  local ok, result = pcall(f)
  debug.sethook(oldhook, mask, count)
  return ok, result
end

local function loadcard(path)
  hooks.emit('before_compile', { path = path })
  local chunk, err = loadfile(path)
  if not chunk then return nil, err end
  -- LuaJIT traces do not reliably run instruction hooks; keep card prototypes interpreted.
  if jit then jit.off(chunk, true) end
  -- Card source is a small pure Lua program. Side effects go through the context at invocation.
  setfenv(chunk, { math = math, string = string, table = table, pairs = pairs, ipairs = ipairs,
    tonumber = tonumber, tostring = tostring, type = type, assert = assert, error = error,
    unpack = unpack, select = select, next = next, actions = require('xivspell.actions') })
  local ok, card = limited(chunk)
  if not ok then return nil, card end
  if type(card) ~= 'table' or type(card.name) ~= 'string' or type(card.phrase) ~= 'string' or type(card.run) ~= 'function' then
    return nil, 'Card must return {name, phrase, action, target, run = function(ctx) ... end}'
  end
  if card.phrase == '' or #card.phrase > 255 or card.phrase:find('[\r\n]') then return nil, 'Spell names must fit a single input line (1–255 bytes)' end
  card.id = fn.fnamemodify(path, ':t:r')
  card.path = path
  card.target = card.target or 'current'
  card.source = table.concat(fn.readfile(path), '\n')
  hooks.emit('after_compile', { path = path, card = card })
  return card
end

function M.reload()
  local previous = {}
  for _, card in ipairs(M.cards) do previous[card.path] = card end
  local cards, errors = {}, {}
  for _, path in ipairs(fn.glob(config.deck .. '/*.lua', false, true)) do
    local card, err = loadcard(path)
    if card then cards[#cards + 1] = card else
      if previous[path] then cards[#cards + 1] = previous[path] end
      errors[#errors + 1] = fn.fnamemodify(path, ':t') .. ': ' .. tostring(err) .. (previous[path] and ' (kept previous version)' or '')
    end
  end
  M.cards = cards
  hooks.emit('deck_loaded', { cards = cards, errors = errors })
  if #errors > 0 then notify(table.concat(errors, '\n'), vim.log.levels.ERROR) end
  return #errors == 0
end

local function find(id)
  for _, card in ipairs(M.cards) do if card.id == id then return card end end
end

local function optional_target(target)
  -- Native events serialize an absent picker override as JSON null. Neovim
  -- decodes that as truthy vim.NIL, which must not override a card's target.
  if target == vim.NIL then return nil end
  return target
end

function M.cast(id, typing, finished, request_id, target_override)
  target_override = optional_target(target_override)
  local card = find(id)
  if not card then notify('Unknown card: ' .. tostring(id), vim.log.levels.ERROR); return false end
  if M.busy then notify('Waiting for the previous input result'); return false end
  local intent, advances
  local state = vim.deepcopy(M.state[id] or {})
  local ctx = { state = state, actions = require('xivspell.actions'), target = target_override or card.target, xiv = require('xiv'), snapshot = M.snapshot or {} }
  function ctx:cast(action, target)
    assert(not intent, 'One action per invocation. Use ctx:sequence() for multi-step macros.')
    assert(type(action) == 'number' and action > 0 and action == math.floor(action), 'action must be a positive action id')
    intent = { action = action, target = target_override or target or self.target,
      targetExplicit = target_override ~= nil or target ~= nil }
  end
  function ctx:sequence(steps)
    assert(#steps > 0, 'Sequence is empty')
    local step = (self.state.step or 0) % #steps + 1
    local item = steps[step]
    if type(item) == 'number' then self:cast(item) else self:cast(item.action, item.target) end
    self.state.step = step
    advances = step
  end
  local ok, err = limited(function() card.run(ctx) end)
  if not ok or not intent then notify(ok and 'Card emitted no action' or tostring(err), vim.log.levels.ERROR); return false end
  local attempt = { card = id, time = os.date('!%Y-%m-%dT%H:%M:%SZ'), mode = M.mode, action = intent.action,
    target = intent.target, typing = typing, step = advances }
  if not hooks.emit('before_cast', { card = card, intent = intent, context = ctx, mode = M.mode }) then
    notify('Cancelled by before_cast hook'); return false
  end
  attempt.action, attempt.target = intent.action, intent.target
  if M.mode == 'practice' then
    M.state[id] = state
    attempt.result = { practice = true }
    log(attempt)
    hooks.emit('after_cast', attempt)
    if finished then finished(attempt.result) end
    notify(string.format('Practice / %s → %s%s', card.name, intent.target, advances and (' / step ' .. advances) or ''))
    return true
  end
  intent.requestId = request_id or (tostring(vim.uv.hrtime()) .. '-' .. fn.getpid())
  M.busy = true
  local started = clock()
  local submitted_at
  local function finish(result, error)
    M.busy = false
    attempt.latencyMs = math.floor((clock() - started) * 1000)
    attempt.result, attempt.error = result, error
    if result and result.accepted then M.state[id] = state end
    log(attempt)
    hooks.emit(error and 'bridge_error' or result.accepted and 'after_cast' or 'cast_rejected', attempt)
    if finished then finished(result, error) end
    notify(error or result.message or vim.inspect(result), error and vim.log.levels.ERROR or nil)
  end
  local function await(result, error)
    if not error and result and result.pending then
      submitted_at = submitted_at or clock()
      if clock() - submitted_at > 35 then finish(nil, 'Cast outcome unknown; queue paused'); return end
      vim.defer_fn(function() M.transport('cast_result', { requestId = intent.requestId }, await) end, 80)
    elseif not error and result and result.retry and not submitted_at and request_id and request_id:match('^weave%-') then
      -- Native retry means UseAction has not run. Keep this exact program
      -- intent/state instead of evaluating Lua or emitting before_cast again.
      -- Cancellation is checked against the native weave ticket on every call.
      vim.defer_fn(function() M.transport('cast', intent, await) end, 150)
    else finish(result, error) end
  end
  M.transport('cast', intent, await)
  return true
end

function M.edit(id)
  local card = find(id)
  if not card then return end
  M.last_edited = id
  if config.runtime then
    M.transport('editor_open', { cardId=id }, function() end)
    return
  end
  local existing = fn.bufnr(card.path)
  local windows = existing >= 0 and fn.win_findbuf(existing) or {}
  if #windows > 0 then api.nvim_set_current_win(windows[1]) else vim.cmd('vsplit ' .. fn.fnameescape(card.path)) end
  api.nvim_buf_set_keymap(0, 'n', '<localleader>c', '<Cmd>Cast ' .. card.id .. '<CR>', { desc = 'Invoke spell buffer' })
end

-- Runs in the interactive editor. Restrict write/close to known card buffers.
function M.editor_action(op, id)
  local card = find(id)
  if not card then return { ok=false, message='Unknown spell: ' .. tostring(id) } end
  local result = require('xivspell.editor').action(op, card.path, card.name)
  if result.ok then M.last_edited = card.id end
  return result
end

function M.editor_command(text)
  local request, err = require('xivspell.editor').parse(text)
  local function feedback(message)
    M.transport('feedback', { text=message, mode='editor' }, function() end)
  end
  if not request then feedback(err); return false end
  if request.op == 'reload' then M.configure(); M.sync(); feedback('Spellbook reloaded'); return true end
  if request.op == 'neovim' then
    local card, failure
    if request.argument == '' then card = find(M.last_edited)
    else card, failure = require('xivspell.command').resolve(request.argument) end
    if not card then feedback(failure or 'Use :nvim SPELL to open a spell buffer'); return false end
    M.last_edited = card.id
    if not config.runtime then M.edit(card.id); return true end
    require('xivspell.editor').remote(config.editor_socket, card.id, function(result) feedback(result.message) end)
    return true
  end
  if config.runtime then
    M.transport('editor_command', { text=text }, function(result, failure)
      feedback(failure or result.message or 'Spell editor ready')
    end)
    return true
  end
  local card
  if request.op == 'edit' then card, err = require('xivspell.command').resolve(request.argument)
  else card = find(M.last_edited) end
  if not card then feedback(err or 'Open a spell with :e first'); return false end
  local ok, result = pcall(M.editor_action, request.op, card.id)
  if not ok then feedback(tostring(result)); return false end
  if result.ok then M.last_edited = card.id end
  feedback(result.message)
  return result.ok
end

function M.book()
  M.reload()
  vim.cmd.tabnew()
  vim.t.spaceghost_name = 'Grimoire'
  deckbuf, deckwin = api.nvim_get_current_buf(), api.nvim_get_current_win()
  vim.bo[deckbuf].buftype = 'nofile'; vim.bo[deckbuf].bufhidden = 'wipe'; vim.bo[deckbuf].swapfile = false
  api.nvim_buf_set_name(deckbuf, 'Grimoire / ' .. deckbuf)
  vim.wo.number = false; vim.wo.relativenumber = false; vim.wo.wrap = false
  local lines = { '', '  G R I M O I R E', '  ARCANIST / Lua spell laboratory', '',
    '  Enter / e: edit Lua buffer', '  r: reload    s: publish spellcard icons', '',
    '  :e SPELL · :w save · :ls spellbook', '' }
  for _, card in ipairs(M.cards) do
    lines[#lines + 1] = '  ◆ ' .. card.name
    lines[#lines + 1] = '    ' .. card.phrase .. ' → ' .. card.target
    lines[#lines + 1] = ''
  end
  lines[#lines + 1] = '  :SpellFollow role / focus / current / party2'
  lines[#lines + 1] = '  Move left stick to cancel follow. :SpellUnfollow stops it.'
  lines[#lines + 1] = '  :SpellStats / :SpellSync / :SpellApi'
  api.nvim_buf_set_lines(deckbuf, 0, -1, false, lines)
  vim.bo[deckbuf].modifiable = false
  for index, line in ipairs(lines) do
    if line:find('◆', 1, true) or index == 2 then api.nvim_buf_add_highlight(deckbuf, ns, 'XivSpellGold', index - 1, 0, -1)
    elseif index == 3 or line:find('→', 1, true) then api.nvim_buf_add_highlight(deckbuf, ns, 'XivSpellBlue', index - 1, 0, -1) end
  end
  local function card_here()
    local row = api.nvim_win_get_cursor(0)[1]
    return M.cards[math.max(1, math.min(#M.cards, math.floor((row - 10) / 3) + 1))]
  end
  vim.keymap.set('n', '<CR>', function() local c = card_here(); if c then M.edit(c.id) end end, { buffer = deckbuf })
  vim.keymap.set('n', 'e', function() local c = card_here(); if c then M.edit(c.id) end end, { buffer = deckbuf })
  vim.keymap.set('n', 's', M.sync, { buffer = deckbuf })
  vim.keymap.set('n', 'r', function() vim.cmd.tabclose(); M.book() end, { buffer = deckbuf })
  api.nvim_win_set_cursor(deckwin, { 10, 0 })
end

function M.sync()
  M.reload()
  local cards = {}
  for _, card in ipairs(M.cards) do cards[#cards + 1] = { id = card.id, name = card.name, action = card.action or 0,
    target = card.target, phrase = card.command or card.phrase, aliases = card.aliases, source = card.source } end
  M.transport('cards', { cards = cards, expansions = require('xivspell.command').expansions }, function(result, error)
    M.connected = not error
    if M.connected and config.runtime then M.watch(result.sequence) end
    notify(error or ('Attached ' .. result.count .. ' spell buffers to game icons'))
  end)
end

function M.watch(sequence)
  if M.watcher then return end
  local after, waiting, failures, session = sequence or 0, false, 0, nil
  M.watcher = vim.uv.new_timer()
  M.watcher:start(80, 80, vim.schedule_wrap(function()
    if waiting or not M.watcher then return end
    waiting = true
    M.transport('events', { after = after }, function(result, error)
      waiting = false
      if error then
        failures = failures + 1
        if failures >= 3 and M.watcher then M.watcher:stop(); M.watcher:close(); M.watcher = nil; M.connected = false end
        return
      end
      failures = 0
      if session and result.session and result.session ~= session then
        session = result.session; after = 0; M.connected = false; M.sync(); return
      end
      session = result.session or session
      if result.state then
        local previous = M.snapshot or {}
        M.snapshot = result.state
        local mode = result.state.armed and 'live' or 'off'
        if M.mode ~= mode then M.mode = mode; hooks.emit('mode_changed', { mode = mode }) end
        if previous.targetId ~= result.state.targetId or previous.focusId ~= result.state.focusId then hooks.emit('target_changed', result.state) end
        if previous.following ~= result.state.following then
          hooks.emit(result.state.following and 'follow_started' or 'follow_stopped', result.state)
          if result.state.message:find('Controller movement', 1, true) then hooks.emit('controller_override', result.state) end
        end
        if not vim.deep_equal(previous, result.state) then hooks.emit('snapshot', result.state) end
      end
      for _, event in ipairs(result.events or {}) do
        if event.kind == 'voice' then
          local voice = require('xivspell.voice')
          if event.card == 'cancel' then voice.cancel() else voice.toggle() end
        elseif event.kind == 'editor-save' then require('xivspell.tile_editor').handle(event)
        elseif event.kind == 'edit' then M.edit(event.card)
        elseif event.kind == 'editor' and math.abs(os.time() * 1000 - (event.time or 0)) < 3000 then M.editor_command(event.card)
        elseif event.kind == 'mode' then M.mode = event.card; hooks.emit('mode_changed', { mode = M.mode })
        elseif (event.kind == 'compile' or event.kind == 'translate') and math.abs(os.time() * 1000 - (event.time or 0)) < 3000 then
          M.prepare_line(event)
        elseif event.kind == 'command' and math.abs(os.time() * 1000 - (event.time or 0)) < 3000 then
          M.invoke(event.card, event.seconds, event.requestId, nil, event.target)
        end
      end
      after = result.sequence or after
    end)
  end))
end

-- Compilation only stages a line. Translation returns an editable suggestion;
-- the user must press Enter again before it can enter the weave.
function M.prepare_line(event)
  local command = require('xivspell.command')
  local function deliver(kind, text, program, failure)
    M.transport(kind, { requestId = event.requestId, text = failure or text,
      cardId = program and program.call.card.id or '', accepted = failure == nil }, function() end)
  end
  if event.kind == 'compile' then
    local program, err = command.compile(event.card)
    if program then deliver('compiled', program.line, program); return end
    if event.card:lower():match('^if%s') or event.card:lower():match('^on%s') then deliver('compiled', '', nil, err); return end
  end
  local spells = {}
  for _, card in ipairs(M.cards) do spells[#spells + 1] = { id = card.id, phrase = card.command or card.phrase } end
  vim.system({ 'python3', root .. '/tools/translate.py' }, { text = true,
    stdin = vim.json.encode({ text = event.card, spells = spells }) }, function(result)
    vim.schedule(function()
      local ok, response = pcall(vim.json.decode, result.stdout or '')
      if not ok or not response.ok then
        deliver('translated', '', nil, ok and response.error or 'Local translator unavailable'); return
      end
      local program, err = command.compile(response.line)
      deliver('translated', program and program.line or '', program, err)
    end)
  end)
end

---Execute a spell name or expansion from the native game input bar. A dot repeats the last successful command.
---@param text string
---@param seconds? number
function M.invoke(text, seconds, request_id, waiting_since, target_override)
  target_override = optional_target(target_override)
  local conditionOutcome
  local input = require('xivspell.command').normalize(text)
  if input == '.' then
    if not M.last_command then M.transport('feedback', { text = 'No previous spell to repeat', requestId = request_id }, function() end); return false end
    hooks.emit('repeat', { command = M.last_command })
    input = M.last_command
    target_override = target_override or M.last_target_override
  end
  local function feedback(message, accepted, skipped, retry) M.transport('feedback', { text = message, requestId = request_id, accepted = accepted, mode = M.mode, condition = conditionOutcome, skipped = skipped, retry = retry }, function() end) end
  if M.busy then
    -- Dot can replace the native ticket while the previous cast result is still
    -- crossing the bridge. Let that result settle before evaluating the restart.
    if request_id and request_id:match('^weave%-') and clock() - (waiting_since or clock()) < 3 then
      waiting_since = waiting_since or clock()
      vim.defer_fn(function() M.invoke(text, seconds, request_id, waiting_since, target_override) end, 80)
      return true
    end
    feedback('Still waiting for the previous spell', false); return false
  end
  if input == 'stop' then M.transport('unfollow', {}, function(r, e) feedback(e or r.message) end); return true end
  local follow = input:match('^follow%s+(%S+)$')
  if follow then
    if M.mode ~= 'live' then feedback('Practice: follow ' .. follow); return true end
    M.transport('follow', { target = follow, requestId = tostring(vim.uv.hrtime()) }, function(r, e)
      hooks.emit(e and 'bridge_error' or 'follow_started', { target = follow, result = r, error = e }); feedback(e or r.message)
    end)
    return true
  end
  local target_command = require('xivspell.language').target_command(input)
  if target_command then
    M.transport('target', { target = target_command, requestId = request_id or tostring(vim.uv.hrtime()) }, function(result, failure)
      feedback(failure or result.message, not failure, true)
    end)
    return true
  end
  local program, error = require('xivspell.command').compile(input)
  if not program then M.streak = 0; feedback(error, false); return false end
  local call
  call, conditionOutcome = require('xivspell.language').select(program, M.snapshot or {})
  if not call then M.last_command = program.line; M.last_target_override = target_override; feedback('Condition false · skipped', true, true); return true end
  local card = call.card
  local typing = { input = text, seconds = seconds or 0, repeatCommand = text == '.',
    wpm = seconds and seconds > 0 and math.floor(#text / 5 / seconds * 60) or 0 }
  local issued = M.cast(card.id, typing, function(result, failure)
    if failure or (result and result.accepted == false) then
      M.streak = 0; feedback(failure or result.message or 'Spell unavailable', false, false, result and result.retry)
    else
      M.streak = (M.streak or 0) + 1; M.last_command = program.line
      M.last_target_override = target_override
      feedback(card.name .. ' · ' .. M.streak .. ' chain' .. (M.mode == 'practice' and ' · practice' or ' · requested'), true)
    end
  end, request_id, call.target or target_override)
  if not issued then feedback('Spell cancelled or Lua card failed', false) end
  return issued
end

function M.stats()
  local lines = { 'GRIMOIRE / this session', '' }
  for _, attempt in ipairs(M.attempts) do
    local t = attempt.typing
    lines[#lines + 1] = string.format('%s  %s  %s%s', attempt.time, attempt.card, attempt.mode,
      t and string.format('  %dwpm  %d%%  %.1fs', t.wpm, t.accuracy, t.seconds) or '')
  end
  vim.cmd.new(); vim.bo.buftype = 'nofile'; vim.bo.bufhidden = 'wipe'
  api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

function M.setup(opts)
  vim.g.loaded_xivspell = true
  config = vim.tbl_extend('force', config, opts or {})
  require('xivspell.transport').setup({ root = root, container = config.container })
  require('xivspell.command').setup()
  api.nvim_set_hl(0, 'XivSpellGold', { fg = '#e8c580', bold = true })
  api.nvim_set_hl(0, 'XivSpellBlue', { fg = '#8bc8e8' })
  local function complete() return vim.tbl_map(function(card) return card.id end, M.cards) end
  api.nvim_create_user_command('Spellbook', M.book, {})
  api.nvim_create_user_command('SpellExpand', function(o)
    local short, full = o.args:match('^(%S+)%s+(.+)$')
    assert(short and full, 'Usage: SpellExpand shortcut full spell name')
    require('xivspell.command').expand(short, full, true)
    notify(short .. ' → ' .. full)
  end, { nargs = '+' })
  api.nvim_create_user_command('Cast', function(o)
    M.transport('input', { text = o.args, requestId = tostring(vim.uv.hrtime()) }, function(_, error) if error then notify(error) end end)
  end, { nargs = 1, complete = complete })
  api.nvim_create_user_command('SpellEdit', function(o) M.edit(o.args) end, { nargs = 1, complete = complete })
  api.nvim_create_user_command('SpellTarget', function(o)
    M.transport('weave_target', {target=o.args}, function(result, failure) notify(failure or result.message) end)
  end, {nargs=1, complete=function() return {'card','friendly','self','current','focus','tank','lowest','targetOfTarget','enemy','nearest','mob','boss','party1','party2','party3','party4','party5','party6','party7','party8'} end})
  api.nvim_create_user_command('SpellSync', M.sync, {})
  api.nvim_create_user_command('SpellStats', M.stats, {})
  api.nvim_create_user_command('SpellFollow', function(o)
    if M.mode ~= 'live' then notify('Casting and following are stopped.'); return end
    M.transport('follow', { target = o.args, requestId = tostring(vim.uv.hrtime()) }, function(r, e) notify(e or r.message) end)
  end, { nargs = 1, complete = function() return { 'role', 'focus', 'current', 'party2', 'party3', 'party4' } end })
  api.nvim_create_user_command('SpellUnfollow', function()
    M.transport('unfollow', {}, function(r, e) notify(e or r.message) end)
  end, {})
  api.nvim_create_user_command('SpellDisarm', function()
    M.mode = 'off'
    M.transport('disarm', {}, function(_, e) notify(e or 'Casting and following stopped.') end)
  end, {})
  api.nvim_create_user_command('SpellApi', function()
    M.transport('catalogue', {}, function(result, error)
      if error then notify(error, vim.log.levels.ERROR); return end
      fn.writefile({ vim.json.encode(result) }, root .. '/api/catalogue.json')
      vim.system({ 'python3', root .. '/tools/bridge.py', 'generate', root .. '/api/catalogue.json' }, { text = true }, vim.schedule_wrap(function(r) notify(r.stdout) end))
    end)
  end, {})
  local group = api.nvim_create_augroup('XivSpell', { clear = true })
  api.nvim_create_autocmd('BufWritePost', { group = group, pattern = config.deck .. '/*.lua', callback = function()
    hooks.emit('buffer_saved', { path = api.nvim_buf_get_name(0) })
    M.reload()
    if M.connected then M.sync() end
  end })
  api.nvim_create_autocmd('VimLeavePre', { group = group, callback = function()
    hooks.emit('session_end', {})
    require('xivspell.transport').stop()
    if M.watcher then M.watcher:stop(); M.watcher:close(); M.watcher = nil end
  end })
  local function attach_lua(buf)
    if not api.nvim_buf_is_loaded(buf) or vim.bo[buf].filetype ~= 'lua' then return end
    local path = fn.resolve(api.nvim_buf_get_name(buf))
    local function inside(directory) return path:sub(1, #directory + 1) == directory .. '/' end
    if path ~= root .. '/grimoire.lua' and not inside(fn.resolve(config.deck)) and not inside(root .. '/lua') then return end
    local command = config.lua_ls or 'lua-language-server'
    if fn.executable(command) == 0 then return end
    vim.lsp.start({ name = 'xivspell-lua', cmd = { command }, root_dir = root,
      settings = { Lua = { runtime = { version = 'LuaJIT', pathStrict = true, path = { 'lua/?.lua', 'lua/?/init.lua', '?.lua', '?/init.lua' } },
        workspace = { library = { root .. '/api', root .. '/lua' }, checkThirdParty = false },
        completion = { maxSuggestCount = 1000 },
        diagnostics = { globals = { 'actions' } }, telemetry = { enable = false } } },
      on_attach = function(client, buf)
        vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = buf })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf })
      end }, { bufnr = buf })
  end
  api.nvim_create_autocmd('FileType', { group = group, pattern = 'lua', callback = function(ev) attach_lua(ev.buf) end })
  for _, buf in ipairs(api.nvim_list_bufs()) do attach_lua(buf) end
  M.reload()
  M.configure()
  api.nvim_create_user_command('SpellConfig', M.configure, {})
  hooks.emit('session_start', { deck = config.deck })
end

function M.configure()
  for _, remove in ipairs(M.user_hooks or {}) do remove() end
  M.user_hooks = {}
  local path = root .. '/grimoire.lua'
  if fn.filereadable(path) == 0 then return end
  local ok, user = pcall(dofile, path)
  if not ok or type(user) ~= 'table' then notify('grimoire.lua: ' .. tostring(user), vim.log.levels.ERROR); return end
  for short, full in pairs(user.expansions or {}) do require('xivspell.command').expand(short, full) end
  for event, handler in pairs(user.hooks or {}) do M.user_hooks[#M.user_hooks + 1] = hooks.on(event, handler) end
  require('xivspell.command').setup()
end

M.root = root
M.loadcard = loadcard
return M
