vim.opt.foldlevelstart = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

return {
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
}
