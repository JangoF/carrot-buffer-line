local utils = require("carrot-buffer-line/utils")
local buffer = require("carrot-buffer-line/carrot_buffer")

local M = {}

M.build_carrot_shelf = function()
	local carrot_shelf = {}
	local carrot_buffer_list = {}
	local active_carrot_buffer = nil

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

	function carrot_shelf:push_buffer(buffer_id)
		if self:check_is_buffer_exist(buffer_id) == nil then
			table.insert(carrot_buffer_list, buffer.build_carrot_buffer(buffer_id))
		end
	end

	function carrot_shelf:pull_buffer(buffer_id)
		local carrot_buffer = self:check_is_buffer_exist(buffer_id)
		if carrot_buffer ~= nil then
			table.remove(carrot_buffer_list, carrot_buffer)
		end
	end

	function carrot_shelf:check_is_buffer_exist(buffer_info)
		if type(buffer_info) == "number" then
			for index, value in ipairs(carrot_buffer_list) do
				if value:get_buffer_id() == buffer_info then
					return index
				end
			end
		else
			for index, value in ipairs(carrot_buffer_list) do
				if value == buffer_info then
					return index
				end
			end
		end

		return nil
	end

	return carrot_shelf
end

M.draw_carrot_shelf = function(target_carrot_shelf, available_width)
	local active_carrot_buffer = target_carrot_shelf:get_active_buffer()
	local sections = {}

	for _, current_buffer in pairs(target_carrot_shelf:get_buffer_list()) do
		table.insert(
			sections,
			buffer.draw_carrot_buffer(current_buffer, current_buffer == active_carrot_buffer) .. "%#SignColumn#"
		)
	end

	local section = utils.overlay_strings("%#SignColumn#" .. string.rep(" ", available_width), table.concat(sections))
	return section
end

return M
