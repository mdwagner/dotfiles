vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("CONFIGURE_PROJECT_NVIM", {}),
  pattern = "ConfigureProjectNvim",
  callback = function()
    require("project_nvim").setup()
  end,
  once = true,
})

vim.cmd [[doautocmd User ConfigureProjectNvim]]
