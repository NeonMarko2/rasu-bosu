local gui = {}

---@class Frame
---@field position Vector
---@field scale Vector
---@field elements table
local frame = { color = { 0, 0, 0, 0.25 }, outline = { 1, 1, 1, 1 }, elements = {} }
---@private
frame.__index = frame

local TYPE_LABEL = 1

function frame:addLabel(text, position)
	self.elements[#self.elements + 1] = { type = TYPE_LABEL, position = position, text = text }
end

local FRAME_HEADER_FONT = love.graphics.newFont(20, "mono", 5)

---@enum GUI_LAYOUTS
local GUI_LAYOUTS = {
	VERTICAL = 1,
}

local DEFAULT_FRAME_CONTENTS_OFFSET = Vector.new(5, 2)
local FRAME_CONTENTS_TO_TITLE_OFFSET = Vector.new(0, 13)

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

local function drawElement(element, frame)
	if element.type == TYPE_LABEL then
		love.graphics.setColor(1, 1, 1, 1)

		if frame.layout == GUI_LAYOUTS.VERTICAL then
			love.graphics.print(element.text, 0, 0)
			love.graphics.translate(0, love.graphics.getFont():getHeight())
		else
			element.position = element.position or {}
			element.position.x = element.position.x or 0
			element.position.y = element.position.y or 0
			love.graphics.print(element.text, element.position.x, element.position.y)
		end
	end
end

function frame:draw()
	love.graphics.translate(-editor.camera.x, -editor.camera.y)
	love.graphics.translate(self.position.x - self.scale.x / 2, self.position.y - self.scale.y / 2)

	local content_offset = DEFAULT_FRAME_CONTENTS_OFFSET
	local content_to_title_offset = Vector.new(0, 0)

	if frame.title then
		setHeaderStencil(self)
		content_to_title_offset = FRAME_CONTENTS_TO_TITLE_OFFSET
	end

	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, self.scale.x, self.scale.y, 5, 5)
	love.graphics.setColor(self.outline)
	love.graphics.rectangle("line", 0, 0, self.scale.x, self.scale.y, 5, 5)

	love.graphics.push()
	love.graphics.translate(content_offset.x, content_offset.y)
	love.graphics.translate(content_to_title_offset.x, content_to_title_offset.y)

	for index, value in ipairs(self.elements) do
		drawElement(value, self)
	end

	love.graphics.pop()

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
