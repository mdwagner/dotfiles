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
vim.opt.foldenable = false
vim.opt.mouse = ""
vim.opt.shortmess = "I"

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat:prepend("%f:%l:%c:%m")
end

if vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = [[nvr -cc split --remote-wait]]
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

-- KEYMAPS
vim.keymap.set("n", "<leader>cc", "gcc", { silent = true, remap = true })
vim.keymap.set("v", "<leader>cc", "gc", { silent = true, remap = true })
vim.keymap.set("v", "<leader>c<space>", "gc", { silent = true, remap = true })

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
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})
vim.api.nvim_create_autocmd("WinNew", {
  group = group,
  pattern = "*",
  callback = function()
    vim.opt.foldenable = false
  end,
})

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

-- HELPERS
local telescope_fzf_native_build_cmd = function()
  if vim.fn.has("win32") == 1 then
    return
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  else
    return "make"
  end
end

-- PLUGINS
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
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
    config = function()
      vim.opt.showmode = false

      local filetype_only = function()
        return vim.bo.filetype or ""
      end

      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 3 },
          },
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
          lualine_x = { filetype_only },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {
          lualine_a = { "tabs" },
          lualine_b = {
            { "filename", path = 4 },
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          "fugitive",
          "nvim-tree",
          "oil",
          "quickfix",
        },
      })
    end,
  },
  {
    "tpope/vim-surround",
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
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "sbdchd/neoformat",
    event = "VeryLazy",
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_only_msg_on_error = 1

      vim.keymap.set("n", "<leader>p", ":Neoformat<CR>", { silent = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        pattern = {
          "*.lua",
        },
        command = "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry",
      })
    end,
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
    "lewis6991/gitsigns.nvim",
    config = true,
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true -- required
    end,
  },
  {
    "garymjr/nvim-snippets",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      friendly_snippets = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "neovim/nvim-lspconfig",
      "garymjr/nvim-snippets",
    },
    config = function()
      local M = {}

      M.has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      M.diagnostic_setqflist = function()
        return vim.diagnostic.setqflist({ title = "All Diagnostics" })
      end

      M.async_format = function()
        vim.lsp.buf.format({ async = true })
      end

      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.g.markdown_fenced_languages = {
        "ts=typescript"
      }

      local lspconfig = require("lspconfig")

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      local lspconfig_defaults = lspconfig.util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        "force",
        lspconfig_defaults.capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
      })

      -- This is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          -- default: 'omnifunc' is set to `vim.lsp.omnifunc()`
          --   i_CTRL-X_CTRL-O
          -- default: 'tagfunc' is set to `vim.lsp.tagfunc()`
          --   go-to-definition, :tjump, CTRL-], CTRL-W_], CTRL-W_}
          -- default: `K` is mapped to `vim.lsp.buf.hover()`
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)   -- TODO: remove
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)       -- TODO: remove
          vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, opts) -- TODO: remove
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)           -- TODO: remove
          -- default: `gq` is mapped to `vim.lsp.formatexpr()`
          vim.keymap.set("n", "<space>f", M.async_format, opts)
          vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)    -- TODO: remove
          vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts) -- TODO: remove
        end
      })

      lspconfig.bashls.setup({})
      lspconfig.crystalline.setup({})
      lspconfig.cssls.setup({})
      lspconfig.denols.setup({
        autostart = false,
      })
      lspconfig.emmet_ls.setup({
        filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
      })
      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({
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
      })
      lspconfig.ts_ls.setup({
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      })
      lspconfig.vimls.setup({})
      lspconfig.zls.setup({})
      lspconfig.standardrb.setup({})
      -- lspconfig.ruby_lsp.setup({})
      -- lspconfig.stimulus_ls.setup({})
      -- lspconfig.tailwindcss.setup({})

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { silent = true })
      vim.keymap.set("n", "<space>q", M.diagnostic_setqflist, { silent = true })
      vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, { silent = true })

      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "snippets" },
          { name = "buffer" },
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            elseif M.has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      })

      -- Use buffer source `/`
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = {
          disallow_symbol_nonprefix_matching = false,
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
    config = function()
      vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory", silent = true })

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
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
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

      vim.keymap.set("n", "<leader>b", builtin.buffers, { silent = true })
      vim.keymap.set("n", "<leader>B", builtin.oldfiles, { silent = true })
      vim.keymap.set("n", "<leader>t", M.command_t, { silent = true })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true })

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
          preview = true,
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
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = telescope_fzf_native_build_cmd(),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
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
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,
        },
      })
    end,
  },
})
