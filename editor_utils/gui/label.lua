label = {}
label.__index = label

function label:setText(text)
	self.text = text
	local font = love.graphics.getFont()
	self.size = Vector.new(font:getWidth(text), font:getHeight())
end

function label.new(parent, text, position)
	local newLabel = { type = 1, text = "", position = position, parent = parent }
	setmetatable(newLabel, label)
	newLabel:setText(text)
	return newLabel
end

function label:draw()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(self.text, 0, 0)
end

return label
