---@class Label
label = element:extend()

---@class Label : Element
---@field text string You _can_ assign the text directly, however the labels size wont change to fit the text
---@overload fun(text:string, position:Udimen): Label

---@private
function label:new(text, position)
	label.super.new(self, position, Udimen.new())
	self.text = text
	self:setText(text)
end

function label:setText(text)
	self.text = text
	local font = love.graphics.getFont()
	self.real_size = Vector.new(font:getWidth(text), font:getHeight())
end

function label:draw()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(self.text, 0, 0)
end

---@private
function label.__tostring()
	return "Label"
end

return label
