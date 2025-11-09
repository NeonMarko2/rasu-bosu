element = Object:extend()

---@class Element
---@field position Udimen
---@field size Udimen
---@field parent Element?
---@field private __ignore_newindex boolean

---@param position Udimen
---@param size Udimen
function element:new(position, size)
	self.__ignore_newindex = true
	self.position = position
	self.size = size
	self.__ignore_newindex = false
	self:setRealSize()
end

function element:setRealSize()
	parent_size = Vector.new(love.graphics.getWidth(), love.graphics.getHeight())
	if self.parent then
		parent_size = self.parent.real_size
	end

	self.real_position = Vector.new(
		parent_size.x * self.position.x_relative + self.position.x_absolute,
		parent_size.y * self.position.y_relative + self.position.y_absolute
	)
	self.real_size = Vector.new(
		parent_size.x * self.size.x_relative + self.size.x_absolute,
		parent_size.y * self.size.y_relative + self.size.y_absolute
	)
end

function element:__newindex(key, value)
	rawset(self, key, value)
	if self.__ignore_newindex == true then
		return
	end
	if key == "parent" or key == "position" then
		self:setRealSize()
	end
end

return element
