local ui_chunk = require("carrot-buffer-line/ui_chunk")

local M = {}
M.__index = M
M._instances = {}

function M.create(buffer_id)
	if M._instances[buffer_id] then
		M._instances[buffer_id]._copy_count = M._instances[buffer_id]._copy_count + 1
		return M._instances[buffer_id]
	end

	local new_instance = setmetatable({ _buffer_id = buffer_id, _copy_count = 1 }, M)
	M._instances[buffer_id] = new_instance
	return new_instance
end

function M:destroy()
	if self._copy_count > 1 then
		self._copy_count = self._copy_count - 1
	else
		M._instances[self._buffer_id] = nil
	end
end

function M:build_ui(is_active)
	local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(self._buffer_id), ":t")
	local result = {}

	table.insert(result, ui_chunk.new("  " .. buffer_name .. "  ", is_active and "CurSearch" or "SignColumn"))
	return result
end

return M
