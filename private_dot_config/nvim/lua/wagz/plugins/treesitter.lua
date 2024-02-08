return {
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
          enable = true,
        },
        playground = {
          enable = true,
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/playground",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false, -- Disabled until Crystal supports TS
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("treesitter-context").setup({
        mode = "topline",
      })
    end,
  },
  {
    "wellle/context.vim",
    init = function()
      vim.g.context_presenter = "nvim-float"
      vim.g.context_highlight_normal = "NormalFloat"
      vim.g.context_highlight_border = "FloatBorder"
      vim.g.context_highlight_tag = "<hide>"
      vim.g.context_filetype_blacklist = { "help" }
    end,
  },
}
