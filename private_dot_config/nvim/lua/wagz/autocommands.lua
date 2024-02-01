vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("WAGZ_NEW_TERMINAL", {}),
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrollback = 100000
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("WAGZ_HIGHLIGHT_YANK", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      timeout = 1000,
    })
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("WAGZ_BATS_BASH_EXT", {}),
  pattern = "*.bats",
  callback = function()
    vim.opt.filetype = "bash"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("WAGZ_GIT_EDITING", {}),
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})
vim.api.nvim_create_autocmd("WinNew", {
  group = vim.api.nvim_create_augroup("WAGZ_DISABLE_FOLDING", {}),
  pattern = "*",
  callback = function()
    vim.opt.foldenable = false
  end,
})
