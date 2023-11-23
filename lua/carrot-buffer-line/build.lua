local utils = require("carrot-buffer-line/utils")

local M = {}

function M.build_section_left(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#SignColumn#"
	return highlight .. string.rep(" ", available_width)
end

function M.build_section_right(window_id, available_width)
	local highlight = utils.window_get_background_color(window_id) or "%#SignColumn#"
	return highlight .. string.rep(" ", available_width)
end

return M
