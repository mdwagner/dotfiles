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
vim.opt.ttimeoutlen = 10
vim.opt.timeout = true
vim.opt.timeoutlen = 2000
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = false
vim.opt.mouse = ""
vim.opt.shortmess = "I"
vim.opt.showmode = false
vim.opt.foldenable = false

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat:prepend("%f:%l:%c:%m")
end
