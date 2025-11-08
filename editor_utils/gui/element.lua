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
	self.real_position = position
	self.real_size = size
end

return element
