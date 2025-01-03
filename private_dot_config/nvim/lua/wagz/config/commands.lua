local current_jobs = {}

local function local_rails_handler(name, command)
  return function()
    if current_jobs[name] then
      return
    end
    vim.cmd [[tabnew]]
    local channel_id = vim.fn.termopen(command, {
      on_exit = function(_, code)
        if code ~= 0 then
          print(name .. " exited with code " .. code)
        end
        current_jobs[name] = nil
      end
    })
    if channel_id > 0 then
      current_jobs[name] = channel_id
    end
    vim.cmd("file " .. name)
    vim.cmd [[clo]]
  end
end

vim.api.nvim_create_user_command("LocalRailsServer", local_rails_handler("term-server", "bin/rails s"), {
  desc = "Start local Ruby on Rails server",
})
vim.api.nvim_create_user_command("LocalRailsSidekiq", local_rails_handler("term-sidekiq", "bundle exec sidekiq"), {
  desc = "Start local Ruby on Rails Sidekiq instance",
})
vim.api.nvim_create_user_command("LocalRailsAssets", local_rails_handler("term-assets", "bin/dev"), {
  desc = "Start local Ruby on Rails dev tools (e.g. Tailwind, etc.)",
})
vim.api.nvim_create_user_command("LocalRailsConsole", local_rails_handler("term-console", "bin/rails c"), {
  desc = "Start local Ruby on Rails dev console",
})
vim.api.nvim_create_user_command("LocalRailsAll", function()
  vim.cmd [[LocalRailsServer]]
  vim.cmd [[LocalRailsSidekiq]]
  vim.cmd [[LocalRailsAssets]]
  vim.cmd [[LocalRailsConsole]]
end, {
  desc = "Start all local LocalRails* commands",
})
