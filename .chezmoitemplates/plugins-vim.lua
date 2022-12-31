local plugins = {
  "vim-surround",
  "nerdcommenter",
  "vim-better-whitespace",
  "vim-airline",
  "vim-airline-themes",
  "vim-pasta",
  "vim-fugitive",
  --"neoformat",
  --"fzf",
  --"fzf.vim",
  --"fzf-mru.vim",
  --"vim-test",
  "vim-tmux-navigator",
  "onedark.nvim",
}

for _, plugin in ipairs(plugins) do
  local cmd = "packadd! " .. plugin
  vim.cmd cmd
end

return true
