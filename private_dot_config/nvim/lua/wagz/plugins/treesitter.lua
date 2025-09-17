vim.opt.foldlevelstart = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    init = function()
      local ensure_installed = {
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
      }
      require("nvim-treesitter").install(ensure_installed, { summary = false })
    end,
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
