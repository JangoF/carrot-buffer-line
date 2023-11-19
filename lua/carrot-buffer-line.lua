local M = {}

local function table_to_string(tbl, count)
	count = count or 0
	local str = "[ "

	for k, v in pairs(tbl) do
		if type(v) == "table" and count < 4 then
			str = str .. k .. ": " .. tableToString(v, count + 1)
		else
			str = str .. k .. ": " .. tostring(v) .. "| "
		end
	end

	return str .. "], "
end

local function window_get_background_color(window_id)
	local window_highlight = vim.api.nvim_get_option_value("winhighlight", { win = window_id })

	local background_highlight = nil
	local highlight_group_list = vim.fn.split(window_highlight, ",")

	for _, value in pairs(highlight_group_list) do
		local parts = vim.fn.split(value, ":")
		if #parts == 2 and parts[1] == "Normal" then
			background_highlight = parts[2]
			break
		end
	end

	if background_highlight then
		background_highlight = "%#" .. background_highlight .. "#"
	end

	return background_highlight
end

local function overlay_strings(baseString, overlayString)
	local result = ""

	for i = 1, #baseString do
		local baseChar = baseString:sub(i, i)
		local overlayChar = overlayString:sub(i, i)

		local mergedChar = overlayChar ~= "" and overlayChar or baseChar
		result = result .. mergedChar
	end

	return result
end

local function build_buffer(buffer_id)
	local filename = vim.fn.fnamemodify(vim.fn.bufname(buffer_id), ":t")
	local max_length = 20
	local truncated_string = #filename > max_length and filename:sub(1, max_length) .. "..." or filename

	local highlight = buffer_id == vim.api.nvim_get_current_buf() and "%#CurSearch#" or "%#NormalNC#"
	return highlight .. "   " .. truncated_string .. "    "
end

local function build_section_left(window_id, available_width)
	local highlight = window_get_background_color(window_id) or "%#CurSearch#"
	return highlight .. string.rep(" ", available_width)
end

local function build_section_center(available_width)
	local modifiable_buffers =
		vim.fn.filter(vim.api.nvim_list_bufs(), 'buflisted(v:val) && getbufvar(v:val, "&modifiable")')
	local section = ""

	for _, value in pairs(modifiable_buffers) do
		section = section .. M.config.build_buffer(value) .. "%#NvimTreeNormal#"
	end

	return overlay_strings("%#NvimTreeNormal#" .. string.rep(" ", available_width), section)
end

local function build_section_right(window_id, available_width)
	local highlight = window_get_background_color(window_id) or "%#NormalNC#"
	return highlight .. string.rep(" ", available_width)
end

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
	build_buffer = build_buffer,
	build_section_left = build_section_left,
	build_section_right = build_section_right,
	build_section_center = build_section_center,
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
