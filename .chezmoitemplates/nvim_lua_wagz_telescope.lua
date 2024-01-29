local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local from_entry = require("telescope.from_entry")
local builtin = require("telescope.builtin")

local M = {}

M.noop = function(_) end

M.if_nil = function(a, b)
  if a == nil then
    return b
  end
  return a
end

M.entry_to_item = function(entry)
  local text = entry.text

  if not text then
    if type(entry.value) == "table" then
      text = entry.value.text
    else
      text = entry.value
    end
  end

  return {
    bufnr = entry.bufnr,
    filename = from_entry.path(entry, false, false),
    lnum = M.if_nil(entry.lnum, 1),
    col = M.if_nil(entry.col, 1),
    text = text,
  }
end

M.buf_delete_selection = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)

  local items = {}
  for _, entry in ipairs(picker:get_multi_selection()) do
    table.insert(items, M.entry_to_item(entry))
  end

  actions.close(prompt_bufnr)

  for _, item in ipairs(items) do
    if item.bufnr ~= nil then
      vim.api.nvim_buf_delete(item.bufnr, { force = true })
    end
  end
end

M.command_t = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>B", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>t", M.command_t, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_better(prompt_bufnr)
        end,
        ["<S-Tab>"] = function(prompt_bufnr)
          actions.toggle_selection(prompt_bufnr)
          actions.move_selection_worse(prompt_bufnr)
        end,
        ["<PageUp>"] = M.noop,
        ["<PageDown>"] = M.noop,
        ["<C-j>"] = M.noop,
      },
    },
    preview = false,
  },
  pickers = {
    buffers = {
      sort_mru = true,
      mappings = {
        i = {
          ["<C-d>"] = function(prompt_bufnr)
            M.buf_delete_selection(prompt_bufnr)
          end,
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
}
