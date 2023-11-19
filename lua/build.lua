local utils = require("utils")

local M = {}

function M.build_buffer(buffer_id)
	local filename = vim.fn.fnamemodify(vim.fn.bufname(buffer_id), ":t")
	local max_length = 20
	local truncated_string = #filename > max_length and filename:sub(1, max_length) .. "..." or filename

	local highlight = buffer_id == vim.api.nvim_get_current_buf() and "%#CurSearch#" or "%#NormalNC#"
	return highlight .. "   " .. truncated_string .. "    "
end

function M.build_section_left(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#CurSearch#"
	return highlight .. string.rep(" ", available_width)
end

function M.build_section_center(available_width)
	local modifiable_buffers =
		vim.fn.filter(vim.api.nvim_list_bufs(), 'buflisted(v:val) && getbufvar(v:val, "&modifiable")')
	local section = ""

	for _, value in pairs(modifiable_buffers) do
		section = section .. M.build_buffer(value) .. "%#NvimTreeNormal#"
	end

	return utils.overlay_strings("%#NvimTreeNormal#" .. string.rep(" ", available_width), section)
end

function M.build_section_right(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#NormalNC#"
	return highlight .. string.rep(" ", available_width)
end

return M
