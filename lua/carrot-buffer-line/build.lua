local utils = require("carrot-buffer-line/utils")

local M = {}

-- local last_active_buffer_id = nil

-- function M.set_active_buffer(buffer_id)
-- 	last_active_buffer_id = buffer_id
-- end

-- function M.get_active_buffer()
-- 	return last_active_buffer_id
-- end

-- function M.build_buffer(buffer_id)
-- 	local filename = vim.fn.fnamemodify(vim.fn.bufname(buffer_id), ":t")
-- 	local max_length = 40
-- 	local truncated_string = filename

-- 	-- if #filename > max_length then
-- 	-- 	truncated_string = filename:sub(1, max_length - 3) .. "..."
-- 	-- elseif truncated_string == "" then
-- 	-- 	truncated_string = "[ Empty File ]"
-- 	-- end

-- 	local highlight = buffer_id == last_active_buffer_id and "%#CurSearch#" or "%#SignColumn#"
-- 	return highlight .. "   " .. truncated_string .. "    "
-- end

function M.build_section_left(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#SignColumn#"
	return highlight .. string.rep(" ", available_width)
end

-- function M.build_section_center(available_width)
-- 	local modifiable_buffers = utils.get_modifiable_buffers()
-- 	local sections = {}

-- 	for _, value in pairs(modifiable_buffers) do
-- 		table.insert(sections, M.build_buffer(value) .. "%#SignColumn#")
-- 	end

-- 	local section = utils.overlay_strings("%#SignColumn#" .. string.rep(" ", available_width), table.concat(sections))
-- 	return section
-- end

function M.build_section_right(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#SignColumn#"
	return highlight .. string.rep(" ", available_width)
end

return M
