local build = require("build")

local M = {}

function _G.build_carrot_tabline()
	local screen_width = vim.api.nvim_get_option_value("columns", {})
	local layout = vim.fn.winlayout()

	local section_0 = ""
	local section_1 = ""
	local section_2 = ""

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
				section_0 = M.config.build_section_left(window_left[2], window_width_left)
			end
		end

		if window_right[1] == "leaf" then
			local buffer = vim.api.nvim_win_get_buf(window_right[2])
			local is_buffer_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buffer })

			if not is_buffer_modifiable then
				window_width_right = vim.api.nvim_win_get_width(window_right[2])
				section_2 = M.config.build_section_right(window_right[2], window_width_right)
			end
		end
		section_1 = M.config.build_section_center(screen_width - window_width_left - window_width_right)
	elseif layout[1] == "leaf" then
		local window = layout[2]
		local buffer = vim.api.nvim_win_get_buf(window)

		local window_width = vim.api.nvim_win_get_width(window)
		local is_buffer_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buffer })

		if is_buffer_modifiable then
			section_0 = M.config.build_section_center(window_width)
		else
			section_1 = M.config.build_section_left(window, window_width)
		end
	end

	return section_0 .. section_1 .. section_2
end

M.config = {
	build_buffer = build.build_buffer,
	build_section_left = build.build_section_left,
	build_section_right = build.build_section_right,
	build_section_center = build.build_section_center,
}

function M.setup(options)
	M.config = vim.tbl_extend("force", M.config, options or {})

	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.build_carrot_tabline()"

	vim.schedule(function()
		vim.cmd.redrawtabline()
	end)
end

return M
