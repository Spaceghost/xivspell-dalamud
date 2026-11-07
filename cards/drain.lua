---@type SpellCard
return {
  name = "Energy Drain",
  action = actions.drain,
  target = "current",
  phrase = "energy drain",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.drain)
  end,
}
