-- Editor integration only. The in-game command bar has its own background runtime.
if vim.g.loaded_xivspell then return end
require('xivspell').setup({ runtime = false,
  lua_ls = vim.fn.expand('~/.local/share/xivspell/luals/bin/lua-language-server') })
