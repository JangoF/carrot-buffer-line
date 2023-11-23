local M = {}

function M.window_get_background_color(window_id)
	local window_highlight = vim.api.nvim_get_option_value("winhighlight", { win = window_id })

	local background_highlight = nil
	local highlight_group_list = vim.fn.split(window_highlight, ",")

	for _, value in pairs(highlight_group_list) do
		local parts = vim.fn.split(value, ":")
		if #parts == 2 and parts[1] == "Normal" then
			background_highlight = parts[2]
			break
		end
	end

	if background_highlight then
		background_highlight = "%#" .. background_highlight .. "#"
	end

	return background_highlight
end

function M.overlay_strings(baseString, overlayString)
	local result = {}
	local resultIndex = 1

	for i = 1, #baseString do
		local baseChar = baseString:sub(i, i)
		local overlayChar = overlayString:sub(i, i)

		result[resultIndex] = overlayChar ~= "" and overlayChar or baseChar
		resultIndex = resultIndex + 1
	end

	return table.concat(result)
end

function M.get_modifiable_buffers()
	local modifiable_buffers = {}

	local buffers = vim.api.nvim_list_bufs()

	for _, buffer in ipairs(buffers) do
		if M.check_is_buffer_valid(buffer) then
			table.insert(modifiable_buffers, buffer)
		end
	end

	return modifiable_buffers
end

function M.check_is_buffer_valid(buffer_id)
	return vim.api.nvim_buf_is_valid(buffer_id)
		and vim.api.nvim_get_option_value("modifiable", { buf = buffer_id })
		and vim.fn.bufname(buffer_id) ~= ""
end

return M
