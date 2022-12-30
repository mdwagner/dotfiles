-- NOTE: Plugins are self managed with Vim
--[[
local plugins = {
  "cmp-buffer",
  "cmp-cmdline",
  "cmp-nvim-lsp",
  "cmp-path",
  "cmp_luasnip",
  "eslint",
  "fzf",
  "fzf-mru.vim",
  "fzf.vim",
  "guihua.lua",
  "indent-blankline.nvim",
  "LuaSnip",
  "navigator.lua",
  "neoformat",
  "neovim-session-manager",
  "nerdcommenter",
  "null-ls.nvim",
  "nvim-cmp",
  "nvim-dap",
  "nvim-dap-ui",
  "nvim-lspconfig",
  "nvim-tree.lua",
  "nvim-treesitter",
  "nvim-web-devicons",
  "onedark.nvim",
  "playground",
  "plenary.nvim",
  "project.nvim",
  "vim-airline",
  "vim-airline-themes",
  "vim-better-whitespace",
  "vim-fugitive",
  "vim-mdx-js",
  "vim-pasta",
  "vim-surround",
  "vim-test",
  "vim-tmux-navigator",
}

for _, plugin in ipairs(plugins) do
  vim.cmd("packadd! " .. plugin)
end

return true
--]]

vim.cmd([[
  packadd! vim-surround
  packadd! nerdcommenter
  packadd! vim-better-whitespace
  packadd! vim-airline
  packadd! vim-airline-themes
  packadd! vim-pasta
  packadd! vim-fugitive
  "packadd! neoformat
  "packadd! fzf
  "packadd! fzf.vim
  "packadd! fzf-mru.vim
  "packadd! vim-test
  packadd! vim-tmux-navigator
  packadd! onedark.nvim
]])
