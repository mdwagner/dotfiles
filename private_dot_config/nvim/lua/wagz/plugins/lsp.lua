vim.api.nvim_create_autocmd("LspAttach", {
  group = require("wagz.util").augroup,
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

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "netmute/ctags-lsp.nvim",
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
        ctags_lsp = {
          filetypes = { "ruby" },
        },
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
}
