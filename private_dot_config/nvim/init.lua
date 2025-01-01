--  ___       __   ________  ________  ________
-- |\  \     |\  \|\   __  \|\   ____\|\_____  \
-- \ \  \    \ \  \ \  \|\  \ \  \___| \|___/  /|
--  \ \  \  __\ \  \ \   __  \ \  \  ___   /  / /
--   \ \  \|\__\_\  \ \  \ \  \ \  \|\  \ /  /_/__
--    \ \____________\ \__\ \__\ \_______\\________\
--     \|____________|\|__|\|__|\|_______|\|_______|

-- OPTIONS
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.ttimeoutlen = 10
vim.opt.timeout = true
vim.opt.timeoutlen = 2000
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = false
vim.opt.mouse = ""
vim.opt.shortmess = "I"
vim.opt.showmode = false
vim.opt.foldenable = false

vim.g.mapleader = ","
vim.g.maplocalleader = vim.g.mapleader
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat:prepend("%f:%l:%c:%m")
end

if vim.fn.has("win32") == 1 then
  if vim.fn.executable("pwsh") == 1 then
    vim.opt.shell = "pwsh"
  else
    vim.opt.shell = "powershell"
  end
  vim.opt.shellcmdflag =
  "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
  vim.opt.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
  vim.opt.shellpipe = [[2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode]]
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

local M = {
  _current_jobs = {},
}

function M.filetype_only()
  return vim.bo.filetype or ""
end

function M.is_floating_win(winnr)
  if vim.api.nvim_win_get_config(winnr).zindex then
    return true
  end
  return false
end

function M.tabs_fmt(_, context)
  local name = string.format("%i", context.tabnr)
  if vim.api.nvim_tabpage_is_valid(context.tabnr) then
    local tab_winnrs = vim.tbl_filter(
      function(winnr)
        if M.is_floating_win(winnr) then
          return false
        end
        return true
      end,
      vim.api.nvim_tabpage_list_wins(context.tabnr)
    )
    local count = #tab_winnrs
    if count > 1 then
      return string.format("%s (%i)", name, count)
    end
  end
  return name
end

function M.tabs_filename_cond()
  local bufnr = vim.api.nvim_get_current_buf()
  local has_no_name = vim.fn.bufname(bufnr) == ""
  local has_no_file = vim.fn.expand('%:p') == ""
  if has_no_name or has_no_file then
    return false
  end
  return true
end

function M.diagnostic_setqflist()
  return vim.diagnostic.setqflist({ title = "All Diagnostics" })
end

function M.local_rails_handler(name, command)
  return function()
    if M._current_jobs[name] then
      return
    end
    vim.cmd [[tabnew]]
    local channel_id = vim.fn.termopen(command, {
      on_exit = function(_, code)
        if code ~= 0 then
          print(name .. " exited with code " .. code)
        end
        M._current_jobs[name] = nil
      end
    })
    if channel_id > 0 then
      M._current_jobs[name] = channel_id
    end
    vim.cmd("file " .. name)
    vim.cmd [[clo]]
  end
end

function M.telescope_buffers()
  require("telescope.builtin").buffers()
end

function M.telescope_oldfiles()
  require("telescope.builtin").oldfiles()
end

function M.telescope_live_grep()
  require("telescope.builtin").live_grep()
end

function M.telescope_current_buffer_fuzzy_find()
  require("telescope.builtin").current_buffer_fuzzy_find()
end

function M.telescope_command_t()
  local builtin = require("telescope.builtin")
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

function M.telescope_help_tags()
  require("telescope.builtin").help_tags()
end

function M.telescope_dot_config()
  require("telescope.builtin").find_files({
    cwd = "~/.config",
  })
end

function M.telescope_commands()
  require("telescope.builtin").commands()
end

function M.telescope_noop(_)
end

function M.telescope_buf_delete(prompt_bufnr)
  local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  for _, entry in ipairs(current_picker:get_multi_selection()) do
    local bufnr = entry.bufnr
    if bufnr ~= nil then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
  require("telescope.actions").close(prompt_bufnr)
end

function M.mini_zoom()
  require("mini.misc").zoom()
end

-- KEYMAPS
vim.keymap.set("n", "<leader>cc", "gcc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines starting at cursor"
})
vim.keymap.set("v", "<leader>cc", "gc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines"
})
vim.keymap.set("v", "<leader>c<space>", "gc", {
  silent = true,
  remap = true,
  desc = "Comment or uncomment lines"
})
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, {
  silent = true,
  desc = "Show diagnostics in a floating window"
})
vim.keymap.set("n", "<space>q", M.diagnostic_setqflist, {
  silent = true,
  desc = "Add buffer diagnostics to the quickfix list"
})
vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, {
  silent = true,
  desc = "Add buffer diagnostics to the location list"
})

