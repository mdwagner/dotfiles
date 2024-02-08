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

return group
