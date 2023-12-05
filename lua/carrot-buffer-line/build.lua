local ui_chunk = require("carrot-buffer-line/ui_chunk")

local M = {}

function M.build_offset(available_width)
	local result = {}
	table.insert(result, ui_chunk.new(string.rep(" ", available_width), "SignColumn"))

	return result
end

function M.build_empty_offset()
	local result = {}
	table.insert(result, ui_chunk.new("", "SignColumn"))
	return result
end

return M
