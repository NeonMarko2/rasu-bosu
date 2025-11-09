---@class Frame
frame = element:extend()
local color = { 0, 0, 0, 0.25 }
local outline = { 1, 1, 1, 1 }
local anchor = Vector.new(0, 0)

local DEFAULT_FRAME_CONTENTS_OFFSET = Vector.new(5, 2)
local FRAME_CONTENTS_TO_TITLE_OFFSET = Vector.new(0, 13)

local FRAME_HEADER_FONT = love.graphics.newFont(20, "mono", 5)

---@enum GUI_LAYOUTS
local GUI_LAYOUTS = {
	VERTICAL = 1,
}

---@class Frame : Element A base container for all drawing elements
---@field elements any
---@field region Region
---@field color table
---@field outline table
---@field anchor Vector Marks where the top left of the ui is. 0,  0 is top left. 0.5,  0.5 is center. 1,  1 is bottom right
---@field layout GUI_LAYOUTS How the elements should be positioned
---@overload fun(position:Udimen, size:Udimen, properties:table?, elements:table<Element>?): Frame

---=============================================================

---@private
function frame:new(position, size, properties, elements)
	frame.super.new(self, position, size)
	self.elements = {}
	self.color = color
	self.outline = outline
	self.anchor = anchor
	self.region = gui.createRegion("blocker", self.real_position, self.real_size)
	if properties then
		for key, property in pairs(properties) do
			self[key] = property
		end
	end
	if elements then
		for _, element in ipairs(elements) do
			self.elements[#self.elements + 1] = element
			element.parent = self
		end
	end
end

---@param ...? Element
function frame:addElement(...)
	for _, element in ipairs({ ... }) do
		self.elements[#self.elements + 1] = element
		element.parent = self
	end
	if #{ ... } == 1 then
		return ...
	end
	return { ... }
end

local function setHeaderStencil(frame)
	local font_length = FRAME_HEADER_FONT:getWidth(frame.title)
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			frame.real_size.x / 2 - font_length / 2 - 5,
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
		love.math.newTransform(frame.real_size.x / 2 - font_length / 2, -FRAME_HEADER_FONT:getHeight() / 2)
	)
end

local function drawElementsVertically(elements)
	for _, element in ipairs(elements) do
		element:draw()
		if element.region then
			gui.registerRegion(element.region)
		end
		love.graphics.translate(0, element.real_size.y)
	end
end

local function drawElementsAbsolute(elements)
	for _, element in ipairs(elements) do
		love.graphics.push()
		love.graphics.translate(element.real_position.x, element.real_position.y)
		element:draw()
		if element.region then
			gui.registerRegion(element.region)
		end
		love.graphics.pop()
	end
end

function frame:draw()
	love.graphics.push()
	if self.parent == nil then
		love.graphics.translate(-editor.camera.x, -editor.camera.y)
	end

	local position = self.real_position
	local size = self.real_size

	love.graphics.translate(position.x - (size.x * self.anchor.x), position.y - (size.y * self.anchor.y))

	local x, y = love.graphics.transformPoint(0, 0)
	self.region.position = Vector.new(x, y)
	if self.region then
		gui.registerRegion(self.region)
	end

	local content_offset = DEFAULT_FRAME_CONTENTS_OFFSET
	local content_to_title_offset = Vector.new(0, 0)

	if self.title then
		setHeaderStencil(self)
		content_to_title_offset = FRAME_CONTENTS_TO_TITLE_OFFSET
	end

	if self.fit_content then
		local width, height = 0, 0
		for index, element in ipairs(self.elements) do
			if element.real_size and element.real_size.y then
				height = height + element.real_size.y
			end
			if element.real_size and element.real_size.x and element.real_size.x > width then
				width = element.real_size.x
			end
		end
		width = width + content_offset.x * 2
		height = height + content_offset.y * 2
		self.real_size = Vector.new(width, height)
	end

	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, size.x, size.y, 5, 5)
	love.graphics.setColor(self.outline)
	love.graphics.rectangle("line", 0, 0, size.x, size.y, 5, 5)

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

---@private
function frame.__tostring()
	return "Frame"
end

return frame
