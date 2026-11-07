-- Runtime half of the generated api/xiv.lua definitions.
local M = {}
setmetatable(M, { __index = function(_, name)
  return function(args, callback)
    require('xivspell').transport('tool', { name = name, arguments = args or vim.empty_dict() }, callback or function(r, e)
      vim.notify(e or vim.inspect(r), e and vim.log.levels.ERROR or vim.log.levels.INFO)
    end)
  end
end })
return M
