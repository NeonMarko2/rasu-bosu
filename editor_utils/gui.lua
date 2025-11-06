local gui = {}

---@class Frame
---@field position Vector
---@field scale Vector
---@field elements? table
local frame = { color = { 0, 0, 0, 0.25 }, outline = { 1, 1, 1, 1 }, elements = {}, title = "Title" }
---@private
frame.__index = frame

local regions = {}

local label = require("editor_utils.gui.label")
local checkBox = require("editor_utils.gui.checkBox")
checkBox.gui = gui

function frame:addLabel(text, position)
	self.elements[#self.elements + 1] = label.new(text, position)
end

function frame:addCheckBox(position)
	self.elements[#self.elements + 1] = checkBox.new()
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

---@param type string
---| "clickable"
---| "blocker"
---@param position Vector
---@param size Vector
---@return table
function gui.registerRegion(type, position, size)
	local region = { type = type, position = position, size = size, activated = Signal.new() }
	regions[#regions + 1] = region
	return region
end

local function isMouseOverRegion(region)
	local x, y = love.mouse.getPosition()
	if
		x > region.position.x
		and x < region.position.x + region.size.x
		and y > region.position.y
		and y < region.position.y + region.size.y
	then
		return true
	end
	return false
end

function gui:updateRegions()
	local x, y = love.mouse.getPosition()
	for index, region in ipairs(regions) do
		if
			x > region.position.x
			and x < region.position.x + region.size.x
			and y > region.position.y
			and y < region.position.y + region.size.y
		then
		end
	end
end

Input.click_began.sub(function()
	gui.detectClickedRegions()
end)

function gui.detectClickedRegions()
	for index, region in ipairs(regions) do
		if isMouseOverRegion(region) then
			region.activated()
		end
	end
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

local function drawElementsVertically(frame, elements)
	for index, element in ipairs(elements) do
		element:draw()
		if frame.layout == GUI_LAYOUTS.VERTICAL then
			love.graphics.translate(0, element.size.y)
		end
	end
end

local function drawElementsAbsolute(frame, elements)
	for index, element in ipairs(elements) do
		love.graphics.push()
		element.position = element.position or Vector.new(0, 0)
		love.graphics.translate(element.position.x, element.position.y)
		element:draw()
		love.graphics.pop()
	end
end

function frame:draw()
	love.graphics.push()
	love.graphics.translate(-editor.camera.x, -editor.camera.y)
	love.graphics.translate(self.position.x - self.scale.x / 2, self.position.y - self.scale.y / 2)

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
		drawElementsVertically(self, self.elements)
	else
		drawElementsAbsolute(self, self.elements)
	end

	love.graphics.pop()

	if self.title then
		drawHeader(self)
	end
	love.graphics.pop()
end

function gui:newFrame(position, scale)
	local newFrame = { position = position, scale = scale, elements = {} }
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

function gui:drawRegisters_Debug()
	for index, value in ipairs(regions) do
		love.graphics.setColor(1, 0.3, 0.3, 0.4)
		love.graphics.push()
		local x, y = love.mouse.getPosition()
		if
			x > value.position.x
			and x < value.position.x + value.size.x
			and y > value.position.y
			and y < value.position.y + value.size.y
		then
			love.graphics.setColor(0.3, 1, 0.3, 0.4)
		end
		love.graphics.translate(-editor.camera.x, -editor.camera.y)
		love.graphics.translate(value.position.x, value.position.y)
		love.graphics.rectangle("fill", 0, 0, value.size.x, value.size.y)
		love.graphics.pop()
	end
end

return gui
