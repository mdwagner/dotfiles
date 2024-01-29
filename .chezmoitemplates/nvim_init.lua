--  ___       __   ________  ________  ________
-- |\  \     |\  \|\   __  \|\   ____\|\_____  \
-- \ \  \    \ \  \ \  \|\  \ \  \___| \|___/  /|
--  \ \  \  __\ \  \ \   __  \ \  \  ___   /  / /
--   \ \  \|\__\_\  \ \  \ \  \ \  \|\  \ /  /_/__
--    \ \____________\ \__\ \__\ \_______\\________\
--     \|____________|\|__|\|__|\|_______|\|_______|

local set = vim.opt
local set_local = vim.opt_local
local let_g = vim.g
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

set.number = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.smartindent = true
set.expandtab = true
set.ttimeoutlen = 10
set.timeout = true
set.timeoutlen = 2000
set.splitbelow = true
set.splitright = true
set.hlsearch = false
set.foldenable = false
set.mouse = nil

let_g.mapleader = ","
let_g.loaded_python_provider = 0
let_g.loaded_python3_provider = 0
let_g.loaded_ruby_provider = 0
let_g.loaded_perl_provider = 0

if vim.fn.executable("rg") == 1 then
	set.grepprg = "rg --vimgrep"
	set.grepformat:prepend("%f:%l:%c:%m")
end

if vim.fn.executable("nvr") == 1 then
	vim.env.GIT_EDITOR = [[nvr -cc split --remote-wait]]
end

if vim.fn.has("win32") == 1 then
	if vim.fn.executable("pwsh") == 1 then
		set.shell = "pwsh"
	else
		set.shell = "powershell"
	end
	set.shellcmdflag =
	"-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
	set.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
	set.shellpipe = [[2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode]]
	set.shellquote = ""
	set.shellxquote = ""
end

-- https://neovim.io/doc/user/lua.html#vim.loader
vim.loader.enable()

autocmd("TermOpen", {
	group = augroup("WAGZ_NEW_TERMINAL", {}),
	pattern = "*",
	callback = function()
		set_local.number = false
		set_local.relativenumber = false
		set_local.scrollback = 100000
	end,
})
autocmd("TextYankPost", {
	group = augroup("WAGZ_HIGHLIGHT_YANK", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			timeout = 1000,
		})
	end,
})
autocmd("WinNew", {
	group = augroup("WAGZ_DISABLE_FOLDING", {}),
	pattern = "*",
	callback = function()
		set.foldenable = false
	end,
})
autocmd({ "BufNewFile", "BufRead" }, {
	group = augroup("WAGZ_BATS_BASH_EXT", {}),
	pattern = "*.bats",
	callback = function()
		set.filetype = "bash"
	end,
})
autocmd("FileType", {
	group = augroup("WAGZ_GIT_EDITING", {}),
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	callback = function()
		set.bufhidden = "delete"
	end,
})

local ok, result = pcall(require, "wagz.plugins")
if not ok then
	print("No plugins loaded...")
	if result then
		print(result)
	end
end
