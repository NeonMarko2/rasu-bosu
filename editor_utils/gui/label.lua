---@class Label
label = element:extend()

---@class Label : Element
---@field text string You _can_ assign the text directly, however the labels size wont change to fit the text
---@overload fun(text:string, position:Udimen): Label

---@private
function label:new(text, position)
	self.__ignore_newindex = true
	self.position = position
	self.size = Udimen.new()
	self.__ignore_newindex = false
	self:setText(text)
end

function label:setText(text)
	self.text = text
	self:setRealSize()
end

function label:draw()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(self.text, 0, 0)
end

function label:setRealSize()
	parent_size = Vector.new(love.graphics.getWidth(), love.graphics.getHeight())
	if self.parent then
		parent_size = self.parent.real_size
	end

	self.real_position = Vector.new(
		parent_size.x * self.position.x_relative + self.position.x_absolute,
		parent_size.y * self.position.y_relative + self.position.y_absolute
	)
	local font = love.graphics.getFont()
	self.real_size = Vector.new(font:getWidth(self.text), font:getHeight())
end

---@private
function label.__tostring()
	return "Label"
end

return label
