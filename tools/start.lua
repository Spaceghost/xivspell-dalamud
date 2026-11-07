local root = vim.env.XIVSPELL_ROOT or '/var/home/jack/xivterm/xivspell'
vim.opt.runtimepath:prepend(root)
vim.g.maplocalleader = ','
vim.o.termguicolors = true
vim.o.number = true
vim.o.mouse = 'a'
vim.o.completeopt = 'menu,menuone,noselect'
require('xivspell').setup({ container = vim.env.XIVSPELL_CONTAINER or 'ffxiv',
  lua_ls = vim.env.XIVSPELL_LUA_LS or vim.fn.expand('~/.local/share/xivspell/luals/bin/lua-language-server') })
vim.schedule(function() require('xivspell').book() end)
