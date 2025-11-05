local gui = {}

---@class Frame
---@field position Vector
---@field scale Vector
local frame = { color = { 0, 0, 0, 0.25 }, outline = { 1, 1, 1, 1 }, elements = {} }
---@private
frame.__index = frame

local TYPE_LABEL = 1

function frame:addLabel(text, position)
	self.elements[#self.elements + 1] = { type = TYPE_LABEL, position = position, text = text }
end

local FRAME_HEADER_FONT = love.graphics.newFont(20, "mono", 5)

local function setHeaderStencil(frame)
	local font_length = FRAME_HEADER_FONT:getWidth(frame.title)
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			frame.scale.x / 2 - font_length / 2 - 5,
			FRAME_HEADER_FONT:getHeight() / 2,
			font_length + 10,
			-FRAME_HEADER_FONT:getHeight()
		)
	end, "replace", 1)
	love.graphics.setStencilTest("equal", 0)
end

local function drawHeader(frame)
	local font_length = FRAME_HEADER_FONT:getWidth(frame.title)
	love.graphics.setStencilTest()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(
		frame.title,
		FRAME_HEADER_FONT,
		love.math.newTransform(frame.scale.x / 2 - font_length / 2, -FRAME_HEADER_FONT:getHeight() / 2)
	)
end

local function drawElement(element)
	if element.type == TYPE_LABEL then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(element.text)
		love.graphics.translate(0, love.graphics.getFont():getHeight())
	end
end

function frame:draw()
	love.graphics.translate(-editor.camera.x, -editor.camera.y)
	love.graphics.translate(self.position.x - self.scale.x / 2, self.position.y - self.scale.y / 2)

	if frame.title then
		setHeaderStencil(self)
	end

	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, self.scale.x, self.scale.y, 5, 5)
	love.graphics.setColor(self.outline)
	love.graphics.rectangle("line", 0, 0, self.scale.x, self.scale.y, 5, 5)

	love.graphics.translate(5, 2)

	for index, value in ipairs(self.elements) do
		drawElement(value)
	end

	if frame.title then
		drawHeader(self)
	end
end

function gui:newFrame(position, scale)
	local newFrame = { position = position, scale = scale }
	return setmetatable(newFrame, frame)
end

local STATE_IDENTIFIER_FONT = love.graphics.newFont(30, "mono", 5)

function gui:drawLabel(text, position, background_color)
	local background_color = background_color or { 0, 0, 0, 0.25 }
	love.graphics.push()
	love.graphics.translate(position.x, position.y)
	love.graphics.translate(-editor.camera.x, -editor.camera.y)
	love.graphics.setColor(background_color)
	love.graphics.rectangle("fill", 0, 0, STATE_IDENTIFIER_FONT:getWidth(text) + 25, 50)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(text, STATE_IDENTIFIER_FONT, 10, 0, 999, "left")
	love.graphics.pop()
end

return gui
