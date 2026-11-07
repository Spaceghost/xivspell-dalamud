---@type SpellCard
return {
  name = "Aethercharge",
  action = actions.charge,
  target = "self",
  phrase = "aethercharge",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.charge)
  end,
}
