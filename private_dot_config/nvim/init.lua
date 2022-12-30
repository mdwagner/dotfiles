--  ___       __   ________  ________  ________
-- |\  \     |\  \|\   __  \|\   ____\|\_____  \
-- \ \  \    \ \  \ \  \|\  \ \  \___| \|___/  /|
--  \ \  \  __\ \  \ \   __  \ \  \  ___   /  / /
--   \ \  \|\__\_\  \ \  \ \  \ \  \|\  \ /  /_/__
--    \ \____________\ \__\ \__\ \_______\\________\
--     \|____________|\|__|\|__|\|_______|\|_______|

-- NOTE: Minimum config for NVIM
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
	print("No plugins found! Minimum config loaded...")
	return
else
	print("Some plugins found! Minimum config loaded...")
  return
end

-- Eager/One-time loaded plugins --

local load_once = function(pkgs)
	for pkg, fn in pairs(pkgs) do
		package.loaded[pkg] = nil
		fn(require(pkg))
	end
end

load_once({
	["project_nvim"] = function(pkg)
		pkg.setup()
	end,
	["dapui"] = function(pkg)
		pkg.setup()
	end,
})

-- Imports --

local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local nvim_lsp = require("lspconfig")
local nvim_tree = require("nvim-tree")
local indent_blankline = require("indent_blankline")
local onedark = require("onedark")
local dap = require("dap")
local dapui = require("dapui")
local nvim_treesitter_configs = require("nvim-treesitter.configs")
local session_manager = require("session_manager")
local session_manager_config = require("session_manager.config")
local null_ls = require("null-ls")
--local navigator = require("navigator")

-- VIM -> NVIM shortcuts --

local set = vim.opt
local let_g = vim.g
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf_set_option = vim.api.nvim_buf_set_option
local buf_get_lines = vim.api.nvim_buf_get_lines
local buf_delete = vim.api.nvim_buf_delete
local win_get_cursor = vim.api.nvim_win_get_cursor
local replace_termcodes = vim.api.nvim_replace_termcodes
local feedkeys = vim.api.nvim_feedkeys
local get_runtime_file = vim.api.nvim_get_runtime_file
local nvim_exec = vim.api.nvim_exec

-- Helper module --

local M = {}

M.opts = {
	silent = { silent = true },
	remap_silent = { remap = true, silent = true },
	nowait_expr = { nowait = true, expr = true },
	buffer_silent = function(buffer)
		return { silent = true, buffer = buffer }
	end,
}

-- Helper functions --

function M.has_words_before()
	local line, col = unpack(win_get_cursor(0))
	return col ~= 0 and buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.feedkey(key, mode)
	feedkeys(replace_termcodes(key, true, true, true), mode, true)
end

function M.get_file_name(path)
	return path:match("^.+/(.+)$")
end

function M.get_file_basename(path)
	local filename = M.get_file_name(path)
	return filename:match("(.+)%..+")
end

-- Global functions --

function _G.list_buffers()
	local buf_list_str = nvim_exec("ls", true)
	return vim.split(buf_list_str, "\n")
end

function _G.delete_buffers(lines)
	for _, line in ipairs(lines) do
		local value = vim.split(vim.trim(line), " ")[1]
		if value then
			local buf = tonumber(value)
			buf_delete(buf, {
				force = true,
			})
		end
	end
end

set.statusline:append("%{fugitive#statusline()}")
set.completeopt = { "menu", "menuone", "noselect" }
set.termguicolors = true
set.showmode = false
if vim.fn.executable("rg") == 1 then
	set.grepprg = "rg --vimgrep"
	set.grepformat:prepend("%f:%l:%c:%m")
end
let_g.airline_theme = "powerlineish"
let_g.airline_powerline_fonts = 1
let_g.rooter_cd_cmd = "lcd"
let_g["test#strategy"] = "neovim"
let_g.neoformat_try_node_exe = 1
let_g.neoformat_only_msg_on_error = 1
let_g.fzf_layout = { down = "40%" }
let_g.fzf_preview_window = {}
let_g.tmux_navigator_no_mappings = 1
let_g.do_filetype_lua = 1 -- enable filetype.lua
let_g.did_load_filetypes = 0 -- disable filetype.vim
let_g.zig_fmt_autosave = 0
let_g.markdown_fenced_languages = {
	"ts=typescript",
}

-- NOTE: not sure if this works (consistently)
if vim.fn.has("nvim") == 1 and vim.fn.executable("nvr") == 1 then
	vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
end

autocmd("FileType", {
	group = augroup("GIT_EDITING", {}),
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	callback = function()
		set.bufhidden = "delete"
	end,
})
autocmd("BufWritePre", {
	group = augroup("AUTOFORMAT", {}),
	pattern = {
		--"*.js",
		--"*.jsx",
		--"*.mjs",
		--"*.ts",
		--"*.tsx",
		--"*.css",
		--"*.json",
		--"*.md",
		--"*.yml",
		--"*.yaml",
		--"*.html",
    --"*.cr",
		--"*.zig",
    "*.lua",
	},
	command = "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry",
})

vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", M.opts.silent)
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", M.opts.silent)
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", M.opts.silent)
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", M.opts.silent)
vim.keymap.set("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", M.opts.silent)

vim.keymap.set("n", "t<C-n>", ":TestNearest<CR>", M.opts.rempa_silent)
vim.keymap.set("n", "t<C-f>", ":TestFile<CR>", M.opts.rempa_silent)
vim.keymap.set("n", "t<C-s>", ":TestSuite<CR>", M.opts.rempa_silent)
vim.keymap.set("n", "t<C-l>", ":TestLast<CR>", M.opts.rempa_silent)
vim.keymap.set("n", "t<C-g>", ":TestVisit<CR>", M.opts.rempa_silent)

vim.keymap.set("n", "<leader>b", ":Buffers<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>B", ":FZFMru<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>D", ":BD<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>p", ":Neoformat<CR>", M.opts.silent)
vim.keymap.set("n", "<leader>t", function()
	if #vim.fn.system("git rev-parse") == 0 then
		return ":GFiles --exclude-standard --others --cached<CR>"
	else
		return ":Files"
	end
end, M.opts.nowait_expr)
vim.keymap.set("n", "<F5>", ":lua require('dap').continue()<CR>", M.opts.silent)
vim.keymap.set("n", "<F6>", ":lua require('dap').step_over()<CR>", M.opts.silent)
vim.keymap.set("n", "<F7>", ":lua require('dap').step_into()<CR>", M.opts.silent)
vim.keymap.set("n", "<F8>", ":lua require('dap').step_out()<CR>", M.opts.silent)
vim.keymap.set("n", "<F1>", ":lua require('dap').toggle_breakpoint()<CR>", M.opts.silent)
vim.keymap.set(
	"n",
	"<F2>",
	":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	M.opts.silent
)
vim.keymap.set(
	"n",
	"<F3>",
	":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))",
	M.opts.silent
)
vim.keymap.set("n", "<F4>", ":lua require('dap').run_last()<CR>", M.opts.silent)
vim.keymap.set("n", "<F10>", ":lua require('dap').terminate()<CR>", M.opts.silent)

-- TODO: replace with Lua user command
vim.cmd([[
  command! BD call fzf#run(fzf#wrap({
  \ 'source': v:lua.list_buffers(),
  \ 'sinklist': { lines -> v:lua.delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
  \ }))
]])

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, M.opts.silent)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, M.opts.silent)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, M.opts.silent)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, M.opts.silent)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, buf)
	-- Enable completion triggered by <c-x><c-o>
	buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>h", vim.lsp.buf.signature_help, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, M.opts.buffer_silent(buf))
	vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, M.opts.buffer_silent(buf))
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	-- Use a sharp border with `FloatBorder` highlights
	border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	-- Use a sharp border with `FloatBorder` highlights
	border = "single",
})

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({
			select = false,
			behavior = cmp.ConfirmBehavior.Replace,
		}),
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif M.has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source `/`
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lsp_servers = {
	servers = {
		"vimls",
		"tsserver",
		"cssls",
		"jsonls",
		"eslint",
		"emmet_ls",
		"sumneko_lua",
		"crystalline",
		"denols",
    "zls",
	},
	overrides = {
		["emmet_ls"] = {
			filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
		},
		["sumneko_lua"] = {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		},
    ["eslint"] = {
      settings = {
        run = "onSave",
      },
    },
		["denols"] = {
			autostart = true,
		},
		["zls"] = {
			autostart = true,
		},
		["crystalline"] = {
			autostart = true,
		},
	},
}
for _, lsp in ipairs(lsp_servers.servers) do
	local overrides = lsp_servers.overrides[lsp] or {}

	nvim_lsp[lsp].setup(vim.tbl_extend("force", {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = capabilities,
	}, overrides))
end

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

indent_blankline.setup({
	char = "¦",
	buftype_exclude = { "terminal" },
	show_first_indent_level = false,
	show_trailing_blankline_indent = false,
})
onedark.setup({
	style = "cool",
	toggle_style_key = "<leader>od",
	colors = {
		dark_red = "#be5046",
		dark_yellow = "#d19a66",
	},
})
onedark.load()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
	dap.repl.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

nvim_treesitter_configs.setup({
	ensure_installed = {
		"bash",
		"css",
		"fish",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"lua",
		"markdown",
		"markdown_inline",
		"tsx",
		"typescript",
		"vim",
		"yaml",
		"c",
		"cmake",
		"comment",
		"dockerfile",
		"go",
		"gomod",
		"graphql",
		"help",
		"make",
		"nix",
		"python",
		"query",
		"ruby",
		"rust",
		"sql",
		"toml",
		"zig",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	playground = {
		enable = true,
		updatetime = 25,
		persist_queries = false,
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

session_manager.setup({
	autoload_mode = session_manager_config.AutoloadMode.CurrentDir,
	autosave_last_session = false,
	autosave_ignore_filetypes = {
		"gitcommit",
		"gitrebase",
		"gitconfig",
	},
	autosave_only_in_session = true,
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.npm_groovy_lint,
  },
})

-- TODO: need to disable lspconfig
--navigator.setup()
