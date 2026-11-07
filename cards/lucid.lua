---@type SpellCard
return {
  name = "Lucid Dreaming",
  action = actions.lucid,
  target = "self",
  phrase = "lucid dreaming",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.lucid)
  end,
}
