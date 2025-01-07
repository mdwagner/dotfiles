vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Don't show git* filetypes in buffer list",
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})

vim.keymap.set("n", "<space>sc", "<cmd>Scratch<cr>", {
  desc = "Open scratch buffer",
  silent = true,
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
    "vim-crystal/vim-crystal",
    ft = { "crystal", "ecrystal" },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs_staged_enable = false,
    },
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true -- required
    end,
  },
  {
    "mtth/scratch.vim",
    event = "VeryLazy",
    init = function()
      vim.g.scratch_no_mappings = 1
      vim.g.scratch_persistence_file = "~/.scratch.vim"
    end,
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
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 45,
      minimumBufferNum = 30,
      notificationOnAutoClose = true,
      ignoredFiletypes = {
        "terminal",
      },
    },
  },
  {
    "sbdchd/neoformat",
    event = "VeryLazy",
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_only_msg_on_error = 1
    end,
  },
}
