local set = vim.opt
local onedark = require("onedark")

set.termguicolors = true

onedark.setup({
  style = "cool",
  toggle_style_key = "<leader>od",
  colors = {
    dark_red = "#be5046",
    dark_yellow = "#d19a66",
  },
})

onedark.load()
