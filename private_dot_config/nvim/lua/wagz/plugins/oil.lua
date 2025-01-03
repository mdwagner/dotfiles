return {
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        --"permissions", -- file permissions
        --"mtime",       -- modified_at (file contents)
        --"type",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local switch = {
            ["."] = true,
            [".."] = true,
          }
          return switch[name] or false
        end,
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<Tab>"] = "actions.preview",
        ["gq"] = "actions.close",
        ["<leader>r"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["g."] = "actions.toggle_hidden",
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
