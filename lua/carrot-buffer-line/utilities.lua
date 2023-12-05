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

function M.crop_buffer_name(buffer_name)
	local last_slash_position = buffer_name:match("^.+()")

	if last_slash_position then
		return buffer_name:sub(last_slash_position + 1)
	else
		return buffer_name
	end
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

function M.count_characters_excluding_patterns(input_string)
	local function utf8_len(str)
		local len = 0
		for _, _ in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
			len = len + 1
		end
		return len
	end

	return utf8_len(string.gsub(input_string, "%%#.-#", ""))
end

function M.split_string(input_string, pattern)
	local separated_string = {}
	local start = 1

	while start <= #input_string do
		local pStart, pEnd = input_string:find(pattern, start)

		if pStart and pStart > start then
			table.insert(separated_string, input_string:sub(start, pStart - 1))
		end

		if pStart then
			table.insert(separated_string, input_string:sub(pStart, pEnd))
			start = pEnd + 1
		else
			table.insert(separated_string, input_string:sub(start))
			break
		end
	end

	return separated_string
end

function M.crop_line(input_string, trimm_length, pattern)
	local component_table = M.split_string(input_string, pattern)
	local remaining_trimm_length = trimm_length
	local last_highlight = ""

	for i = 1, #component_table do
		if component_table[i]:match(pattern) then
			last_highlight = component_table[i]
			component_table[i] = ""
		else
			local current_component_length = #component_table[i]

			if remaining_trimm_length < current_component_length then
				component_table[i] = string.sub(component_table[i], remaining_trimm_length + 1)
				remaining_trimm_length = 0
			else
				component_table[i] = ""
				remaining_trimm_length = remaining_trimm_length - current_component_length
			end
		end

		if remaining_trimm_length <= 0 then
			break
		end
	end

	table.insert(component_table, 1, last_highlight)
	return table.concat(component_table)
end

function M.concatenate_arrays(array_one, array_two)
	local result = {}

	for i = 1, #array_one do
		table.insert(result, array_one[i])
	end

	for i = 1, #array_two do
		table.insert(result, array_two[i])
	end

	return result
end

function M.build_ui_chunk_array_to_string(ui_chunk_array)
	local result = ""

	for i = 1, #ui_chunk_array do
		result = result .. ui_chunk_array[i]:build()
	end

	return result
end

-- function M.distance_to_active_buffer()
-- 	local result = {}

-- 	local distance_to_active_buffer = 0
-- 	for key, current_buffer in pairs(buffer_list) do
-- 		local current_buffer_string = buffer.draw_carrot_buffer(current_buffer, current_buffer == active_carrot_buffer)
-- 		table.insert(result, current_buffer_string)

-- 		if current_buffer == active_carrot_buffer then
-- 			distance_to_active_buffer = (
-- 				utils.count_characters_excluding_patterns(table.concat(result))
-- 				+ utils.count_characters_excluding_patterns(current_buffer_string)
-- 			) / 2
-- 		end

-- 		if key ~= #buffer_list then
-- 			table.insert(result, "%#StatusLine# ")
-- 		end
-- 	end
-- end

-- function M.crop_window(available_width, input_string)
-- 	local input_string_size = M.count_characters_excluding_patterns(input_string)

-- 	if input_string_size <= available_width then
-- 		return string.rep(" ", available_width - input_string_size)
-- 	end

-- 	local half_available_width = available_width / 2

-- 	if half_available_width then
-- 	end
-- end

function M.index_of(array, element)
	for i, value in ipairs(array) do
		if value == element then
			return i
		end
	end

	return nil
end
return M
