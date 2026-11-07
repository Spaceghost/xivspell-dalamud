---@type SpellCard
return {
  name = "Ruin",
  action = actions.ruin,
  target = "current",
  phrase = "ruin",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.ruin)
  end,
}
