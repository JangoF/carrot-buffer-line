local ui_chunk = require("carrot-buffer-line/ui_chunk")

local M = {}
M.__index = M

function M.new()
	local self = setmetatable({}, M)
	return self
end

function M:build_ui()
	local tabpages = vim.api.nvim_list_tabpages()
	local current_tabpage = vim.api.nvim_get_current_tabpage()

	local result = {}
	table.insert(result, ui_chunk.new("", "IncSearch"))

	for key, value in pairs(tabpages) do
		local tabpage_ui_chink =
			ui_chunk.new(" " .. key .. " ", current_tabpage == value and "CurSearch" or "SignColumn")
		table.insert(result, tabpage_ui_chink)
	end

	table.insert(result, ui_chunk.new("", "IncSearch"))
	return result
end

return M
