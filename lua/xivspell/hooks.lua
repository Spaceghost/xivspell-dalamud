---@class SpellHooks
local M = { handlers = {} }
---Register a hook. Return false from before_parse/before_cast/mcp_before to cancel.
---Errors are isolated and reported. The returned function removes this handler.
---@overload fun(event: 'session_start', callback: fun(event: {deck: string})): fun()
---@overload fun(event: 'session_end', callback: fun(event: table)): fun()
---@overload fun(event: 'before_compile', callback: fun(event: {path: string})): fun()
---@overload fun(event: 'after_compile', callback: fun(event: {path: string, card: SpellCard})): fun()
---@overload fun(event: 'deck_loaded', callback: fun(event: {cards: SpellCard[], errors: string[]})): fun()
---@overload fun(event: 'buffer_saved', callback: fun(event: {path: string})): fun()
---@overload fun(event: 'before_parse', callback: fun(event: {text: string, card?: SpellCard}): boolean|nil): fun()
---@overload fun(event: 'after_parse', callback: fun(event: {text: string, card?: SpellCard})): fun()
---@overload fun(event: 'expand', callback: fun(event: {from: string, to: string})): fun()
---@overload fun(event: 'repeat', callback: fun(event: {command: string})): fun()
---@overload fun(event: 'before_cast', callback: fun(event: SpellBeforeCast): boolean|nil): fun()
---@overload fun(event: 'after_cast', callback: fun(event: SpellAttempt)): fun()
---@overload fun(event: 'cast_rejected', callback: fun(event: SpellAttempt)): fun()
---@overload fun(event: 'bridge_error', callback: fun(event: SpellAttempt|table)): fun()
---@overload fun(event: 'snapshot', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'target_changed', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'mode_changed', callback: fun(event: {mode: SpellMode})): fun()
---@overload fun(event: 'follow_started', callback: fun(event: SpellSnapshot|table)): fun()
---@overload fun(event: 'follow_stopped', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'controller_override', callback: fun(event: SpellSnapshot)): fun()
---@overload fun(event: 'mcp_before', callback: fun(event: SpellRpcEvent): boolean|nil): fun()
---@overload fun(event: 'mcp_after', callback: fun(event: SpellRpcEvent)): fun()
---@param event string
---@param callback fun(context: table): boolean|nil
---@return fun()
function M.on(event, callback)
  assert(type(event) == 'string' and type(callback) == 'function')
  M.handlers[event] = M.handlers[event] or {}
  local handlers = M.handlers[event]
  handlers[#handlers + 1] = callback
  return function()
    for index, handler in ipairs(handlers) do if handler == callback then table.remove(handlers, index); return end end
  end
end

---Emit an event. All handlers run in registration order; false cancels cancellable work.
---@param event string
---@param context table
---@return boolean
function M.emit(event, context)
  local proceed = true
  local handlers = vim.list_extend({}, M.handlers[event] or {})
  for _, handler in ipairs(handlers) do
    local ok, result = pcall(handler, context)
    if not ok then vim.notify('Grimoire hook ' .. event .. ': ' .. tostring(result), vim.log.levels.ERROR)
    elseif result == false then proceed = false end
  end
  return proceed
end
return M
