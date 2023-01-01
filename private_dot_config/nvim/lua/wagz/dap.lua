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
  dapui.open({})
  dap.repl.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("CONFIGURE_DAP", {}),
  pattern = "ConfigureDap",
  callback = function()
    dapui.setup()
  end,
  once = true,
})

vim.cmd [[doautocmd User ConfigureDap]]
