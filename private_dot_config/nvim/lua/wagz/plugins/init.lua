return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true

      require("tokyonight").setup({
        styles = {
          keywords = { italic = false },
        },
        dim_inactive = true,
      })

      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.opt.showmode = false

      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },
  {
    "echasnovski/mini.starter",
    version = "*",
    config = function()
      local starter = require("mini.starter")
      starter.setup({
        evaluate_single = true,
        items = {
          starter.sections.recent_files(10, false),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning("center", "center"),
        },
        header = function()
          local hour = tonumber(vim.fn.strftime("%H"))
          -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
          local part_id = math.floor((hour + 4) / 8) + 1
          local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
          return ("good %s, %s"):format(day_part, "wagz")
        end,
      })
    end,
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  {
    "preservim/nerdcommenter",
    event = "VeryLazy",
  },
  {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.g.better_whitespace_filetypes_blacklist = {
        "diff",
        "git",
        "gitcommit",
        "unite",
        "qf",
        "help",
        "markdown",
        "fugitive",
        "terminal",
      }

      vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("NEW_TERMINAL_WHITESPACE", {}),
        pattern = "*",
        command = "DisableWhitespace",
      })
    end,
  },
  {
    "sickill/vim-pasta",
    event = "VeryLazy",
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.opt.statusline:append("%{fugitive#statusline()}")
    end,
  },
  {
    "earthly/earthly.vim",
    branch = "main",
    ft = { "Earthfile" },
  },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
      vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
      vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
      vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
      vim.keymap.set("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", { silent = true })
    end,
  },
  {
    "sbdchd/neoformat",
    event = "VeryLazy",
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_only_msg_on_error = 1

      vim.keymap.set("n", "<leader>p", ":Neoformat<CR>", { silent = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("AUTOFORMAT", {}),
        pattern = {
          "*.lua",
        },
        command = "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry",
      })
    end,
  },
  {
    "eslint/eslint",
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = {
          char = "¦",
        },
        exclude = {
          buftypes = { "terminal" },
        },
        scope = {
          show_start = false,
        },
        whitespace = {
          remove_blankline_trail = false,
        },
      })
    end,
  },
  {
    "ziglang/zig.vim",
    ft = { "zig", "zir" },
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
  },
  {
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
  },
  {
    "jxnblk/vim-mdx-js",
    ft = { "markdown" },
  },
  {
    "Shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local session_manager = require("session_manager")
      local session_manager_config = require("session_manager.config")

      session_manager.setup({
        --sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
        --path_replacer = '__', -- The character to which the path separator will be replaced for session files.
        --colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
        autoload_mode = session_manager_config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
        autosave_last_session = true,                                 -- Automatically save last session on exit and on session switch.
        --autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
        --autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
        autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
          "gitcommit",
          "gitrebase",
          "gitconfig",
        },
        --autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
        autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
        --max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
      })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("WAGZ_PROJECT_NVIM", {}),
        pattern = "WagzProjectNvim",
        callback = function()
          require("project_nvim").setup()
        end,
        once = true,
      })

      vim.cmd [[doautocmd User WagzProjectNvim]]
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },
}
