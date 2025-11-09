element = Object:extend()

---@class Element
---@field position Udimen
---@field size Udimen
---@field parent Element?

---@param position Udimen
---@param size Udimen
function element:new(position, size)
	self.position = position
	self.size = size
	self.real_position = Vector.new(position.x_absolute, position.y_absolute)
	self.real_size = Vector.new(size.x_absolute, size.y_absolute)
end

return element
