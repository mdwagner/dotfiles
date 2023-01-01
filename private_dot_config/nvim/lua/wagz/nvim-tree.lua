local nvim_tree = require("nvim-tree")

vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>", { silent = true })

nvim_tree.setup({
	view = {
		mappings = {
			list = {
				{ key = "C", action = "cd" },
				{ key = "?", action = "toggle_help" },
			},
		},
	},
	actions = {
		open_file = {
			window_picker = {
				exclude = {
					buftype = { "nofile", "help" },
				},
			},
		},
		change_dir = {
			global = true,
		},
	},
})
