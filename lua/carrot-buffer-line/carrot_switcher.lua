local shelf = require("carrot-buffer-line/carrot_shelf")
local utils = require("carrot-buffer-line/utils")

local M = {}

M.build_carrot_switcher = function()
	local carrot_switcher = {}
	local carrot_shelf_list = {}
	local active_carrot_shelf = nil

	function carrot_switcher:get_shelf_list()
		return carrot_shelf_list
	end

	function carrot_switcher:get_active_shelf()
		return active_carrot_shelf
	end

	function carrot_switcher:set_shelf_active(shelf_id)
		local carrot_shelf = self:check_is_shelf_exist(shelf_id)

		if carrot_shelf ~= nil then
			active_carrot_shelf = carrot_shelf_list[carrot_shelf]
		end
	end

	function carrot_switcher:set_shelf_inactive(shelf_id)
		local carrot_shelf = self:check_is_shelf_exist(shelf_id)

		if carrot_shelf ~= nil then
			active_carrot_shelf = nil
		end
	end

	function carrot_switcher:push_shelf(shelf_id)
		if self:check_is_shelf_exist(shelf_id) == nil then
			table.insert(carrot_shelf_list, shelf.build_carrot_shelf(shelf_id))
		end
	end

	function carrot_switcher:pull_shelf(shelf_id)
		local carrot_shelf = self:check_is_shelf_exist(shelf_id)
		if carrot_shelf ~= nil then
			return table.remove(carrot_shelf_list, carrot_shelf)
		end
	end

	function carrot_switcher:check_is_shelf_exist(shelf_id)
		for index, value in ipairs(carrot_shelf_list) do
			if value:get_shelf_id() == shelf_id then
				return index
			end
		end

		return nil
	end

	return carrot_switcher
end

M.draw_carrot_switcher = function(target_carrot_switcher, available_width)
	local function draw_tab(shelf_id, is_active)
		return (is_active and "%#CurSearch#" or "%#SignColumn#") .. " " .. shelf_id .. " "
	end

	local function draw_shelf_switcher(shelf_list, active_shelf)
		local result = {}

		for key, value in pairs(shelf_list) do
			table.insert(result, draw_tab(value:get_shelf_id(), value == active_shelf))

			if key ~= #shelf_list then
				table.insert(result, "%#StatusLine# ")
			end
		end

		return table.concat(result)
	end

	local shelf_list = target_carrot_switcher:get_shelf_list()
	local active_shelf = target_carrot_switcher:get_active_shelf()

	local shelf_switcher_string = draw_shelf_switcher(shelf_list, active_shelf)
	local shelf_switcher_string_width = utils.count_characters_excluding_patterns(shelf_switcher_string)
	local carrot_shelf_string = shelf.draw_carrot_shelf(active_shelf, available_width - shelf_switcher_string_width - 1)

	local result = carrot_shelf_string .. shelf_switcher_string
	return result
end

return M
