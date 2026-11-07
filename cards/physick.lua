---@type SpellCard
return {
  name = "Physick",
  action = actions.physick,
  target = "self",
  phrase = "physick",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.physick)
  end,
}
