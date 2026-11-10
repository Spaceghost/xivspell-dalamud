package.path = 'lua/?.lua;' .. package.path
local L = require('xivspell.language')
local cards = { ruin={ id='ruin', phrase='ruin' }, physick={ id='physick', phrase='physick' }, aegis={ id='aegis', phrase='radiant aegis' } }
local function lookup(s)
  for _, card in pairs(cards) do if s:lower() == card.id or s:lower() == card.phrase then return card end end
  return nil, 'Unknown spell'
end
local function compile(s) return assert(L.compile(s, lookup)) end
assert(compile('on focus physick').call.target == 'focus')
assert(compile('on friendly physick').call.target == 'friendly')
assert(compile('on target ruin').call.target == 'current')
assert(compile('on "Dusk Bat" ruin').call.target == 'name:Dusk Bat')
assert(compile('on party8 physick').call.target == 'party8')
assert(compile('on tank physick').call.target == 'tank')
for _, alias in ipairs({ 'me', 'myself', 'I', 'im', "I'm", 'own' }) do
  assert(compile('on ' .. alias .. ' physick').call.target == 'self', alias)
end
assert(compile("I'm physick").line == 'on self physick')
assert(compile('I am physick').line == 'on self physick')
assert(compile('on off-tank physick').call.target == 'tank2')
assert(compile('on dps3 physick').call.target == 'dps3')
assert(compile('on mobs ruin').call.target == 'mob')
assert(compile('on boss ruin').call.target == 'boss')
assert(compile('on nearest enemy ruin').line == 'on nearest ruin')
assert(compile('nearest enemy ruin').call.target == 'nearest')
assert(compile('on nearest ruin').call.target == 'nearest')
assert(compile('on closest enemy ruin').call.target == 'nearest')
assert(compile('on nearest-enemy ruin').call.target == 'nearest')
assert(compile('if target.exists then on nearest enemy ruin else on self physick').call.target == 'nearest')
assert(L.target_command('target nearest enemy') == 'nearest')
assert(L.target_command('target nearest mob') == 'nearestmob')
assert(L.target_command('target nearest enemy/mob') == 'nearestmob')
assert(not L.target_command('target nearest enemy ruin'))
assert(compile('target nearest enemy ruin').line == 'on nearest ruin')
assert(compile('on nearest mob ruin').call.target == 'nearestmob')
assert(compile('target nearest mob ruin').call.target == 'nearestmob')
local p = compile('if self.hp < 50% and target.exists then on self physick else on current ruin')
assert(L.select(p, { playerName='Me', hp=40, maxHp=100, targetId=5 }).card.id == 'physick')
assert(L.select(p, { playerName='Me', hp=60, maxHp=100, targetId=5 }).card.id == 'ruin')
assert(L.select(p, { playerName='Me', hp=40, maxHp=100 }).card.id == 'ruin')
assert(not L.select(compile('if target.hp < 50% then ruin'), {}), 'missing actors never satisfy numeric conditions')
assert(L.select(compile('if not target.exists then on self radiant aegis'), {}).card.id == 'aegis')
assert(L.select(compile('if self.hp < 1 or target.exists and focus.exists then ruin'), { hp=2, targetId=1 }) == nil)
assert(L.select(compile('if (self.hp < 1 or target.exists) and not focus.exists then ruin'), { hp=2, targetId=1 }))
assert(L.select(compile('if self.casting == false then ruin'), { isCasting=false }))
for _, s in ipairs({ 'while true do ruin', 'if os.execute then ruin', 'if self.hp < 101% then ruin',
  'if self.hp then ruin', 'if self.hp < 50% ruin', 'on party9 physick', 'on tank unknown',
  'if (target.exists then ruin', 'if self.hp < 50% then ruin; os.execute("x")' }) do
  assert(not L.compile(s, lookup), 'invalid language accepted: ' .. s)
end
print('PASS spell targets, named targets, percentage conditions, boolean precedence, else branches, missing actors and invalid programs')
