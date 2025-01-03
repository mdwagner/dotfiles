local is_floating_win = require("wagz.util").is_floating_win

local function filetype_only()
  return vim.bo.filetype or ""
end

local function tabs_fmt(_, context)
  local name = string.format("%i", context.tabnr)
  if vim.api.nvim_tabpage_is_valid(context.tabnr) then
    local tab_winnrs = vim.tbl_filter(
      function(winnr)
        return not is_floating_win(winnr)
      end,
      vim.api.nvim_tabpage_list_wins(context.tabnr)
    )
    local count = #tab_winnrs
    if count > 1 then
      return string.format("%s (%i)", name, count)
    end
  end
  return name
end

local function tabs_filename_cond()
  local bufnr = vim.api.nvim_get_current_buf()
  local has_no_name = vim.fn.bufname(bufnr) == ""
  local has_no_file = vim.fn.expand("%:p") == ""
  return not (has_no_name or has_no_file)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    main = "lualine",
    opts = {
      options = {
        theme = "tokyonight",
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename", path = 3 },
        },
        lualine_x = { filetype_only },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.o.columns / 2,
            mode = 1,
            fmt = tabs_fmt,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            "filename",
            file_status = false,
            newfile_status = false,
            path = 3,
            cond = tabs_filename_cond,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "fugitive",
        "quickfix",
        "lazy",
        "man",
        "oil",
      },
    },
  },
}
