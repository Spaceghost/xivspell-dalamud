---@diagnostic disable: duplicate-set-field
-- Replacing the transport twice is deliberate: live request control, then pure practice checks.
local root = vim.fn.getcwd()
local test_state = vim.fn.tempname()
vim.env.XDG_STATE_HOME = test_state
vim.opt.runtimepath:prepend(root)
local spell = require('xivspell')
spell.setup({ container = false })
spell.mode = 'practice' -- offline rehearsal is a test fixture, never the UI default
assert(#spell.cards == 14, 'ACN deck')
assert(spell.cast('burst'))
assert(spell.state.burst.step == 1)
assert(spell.cast('burst'))
assert(spell.state.burst.step == 2)
local requests = {}
---@type fun(result?: table, error?: string)
local callback = function() error("No request in flight") end
spell.transport = function(method, payload, cb)
  requests[#requests + 1] = { method = method, payload = payload }; callback = cb
end
spell.mode = 'live'
assert(spell.cast('burst'))
assert(requests[1].payload.action == 181 and requests[1].payload.requestId)
assert(not spell.cast('ruin'), 'in-flight input must not duplicate a cast')
callback({ accepted = false, message = 'cooldown' })
assert(spell.state.burst.step == 2, 'failed request must retain sequence step')
assert(spell.cast('burst'))
assert(requests[2].payload.action == 181)
callback({ accepted = true, message = 'accepted' })
assert(spell.state.burst.step == 3)
assert(spell.cast('burst'))
assert(requests[3].payload.action == 25800 and requests[3].payload.target == 'self')
callback(nil, 'bridge disconnected')
assert(not spell.busy and spell.state.burst.step == 3)
local bad = vim.fn.tempname() .. '.lua'
vim.fn.writefile({ 'while true do end' }, bad)
local card, error = spell.loadcard(bad)
assert(not card and tostring(error):find('instruction budget'), 'runaway card must return control')
vim.fn.writefile({ 'return os.execute("false")' }, bad)
assert(not spell.loadcard(bad), 'card definitions have no shell access')
vim.fn.delete(bad)
spell.mode = 'practice'
spell.book()
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
assert(vim.tbl_contains(lines, '  ◆ Ruin'))
assert(#requests == 3, 'practice must never call the cast bridge')
local feedback = {}
spell.transport = function(method, payload, cb)
  assert(method == 'feedback', 'Practice name invocation must not request a game action')
  feedback[#feedback + 1] = payload
  cb({ ok = true })
end
local command = require('xivspell.command')
assert(assert(command.resolve('Radiant Aegis')).id == 'aegis')
assert(assert(command.resolve('ra')).id == 'aegis')
assert(command.candidates('ru')[1].word == 'ruin')
assert(spell.invoke('ra'))
assert(spell.last_command == 'radiant aegis')
assert(spell.invoke('.'))
assert(feedback[#feedback].text:find('2 chain', 1, true))
assert(not spell.invoke('not a spell'))
local remove = spell.on('before_cast', function() return false end)
assert(not spell.invoke('ruin'))
assert(feedback[#feedback].accepted == false)
remove()
command.expand('cycle1', 'cycle2'); command.expand('cycle2', 'cycle1')
local missing, expansion_error = command.resolve('cycle1')
assert(not missing and expansion_error == 'Expansion cycle')
assert(spell.invoke('burst next'))
local step = spell.state.burst.step
assert(spell.invoke('.'))
assert(spell.state.burst.step == step % 3 + 1, 'dot repeats the macro invocation, advancing one step')
spell.mode = 'live'
local cast_ticket
spell.transport = function(method, payload, cb)
  if method == 'cast' then cast_ticket = payload.requestId; cb({ accepted = true, message = 'accepted' })
  else cb({ ok = true }) end
end
assert(spell.invoke('ruin', 0, 'weave-test-cancellation-ticket'))
assert(cast_ticket == 'weave-test-cancellation-ticket', 'native weave ticket must reach the final action gate')
local burst_card
for _, card in ipairs(spell.cards) do if card.id == 'burst' then burst_card = card end end
assert(burst_card)
local original_run = burst_card.run
local evaluations, before_hooks, submissions = 0, 0, {}
burst_card.run = function(ctx) evaluations = evaluations + 1; original_run(ctx) end
local remove_readiness_hook = spell.on('before_cast', function() before_hooks = before_hooks + 1 end)
local original_hrtime, time_shift = vim.uv.hrtime, 0
vim.uv.hrtime = function() return original_hrtime() + time_shift end
local confirmation
local waiting_step = spell.state.burst.step
spell.transport = function(method, payload, cb)
  if method == 'cast' then
    submissions[#submissions + 1] = vim.deepcopy(payload)
    if #submissions < 3 then
      time_shift = 60000000000 -- a known cooldown can exceed the cast-confirmation deadline
      cb({accepted=false, retry=true, message='Cooldown'})
    else cb({accepted=true, pending=true}) end
  elseif method == 'cast_result' then confirmation = cb
  else cb({ok=true}) end
end
assert(spell.cast('burst', nil, nil, 'weave-readiness-test'))
assert(spell.busy and spell.state.burst.step == waiting_step)
assert(vim.wait(1500, function() return confirmation ~= nil end), 'Known cooldown must not consume confirmation timeout')
assert(evaluations == 1 and before_hooks == 1, 'Cooldown polling cannot rerun Lua or before_cast hooks')
assert(#submissions == 3 and vim.deep_equal(submissions[1], submissions[2]) and vim.deep_equal(submissions[2], submissions[3]), 'Retries retain the exact action, target and native cancellation ticket')
assert(spell.state.burst.step == waiting_step, 'Prepared state cannot commit while waiting')
assert(confirmation)({accepted=true, message='Confirmed after cooldown'})
assert(not spell.busy and spell.state.burst.step == waiting_step % 3 + 1, 'One confirmed action commits one macro step')
vim.uv.hrtime = original_hrtime
burst_card.run = original_run
remove_readiness_hook()
print('PASS retained Lua intent, single hook evaluation, long cooldown and confirmation deadline')
local cancelled_step, cancelled_requests = spell.state.burst.step, 0
spell.transport = function(method, payload, cb)
  if method == 'cast' then
    cancelled_requests = cancelled_requests + 1
    if cancelled_requests == 1 then cb({accepted=false, retry=true})
    else cb(nil, 'Weave interrupted') end
  else cb({ok=true}) end
end
assert(spell.cast('burst', nil, nil, 'weave-cancel-during-wait'))
assert(vim.wait(1000, function() return not spell.busy end))
assert(cancelled_requests == 2 and spell.state.burst.step == cancelled_step, 'Cancelled pre-cast waits stop without spending macro state')
local pendingResult
local beforeStep = spell.state.burst.step
spell.transport = function(method, payload, cb)
  if method == 'cast' then cb({ accepted = true, pending = true })
  elseif method == 'cast_result' then pendingResult = cb
  else cb({ ok = true }) end
end
assert(spell.cast('burst', nil, nil, 'weave-confirm-test'))
assert(spell.state.burst.step == beforeStep and spell.busy, 'request acceptance does not advance macro state')
assert(vim.wait(500, function() return pendingResult ~= nil end))
pendingResult({ accepted = false, retry = true, message = 'Movement interrupted' })
assert(not spell.busy and spell.state.burst.step == beforeStep, 'interrupted movement retains macro substep')
pendingResult = nil
assert(spell.cast('burst', nil, nil, 'weave-confirm-retry'))
assert(vim.wait(500, function() return pendingResult ~= nil end))
assert(pendingResult)({ accepted = true, message = 'Cast confirmed' })
assert(not spell.busy and spell.state.burst.step == beforeStep % 3 + 1, 'only confirmed cast advances macro substep')
local restartRequests = 0
spell.transport = function(method, payload, cb)
  if method == 'cast' then restartRequests = restartRequests + 1; cb({ accepted = true, message = 'confirmed' })
  else cb({ ok = true }) end
end
spell.busy = true
assert(spell.invoke('ruin', 0, 'weave-restarted-ticket'))
assert(restartRequests == 0, 'restart waits for cancelled request result to settle')
spell.busy = false
assert(vim.wait(500, function() return restartRequests == 1 end), 'restart proceeds after pending result settles')
local eventReads, syncs, afters = 0, 0, {}
spell.transport = function(method, payload, cb)
  if method == 'events' then
    eventReads = eventReads + 1; afters[eventReads] = payload.after
    cb({ session=eventReads == 1 and 'before-reload' or 'after-reload', sequence=eventReads == 1 and 99 or 0, events={} })
  elseif method == 'cards' then syncs = syncs + 1; cb({ count=14, sequence=0 })
  else cb({ ok=true }) end
end
spell.watch(99)
assert(vim.wait(1000, function() return eventReads >= 3 end))
spell.watcher:stop(); spell.watcher:close(); spell.watcher = nil
assert(syncs == 1 and afters[3] == 0, 'native reload resends deck and resets event cursor')
print('PASS: native reload reconnects spell deck and event stream')
print('PASS: pending cast confirmation, movement retry and restart preserve macro state')
print('PASS: native weave request identity survives Lua card invocation')
print('PASS: deck, macro sequencing, retries, in-flight input, instruction budget and practice isolation')
print('PASS: spell names, Tab candidates, expansions, dot repeat, hook cancellation and expansion cycles')
vim.fn.delete(test_state, 'rf')
vim.cmd.qa({ bang = true })
