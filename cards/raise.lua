---@type SpellCard
return {
  name = "Resurrection",
  action = actions.raise,
  target = "focus",
  phrase = "resurrection",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.raise)
  end,
}
