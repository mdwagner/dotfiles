vim.opt.foldlevelstart = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

return {
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   lazy = false,
  --   branch = "main",
  --   build = ":TSUpdate",
  --   init = function()
  --     local ensure_installed = {}
  --     local max_wait_ms = 300000 -- 5 mins
  --     require("nvim-treesitter").install(ensure_installed):wait(max_wait_ms)
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
        "rbs",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      indent = {
        enable = false,
      },
    },
  },
  {
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
  },
  {
    "earthly/earthly.vim",
    branch = "main",
    ft = { "Earthfile" },
  },
}
