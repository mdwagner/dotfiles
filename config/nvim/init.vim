lua << EOF
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'tpope/vim-surround'
  use 'scrooloose/nerdcommenter'
  use 'ntpeters/vim-better-whitespace'
  use 'christoomey/vim-tmux-navigator'
  use { 'mg979/vim-visual-multi', branch = 'master' }
  use 'machakann/vim-highlightedyank'
  use 'bling/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'sickill/vim-pasta'
  use 'mtth/scratch.vim'
  use 'tpope/vim-fugitive'
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  use 'airblade/vim-rooter'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    }
  }
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use { 'prettier/vim-prettier', run = 'npm install' }
  use { 'junegunn/fzf', run = './install --bin' }
  use 'junegunn/fzf.vim'
  use 'pbogut/fzf-mru.vim'
  use 'eslint/eslint'
  use 'jxnblk/vim-mdx-js'
  use 'vim-test/vim-test'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'joshdick/onedark.vim'
end)
EOF

set number
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set smarttab
set expandtab
set autoread
set laststatus=2
set nocompatible
set backspace=indent,eol,start
set ttimeoutlen=10
set timeout timeoutlen=2000
set splitbelow
set splitright
set nohlsearch
set hidden
set statusline+=%{fugitive#statusline()}
set completeopt=menu,menuone,noselect
set termguicolors
let mapleader=','
let g:loaded_python_provider = 0
let g:python3_host_prog = '~/.dotfiles/providers/py3nvim/bin/python'
let g:loaded_ruby_provider = 0
let g:node_host_prog = '~/.dotfiles/providers/nodenvim/node_modules/.bin/neovim-node-host'
let g:loaded_perl_provider = 0
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts=1
let g:rooter_cd_cmd = 'lcd'
let g:test#strategy = "neovim"
let g:indent_blankline_show_first_indent_level = v:false
syntax on
colorscheme onedark
filetype on
filetype indent on
filetype plugin on
autocmd BufEnter * setlocal hidden
autocmd TermOpen * startinsert
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * setlocal scrollback=10000
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
nnoremap <expr> <leader>t (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>B :FZFMru<CR>
nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>

lua << EOF
vim.g.fzf_layout = { down = '40%' }
vim.g.fzf_preview_window = {}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      select = false, -- If select is `true` and you haven't selected any item, automattically selects the first item.
      behavior = cmp.ConfirmBehavior.Replace, -- cmp.ConfirmBehavior.{Insert,Replace}
    }),
    ['<C-Space>'] = cmp.config.disable,
    ['<C-y>'] = cmp.config.disable,
    ['<C-d>'] = cmp.config.disable,
    ['<C-f>'] = cmp.config.disable,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})
-- Use buffer source `/`
cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } }
})
-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})
-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'vimls', 'tsserver', 'cssls', 'jsonls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end

local tree_cb = require('nvim-tree.config').nvim_tree_callback
require('nvim-tree').setup {
  view = {
    mappings = {
      list = {
        { key = "C", cb = tree_cb("cd") },
        { key = "?", cb = tree_cb("toggle_help") },
      }
    }
  }
}

require("indent_blankline").setup {
  char = "¦",
  buftype_exclude = {"terminal"},
}

-- neovim-remote
if vim.fn.has('nvim') == 1 then
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end
EOF


" ---- UNIQUE UNUSED ----
" Plugins
"call plug#begin('~/.vim/plugged')
"Plug 'vim-crystal/vim-crystal'
"Plug 'mattn/emmet-vim'
"Plug 'puremourning/vimspector'
"Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
"Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
"call plug#end()

"" Standard
"let g:user_emmet_mode='a'
"let g:user_emmet_install_global=0
"let g:chadtree_settings = {
"\   'theme': {
"\     'icon_glyph_set': 'ascii'
"\   }
"\ }
"let g:coq_settings = {
"\   'auto_start': 'shut-up',
"\   'display.icons.mode': 'none'
"\ }
"autocmd FileType html,css EmmetInstall
"nnoremap <leader>n <cmd>CHADopen<cr>

"lua << EOF
"local nvim_lsp = require('lspconfig')
"local coq = require('coq')
"local servers = { 'denols' }

"for _, lsp in ipairs(servers) do
  "nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
    "on_attach = on_attach,
    "flags = {
      "debounce_text_changes = 150,
    "}
  "}))
"end
"EOF
