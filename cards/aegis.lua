---@type SpellCard
return {
  name = "Radiant Aegis",
  action = actions.aegis,
  target = "self",
  phrase = "radiant aegis",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.aegis)
  end,
}
