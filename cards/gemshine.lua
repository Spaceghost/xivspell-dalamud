---@type SpellCard
return {
  name = "Gemshine",
  action = actions.gemshine,
  target = "current",
  phrase = "gemshine",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.gemshine)
  end,
}
