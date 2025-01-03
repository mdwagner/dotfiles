local function zoom()
  require("mini.misc").zoom(nil, {
    border = "solid",
    title = "FLOATING",
    title_pos = "center",
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = require("wagz.util").augroup,
  desc = "Blacklist mini.trailspace for filetypes",
  pattern = {
    "diff",
    "git",
    "gitcommit",
    "unite",
    "qf",
    "help",
    "markdown",
    "fugitive",
    "terminal",
  },
  callback = function(event)
    vim.b[event.buf].minitrailspace_disable = true
  end,
})

return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    config = function()
      local mini_icons = require("mini.icons")
      mini_icons.setup()
      mini_icons.mock_nvim_web_devicons()
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    opts = {
      -- tpope/vim-surround mappings
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",

        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)

      -- Remap adding surrounding to Visual mode selection
      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true })

      -- Make special mapping for "add surrounding for line"
      vim.keymap.set("n", "yss", "ys_", { remap = true })
    end,
  },
  {
    "echasnovski/mini.misc",
    version = "*",
    lazy = false,
    keys = {
      { "<leader>zz", zoom, silent = true },
    },
    config = function()
      require("mini.misc").setup()
    end,
  },
  {
    "echasnovski/mini.notify",
    version = "*",
    lazy = false,
    opts = {
      content = {
        format = function(notif)
          return notif.msg
        end,
      },
      window = {
        winblend = 0,
      },
    },
    config = function(_, opts)
      local mini_notify = require("mini.notify")
      mini_notify.setup(opts)
      vim.notify = mini_notify.make_notify()
    end,
  },
  {
    "echasnovski/mini.trailspace",
    version = "*",
    lazy = false,
    config = function()
      require("mini.trailspace").setup()
    end,
  },
}
