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
