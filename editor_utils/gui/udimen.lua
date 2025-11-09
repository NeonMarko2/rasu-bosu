local udimen = {}

local udimen_meta = {}
udimen_meta.__index = udimen_meta

---@class Udimen Stands for User Interface Dimension
---@field x_relative number
---@field y_relative number
---@field x_absolute number
---@field y_absolute number

---@overload fun()
---@return Udimen
function udimen.new(x_relative, y_relative, x_absolute, y_absolute)
	x_relative = x_relative or 0
	y_relative = y_relative or 0
	x_absolute = x_absolute or 0
	y_absolute = y_absolute or 0
	local udimen =
		{ x_relative = x_relative, y_relative = y_relative, x_absolute = x_absolute, y_absolute = y_absolute }
	return setmetatable(udimen, udimen_meta)
end

return udimen
