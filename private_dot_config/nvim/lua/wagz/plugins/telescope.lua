local function buffers()
  require("telescope.builtin").buffers()
end

local function oldfiles()
  require("telescope.builtin").oldfiles()
end

local function live_grep()
  require("telescope.builtin").live_grep()
end

local function current_buffer_fuzzy_find()
  require("telescope.builtin").current_buffer_fuzzy_find()
end

local function command_t()
  local builtin = require("telescope.builtin")
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

local function help_tags()
  require("telescope.builtin").help_tags()
end

local function dot_config()
  require("telescope.builtin").find_files({
    cwd = "~/.config",
  })
end

local function commands()
  require("telescope.builtin").commands()
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

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    keys = {
      { "<leader>b",  buffers,                   silent = true, desc = "Telescope buffers" },
      { "<leader>B",  oldfiles,                  silent = true, desc = "Telescope oldfiles" },
      { "<leader>fg", live_grep,                 silent = true, desc = "Telescope live_grep" },
      { "<leader>fs", current_buffer_fuzzy_find, silent = true, desc = "Telescope current_buffer_fuzzy_find" },
      { "<leader>fh", help_tags,                 silent = true, desc = "Telescope help_tags" },
      { "<leader>fc", dot_config,                silent = true, desc = "Telescope find_files in ~/.config" },
      { "<leader>fm", commands,                  silent = true, desc = "Telescope commands" },
      { "<leader>t",  command_t,                 silent = true, desc = "Telescope find_files or git_files (if inside .git directory)" },
    },
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
