---@type SpellCard
return {
  name = "Swiftcast",
  action = actions.swift,
  target = "self",
  phrase = "swiftcast",
  ---@param ctx SpellContext
  run = function(ctx)
    ctx:cast(actions.swift)
  end,
}
