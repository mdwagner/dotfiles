vim.opt.guicursor:append("t:blinkon0")

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-mini/mini.icons",
    {
      "folke/snacks.nvim",
      opts = {
        image = {
          -- your image configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      }
    },
  },
  event = "VeryLazy",
  config = function()
    local fzf = require("fzf-lua")
    local actions = require("fzf-lua.actions")

    -- helpers that mirror your Telescope functions ---------------------------
    local function command_t()
      -- git repo? use git_files else files
      vim.fn.system("git rev-parse --is-inside-work-tree")
      local in_git = (vim.v.shell_error == 0)
      if in_git then
        fzf.git_files({
          cmd = "git ls-files --cached --others --exclude-standard", -- show untracked
        })
      else
        fzf.files({ fd_opts = [[--type f --hidden --follow --exclude .git]] })
      end
    end

    local function dot_config()
      fzf.files({
        cwd = vim.fn.expand("~/.config"),
        fd_opts = [[--type f --hidden --follow --exclude .git]],
        prompt = "  ~/.config❯ ",
      })
    end

    local function help_tags()
      fzf.helptags({
        winopts = {
          preview = { layout = "vertical", vertical = "down:60%" },
        },
      })
    end

    local function buffers()
      fzf.buffers({
        sort_lastused = true,     -- Telescope's sort_mru = true
        winopts = { preview = { layout = "vertical", vertical = "down:60%" } },
        actions = {
          -- delete selected buffers (multi-select supported)
          ["ctrl-d"] = actions.buf_del,
        },
      })
    end

    local function current_buffer_fuzzy_find()
      -- Telescope's current_buffer_fuzzy_find ≈ fzf-lua.blines()
      -- “ivy-ish” feel via bottom prompt + small height
      fzf.blines({
        prompt = "Buffer❯ ",
        winopts = {
          height = 0.40,
          width = 1.00,
          row = 1.0,               -- bottom
          preview = { hidden = true },
        },
      })
    end
    ---------------------------------------------------------------------------

    fzf.setup({
      winopts = {
        height = 0.85,
        width  = 0.85,
        preview = {
          layout   = "vertical",
          vertical = "down:60%",
          wrap     = true,   -- like your TelescopePreviewerLoaded wrap
        },
        cursor = "block",
        cursorline = true,
      },
      -- history file like Telescope's fzy history
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
      },
      files = {
        prompt  = "Files❯ ",
        fd_opts = [[--type f --hidden --follow --exclude .git]],
      },
      git = {
        files = {
          -- show untracked like your telescope.git_files.show_untracked = true
          cmd = "git ls-files --cached --others --exclude-standard",
          prompt = "GitFiles❯ ",
        },
      },
      grep = {
        prompt = "Grep❯ ",
        rg_opts = [[--hidden --line-number --no-heading --color=always --smart-case -g !.git]],
        multiprocess = true,
      },
      buffers = {
        sort_lastused = true,
      },
      keymap = {
        builtin = {
          ["<esc>"] = "abort",        -- close on <Esc> in the fzf UI (insert/normal)
          ["<C-n>"] = "down",         -- cycle down list
          ["<C-p>"] = "up",           -- cycle up list
          ["<C-j>"] = "preview-page-down", -- scroll preview down half a page
          ["<C-k>"] = "preview-page-up",   -- scroll preview up half a page
        },
        fzf = {
          ["esc"] = "abort",
          ["ctrl-n"] = "down",
          ["ctrl-p"] = "up",
          ["ctrl-j"] = "preview-page-down",
          ["ctrl-k"] = "preview-page-up",
        },
      },
      -- NOTE: Telescope treesitter-preview disable doesn't have a 1:1 here.
      -- fzf-lua previews use bat/grep/ts; the global wrap above keeps long lines readable.
    })

    -- keymaps (preserve your UX) --------------------------------------------
    local map = vim.keymap.set
    map("n", "<leader>b", buffers,                       { desc = "FZF buffers", silent = true })
    map("n", "<space>fo", fzf.oldfiles,                  { desc = "FZF oldfiles", silent = true })
    map("n", "<space>fg", fzf.live_grep,                 { desc = "FZF live_grep", silent = true })
    map("n", "<space>ff", current_buffer_fuzzy_find,     { desc = "FZF current buffer fuzzy", silent = true })
    map("n", "<space>fc", fzf.commands,                  { desc = "FZF commands", silent = true })
    map("n", "<space>fh", help_tags,                     { desc = "FZF help_tags", silent = true })
    map("n", "<space>f.", dot_config,                    { desc = "FZF find ~/.config", silent = true })
    map("n", "<leader>t", command_t,                     { desc = "FZF git_files or files", silent = true })

    -- If you liked multi-select tab cycling in Telescope, here's an analogue:
    -- Within fzf UI: use <Tab>/<S-Tab> to tag/untag, then <enter> passes all selections.
    -- You can also customize per-picker actions if you want different multi behaviors.
    ---------------------------------------------------------------------------
  end,
}
