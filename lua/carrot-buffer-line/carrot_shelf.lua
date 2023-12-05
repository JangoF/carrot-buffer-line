local ordered_map = require("carrot-buffer-line/ordered_map")
local utilities = require("carrot-buffer-line/utilities")
local carrot_buffer = require("carrot-buffer-line/carrot_buffer")

local M = {}
M.__index = M
M._instances = {}

function M.create(tab_id)
	if M._instances[tab_id] then
		M._instances[tab_id]._copy_count = M._instances[tab_id]._copy_count + 1
		return M._instances[tab_id]
	end

	local new_instance = setmetatable({
		_tab_id = tab_id,
		_copy_count = 1,
		_buffers = ordered_map.new(),
		_active_buffer_id = nil,
	}, M)

	M._instances[tab_id] = new_instance
	return new_instance
end

function M:destroy()
	if self._copy_count > 1 then
		self._copy_count = self._copy_count - 1
	else
		M._instances[self._tab_id] = nil
	end
end

function M:build_ui()
	local result = {}

	for _, buffer_id in pairs(self._buffers:get_ordered_array()) do
		local current_buffer = self._buffers:get(buffer_id)
		local current_buffer_ui = current_buffer:build_ui(buffer_id == self._active_buffer_id)
		result = utilities.concatenate_arrays(result, current_buffer_ui)
	end

	return result
end

function M:_insert_buffer(buffer_id)
	if self._buffers:get(buffer_id) == nil then
		self._buffers:insert(buffer_id, carrot_buffer.create(buffer_id))
	end

	self._active_buffer_id = buffer_id
end

function M:_remove_buffer(buffer_id)
	local buffer = self._buffers:get(buffer_id)

	if buffer then
		buffer:destroy()
		local next_buffer_id = nil

		if buffer_id == self._active_buffer_id then
			local ordered_buffers = self._buffers:get_ordered_array()
			local buffer_index = utilities.index_of(ordered_buffers, buffer_id)

			if buffer_index < #ordered_buffers then
				next_buffer_id = ordered_buffers[buffer_index + 1]
			elseif #ordered_buffers > 1 then
				next_buffer_id = ordered_buffers[buffer_index - 1]
			end
		end

		self._buffers:remove(buffer_id)
		self._active_buffer_id = next_buffer_id
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(arguments)
		if utilities.check_is_buffer_valid(arguments.buf) then
			local active_tab_id = vim.api.nvim_get_current_tabpage()
			M._instances[active_tab_id]:_insert_buffer(arguments.buf)
		end
	end,
})

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(arguments)
		if utilities.check_is_buffer_valid(arguments.buf) then
			local active_tab_id = vim.api.nvim_get_current_tabpage()
			M._instances[active_tab_id]:_remove_buffer(arguments.buf)
		end
	end,
})

return M
