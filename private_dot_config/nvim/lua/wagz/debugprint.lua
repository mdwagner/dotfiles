local debugprint = require("debugprint");

debugprint.setup({
	create_keymaps = false,
	filetypes = {
		["crystal"] = {
			left = 'STDERR.puts "',
			right = '"',
			mid_var = "#{",
			right_var = '}"',
		},
	},
})

vim.keymap.set("n", "<leader>d", function()
	return debugprint.debugprint()
end, { expr = true })
vim.keymap.set("n", "<leader>D", function()
	return debugprint.debugprint({ above = true })
end, { expr = true })
