local M = {}
local aliases = { e='edit', edit='edit', nvim='neovim', w='write', write='write', wq='writequit', q='quit', reload='reload' }
function M.parse(text)
  local name, rest = text:match('^:([%a]+)%s*(.-)%s*$')
  local op = name and aliases[name:lower()]
  if not op then return nil, 'Unknown editor command · :help lists commands' end
  if op ~= 'edit' and op ~= 'neovim' and rest ~= '' then return nil, ':' .. name .. ' takes no arguments' end
  return { op=op, argument=rest }
end
function M.action(op, path, name)
  local api, fn = vim.api, vim.fn
  local buffer = fn.bufnr(path)
  if op == 'edit' then
    local windows = buffer >= 0 and fn.win_findbuf(buffer) or {}
    if #windows > 0 then api.nvim_set_current_win(windows[1]) else vim.cmd('vsplit ' .. fn.fnameescape(path)) end
    return { ok=true, message='Editing ' .. name }
  end
  if buffer < 0 or not api.nvim_buf_is_loaded(buffer) then return { ok=false, message='Open the spell with :e first' } end
  if fn.resolve(api.nvim_buf_get_name(buffer)) ~= fn.resolve(path) then return { ok=false, message='The editor buffer changed' } end
  if op == 'write' or op == 'writequit' then api.nvim_buf_call(buffer, function() vim.cmd.write() end) end
  if op == 'quit' or op == 'writequit' then
    if vim.bo[buffer].modified then return { ok=false, message='Unsaved spell changes · use :w first' } end
    api.nvim_buf_delete(buffer, { force=false })
  end
  return { ok=true, message=(op == 'quit' and 'Closed ' or 'Saved ') .. name }
end

-- Editor operations use an asynchronous local RPC client with a deadline, so
-- a busy or missing interactive editor cannot block gameplay's event loop.
---@param socket string|nil
---@param id string
---@param callback fun(result: {ok: boolean, message: string})
function M.remote(socket, id, callback)
  if type(socket) ~= 'string' or socket == '' then
    callback({ok=false, message='Set editor_socket to your Neovim listen socket'}); return
  end
  local expression = 'json_encode(luaeval(' .. vim.fn.string("require('xivspell').editor_action('edit', _A)") .. ', ' .. vim.fn.string(id) .. '))'
  vim.system({vim.v.progpath, '--server', socket, '--remote-expr', expression}, {text=true, timeout=3000}, vim.schedule_wrap(function(result)
    if result.code ~= 0 then
      callback({ok=false, message='Neovim editor unavailable · start it with --listen or check editor_socket'}); return
    end
    local ok, response = pcall(vim.json.decode, result.stdout)
    if not ok or type(response) ~= 'table' or type(response.ok) ~= 'boolean' or type(response.message) ~= 'string' then
      callback({ok=false, message='Neovim returned an invalid editor result'}); return
    end
    callback(response)
  end))
end
return M
