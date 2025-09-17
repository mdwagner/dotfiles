local function show_select_prev(cmp)
  cmp.show({
    callback = function()
      cmp.select_prev()
    end,
  })
end

-- local function dictionary(cmp)
--   cmp.show({ providers = { "dictionary" } })
-- end

return {
  {
    "saghen/blink.cmp",
    lazy = false, -- don't need?
    dependencies = {
      "rafamadriz/friendly-snippets",
      "disrupted/blink-cmp-conventional-commits",
    },
    -- version = "1.*",
    branch = "main", -- replace with version
    build = "mise x rust@nightly -- cargo build --release", -- don't need?
    opts = {
      fuzzy = {
        -- implementation = "prefer_rust_with_warning",
        prebuilt_binaries = { -- replace with above
          download = false, -- handled by build option above
        },
      },
      keymap = {
        preset = "none",

        ["<C-y>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

        ["<C-n>"] = { "select_next", "show" },
        ["<C-p>"] = { "select_prev", show_select_prev },

        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        -- ["<C-i>"] = { dictionary },

        cmdline = {
          preset = "none",

          ["<C-y>"] = { "accept" },
          ["<C-e>"] = { "cancel" },

          ["<C-n>"] = { "select_next" },
          ["<C-p>"] = { "select_prev" },

          ["<Tab>"] = { "select_next" },
          ["<S-Tab>"] = { "select_prev" },
        },
        -- term = {
        --   enabled = false,
        -- },
      },
      -- cmdline = {
      --   keymap = { preset = "inherit" },
      --   completion = {
      --     menu = {
      --       auto_show = true
      --     },
      --   },
      --   list = {
      --     selection = {
      --       preselect = false,
      --       auto_insert = false,
      --     },
      --   },
      --   sources = function()
      --     local type = vim.fn.getcmdtype()
      --     -- Search forward and backward
      --     if type == "/" or type == "?" then return { "buffer" } end
      --     -- Commands
      --     if type == ":" or type == "@" then return { "path", "cmdline" } end
      --     return {}
      --   end,
      -- },
      -- term = {
      --   enabled = false,
      -- },
      completion = {
        list = { -- remove
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            auto_insert = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
          },
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
              -- kind = {
              --   -- Optionally, you may also use the highlights from mini.icons
              --   highlight = function(ctx)
              --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              --     return hl
              --   end,
              -- },
            },
          },
          auto_show = function(ctx)
            -- return ctx.mode == "cmdwin"
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 2000,
          window = { -- remove
            border = "rounded",
          },
        },
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true, -- remove?
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal"
      },
      sources = {
        default = { "conventional_commits", "lsp", "path", "snippets", "buffer" },
        cmdline = function() -- remove
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "path", "cmdline" }
          end
          return {}
        end,
        providers = {
          -- dictionary = {
          --   name = "dictionary",
          --   module = "blink-cmp-dictionary",
          --   opts = {
          --     prefix_min_len = 2,
          --     get_command = {
          --       "rg",
          --       "--color=never",
          --       "--no-line-number",
          --       "--no-messages",
          --       "--no-filename",
          --       "--ignore-case",
          --       "--",
          --       "${prefix}",
          --       "/usr/share/dict/words",
          --     },
          --     documentation = {
          --       enable = true,
          --       get_command = {
          --         "wn",
          --         "${word}",
          --         "-over",
          --       },
          --     },
          --   },
          -- },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
            opts = {},
          },
        },
      },
      signature = {
        enabled = true,
        window = { -- remove
          border = "rounded",
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
