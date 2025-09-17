vim.api.nvim_create_autocmd("LspAttach", {
  group = require("wagz.util").augroup,
  desc = "LSP actions",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    -- default: 'omnifunc' is set to `vim.lsp.omnifunc()`
    --   i_CTRL-X_CTRL-O
    --
    -- default: 'tagfunc' is set to `vim.lsp.tagfunc()` for go-to-definition, :tjump
    --   CTRL-], CTRL-W_], CTRL-W_}
    --
    -- default: 'formatexpr' is set to `vim.lsp.formatexpr()`
    --   n_gq, v_gq
    --
    -- default: `K` is mapped to `vim.lsp.buf.hover()`

    -- Unset 'omnifunc' (using blink.cmp instead)
    vim.bo[event.buf].omnifunc = nil

    if client.supports_method("textDocument/typeDefinition", { bufnr = event.buf }) then
      vim.keymap.set("n", "gd", vim.lsp.buf.type_definition, {
        silent = true,
        buffer = event.buf,
        desc = "Jumps to the definition of the type of the symbol under the cursor",
      })
    end

    if client.supports_method("textDocument/references", { bufnr = event.buf }) then
      vim.keymap.set("n", "grr", vim.lsp.buf.references, {
        silent = true,
        buffer = event.buf,
        desc = "Lists all the references to the symbol under the cursor in the quickfix window",
      })
    end

    if client.supports_method("textDocument/rename", { bufnr = event.buf }) then
      vim.keymap.set("n", "grn", vim.lsp.buf.rename, {
        silent = true,
        buffer = event.buf,
        desc = "Renames all references to the symbol under the cursor",
      })
    end

    if client.supports_method("textDocument/codeAction", { bufnr = event.buf }) then
      vim.keymap.set("n", "gra", vim.lsp.buf.code_action, {
        silent = true,
        buffer = event.buf,
        desc = "Selects a code action available at the current cursor position",
      })
    end

    if client.supports_method("textDocument/documentSymbol", { bufnr = event.buf }) then
      vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, {
        silent = true,
        buffer = event.buf,
        desc = "Lists all symbols in the current buffer in the quickfix window",
      })
    end

    if client.supports_method("textDocument/signatureHelp", { bufnr = event.buf }) then
      vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, {
        silent = true,
        buffer = event.buf,
        desc = "Displays signature information about the symbol under the cursor in a floating window",
      })
    end
  end
})

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "single", title = "HOVER" })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

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
        cssls = {
          settings = {
            css = { validate = false },
            scss = { validate = false },
            less = { validate = false },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "eruby",
            "css",
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
        ctags_lsp = {
          filetypes = { "ruby" },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- vim.lsp.config("*", {
      --   capabilities = require("blink.cmp").get_lsp_capabilities(),
      -- })
      --
      -- for name, config in pairs(opts.servers) do
      --   config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      --   vim.lsp.config(name, config)
      -- end
      --
      -- for name, _ in pairs(opts.servers) do
      --   vim.lsp.enable(name)
      -- end
    end,
  },
}
