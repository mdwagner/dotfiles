local indent_blankline = require("ibl")

indent_blankline.setup({
  indent = {
    char = "¦",
  },
  exclude = {
    buftypes = { "terminal" },
  },
  scope = {
    show_start = false,
  },
  whitespace = {
    remove_blankline_trail = false
  },
})
