local data = require("carrot-buffer-line/data")

local M = {}

M.register_events = function()
	local CARROT_BUFFER_LINE_CMD = "CarrotBufferLineCMD"
	vim.api.nvim_create_augroup(CARROT_BUFFER_LINE_CMD, { clear = true })

	vim.api.nvim_create_autocmd("BufEnter", {
		group = CARROT_BUFFER_LINE_CMD,
		callback = function()
			local active_buffer_id = vim.api.nvim_get_current_buf()

			data.shelf:push_buffer(active_buffer_id)
      data.shelf:set_buffer_active(active_buffer_id)
		end,
	})
end

return M
