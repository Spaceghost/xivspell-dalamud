---@type SpellCard
return {
  name = "Aether notebook / three steps",
  action = actions.charge,
  target = "current",
  phrase = "burst next",
  ---@param ctx SpellContext
  run = function(ctx)
    -- Each invocation advances ONE step. Cooldown failures retain the step.
    ctx:sequence({
      { action = actions.charge, target = "self" },
      actions.drain,
      actions.fester,
    })
  end,
}
