M = {}
M.__index = M

function M.new()
	local self = setmetatable({}, M)
	self._keys = {}
	self._map = {}
	return self
end

function M:insert(key, value)
	if not self._map[key] then
		table.insert(self._keys, key)
	end
	self._map[key] = value
end

function M:remove(key)
	local value = self._map[key]

	if value then
		self._map[key] = nil

		for i, k in ipairs(self._keys) do
			if k == key then
				table.remove(self._keys, i)
				break
			end
		end
	end

	return value
end

function M:get(key)
	return self._map[key]
end

function M:get_ordered_array()
	return self._keys
end

return M
