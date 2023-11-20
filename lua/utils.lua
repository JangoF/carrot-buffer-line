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
	local result = ""

	for i = 1, #baseString do
		local baseChar = baseString:sub(i, i)
		local overlayChar = overlayString:sub(i, i)

		local mergedChar = overlayChar ~= "" and overlayChar or baseChar
		result = result .. mergedChar
	end

	return result
end

return M
