local M = {
  augroup = vim.api.nvim_create_augroup("WAGZ", {}),
}

function M.is_floating_win(winnr)
  return vim.api.nvim_win_get_config(winnr).zindex ~= nil
end

return M
