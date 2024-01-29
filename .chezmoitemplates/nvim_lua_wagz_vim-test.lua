local let_g = vim.g

let_g["test#strategy"] = "neovim"

vim.keymap.set("n", "t<C-n>", ":TestNearest<CR>", { remap = true, silent = true })
vim.keymap.set("n", "t<C-f>", ":TestFile<CR>", { remap = true, silent = true })
vim.keymap.set("n", "t<C-s>", ":TestSuite<CR>", { remap = true, silent = true })
vim.keymap.set("n", "t<C-l>", ":TestLast<CR>", { remap = true, silent = true })
vim.keymap.set("n", "t<C-g>", ":TestVisit<CR>", { remap = true, silent = true })
