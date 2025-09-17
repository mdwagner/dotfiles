return {
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == "." or name == ".."
        end,
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["gq"] = "actions.close",
        ["-"] = "actions.parent",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<Tab>"] = "actions.preview",
        ["<leader>r"] = "actions.refresh",
        ["yp"] = "actions.copy_entry_path",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.keymap.set("n", "-", ":Oil<CR>", {
        desc = "Open parent directory",
        silent = true,
      })
    end,
  },
}
