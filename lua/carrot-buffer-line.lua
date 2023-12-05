-- local commands = require("carrot-buffer-line/commands")
-- local events = require("carrot-buffer-line/events")
-- local carrot_tab_control = require("carrot-buffer-line/carrot_tab_control")
-- local utils = require("carrot-buffer-line/utils")

-- local default = require("carrot-buffer-line/default")
local data = require("carrot-buffer-line/data")
local build = require("carrot-buffer-line/build")

-- local ui_chunk = require("carrot-buffer-line/ui_chunk")
-- local coarrot_ui_chunk = require("carrot-buffer-line/carrot-ui-chunk")
-- local carrot_shelf = require("carrot-buffer-line/carrot-buffer-shelf")

-- local carrot_switcher = require("carrot-buffer-line/carrot_switcher")

local M = {}
-- M = vim.tbl_extend("force", M, default)
M = vim.tbl_extend("force", M, data)

function _G.build_carrot_tabline()
	local screen_width = vim.api.nvim_get_option_value("columns", {})
	local layout = vim.fn.winlayout()

	local offset_left = build.build_empty_offset()
	local offset_right = build.build_empty_offset()

	if layout[1] == "row" then
		local window_width_left = 0
		local window_width_right = 0

		local window_left = layout[2][1]
		local window_right = layout[2][#layout[2]]

		if window_left[1] == "leaf" then
			local buffer = vim.api.nvim_win_get_buf(window_left[2])
			local is_buffer_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buffer })

			if not is_buffer_modifiable then
				window_width_left = vim.api.nvim_win_get_width(window_left[2])
				offset_left = build.build_offset(window_width_left)
			end
		end

		if window_right[1] == "leaf" then
			local buffer = vim.api.nvim_win_get_buf(window_right[2])
			local is_buffer_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buffer })

			if not is_buffer_modifiable then
				window_width_right = vim.api.nvim_win_get_width(window_right[2])
				offset_left = build.build_offset(window_width_right)
			end
		end
	elseif layout[1] == "leaf" then
		local window = layout[2]
		local buffer = vim.api.nvim_win_get_buf(window)

		local window_width = vim.api.nvim_win_get_width(window)
		local is_buffer_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buffer })

		if not is_buffer_modifiable then
			offset_left = build.build_offset(window_width)
		end
	end

  print(offset_left)
	local result = ""
	for _, current_ui_chunk in
		ipairs(M.carrot:build_ui(offset_left, offset_right, screen_width))
	do
		result = result .. current_ui_chunk:build()
	end

	return result
end

function M.setup(options)
	-- M.config = vim.tbl_extend("force", M.config, options or {})

	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.build_carrot_tabline()"

	vim.schedule(function()
		vim.cmd.redrawtabline()
	end)

	-- M.carrot.
	-- local current_tab_id = vim.api.nvim_get_current_tabpage()
	-- M.switcher:push_shelf(current_tab_id)
	-- M.switcher:set_shelf_active(current_tab_id)

	-- events.register_events()
	-- commands.register_commands()
end

return M
