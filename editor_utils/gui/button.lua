button = element:extend()

---@class Button : Element
---@field region Region
---@overload fun(position: Udimen, size: Udimen, on_click: function)

function button:new(position, size, on_click)
	button.super.new(self, position, size)
	self.region = gui.createRegion("clickable", self.real_position, self.real_size)
	self.region.activated.sub(on_click)
end

function button:draw()
	local x, y = love.graphics.transformPoint(0, 0)
	self.region.position = Vector.new(x, y)
	love.graphics.setColor(1, 1, 1, 0)
	if gui.getCurrentlyHoveringOver() == self.region then
		love.graphics.setColor(1, 1, 1, 0.2)
	end
	love.graphics.rectangle("fill", 0, 0, self.real_size.x, self.real_size.y, 5, 5)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", 0, 0, self.real_size.x, self.real_size.y, 5, 5)
	gui.registerRegion(self.region)
end
