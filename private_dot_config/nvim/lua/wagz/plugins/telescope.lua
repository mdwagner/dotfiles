local function command_t()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return string.format("<cmd>Telescope %s<cr>", vim.v.shell_error == 0 and "git_files" or "find_files")
end

local function dot_config()
  require("telescope.builtin").find_files({
    cwd = "~/.config",
  })
end

local function help_tags()
  require("telescope.builtin").help_tags({
    layout_strategy = "vertical",
  })
end

local function buffers()
  require("telescope.builtin").buffers({
    layout_strategy = "vertical",
  })
end

local function current_buffer_fuzzy_find()
  local themes = require("telescope.themes")
  require("telescope.builtin").current_buffer_fuzzy_find(themes.get_ivy())
end

local function buf_delete(prompt_bufnr)
  local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  for _, entry in ipairs(current_picker:get_multi_selection()) do
    local bufnr = entry.bufnr
    if bufnr ~= nil then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
  require("telescope.actions").close(prompt_bufnr)
end

vim.api.nvim_create_autocmd("User", {
  group = require("wagz.util").augroup,
  desc = "Wrap Telescope previewer",
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.keymap.set("n", "<leader>b", buffers, {
  desc = "Telescope buffers",
  silent = true,
})
vim.keymap.set("n", "<space>fo", "<cmd>Telescope oldfiles<cr>", {
  desc = "Telescope oldfiles",
  silent = true,
})
vim.keymap.set("n", "<space>fg", "<cmd>Telescope live_grep<cr>", {
  desc = "Telescope live_grep",
  silent = true,
})
vim.keymap.set("n", "<space>ff", current_buffer_fuzzy_find, {
  desc = "Telescope current_buffer_fuzzy_find",
  silent = true,
})
vim.keymap.set("n", "<space>fc", "<cmd>Telescope commands<cr>", {
  desc = "Telescope commands",
  silent = true,
})
vim.keymap.set("n", "<space>fh", help_tags, {
  desc = "Telescope help_tags",
  silent = true,
})
vim.keymap.set("n", "<space>f.", dot_config, {
  desc = "Telescope find_files in ~/.config",
  silent = true,
})
vim.keymap.set("n", "<leader>t", command_t, {
  desc = "Telescope find_files or git_files (if inside .git directory)",
  silent = true,
  expr = true,
})

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<Tab>"] = function(prompt_bufnr)
                actions.toggle_selection(prompt_bufnr)
                actions.move_selection_better(prompt_bufnr)
              end,
              ["<S-Tab>"] = function(prompt_bufnr)
                actions.toggle_selection(prompt_bufnr)
                actions.move_selection_worse(prompt_bufnr)
              end,
              ["<PageUp>"] = function() end,
              ["<PageDown>"] = function() end,
              ["<C-j>"] = function() end,
            },
          },
          preview = {
            treesitter = {
              disable = { "javascript" },
            },
          },
        },
        pickers = {
          buffers = {
            sort_mru = true,
            mappings = {
              i = {
                ["<C-d>"] = buf_delete,
              },
            },
          },
          git_files = {
            show_untracked = true,
          },
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
        }
      })
      telescope.load_extension("fzy_native")
    end,
  },
}
