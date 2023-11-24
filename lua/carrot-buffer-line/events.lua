local data = require("carrot-buffer-line/data")

local M = {}

M.register_events = function()
	local CARROT_BUFFER_LINE_CMD = "CarrotBufferLineCMD"
	vim.api.nvim_create_augroup(CARROT_BUFFER_LINE_CMD, { clear = true })

	vim.api.nvim_create_autocmd("BufEnter", {
		group = CARROT_BUFFER_LINE_CMD,
		callback = function(arguments)
			local current_buffer_id = arguments.buf
			local current_shelf = data.switcher:get_active_shelf()

			if current_shelf ~= nil then
				current_shelf:push_buffer(current_buffer_id)
				current_shelf:set_buffer_active(current_buffer_id)
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		group = CARROT_BUFFER_LINE_CMD,
		callback = function(arguments)
			local current_buffer_id = arguments.buf
			local current_shelf = data.switcher:get_active_shelf()

			if current_shelf ~= nil then
				current_shelf:pull_buffer(current_buffer_id)
				current_shelf:set_buffer_inactive(current_buffer_id)
			end
		end,
	})

	vim.api.nvim_create_autocmd("TabEnter", {
		group = CARROT_BUFFER_LINE_CMD,
		callback = function()
			local current_tab_id = vim.api.nvim_get_current_tabpage()
			data.switcher:push_shelf(current_tab_id)
			data.switcher:set_shelf_active(current_tab_id)
		end,
	})

	vim.api.nvim_create_autocmd("TabClosed", {
		group = CARROT_BUFFER_LINE_CMD,
		callback = function()
			local current_tab_id = vim.api.nvim_get_current_tabpage()
			data.switcher:pull_shelf(current_tab_id)
			data.switcher:set_shelf_inactive(current_tab_id)
		end,
	})
end

return M
