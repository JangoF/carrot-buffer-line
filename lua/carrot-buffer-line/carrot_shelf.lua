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

-- local utils_module = require("carrot-buffer-line/utils")
-- require("carrot-buffer-line/carrot_buffer")

-- function CarrotTabBuild(tab_id)
-- 	local CarrotTab = {}
-- 	local nvim_tab_id = tab_id

-- 	local carrot_buffer_current = 0
-- 	local carrot_buffer_list = {}

-- 	function CarrotTab:buffer_push(buffer_id)
-- 		if utils_module.check_is_buffer_valid(buffer_id) and self:get_carrot_buffer(buffer_id) == nil then
-- 			local carrot_buffer_new = CarrotBufferBuild(buffer_id)
-- 			table.insert(carrot_buffer_list, carrot_buffer_new)

-- 			return carrot_buffer_new
-- 		end

-- 		return nil
-- 	end

-- 	function CarrotTab:buffer_pull(buffer_id)
-- 		if #carrot_buffer_list == 0 then
-- 			return nil
-- 		end

-- 		local carrot_buffer_existing = self:get_carrot_buffer(buffer_id)

-- 		if not carrot_buffer_existing == nil then
-- 			if carrot_buffer_existing == carrot_buffer_current then
-- 				if carrot_buffer_existing == #carrot_buffer_list then
-- 					self:goto_previous_buffer()
-- 				else
-- 					self:goto_next_buffer()
-- 				end
-- 			end

-- 			local removed_carrot_buffer = table.remove(carrot_buffer_list, carrot_buffer_existing)

-- 			if #carrot_buffer_list == 0 then
-- 				carrot_buffer_current = 0
-- 			end

-- 			return removed_carrot_buffer
-- 		end

-- 		return nil
-- 	end

-- 	function CarrotTab:get_carrot_buffer(buffer_id)
-- 		for index, value in ipairs(carrot_buffer_list) do
-- 			if value:get_buffer_id() == buffer_id then
-- 				return index
-- 			end
-- 		end

-- 		return nil
-- 	end

-- 	function CarrotTab:set_current_buffer(buffer_id)
-- 		local carrot_buffer_existing = self:get_carrot_buffer(buffer_id)

-- 		if carrot_buffer_existing ~= nil then
-- 			carrot_buffer_current = carrot_buffer_existing
-- 		end
-- 	end

-- 	function CarrotTab:goto_buffer(index)
-- 		if #carrot_buffer_list > 0 then
-- 			if index < 1 then
-- 				carrot_buffer_current = 1
-- 			elseif index > #carrot_buffer_list then
-- 				carrot_buffer_current = #carrot_buffer_list
-- 			end
-- 		end
-- 	end

-- 	function CarrotTab:goto_next_buffer()
-- 		if carrot_buffer_current == #carrot_buffer_list then
-- 			carrot_buffer_current = 1
-- 		else
-- 			carrot_buffer_current = carrot_buffer_current + 1
-- 		end
-- 	end

-- 	function CarrotTab:goto_previous_buffer()
-- 		if carrot_buffer_current == 1 then
-- 			carrot_buffer_current = #carrot_buffer_list
-- 		else
-- 			carrot_buffer_current = carrot_buffer_current - 1
-- 		end
-- 	end

-- 	function CarrotTab:draw(available_width)
-- 		local sections = {}

-- 		for index, carrot_buffer in pairs(carrot_buffer_list) do
-- 			table.insert(sections, carrot_buffer:draw(index == carrot_buffer_current) .. "%#SignColumn#")
-- 		end

-- 		local section =
-- 			utils_module.overlay_strings("%#SignColumn#" .. string.rep(" ", available_width), table.concat(sections))
-- 		return section
-- 	end

-- 	return CarrotTab
-- end

-- return CarrotTabBuild
