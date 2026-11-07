---@type SpellCard
return {
  name = "Summon Topaz",
  action = actions.topaz,
  target = "current",
  phrase = "summon topaz",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.topaz)
  end,
}
