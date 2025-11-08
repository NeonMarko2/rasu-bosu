label = element:extend()

---@class Label : Element
---@field text string
---@field setText fun(self:Label, text:string)

function label:setText(text)
	self.text = text
	local font = love.graphics.getFont()
	self.real_size = Vector.new(font:getWidth(text), font:getHeight())
end

---@param text string
---@param position Udimen
function label:new(text, position)
	label.super.new(self, position, Vector.new(0, 0))
	self.text = text
	self:setText(text)
end

function label:draw()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(self.text, 0, 0)
end

return label
