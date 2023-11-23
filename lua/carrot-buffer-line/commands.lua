local build = require("carrot-buffer-line/build")
local utils = require("carrot-buffer-line/utils")

local M = {}

local commands = {
	{
		name = "CarrotBufferLineGoToBuffer",
		options = {
			nargs = 1,
		},
		command = function(buffer_tab_id) end,
	},
	{
		name = "CarrotBufferLineGoToBufferNext",
		command = function() end,
	},
	{
		name = "CarrotBufferLineGoToBufferPrevious",
		command = function() end,
	},
}

function M.register_commands()
	for _, command in ipairs(commands) do
		vim.api.nvim_create_user_command(command.name, command.command, command.options or {})
	end
end

return M
