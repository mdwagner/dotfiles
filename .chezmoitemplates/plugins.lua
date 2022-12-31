vim.cmd("packadd! packer.nvim")

require("packer").startup(function(use)
  -- NVIM --
  use({ "neovim/nvim-lspconfig" })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
  })
  use({ "lukas-reineke/indent-blankline.nvim" })
  use({ "ahmedkhalf/project.nvim" })
  use({ "navarasu/onedark.nvim" })
  use({ "mfussenegger/nvim-dap" })
  use({
    "rcarriga/nvim-dap-ui",
    requires = "mfussenegger/nvim-dap",
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use({ "nvim-treesitter/playground" })
  use({
    "Shatur/neovim-session-manager",
    requires = "nvim-lua/plenary.nvim",
  })

  -- VIM --
  use({ "tpope/vim-surround" })
  use({ "preservim/nerdcommenter" })
  use({ "ntpeters/vim-better-whitespace" })
  use({ "bling/vim-airline" })
  use({ "vim-airline/vim-airline-themes" })
  use({ "sickill/vim-pasta" })
  use({ "tpope/vim-fugitive" })
  use({ "sbdchd/neoformat" })
  use({ "junegunn/fzf", run = "./install --bin" })
  use({ "junegunn/fzf.vim" })
  use({ "pbogut/fzf-mru.vim" })
  use({ "eslint/eslint" })
  use({ "vim-test/vim-test" })
  use({ "ziglang/zig.vim" })
  use({ "vim-crystal/vim-crystal" })
  use({ "christoomey/vim-tmux-navigator" })
  use({ "jxnblk/vim-mdx-js" })
end)

return true
