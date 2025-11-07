local frame = { color = { 0, 0, 0, 0.25 }, outline = { 1, 1, 1, 1 } }
frame.gui = nil
frame.__index = frame

local DEFAULT_FRAME_CONTENTS_OFFSET = Vector.new(5, 2)
local FRAME_CONTENTS_TO_TITLE_OFFSET = Vector.new(0, 13)

local FRAME_HEADER_FONT = love.graphics.newFont(20, "mono", 5)

---@enum GUI_LAYOUTS
local GUI_LAYOUTS = {
	VERTICAL = 1,
}

function frame:newFrame(position, scale)
	local newFrame = {
		position = position,
		scale = scale,
		elements = {},
		region = frame.gui.registerRegion("blocker", position, scale),
	}
	return setmetatable(newFrame, frame)
end

function frame:addLabel(text, position)
	self.elements[#self.elements + 1] = frame.gui.label.new(text, position)
end

function frame:addCheckBox(position)
	self.elements[#self.elements + 1] = frame.gui.checkBox.new()
end

function frame:addElement(element)
	self.elements[#self.elements + 1] = element
end

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

local function drawElementsVertically(elements)
	for _, element in ipairs(elements) do
		element:draw()
		if element.region then
			frame.gui.addRegion(element.region)
		end
		love.graphics.translate(0, element.size.y)
	end
end

local function drawElementsAbsolute(elements)
	for _, element in ipairs(elements) do
		love.graphics.push()
		element.position = element.position or Vector.new(0, 0)
		love.graphics.translate(element.position.x, element.position.y)
		element:draw()
		if element.region then
			frame.gui.addRegion(element.region)
		end
		love.graphics.pop()
	end
end

function frame:draw()
	love.graphics.push()
	love.graphics.translate(-editor.camera.x, -editor.camera.y)
	love.graphics.translate(self.position.x - self.scale.x / 2, self.position.y - self.scale.y / 2)

	local x, y = love.graphics.transformPoint(0, 0)
	self.region.position = Vector.new(x, y)
	if self.region then
		frame.gui.addRegion(self.region)
	end

	local content_offset = DEFAULT_FRAME_CONTENTS_OFFSET
	local content_to_title_offset = Vector.new(0, 0)

	if self.title then
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

	if self.layout == GUI_LAYOUTS.VERTICAL then
		drawElementsVertically(self.elements)
	else
		drawElementsAbsolute(self.elements)
	end

	love.graphics.pop()

	if self.title then
		drawHeader(self)
	end
	love.graphics.pop()
end

return frame
