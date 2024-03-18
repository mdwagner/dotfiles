--  ___       __   ________  ________  ________
-- |\  \     |\  \|\   __  \|\   ____\|\_____  \
-- \ \  \    \ \  \ \  \|\  \ \  \___| \|___/  /|
--  \ \  \  __\ \  \ \   __  \ \  \  ___   /  / /
--   \ \  \|\__\_\  \ \  \ \  \ \  \|\  \ /  /_/__
--    \ \____________\ \__\ \__\ \_______\\________\
--     \|____________|\|__|\|__|\|_______|\|_______|

-- OPTIONS
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
vim.opt.mouse = nil
vim.opt.shortmess = "I"

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep"
	vim.opt.grepformat:prepend("%f:%l:%c:%m")
end

if vim.fn.executable("nvr") == 1 then
	vim.env.GIT_EDITOR = [[nvr -cc split --remote-wait]]
end

if vim.fn.has("win32") == 1 then
	if vim.fn.executable("pwsh") == 1 then
		vim.opt.shell = "pwsh"
	else
		vim.opt.shell = "powershell"
	end
	vim.opt.shellcmdflag =
	"-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
	vim.opt.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
	vim.opt.shellpipe = [[2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode]]
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

-- AUTOCOMMANDS
local group = vim.api.nvim_create_augroup("WAGZ", {})

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrollback = 100000
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			timeout = 1000,
		})
	end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = group,
	pattern = "*.bats",
	callback = function()
		vim.opt.filetype = "bash"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	callback = function()
		vim.opt.bufhidden = "delete"
	end,
})
vim.api.nvim_create_autocmd("WinNew", {
	group = group,
	pattern = "*",
	callback = function()
		vim.opt.foldenable = false
	end,
})

-- LAZY
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- HELPERS
local telescope_fzf_native_build_cmd = function()
	if vim.fn.has("win32") == 1 then
		return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
	else
		return "make"
	end
end

