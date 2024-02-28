return {
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/oil.nvim",
    },
    config = function()
      local nvim_tree = require("nvim-tree")

      --vim.g.loaded_netrw = 1
      --vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })
      vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>", { silent = true })

      --
      -- This function has been generated from your
      --   view.mappings.list
      --   view.mappings.custom_only
      --   remove_keymaps
      --
      -- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
      --
      -- Although care was taken to ensure correctness and completeness, your review is required.
      --
      -- Please check for the following issues in auto generated content:
      --   "Mappings removed" is as you expect
      --   "Mappings migrated" are correct
      --
      -- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
      --

      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end


        -- Default mappings. Feel free to modify or remove as you wish.
        --
        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
        vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
        -- END_DEFAULT_ON_ATTACH


        -- Mappings migrated from view.mappings.list
        --
        -- You will need to insert "your code goes here" for any mappings with a custom action_cb
        vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end

      nvim_tree.setup({
        on_attach = on_attach,
        view = {
          signcolumn = "auto",
        },
        actions = {
          open_file = {
            window_picker = {
              exclude = {
                buftype = { "nofile", "help" },
              },
            },
          },
          change_dir = {
            enable = false,
          },
        },
        disable_netrw = false,
        hijack_netrw = true,
        hijack_directories = {
          enable = false,
        },
        filesystem_watchers = {
          enable = false,
        },
      })
    end,
  },
  {
    "mtth/scratch.vim",
    event = "VeryLazy",
    config = function()
      vim.g.scratch_persistence_file = "~/.scratch.vim"
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          --"permissions", -- file permissions
          --"mtime",       -- modified_at (file contents)
          --"type",
        },
        view_options = {
          show_hidden = true,
          ---@diagnostic disable-next-line:unused-local
          is_always_hidden = function(name, bufnr)
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
      })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local obsidian = require("obsidian")

      local workspace_path = "~/Documents/vault"
      if vim.fn.has("mac") == 1 then
        workspace_path = "~/Documents/My Vault"
      end

      if vim.fn.has("win32") == 0 then
        obsidian.setup({
          workspaces = {
            {
              name = "personal",
              path = workspace_path,
            },
          },
          ui = {
            enable = false,
          },
        })
      end
    end,
  },
}
