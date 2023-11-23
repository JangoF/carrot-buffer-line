local default = require("carrot-buffer-line/default")

local M = {}

M.build_carrot_buffer = function(target_buffer_id)
	local carrot_buffer = {}
	local buffer_id = target_buffer_id

	function carrot_buffer:get_buffer_id()
		return buffer_id
	end

	return carrot_buffer
end

M.draw_carrot_buffer = function(target_carrot_buffer, is_active)
	local max_length = math.max(default.config.max_buffer_name_length, 3)
	local buffer_id = vim.fn.bufname(target_carrot_buffer:get_buffer_id())
	local truncated_string = vim.fn.fnamemodify(buffer_id, ":t")

	if #truncated_string > max_length then
		truncated_string = truncated_string:sub(1, max_length - 3) .. "..."
	end

	local highlight = is_active and "%#CurSearch#" or "%#SignColumn#"
	return highlight .. "   " .. truncated_string .. "    "
end

return M
