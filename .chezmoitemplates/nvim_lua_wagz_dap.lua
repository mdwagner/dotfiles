local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<Leader>lb", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<Leader>lB", function() dap.set_breakpoint() end)
vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
vim.keymap.set("n", "<Leader>ll", function() dap.run_last() end)

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-q", "-i", "dap" }
}

dap.configurations.crystal = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      local path = vim.fn.input({
        prompt = "Path to executable: ",
        default = vim.fn.getcwd() .. "/",
        completion = "file"
      })
      return (path and path ~= "") and path or dap.ABORT
    end,
  }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup({
  layouts = {
    {
      position = "left",
      size = 40,
      elements = {
        {
          id = "scopes",
          size = 0.5
        },
        {
          id = "watches",
          size = 0.25
        },
        {
          id = "breakpoints",
          size = 0.25
        },
      },
    },
    {
      position = "bottom",
      size = 10,
      elements = {
        {
          id = "repl",
          size = 1
        },
      },
    }
  },
})
