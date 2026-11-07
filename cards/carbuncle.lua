---@type SpellCard
return {
  name = "Summon Carbuncle",
  action = actions.carbuncle,
  target = "self",
  phrase = "summon carbuncle",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.carbuncle)
  end,
}
