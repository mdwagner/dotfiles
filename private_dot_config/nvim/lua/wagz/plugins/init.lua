local function format()
  require("conform").format({ async = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Don't show git* filetypes in buffer list",
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})

return {
  {
    "folke/lazy.nvim",
    version = "*",
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
    "lewis6991/gitsigns.nvim",
    opts = {
      signs_staged_enable = false,
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
    "stevearc/conform.nvim",
    keys = {
      { "<leader>p", format, desc = "Format buffer" }
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        ruby = { "rubocop" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        eruby = { "htmlbeautifier" },
        css = { "prettier" },
        scss = { "prettier" },
        sass = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        awk = { "gawk" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
