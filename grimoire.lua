---@type SpellUserConfig
return {
  -- Type one of these, then Tab (or Enter) to expand it into a spell name.
  expansions = {
    ra = 'radiant aegis',
    sc = 'summon carbuncle',
    ed = 'energy drain',
    sr = 'summon ruby',
    st = 'summon topaz',
    bn = 'burst next',
  },
  hooks = {
    -- Example: redirect only Physick to your focus target when you choose to.
    -- before_cast = function(event)
    --   if event.card.id == 'physick' then event.intent.target = 'focus' end
    -- end,
    -- after_cast = function(attempt) ... end,
    -- cast_rejected = function(attempt) ... end,
  },
}
