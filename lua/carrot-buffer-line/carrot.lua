local ordered_map = require("carrot-buffer-line/ordered_map")
local carrot_shelf = require("carrot-buffer-line/carrot_shelf")

local M = {}
M.__index = M

function M.create()
	local self = setmetatable({
		_shelves = ordered_map.new(),
		_active_buffer_id = vim.api.nvim_get_current_tabpage(),
	}, M)

	for _, tab_id in ipairs(vim.api.nvim_list_tabpages()) do
		self:_insert_shelf(tab_id)
	end

	vim.api.nvim_create_autocmd("TabEnter", {
		callback = function()
			local active_tab_id = vim.api.nvim_get_current_tabpage()
			self:_insert_shelf(active_tab_id)
			self._active_buffer_id = active_tab_id
		end,
	})

	vim.api.nvim_create_autocmd("TabClosed", {
		callback = function()
			self:_remove_shelf(vim.fn.expand("<afile>"))
			self._active_buffer_id = vim.api.nvim_get_current_tabpage()
		end,
	})

	return self
end

function M:build_ui(offset_left, offset_right, available_width)
	-- if offset_left:get_length() == available_width then
	-- 	return offset_left
	-- end

	-- local result = {}
	-- table.insert(result, offset_left)
	-- result = self._shelves:get(self._active_buffer_id):build_ui()

	-- return result
	return self._shelves:get(self._active_buffer_id):build_ui()
end

function M:_insert_shelf(tab_id)
	if self._shelves:get(tab_id) == nil then
		self._shelves:insert(tab_id, carrot_shelf.create(tab_id))
	end
end

function M:_remove_shelf(tab_id)
	local shelf = self._shelves:get(tab_id)

	if shelf then
		shelf:destroy()
		self._shelves:remove(tab_id)
	end
end

return M
