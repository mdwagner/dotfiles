local let_g = vim.g
local buf_delete = vim.api.nvim_buf_delete
local nvim_exec = vim.api.nvim_exec

local command_t = function()
	if #vim.fn.system("git rev-parse") == 0 then
		return ":GFiles --exclude-standard --others --cached<CR>"
	else
		return ":Files"
	end
end

function _G.list_buffers()
	local buf_list_str = nvim_exec("ls", true)
	return vim.split(buf_list_str, "\n")
end

function _G.delete_buffers(lines)
	for _, line in ipairs(lines) do
		local value = vim.split(vim.trim(line), " ")[1]
		if value then
			local buf = tonumber(value)
			buf_delete(buf, {
				force = true,
			})
		end
	end
end

let_g.fzf_layout = { down = "40%" }
let_g.fzf_preview_window = {}

vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>B", ":FZFMru<CR>", { silent = true })
vim.keymap.set("n", "<leader>D", ":BD<CR>", { silent = true })
vim.keymap.set("n", "<leader>t", command_t, { nowait = true, expr = true })

vim.cmd([[
  command! BD call fzf#run(fzf#wrap({
  \ 'source': v:lua.list_buffers(),
  \ 'sinklist': { lines -> v:lua.delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
  \ }))
]])
