---@type SpellCard
return {
  name = "Physick",
  action = actions.physick,
  -- Heal the selected living teammate/player; otherwise heal yourself.
  target = "friendly",
  phrase = "physick",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.physick)
  end,
}
