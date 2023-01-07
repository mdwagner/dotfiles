vim.cmd("packadd! packer.nvim")

require("packer").startup(function(use)
  use({ "tpope/vim-surround" })
  use({ "preservim/nerdcommenter" })
  use({
    "ntpeters/vim-better-whitespace",
    config = function()
      require("wagz.better-whitespace")
    end,
  })
  use({
    "bling/vim-airline",
    config = function()
      require("wagz.airline")
    end,
  })
  use({
    "vim-airline/vim-airline-themes",
    after = "vim-airline",
  })
  use({ "sickill/vim-pasta" })
  use({
    "tpope/vim-fugitive",
    config = function()
      require("wagz.git")
    end,
  })
  use({
    "sbdchd/neoformat",
    config = function()
      require("wagz.neoformat")
    end,
  })
  use({
    "junegunn/fzf",
    run = "./install --bin",
  })
  use({
    "junegunn/fzf.vim",
    after = "fzf",
    config = function()
      require("wagz.fzf")
    end,
  })
  use({
    "pbogut/fzf-mru.vim",
    after = "fzf",
  })
  use({ "eslint/eslint" })
  use({
    "vim-test/vim-test",
    config = function()
      require("wagz.vim-test")
    end,
  })
  use({
    "ziglang/zig.vim",
    ft = { "zig", "zir" },
    config = function()
      require("wagz.zig")
    end,
  })
  use({
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
  })
  use({
    "christoomey/vim-tmux-navigator",
    config = function()
      require("wagz.tmux-navigator")
    end,
  })
  use({ "jxnblk/vim-mdx-js" })
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
    after = "nvim-lspconfig",
    config = function()
      require("wagz.lsp")
    end,
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("wagz.nvim-tree")
    end,
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("wagz.indent-blankline")
    end,
  })
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("wagz.project-nvim")
    end,
  })
  use({
    "navarasu/onedark.nvim",
    config = function()
      require("wagz.onedark")
    end,
  })
  use({
    "rcarriga/nvim-dap-ui",
    requires = "mfussenegger/nvim-dap",
    config = function()
      require("wagz.dap")
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require("wagz.treesitter")
    end,
  })
  use({
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  })
  use({
    "Shatur/neovim-session-manager",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("wagz.session-manager")
    end,
  })
  use({ "mtth/scratch.vim" })
end)
