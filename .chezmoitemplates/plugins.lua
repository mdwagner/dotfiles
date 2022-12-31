vim.cmd("packadd! packer.nvim")

local packer = require("packer")

packer.startup(function(use)
  use({ "tpope/vim-surround" })
  use({ "preservim/nerdcommenter" })
  use({ "ntpeters/vim-better-whitespace" })
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
    end,
  })
  use({
    "ziglang/zig.vim",
    ft = { "zig", "zir" },
    config = function()
    end,
  })
  use({
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
    config = function()
    end,
  })
  use({
    "christoomey/vim-tmux-navigator",
    config = function()
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
    end,
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
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
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    config = function()
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
end)

if vim.fn.filereadable(packer.config.compile_path) == 0 then
  vim.ui.select(
    { "Yes", "Cancel" },
    { prompt = [[Perform :PackerSync and Quit?]] },
    function(choice)
      if choice == "Yes" or not choice then
        vim.api.nvim_create_autocmd({ "User", "PackerComplete" }, {
          command = "qall!"
        })
        packer.sync()
      end
    end
  )
  return false
end

return true
