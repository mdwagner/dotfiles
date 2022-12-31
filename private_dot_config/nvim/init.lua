--  ___       __   ________  ________  ________
-- |\  \     |\  \|\   __  \|\   ____\|\_____  \
-- \ \  \    \ \  \ \  \|\  \ \  \___| \|___/  /|
--  \ \  \  __\ \  \ \   __  \ \  \  ___   /  / /
--   \ \  \|\__\_\  \ \  \ \  \ \  \|\  \ /  /_/__
--    \ \____________\ \__\ \__\ \_______\\________\
--     \|____________|\|__|\|__|\|_______|\|_______|

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.ttimeoutlen = 10
vim.opt.timeout = true
vim.opt.timeoutlen = 2000
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = false
vim.opt.foldenable = false
vim.g.mapleader = ","
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("NEW_TERMINAL", {}),
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrollback = 10000
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HIGHLIGHT_YANK", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			timeout = 1000,
		})
	end,
})
vim.api.nvim_create_autocmd("WinNew", {
	group = vim.api.nvim_create_augroup("DISABLE_FOLDING", {}),
	pattern = "*",
  callback = function()
    vim.opt.foldenable = false
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("BATS_BASH_EXT", {}),
  pattern = "*.bats",
  callback = function()
    vim.opt.filetype = "bash"
  end,
})

if not pcall(require, "wagz.plugins") then
  print("Tiny config loaded!")
else
  print("Plugin config loaded!")
end
