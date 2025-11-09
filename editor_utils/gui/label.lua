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
	self.text = ""
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
	if self.__ignore_newindex then
		return
	end
	parent_size = Vector.new(love.graphics.getWidth(), love.graphics.getHeight())
	if self.parent then
		parent_size = self.parent.real_size
	end

	self.real_position = Vector.new(
		parent_size.x * self.position.x_relative + self.position.x_absolute,
		parent_size.y * self.position.y_relative + self.position.y_absolute
	)
	local font = love.graphics.getFont()

	local new_line_count = 1
	for words in string.gmatch(self.text, "\n") do
		new_line_count = new_line_count + 1
	end

	self.real_size = Vector.new(font:getWidth(self.text), font:getHeight() * new_line_count)
end

---@private
function label.__tostring()
	return "Label"
end

return label