-- AUTOCOMMANDS
local group = vim.api.nvim_create_augroup("WAGZ", {})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrollback = 100000
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      timeout = 1000,
    })
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group,
  pattern = "*.bats",
  callback = function()
    vim.opt.filetype = "bash"
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group,
  pattern = "*.rabl",
  callback = function()
    vim.opt.filetype = "ruby"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Set the help window to open at the top",
  pattern = "help",
  command = [[wincmd K]],
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.wrap = true
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "LSP actions",
  callback = function(event)
    -- default: 'omnifunc' is set to `vim.lsp.omnifunc()`
    --   i_CTRL-X_CTRL-O
    -- default: 'tagfunc' is set to `vim.lsp.tagfunc()`
    --   go-to-definition, :tjump, CTRL-], CTRL-W_], CTRL-W_}
    -- default: `K` is mapped to `vim.lsp.buf.hover()`
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      silent = true,
      buffer = event.buf,
      desc = "Jumps to the definition of the symbol under the cursor",
    })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
      silent = true,
      buffer = event.buf,
      desc = "Jumps to the declaration of the symbol under the cursor",
    })
    -- TODO: remove
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, {
      silent = true,
      buffer = event.buf,
      desc = "Lists all the implementations for the symbol under the cursor in the quickfix window",
    })
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {
      silent = true,
      buffer = event.buf,
      desc = "Jumps to the definition of the type of the symbol under the cursor",
    })
    -- TODO: remove
    vim.keymap.set("n", "grr", vim.lsp.buf.references, {
      silent = true,
      buffer = event.buf,
      desc = "Lists all the references to the symbol under the cursor in the quickfix window",
    })
    -- TODO: remove
    vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, {
      silent = true,
      buffer = event.buf,
      desc = "Displays signature information about the symbol under the cursor in a floating window",
    })
    -- TODO: remove
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, {
      silent = true,
      buffer = event.buf,
      desc = "Renames all references to the symbol under the cursor",
    })
    -- default: `gq` is mapped to `vim.lsp.formatexpr()`
    vim.keymap.set("n", "<space>f", vim.lsp.buf.format, {
      silent = true,
      buffer = event.buf,
      desc = "Formats a buffer using the attached (and optionally filtered) language server clients",
    })
    -- TODO: remove
    vim.keymap.set("n", "gra", vim.lsp.buf.code_action, {
      silent = true,
      buffer = event.buf,
      desc = "Selects a code action available at the current cursor position",
    })
    -- TODO: remove
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, {
      silent = true,
      buffer = event.buf,
      desc = "Lists all symbols in the current buffer in the quickfix window",
    })
  end
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})

vim.api.nvim_create_user_command("LocalRailsServer",
  M.local_rails_handler("term-server", "bundle exec rails s -b 0.0.0.0 -p 3000"), {
    desc = "Start local Ruby on Rails server",
  })
vim.api.nvim_create_user_command("LocalRailsSidekiq", M.local_rails_handler("term-sidekiq", "bundle exec sidekiq"), {
  desc = "Start local Ruby on Rails Sidekiq instance",
})
vim.api.nvim_create_user_command("LocalRailsAssets", M.local_rails_handler("term-assets", "bin/dev"), {
  desc = "Start local Ruby on Rails dev tools (e.g. Tailwind, etc.)",
})
vim.api.nvim_create_user_command("LocalRailsConsole", M.local_rails_handler("term-console", "bundle exec rails c"), {
  desc = "Start local Ruby on Rails dev console",
})
vim.api.nvim_create_user_command("LocalRailsAll", function()
  vim.cmd [[LocalRailsServer]]
  vim.cmd [[LocalRailsSidekiq]]
  vim.cmd [[LocalRailsAssets]]
  vim.cmd [[LocalRailsConsole]]
end, {
  desc = "Start all local LocalRails* commands",
})

