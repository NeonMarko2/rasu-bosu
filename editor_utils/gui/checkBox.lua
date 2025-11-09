---@class CheckBox
checkBox = element:extend()

---@class CheckBox : Element
---@field value boolean
---@field region Region
---@overload fun() : CheckBox

---@private
function checkBox:new()
	checkBox.super.new(self, Udimen.new(), Udimen.new(0, 0, 30, 35))
	self.value = true
	local region = gui.createRegion("clickable", Vector.new(3, 5), Vector.new(30, 30))
	local on_click = function()
		return self:toggle()
	end
	self.region = region
	self.region.activated.sub(on_click)
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
	if gui.getCurrentlyHoveringOver() == self.region then
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.rectangle("fill", 0, 0, 30, 30)
	end
	if self.value == true then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 5, 5, 20, 20, 3, 3)
	end
end

---@private
function checkBox.__tostring()
	return "CheckBox"
end

return checkBox
