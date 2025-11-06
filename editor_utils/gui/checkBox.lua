local checkBox = {}
checkBox.__index = checkBox
checkBox.gui = nil

function checkBox.new()
	local newBox = { size = Vector.new(30, 35), value = true, region = nil }
	local region = checkBox.gui.registerRegion("clickable", Vector.new(3, 5), Vector.new(30, 30))
	local on_click = function()
		return newBox:toggle()
	end
	newBox.region = region
	newBox.region.activated.sub(on_click)
	return setmetatable(newBox, checkBox)
end

function checkBox:toggle()
	if self.value == true then
		self.value = false
		return
	end
	self.value = true
end

function checkBox:draw()
	love.graphics.setColor(1, 1, 1, 1)
	local x, y = love.graphics.transformPoint(0, 0)
	self.region.position = Vector.new(x, y)
	love.graphics.rectangle("line", 0, 0, 30, 30, 3, 3)
	if self.value == true then
		love.graphics.rectangle("fill", 5, 5, 20, 20, 3, 3)
	end
end

return checkBox
