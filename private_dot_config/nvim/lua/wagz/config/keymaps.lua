local function diagnostic_setqflist()
  return vim.diagnostic.setqflist({ title = "All Diagnostics" })
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
vim.keymap.set("n", "<C-h>", "<C-w>h", {
  desc = "Navigate to Left window",
  remap = true,
  silent = true,
})
vim.keymap.set("n", "<C-j>", "<C-w>j", {
  desc = "Navigate to Lower window",
  remap = true,
  silent = true,
})
vim.keymap.set("n", "<C-k>", "<C-w>k", {
  desc = "Navigate to Upper window",
  remap = true,
  silent = true,
})
vim.keymap.set("n", "<C-l>", "<C-w>l", {
  desc = "Navigate to Right window",
  remap = true,
  silent = true,
})
