return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        keywords = { italic = false },
      },
      dim_inactive = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },
}
