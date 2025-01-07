vim.keymap.set("n", "<space>ss", "<cmd>ObsidianToday<cr>", {
  desc = "Open today's daily note",
  silent = true,
})

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
}
