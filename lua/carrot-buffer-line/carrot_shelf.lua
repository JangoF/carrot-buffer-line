local utils = require("carrot-buffer-line/utils")
local buffer = require("carrot-buffer-line/carrot_buffer")

local M = {}

M.build_carrot_shelf = function(target_shelf_id)
	local carrot_shelf = {}
	local shelf_id = target_shelf_id

	local carrot_buffer_list = {}
	local active_carrot_buffer = nil

	function carrot_shelf:get_shelf_id()
		return shelf_id
	end

	function carrot_shelf:get_buffer_list()
		return carrot_buffer_list
	end

	function carrot_shelf:get_active_buffer()
		return active_carrot_buffer
	end

	function carrot_shelf:set_buffer_active(buffer_id)
		local carrot_buffer = self:check_is_buffer_exist(buffer_id)

		if carrot_buffer ~= nil then
			active_carrot_buffer = carrot_buffer_list[carrot_buffer]
		end
	end

	function carrot_shelf:set_buffer_inactive(buffer_id)
		local carrot_buffer = self:check_is_buffer_exist(buffer_id)

		if carrot_buffer ~= nil then
			active_carrot_buffer = nil
		end
	end

	function carrot_shelf:push_buffer(buffer_id)
		if self:check_is_buffer_exist(buffer_id) == nil and utils.check_is_buffer_valid(buffer_id) then
			table.insert(carrot_buffer_list, buffer.build_carrot_buffer(buffer_id))
		end
	end

	function carrot_shelf:pull_buffer(buffer_id)
		local carrot_buffer = self:check_is_buffer_exist(buffer_id)
		if carrot_buffer ~= nil then
			return table.remove(carrot_buffer_list, carrot_buffer)
		end
	end

	function carrot_shelf:check_is_buffer_exist(buffer_id)
		for index, value in ipairs(carrot_buffer_list) do
			if value:get_buffer_id() == buffer_id then
				return index
			end
		end

		return nil
	end

	return carrot_shelf
end

M.switch_to_next_buffer = function(target_carrot_shelf)
	local carrot_buffer_list = target_carrot_shelf:get_buffer_list()
	local active_buffer = target_carrot_shelf:get_active_buffer()
	local active_buffer_index = target_carrot_shelf:check_is_buffer_exist(active_buffer:get_buffer_id())

	if active_buffer_index == #carrot_buffer_list then
		target_carrot_shelf:set_buffer_active(carrot_buffer_list[1])
	else
		target_carrot_shelf:set_buffer_active(carrot_buffer_list[active_buffer_index + 1])
	end

	return target_carrot_shelf:get_active_buffer()
end

M.switch_to_prev_buffer = function(target_carrot_shelf)
	local carrot_buffer_list = target_carrot_shelf:get_buffer_list()
	local active_buffer = target_carrot_shelf:get_active_buffer()
	local active_buffer_index = target_carrot_shelf:check_is_buffer_exist(active_buffer:get_buffer_id())

	if active_buffer_index == 1 then
		target_carrot_shelf:set_buffer_active(carrot_buffer_list[#carrot_buffer_list])
	else
		target_carrot_shelf:set_buffer_active(carrot_buffer_list[active_buffer_index - 1])
	end

	return target_carrot_shelf:get_active_buffer()
end

M.draw_carrot_shelf = function(target_carrot_shelf, available_width)
	local active_carrot_buffer = target_carrot_shelf:get_active_buffer()
	local buffer_list = target_carrot_shelf:get_buffer_list()
	local result = {}

	for key, current_buffer in pairs(buffer_list) do
		table.insert(result, buffer.draw_carrot_buffer(current_buffer, current_buffer == active_carrot_buffer))

		if key ~= #buffer_list then
			table.insert(result, "%#StatusLine# ")
		end
	end

	local shelf_stirng = table.concat(result)
	local shelf_string_width = utils.count_characters_excluding_patterns(shelf_stirng)

	local result_stirng = shelf_stirng .. "%#StatusLine# " .. string.rep(" ", available_width - shelf_string_width)
	return result_stirng
end

return M
