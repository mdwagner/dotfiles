local function diagnostic_setqflist()
  return vim.diagnostic.setqflist({ title = "All Diagnostics" })
end

local function move(pos)
  local is_floating_win = require("wagz.util").is_floating_win
  return function()
    if is_floating_win(vim.api.nvim_get_current_win()) then
      return "<leader>zz"
    end
    return "<C-w>" .. pos
  end
end

vim.keymap.set("n", "<leader>cc", "gcc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines starting at cursor",
})
vim.keymap.set("v", "<leader>cc", "gc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines",
})
vim.keymap.set("v", "<leader>c<space>", "gc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines",
})
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, {
  silent = true,
  desc = "Show diagnostics in a floating window",
})
vim.keymap.set("n", "<space>q", diagnostic_setqflist, {
  silent = true,
  desc = "Add buffer diagnostics to the quickfix list",
})
vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, {
  silent = true,
  desc = "Add buffer diagnostics to the location list",
})

vim.keymap.set("n", "<C-h>", move("h"), {
  desc = "Navigate to Left window",
  remap = true,
  silent = true,
  expr = true,
})
vim.keymap.set("n", "<C-j>", move("j"), {
  desc = "Navigate to Lower window",
  remap = true,
  silent = true,
  expr = true,
})
vim.keymap.set("n", "<C-k>", move("k"), {
  desc = "Navigate to Upper window",
  remap = true,
  silent = true,
  expr = true,
})
vim.keymap.set("n", "<C-l>", move("l"), {
  desc = "Navigate to Right window",
  remap = true,
  silent = true,
  expr = true,
})

-- LazyVim --

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", {
  desc = "Down",
  expr = true,
  silent = true,
})
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", {
  desc = "Down",
  expr = true,
  silent = true,
})
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", {
  desc = "Up",
  expr = true,
  silent = true,
})
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", {
  desc = "Up",
  expr = true,
  silent = true,
})

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", {
  desc = "Increase Window Height",
  silent = true,
})
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", {
  desc = "Decrease Window Height",
  silent = true,
})
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", {
  desc = "Decrease Window Width",
  silent = true,
})
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", {
  desc = "Increase Window Width",
  silent = true,
})

vim.keymap.set("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", {
  desc = "Redraw / Clear hlsearch / Diff Update",
  silent = true,
})

-- better indenting
vim.keymap.set("v", "<", "<gv", {
  silent = true,
})
vim.keymap.set("v", ">", ">gv", {
  silent = true,
})

vim.keymap.set("n", "[q", vim.cmd.cprev, {
  desc = "Previous Quickfix",
  silent = true,
})
vim.keymap.set("n", "]q", vim.cmd.cnext, {
  desc = "Next Quickfix",
  silent = true,
})

-- diagnostic
local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), {
  desc = "Next Diagnostic",
  silent = true,
})
vim.keymap.set("n", "[d", diagnostic_goto(false), {
  desc = "Prev Diagnostic",
  silent = true,
})
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), {
  desc = "Next Error",
  silent = true,
})
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), {
  desc = "Prev Error",
  silent = true,
})
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), {
  desc = "Next Warning",
  silent = true,
})
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), {
  desc = "Prev Warning",
  silent = true,
})
