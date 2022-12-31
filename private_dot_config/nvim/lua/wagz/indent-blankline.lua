local indent_blankline = require("indent_blankline")

indent_blankline.setup({
	char = "¦",
	buftype_exclude = { "terminal" },
	show_first_indent_level = false,
	show_trailing_blankline_indent = false,
})
