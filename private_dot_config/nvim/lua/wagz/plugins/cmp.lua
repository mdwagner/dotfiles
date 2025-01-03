local function show_select_prev(cmp)
  cmp.show({
    callback = function()
      cmp.select_prev()
    end,
  })
end

local function dictionary(cmp)
  cmp.show({ providers = { "dictionary" } })
end

return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-dictionary",
    },
    version = "v0.*",
    opts = {
      keymap = {
        preset = "none",

        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

        ["<C-n>"] = { "select_next", "show" },
        ["<C-p>"] = { "select_prev", show_select_prev },

        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<C-i>"] = { dictionary },

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
          auto_show = true,
          auto_show_delay_ms = 2000,
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
        providers = {
          dictionary = {
            name = "dictionary",
            module = "blink-cmp-dictionary",
            opts = {
              prefix_min_len = 2,
              get_command = {
                "rg",
                "--color=never",
                "--no-line-number",
                "--no-messages",
                "--no-filename",
                "--ignore-case",
                "--",
                "${prefix}",
                "/usr/share/dict/words",
              },
              documentation = {
                enable = true,
                get_command = {
                  "wn",
                  "${word}",
                  "-over",
                },
              },
            },
          },
        },
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
}