-- PLUGINS
require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true

			require("tokyonight").setup({
				styles = {
					keywords = { italic = false },
				},
				dim_inactive = true,
			})

			vim.cmd [[colorscheme tokyonight-night]]
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.opt.showmode = false

			local filetype_only = function()
				return vim.bo.filetype or ""
			end

			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						{ "filename", path = 3 },
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{ "filename", path = 3 },
					},
					lualine_x = { filetype_only },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				tabline = {
					lualine_a = { "tabs" },
					lualine_b = {
						{ "filename", path = 4 },
					},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = {
					"fugitive",
					"nvim-tree",
					"oil",
					"quickfix",
				},
			})
		end,
	},
	{
		"echasnovski/mini.starter",
		enabled = false,
		version = "*",
		config = function()
			local starter = require("mini.starter")
			starter.setup({
				evaluate_single = true,
				items = {
					starter.sections.recent_files(10, false),
				},
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.aligning("center", "center"),
				},
				header = function()
					local hour = tonumber(vim.fn.strftime("%H"))
					-- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
					local part_id = math.floor((hour + 4) / 8) + 1
					local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
					return ("good %s, %s"):format(day_part, "wagz")
				end,
			})
		end,
	},
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},
	{
		"preservim/nerdcommenter",
		event = "VeryLazy",
	},
	{
		"ntpeters/vim-better-whitespace",
		config = function()
			vim.g.better_whitespace_filetypes_blacklist = {
				"diff",
				"git",
				"gitcommit",
				"unite",
				"qf",
				"help",
				"markdown",
				"fugitive",
				"terminal",
			}

			vim.api.nvim_create_autocmd("TermOpen", {
				group = group,
				pattern = "*",
				command = "DisableWhitespace",
			})
		end,
	},
	{
		"sickill/vim-pasta",
		event = "VeryLazy",
	},
	{
		"tpope/vim-fugitive",
		config = function()
			vim.opt.statusline:append("%{fugitive#statusline()}")
		end,
	},
	{
		"earthly/earthly.vim",
		branch = "main",
		ft = { "Earthfile" },
	},
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		config = function()
			vim.g.tmux_navigator_no_mappings = 1

			vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
			vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
			vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
			vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
			vim.keymap.set("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", { silent = true })
		end,
	},
	{
		"sbdchd/neoformat",
		event = "VeryLazy",
		config = function()
			vim.g.neoformat_try_node_exe = 1
			vim.g.neoformat_only_msg_on_error = 1

			vim.keymap.set("n", "<leader>p", ":Neoformat<CR>", { silent = true })

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				pattern = {
					"*.lua",
				},
				command = "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry",
			})
		end,
	},
	{
		"eslint/eslint",
		event = "VeryLazy",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
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
					remove_blankline_trail = false,
				},
			})
		end,
	},
	{
		"ziglang/zig.vim",
		ft = { "zig", "zir" },
		config = function()
			vim.g.zig_fmt_autosave = 0
		end,
	},
	{
		"vim-crystal/vim-crystal",
		ft = { "crystal", "ecrystal" },
	},
	{
		"jxnblk/vim-mdx-js",
		ft = { "markdown" },
	},
	{
		"Shatur/neovim-session-manager",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local session_manager = require("session_manager")
			local session_manager_config = require("session_manager.config")

			session_manager.setup({
				--sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
				--path_replacer = '__', -- The character to which the path separator will be replaced for session files.
				--colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
				autoload_mode = session_manager_config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
				autosave_last_session = true,                                 -- Automatically save last session on exit and on session switch.
				--autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
				--autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
				autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
					"gitcommit",
					"gitrebase",
					"gitconfig",
				},
				--autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
				autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
				--max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
			})
		end,
	},
	{
		"ahmedkhalf/project.nvim",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true -- required
		end,
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local nvim_lsp = require("lspconfig")

			local set = vim.opt
			local let_g = vim.g
			local buf_set_option = vim.api.nvim_buf_set_option
			local buf_get_lines = vim.api.nvim_buf_get_lines
			local win_get_cursor = vim.api.nvim_win_get_cursor
			local get_runtime_file = vim.api.nvim_get_runtime_file

			local has_words_before = function()
				local line, col = unpack(win_get_cursor(0))
				return col ~= 0 and buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			set.completeopt = { "menu", "menuone", "noselect" }

			-- Mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { silent = true })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
			vim.keymap.set("n", "<space>q", function()
				return vim.diagnostic.setqflist({ title = "All Diagnostics" })
			end, { silent = true })
			vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, { silent = true })

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(_, buf)
				-- Enable completion triggered by <c-x><c-o>
				buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

				local buffer_silent = function(bufnr)
					return { silent = true, buffer = bufnr }
				end

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buffer_silent(buf))
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, buffer_silent(buf))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, buffer_silent(buf))
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buffer_silent(buf))
				vim.keymap.set("n", "<space>h", vim.lsp.buf.signature_help, buffer_silent(buf))
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, buffer_silent(buf))
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, buffer_silent(buf))
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, buffer_silent(buf))
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, buffer_silent(buf))
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, buffer_silent(buf))
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, buffer_silent(buf))
				vim.keymap.set("n", "gr", vim.lsp.buf.references, buffer_silent(buf))
				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, buffer_silent(buf))
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
						elseif has_words_before() then
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

			let_g.markdown_fenced_languages = {
				"ts=typescript"
			}

			-- Setup lspconfig
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Use a loop to conveniently call 'setup' on multiple servers and
			-- map buffer local keybindings when the language server attaches
			local lsp_servers = {
				servers = {
					"bashls",
					"crystalline",
					"cssls",
					"denols",
					"emmet_ls",
					"eslint",
					"jsonls",
					"lua_ls",
					"tsserver",
					"vimls",
					"zls",
				},
				overrides = {
					["emmet_ls"] = {
						filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
					},
					["eslint"] = {
						settings = {
							run = "onSave",
						},
					},
					["lua_ls"] = {
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
									checkThirdParty = false,
								},
								telemetry = {
									enable = false,
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "tab",
										tab_size = "2",
									},
								},
							},
						},
					},
					["denols"] = {
						autostart = false,
					},
					["tsserver"] = {
						filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
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
		end,
	},
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"stevearc/oil.nvim",
		},
		config = function()
			local nvim_tree = require("nvim-tree")

			--vim.g.loaded_netrw = 1
			--vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true

			vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })
			vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>", { silent = true })

			--
			-- This function has been generated from your
			--   view.mappings.list
			--   view.mappings.custom_only
			--   remove_keymaps
			--
			-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
			--
			-- Although care was taken to ensure correctness and completeness, your review is required.
			--
			-- Please check for the following issues in auto generated content:
			--   "Mappings removed" is as you expect
			--   "Mappings migrated" are correct
			--
			-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
			--

			local function on_attach(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end


				-- Default mappings. Feel free to modify or remove as you wish.
				--
				-- BEGIN_DEFAULT_ON_ATTACH
				vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
				vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
				vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
				vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
				vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
				vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
				vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
				vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
				vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
				vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
				vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
				vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
				vim.keymap.set("n", "a", api.fs.create, opts("Create"))
				vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
				vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
				vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
				vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
				vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
				vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
				vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
				vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
				vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
				vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
				vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
				vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
				vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
				vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
				vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
				vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
				vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
				vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
				vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
				vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
				vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
				vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
				vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
				vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
				vim.keymap.set("n", "q", api.tree.close, opts("Close"))
				vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
				vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
				vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
				vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
				vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
				vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
				vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
				vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
				vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
				vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
				-- END_DEFAULT_ON_ATTACH


				-- Mappings migrated from view.mappings.list
				--
				-- You will need to insert "your code goes here" for any mappings with a custom action_cb
				vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			end

			nvim_tree.setup({
				on_attach = on_attach,
				view = {
					signcolumn = "auto",
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
						enable = false,
					},
				},
				disable_netrw = false,
				hijack_netrw = true,
				hijack_directories = {
					enable = false,
				},
				filesystem_watchers = {
					enable = false,
				},
			})
		end,
	},
	{
		"mtth/scratch.vim",
		event = "VeryLazy",
		config = function()
			vim.g.scratch_persistence_file = "~/.scratch.vim"
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

			require("oil").setup({
				default_file_explorer = true,
				columns = {
					"icon",
					--"permissions", -- file permissions
					--"mtime",       -- modified_at (file contents)
					--"type",
				},
				view_options = {
					show_hidden = true,
					---@diagnostic disable-next-line:unused-local
					is_always_hidden = function(name, bufnr)
						local switch = {
							["."] = true,
							[".."] = true,
						}
						return switch[name] or false
					end,
				},
				use_default_keymaps = false,
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-x>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<Tab>"] = "actions.preview",
					["gq"] = "actions.close",
					["<leader>r"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["g."] = "actions.toggle_hidden",
					["yp"] = "actions.copy_entry_path",
				},
			})
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local obsidian = require("obsidian")

			local workspace_path = "~/Documents/vault"
			if vim.fn.has("mac") == 1 then
				workspace_path = "~/Documents/My Vault"
			end

			if vim.fn.has("win32") == 0 then
				obsidian.setup({
					workspaces = {
						{
							name = "personal",
							path = workspace_path,
						},
					},
					ui = {
						enable = false,
					},
				})
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			vim.keymap.set("n", "<F5>", function() dap.continue() end)
			vim.keymap.set("n", "<F10>", function() dap.step_over() end)
			vim.keymap.set("n", "<F11>", function() dap.step_into() end)
			vim.keymap.set("n", "<F12>", function() dap.step_out() end)
			vim.keymap.set("n", "<Leader>lb", function() dap.toggle_breakpoint() end)
			vim.keymap.set("n", "<Leader>lB", function() dap.set_breakpoint() end)
			vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
			vim.keymap.set("n", "<Leader>ll", function() dap.run_last() end)

			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "-q", "-i", "dap" }
			}

			dap.configurations.crystal = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						local path = vim.fn.input({
							prompt = "Path to executable: ",
							default = vim.fn.getcwd() .. "/",
							completion = "file"
						})
						return (path and path ~= "") and path or dap.ABORT
					end,
				}
			}

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dapui.setup({
				layouts = {
					{
						position = "left",
						size = 40,
						elements = {
							{
								id = "scopes",
								size = 0.5
							},
							{
								id = "watches",
								size = 0.25
							},
							{
								id = "breakpoints",
								size = 0.25
							},
						},
					},
					{
						position = "bottom",
						size = 10,
						elements = {
							{
								id = "repl",
								size = 1
							},
						},
					}
				},
			})
		end,
	},
	{
		"andrewferrier/debugprint.nvim",
		event = "VeryLazy",
		config = function()
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
		end,
	},
	{
		"vim-test/vim-test",
		event = "VeryLazy",
		config = function()
			vim.g["test#strategy"] = "neovim"

			vim.keymap.set("n", "t<C-n>", ":TestNearest<CR>", { remap = true, silent = true })
			vim.keymap.set("n", "t<C-f>", ":TestFile<CR>", { remap = true, silent = true })
			vim.keymap.set("n", "t<C-s>", ":TestSuite<CR>", { remap = true, silent = true })
			vim.keymap.set("n", "t<C-l>", ":TestLast<CR>", { remap = true, silent = true })
			vim.keymap.set("n", "t<C-g>", ":TestVisit<CR>", { remap = true, silent = true })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local from_entry = require("telescope.from_entry")
			local builtin = require("telescope.builtin")

			local M = {}

			M.noop = function(_) end

			M.if_nil = function(a, b)
				if a == nil then
					return b
				end
				return a
			end

			M.entry_to_item = function(entry)
				local text = entry.text

				if not text then
					if type(entry.value) == "table" then
						text = entry.value.text
					else
						text = entry.value
					end
				end

				return {
					bufnr = entry.bufnr,
					filename = from_entry.path(entry, false, false),
					lnum = M.if_nil(entry.lnum, 1),
					col = M.if_nil(entry.col, 1),
					text = text,
				}
			end

			M.buf_delete_selection = function(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)

				local items = {}
				for _, entry in ipairs(picker:get_multi_selection()) do
					table.insert(items, M.entry_to_item(entry))
				end

				actions.close(prompt_bufnr)

				for _, item in ipairs(items) do
					if item.bufnr ~= nil then
						vim.api.nvim_buf_delete(item.bufnr, { force = true })
					end
				end
			end

			M.command_t = function()
				vim.fn.system("git rev-parse --is-inside-work-tree")
				if vim.v.shell_error == 0 then
					builtin.git_files()
				else
					builtin.find_files()
				end
			end

			vim.keymap.set("n", "<leader>b", builtin.buffers, {})
			vim.keymap.set("n", "<leader>B", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>t", M.command_t, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

			telescope.setup {
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<Tab>"] = function(prompt_bufnr)
								actions.toggle_selection(prompt_bufnr)
								actions.move_selection_better(prompt_bufnr)
							end,
							["<S-Tab>"] = function(prompt_bufnr)
								actions.toggle_selection(prompt_bufnr)
								actions.move_selection_worse(prompt_bufnr)
							end,
							["<PageUp>"] = M.noop,
							["<PageDown>"] = M.noop,
							["<C-j>"] = M.noop,
						},
					},
					preview = true,
				},
				pickers = {
					buffers = {
						sort_mru = true,
						mappings = {
							i = {
								["<C-d>"] = function(prompt_bufnr)
									M.buf_delete_selection(prompt_bufnr)
								end,
							},
						},
					},
					git_files = {
						show_untracked = true,
					},
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					-- Your extension configuration goes here:
					-- extension_name = {
					--   extension_config_key = value,
					-- }
					-- please take a look at the readme of the extension you want to configure
				}
			}
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = telescope_fzf_native_build_cmd(),
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
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
					"vimdoc",
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
		end,
	},
	{
		"nvim-treesitter/playground",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = false, -- Disabled until Crystal supports TS
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesitter-context").setup({
				mode = "topline",
			})
		end,
	},
	{
		"wellle/context.vim",
		init = function()
			vim.g.context_enabled = 0
			vim.g.context_presenter = "nvim-float"
			vim.g.context_highlight_normal = "NormalFloat"
			vim.g.context_highlight_border = "FloatBorder"
			vim.g.context_highlight_tag = "<hide>"
			vim.g.context_filetype_blacklist = { "help", "tutor" }
		end,
	},
})
