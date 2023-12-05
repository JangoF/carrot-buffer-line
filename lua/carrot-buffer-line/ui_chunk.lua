local M = {}
M.__index = M

function M.new(string, highlight)
	local self = setmetatable({}, M)

	self._data = string
	self._highlight = highlight

	return self
end

function M:build()
	return "%#" .. self._highlight .. "#" .. self._data
end

function M:crop_first_n_characters(value)
	self._data = string.sub(self._data, 1, value)
end

function M:crop_last_n_characters(value)
	self._data = string.sub(self._data, -value)
end

function M:get_length()
	return #self._data
end

return M
