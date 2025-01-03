vim.api.nvim_create_autocmd("TermOpen", {
  group = require("wagz.util").augroup,
  desc = "Set terminal defaults",
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrollback = 100000
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = require("wagz.util").augroup,
  desc = "Enable highlight on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      timeout = 1000,
    })
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = require("wagz.util").augroup,
  desc = "Set bats filetype to bash",
  pattern = "*.bats",
  callback = function()
    vim.opt.filetype = "bash"
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = require("wagz.util").augroup,
  desc = "Set rabl filetype to ruby",
  pattern = "*.rabl",
  callback = function()
    vim.opt.filetype = "ruby"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Set the help window to open at the top",
  pattern = "help",
  command = [[wincmd K]],
})
