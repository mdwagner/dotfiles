local set = vim.opt

set.termguicolors = true

require("tokyonight").setup({
  styles = {
    keywords = { italic = false },
  },
  dim_inactive = true,
})

vim.cmd [[colorscheme tokyonight-night]]
