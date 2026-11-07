---@type SpellCard
return {
  name = "Fester",
  action = actions.fester,
  target = "current",
  phrase = "fester",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.fester)
  end,
}
