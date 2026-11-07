---@type SpellCard
return {
  name = "Summon Ruby",
  action = actions.ruby,
  target = "current",
  phrase = "summon ruby",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.ruby)
  end,
}
