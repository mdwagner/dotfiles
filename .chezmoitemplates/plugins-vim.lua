vim.cmd([[
  packadd! vim-surround
  packadd! nerdcommenter
  packadd! vim-better-whitespace
  packadd! vim-airline
  packadd! vim-airline-themes
  packadd! vim-pasta
  packadd! vim-fugitive
  packadd! neoformat
  packadd! fzf
  packadd! fzf.vim
  packadd! fzf-mru.vim
  packadd! eslint
  packadd! vim-test
  packadd! zig.vim
  packadd! vim-crystal
  packadd! vim-tmux-navigator
  packadd! vim-mdx-js
  packadd! nvim-lspconfig
  packadd! cmp-nvim-lsp
  packadd! cmp-buffer
  packadd! cmp-path
  packadd! cmp-cmdline
  packadd! LuaSnip
  packadd! cmp_luasnip
  packadd! nvim-cmp
  packadd! nvim-web-devicons
  packadd! nvim-tree.lua
  packadd! indent-blankline.nvim
  packadd! project.nvim
  packadd! onedark.nvim
  packadd! nvim-dap
  packadd! nvim-dap-ui
  packadd! nvim-treesitter
  packadd! playground
  packadd! plenary.nvim
  packadd! neovim-session-manager
  packadd! scratch.vim
]])

require("wagz.better-whitespace")
require("wagz.airline")
require("wagz.git")
require("wagz.neoformat")
require("wagz.fzf")
require("wagz.vim-test")
require("wagz.zig")
require("wagz.tmux-navigator")
require("wagz.lsp")
require("wagz.nvim-tree")
require("wagz.indent-blankline")
require("wagz.project-nvim")
require("wagz.onedark")
require("wagz.dap")
require("wagz.treesitter")
require("wagz.session-manager")
