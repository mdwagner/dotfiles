local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local nvim_lsp = require("lspconfig")

local set = vim.opt
local let_g = vim.g
local buf_set_option = vim.api.nvim_buf_set_option
local buf_get_lines = vim.api.nvim_buf_get_lines
local win_get_cursor = vim.api.nvim_win_get_cursor
local get_runtime_file = vim.api.nvim_get_runtime_file

local has_words_before = function()
  local line, col = unpack(win_get_cursor(0))
  return col ~= 0 and buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

set.completeopt = { "menu", "menuone", "noselect" }

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { silent = true })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, buf)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local buffer_silent = function(bufnr)
    return { silent = true, buffer = bufnr }
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buffer_silent(buf))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, buffer_silent(buf))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, buffer_silent(buf))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buffer_silent(buf))
  vim.keymap.set("n", "<space>h", vim.lsp.buf.signature_help, buffer_silent(buf))
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, buffer_silent(buf))
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, buffer_silent(buf))
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, buffer_silent(buf))
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, buffer_silent(buf))
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, buffer_silent(buf))
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, buffer_silent(buf))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, buffer_silent(buf))
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, buffer_silent(buf))
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
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
})

let_g.markdown_fenced_languages = {
  "ts=typescript"
}

-- Setup lspconfig
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lsp_servers = {
  servers = {
    "bashls",
    "crystalline",
    "cssls",
    "denols",
    "emmet_ls",
    "eslint",
    "jsonls",
    "lua_ls",
    "tsserver",
    "vimls",
    "zls",
  },
  overrides = {
    ["emmet_ls"] = {
      filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
    },
    ["eslint"] = {
      settings = {
        run = "onSave",
      },
    },
    ["lua_ls"] = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = get_runtime_file("", true),
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
    ["denols"] = {
      autostart = false,
    },
    ["tsserver"] = {
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    },
  },
}

for _, lsp in ipairs(lsp_servers.servers) do
  local overrides = lsp_servers.overrides[lsp] or {}

  nvim_lsp[lsp].setup(vim.tbl_extend("force", {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }, overrides))
end
