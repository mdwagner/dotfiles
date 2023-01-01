local let_g = vim.g
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

let_g.better_whitespace_filetypes_blacklist = {
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

autocmd("TermOpen", {
  group = augroup("NEW_TERMINAL_WHITESPACE", {}),
  pattern = "*",
  command = "DisableWhitespace",
})
