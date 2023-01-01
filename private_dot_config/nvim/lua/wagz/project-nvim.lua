vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("WAGZ_PROJECT_NVIM", {}),
  pattern = "WagzProjectNvim",
  callback = function()
    require("project_nvim").setup()
  end,
  once = true,
})

vim.cmd [[doautocmd User WagzProjectNvim]]
