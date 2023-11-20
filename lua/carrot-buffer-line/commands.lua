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
}

function M.register_commands()
	for _, command in ipairs(commands) do
		vim.api.nvim_create_user_command(command.name, command.command, command.options)
	end
end

return M
