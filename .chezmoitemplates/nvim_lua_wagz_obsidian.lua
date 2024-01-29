local obsidian = require("obsidian")

local workspace_path = "~/Documents/vault"
if vim.fn.has("mac") == 1 then
	workspace_path = "~/Documents/My Vault"
end

obsidian.setup({
  workspaces = {
    {
      name = "personal",
      path = workspace_path,
    },
  },
})
