vim.api.nvim_create_autocmd("TermOpen", {
  group = require("wagz.util").augroup,
  desc = "Set terminal defaults",
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrollback = 100000
    vim.opt_local.wrap = true
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
  desc = "Automatically move help windows to the top",
  pattern = "help",
  command = [[wincmd K]],
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = require("wagz.util").augroup,
  desc = "Ensure help windows stay at the top after closing and reopening",
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd [[wincmd K]]
    end
  end,
})

-- LazyVim --

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = require("wagz.util").augroup,
  desc = "Check if we need to reload the file when it changed",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd [[checktime]]
    end
  end,
})
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = require("wagz.util").augroup,
  desc = "Resize splits if window got resized",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd [[tabdo wincmd =]]
    vim.cmd("tabnext " .. current_tab)
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Make it easier to close man-files when opened inline",
  pattern = "man",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Wrap and check for spell in text filetypes",
  pattern = { "text", "plaintex", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Fix conceallevel for json files",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