-- Snippets (see https://cmp.saghen.dev/configurations/snippets.html#custom-snippets)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line:undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        keywords = { italic = false },
      },
      dim_inactive = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },
  {
    "echasnovski/mini.icons",
    lazy = false,
    config = function()
      local mini_icons = require("mini.icons")
      mini_icons.setup()
      mini_icons.mock_nvim_web_devicons()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    main = "lualine",
    opts = {
      options = {
        theme = "tokyonight",
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename", path = 3 },
        },
        lualine_x = { M.filetype_only },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.o.columns / 2,
            mode = 1,
            fmt = M.tabs_fmt,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            "filename",
            file_status = false,
            newfile_status = false,
            path = 3,
            cond = M.tabs_filename_cond,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "fugitive",
        "quickfix",
        "lazy",
        "man",
        "oil",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    opts = {
      -- tpope/vim-surround mappings
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",

        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)

      -- Remap adding surrounding to Visual mode selection
      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true })

      -- Make special mapping for "add surrounding for line"
      vim.keymap.set("n", "yss", "ys_", { remap = true })
    end,
  },
  {
    "ntpeters/vim-better-whitespace",
    init = function()
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
        group = group,
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
    cmd = {
      "Git",
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     silent = true },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     silent = true },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       silent = true },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    silent = true },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", silent = true },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
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
    },
  },
  {
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs_staged_enable = false,
    },
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true -- required
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        bashls = {},
        crystalline = {},
        cssls = {},
        denols = {
          autostart = false,
        },
        emmet_ls = {
          filetypes = {
            "html",
            "eruby",
            "css",
            "typescriptreact",
            "javascriptreact",
            "sass",
            "scss",
          },
        },
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "tab",
                  tab_size = "2",
                },
              },
            },
          },
        },
        ts_ls = {
          filetypes = {
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
        vimls = {},
        zls = {},
        standardrb = {},
        -- ruby_lsp = {},
        -- stimulus_ls = {},
        -- tailwindcss = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "v0.*",
    opts = {
      keymap = {
        preset = "none",

        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

        ["<C-n>"] = { "select_next", "show" },
        ["<C-p>"] = { "select_prev", "show" },

        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        cmdline = {
          preset = "none",

          ["<CR>"] = { "accept", "fallback" },
          ["<C-e>"] = { "cancel" },

          ["<C-n>"] = { "select_next" },
          ["<C-p>"] = { "select_prev" },

          ["<Tab>"] = { "select_next" },
          ["<S-Tab>"] = { "select_prev" },
        },
      },
      completion = {
        list = {
          selection = function(ctx)
            return ctx.mode == "cmdline" and "manual" or "preselect"
          end,
        },
        menu = {
          border = "rounded",
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal"
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "mtth/scratch.vim",
    cmd = {
      "Scratch",
      "ScratchInsert",
      "ScratchSelection",
      "ScratchPreview",
    },
    init = function()
      vim.g.scratch_persistence_file = "~/.scratch.vim"
    end,
  },
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", ":Oil<CR>", desc = "Open parent directory", silent = true },
    },
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
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    keys = {
      { "<leader>b",  M.telescope_buffers,                   silent = true, desc = "Telescope buffers" },
      { "<leader>B",  M.telescope_oldfiles,                  silent = true, desc = "Telescope oldfiles" },
      { "<leader>fg", M.telescope_live_grep,                 silent = true, desc = "Telescope live_grep" },
      { "<leader>fs", M.telescope_current_buffer_fuzzy_find, silent = true, desc = "Telescope current_buffer_fuzzy_find" },
      { "<leader>fh", M.telescope_help_tags,                 silent = true, desc = "Telescope help_tags" },
      { "<leader>fc", M.telescope_dot_config,                silent = true, desc = "Telescope find_files in ~/.config" },
      { "<leader>fm", M.telescope_commands,                  silent = true, desc = "Telescope commands" },
      { "<leader>t",  M.telescope_command_t,                 silent = true, desc = "Telescope find_files or git_files (if inside .git directory)" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup {
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
              ["<PageUp>"] = M.telescope_noop,
              ["<PageDown>"] = M.telescope_noop,
              ["<C-j>"] = M.telescope_noop,
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
                ["<C-d>"] = M.telescope_buf_delete,
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
      telescope.load_extension("fzy_native")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      vim.opt.foldlevelstart = 1
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "fish",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "c",
        "cmake",
        "comment",
        "dockerfile",
        "go",
        "gomod",
        "graphql",
        "vimdoc",
        "make",
        "nix",
        "python",
        "query",
        "ruby",
        "rust",
        "sql",
        "toml",
        "zig",
        "kdl",
        "earthfile",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = false,
      },
    },
  },
  {
    "echasnovski/mini.misc",
    version = "*",
    lazy = false,
    config = true,
    keys = {
      { "<leader>zz", M.mini_zoom, silent = true },
    },
  },
  {
    "OXY2DEV/foldtext.nvim",
    lazy = false,
    opts = {
      -- |  def derp(a, b) # 3 lines
      default = {
        {
          type = "custom",
          handler = function(_, bufnr)
            local line = table.concat(vim.fn.getbufline(bufnr, vim.v.foldstart))
            return { line, "Title" }
          end,
        },
        {
          type = "raw",
          text = " # ",
          hl = "Comment",
        },
        {
          type = "fold_size",
          postfix = " lines",
        },
      },
    },
  },
  {
    "echasnovski/mini.notify",
    version = "*",
    lazy = false,
    opts = {
      content = {
        format = function(notif)
          return notif.msg
        end,
      },
      lsp_progress = {
        enable = false,
      },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 45,
      minimumBufferNum = 30,
      notificationOnAutoClose = true,
      ignoredFiletypes = {
        "terminal",
      },
    },
  },
})
