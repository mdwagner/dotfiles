vim.g.mapleader = ","
vim.g.maplocalleader = vim.g.mapleader

vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.timeoutlen = 2000
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = false
vim.opt.mouse = ""
vim.opt.shortmess = "I"
vim.opt.showmode = false
vim.opt.foldenable = false

-- LazyVim --

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
vim.opt.conceallevel = 2                                    -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.cursorline = true                                   -- Enable highlighting of the current line
vim.opt.foldlevel = 99
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.ignorecase = true      -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.jumpoptions = "view"
vim.opt.linebreak = true       -- Wrap lines at convenient points
vim.opt.list = true            -- Show some invisible characters (tabs...
vim.opt.listchars = "tab:>-,nbsp:+,precedes:<,extends:>"
vim.opt.scrolloff = 2          -- Lines of context
vim.opt.shiftround = true      -- Round indent
vim.opt.sidescrolloff = 4      -- Columns of context
vim.opt.smartcase = true       -- Don't ignore case with capitals
vim.opt.splitkeep = "screen"
vim.opt.termguicolors = true   -- True color support
vim.opt.timeoutlen = 300
vim.opt.virtualedit = "block"  -- Allow cursor to move where there is no text in visual block mode
vim.opt.winminwidth = 5        -- Minimum window width
vim.opt.wrap = false           -- Disable line wrap
