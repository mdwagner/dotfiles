local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<F5>", ":lua require('dap').continue()<CR>", { silent = true })
vim.keymap.set("n", "<F6>", ":lua require('dap').step_over()<CR>", { silent = true })
vim.keymap.set("n", "<F7>", ":lua require('dap').step_into()<CR>", { silent = true })
vim.keymap.set("n", "<F8>", ":lua require('dap').step_out()<CR>", { silent = true })
vim.keymap.set("n", "<F1>", ":lua require('dap').toggle_breakpoint()<CR>", { silent = true })
vim.keymap.set(
  "n",
  "<F2>",
  ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { silent = true }
)
vim.keymap.set(
  "n",
  "<F3>",
  ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))",
  { silent = true }
)
vim.keymap.set("n", "<F4>", ":lua require('dap').run_last()<CR>", { silent = true })
vim.keymap.set("n", "<F10>", ":lua require('dap').terminate()<CR>", { silent = true })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local group = vim.api.nvim_create_augroup("WAGZ_DAP", {})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "WagzDap",
  callback = function()
    dapui.setup()
  end,
  once = true,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "dap-repl",
  callback = function(args)
    -- Hides dap-repl from appearing in buffers
    vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
  end,
})

vim.cmd [[doautocmd User WagzDap]]
