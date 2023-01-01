local let_g = vim.g
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

let_g.neoformat_try_node_exe = 1
let_g.neoformat_only_msg_on_error = 1

vim.keymap.set("n", "<leader>p", ":Neoformat<CR>", { silent = true })

autocmd("BufWritePre", {
	group = augroup("AUTOFORMAT", {}),
	pattern = {
    "*.lua",
	},
	command = "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry",
})
