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

let_g.mapleader = ","
let_g.do_filetype_lua = 1
let_g.loaded_python_provider = 0
let_g.loaded_python3_provider = 0
let_g.loaded_ruby_provider = 0
let_g.loaded_perl_provider = 0
let_g.loaded_node_provider = 0

if vim.fn.executable("rg") == 1 then
  set.grepprg = "rg --vimgrep"
  set.grepformat:prepend("%f:%l:%c:%m")
end

if vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = [[nvr -cc split --remote-wait]]
end

autocmd("TermOpen", {
	group = augroup("NEW_TERMINAL", {}),
	pattern = "*",
	callback = function()
		set_local.number = false
		set_local.relativenumber = false
		set_local.scrollback = 10000
	end,
})
autocmd("TextYankPost", {
	group = augroup("HIGHLIGHT_YANK", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			timeout = 1000,
		})
	end,
})
autocmd("WinNew", {
	group = augroup("DISABLE_FOLDING", {}),
	pattern = "*",
  callback = function()
    set.foldenable = false
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("BATS_BASH_EXT", {}),
  pattern = "*.bats",
  callback = function()
    set.filetype = "bash"
  end,
})
autocmd("FileType", {
  group = augroup("GIT_EDITING", {}),
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    set.bufhidden = "delete"
  end,
})

pcall(require, "wagz.plugins")
