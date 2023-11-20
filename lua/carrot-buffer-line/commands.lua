local build = require("carrot-buffer-line/build")
local utils = require("carrot-buffer-line/utils")

local M = {}

local commands = {
	{
		name = "CarrotBufferLineGoToBufferTab",
		options = {
			nargs = 1,
		},
		command = function(buffer_tab_id)
			local modifiable_buffers =
				vim.fn.filter(vim.api.nvim_list_bufs(), 'buflisted(v:val) && getbufvar(v:val, "&modifiable")')

			local target_buffer_tab_id = tonumber(buffer_tab_id.fargs[1])
			if target_buffer_tab_id <= #modifiable_buffers then
				vim.api.nvim_set_current_buf(modifiable_buffers[target_buffer_tab_id])
			end
		end,
	},
	{
		name = "CarrotBufferLineGoToBufferNext",
		command = function()
			local modifiable_buffers = utils.get_modifiable_buffers()
			local active_buffer = build.get_active_buffer()

			for key, current_buffer in ipairs(modifiable_buffers) do
				if current_buffer == active_buffer then
					if key == #modifiable_buffers then
						vim.api.nvim_set_current_buf(modifiable_buffers[1])
					else
						vim.api.nvim_set_current_buf(modifiable_buffers[key + 1])
					end
				end
			end
		end,
	},
	{
		name = "CarrotBufferLineGoToBufferPrevious",
		command = function()
			local modifiable_buffers = utils.get_modifiable_buffers()
			local active_buffer = build.get_active_buffer()

			for key, current_buffer in ipairs(modifiable_buffers) do
				if current_buffer == active_buffer then
					if key == 1 then
						vim.api.nvim_set_current_buf(modifiable_buffers[#modifiable_buffers])
					else
						vim.api.nvim_set_current_buf(modifiable_buffers[key - 1])
					end
				end
			end
		end,
	},
}

function M.register_commands()
	for _, command in ipairs(commands) do
		vim.api.nvim_create_user_command(command.name, command.command, command.options or {})
	end
end

return M
