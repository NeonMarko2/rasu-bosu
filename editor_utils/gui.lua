local gui = {}

gui.label = require("editor_utils.gui.label")
gui.checkBox = require("editor_utils.gui.checkBox")
gui.frame = require("editor_utils.gui.frame")
local checkBox = gui.checkBox
local frame = gui.frame
checkBox.gui = gui
frame.gui = gui

---@class Region Regions are used for detecting mouse events at specified areas
---@field type string Determines whether the region will detect mouse events, or block them. Used on frames to prevent mouse inputs from going through them.
---| "clickable"
---| "blocker"
---@field position Vector
---@field size Vector
---@field activated Signal When the mouse clicks while on top of the region
---@field began_hover_over Signal
---@field ended_hover_over Signal

---@type Region[]
local regions = {}

---@type Region?
local hovering_over = nil

local STATE_IDENTIFIER_FONT = love.graphics.newFont(30, "mono", 5)

function gui:newFrame(position, scale, properties, elements)
	return frame:newFrame(position, scale, properties, elements)
end

---Creates a regions used for detecting mouse events within its specifies area
---@param type string
---| "clickable"
---| "blocker"
---@param position Vector
---@param size Vector
---@return Region
function gui.createRegion(type, position, size)
	local region = {
		type = type,
		position = position,
		size = size,
		activated = Signal.new(),
		began_hover_over = Signal.new(),
		ended_hover_over = Signal.new(),
	}
	return region
end

---Allows the region/register to detect its mouse events next frame.
---
---Adds the given region to a table, which exists until the next register reset (which is usually just one frame).
---@param region Region
function gui.registerRegion(region)
	regions[#regions + 1] = region
end

---Resets the registered regions.
function gui.resetRegisters()
	regions = {}
end

---@param region Region
---@return boolean
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

---Returns whether the mouse is pointing over any UI elements (region/register).
---@return boolean
function gui.isOverUi()
	return hovering_over ~= nil
end

---If the mouse is pointing over any region, it will return that region. Otherwise it will return nil. If there are multiple regions overlapping it will return the top most one.
---@return Region?
function gui.getCurrentlyHoveringOver()
	return hovering_over
end

function gui:updateRegions()
	for i = #regions, 1, -1 do
		if isMouseOverRegion(regions[i]) then
			if hovering_over ~= regions[i] then
				regions[i].began_hover_over()
			end

			hovering_over = regions[i]
			return
		end
	end

	if hovering_over then
		hovering_over.ended_hover_over()
	end

	hovering_over = nil
end

Input.click_began.sub(function()
	if hovering_over then
		hovering_over.activated()
	end
end)

function gui:drawRegisters_Debug()
	local detected_region = false
	for i = #regions, 1, -1 do
		local value = regions[i]
		love.graphics.setColor(1, 0.3, 0.3, 0.4)
		love.graphics.push()
		if detected_region == false then
			local x, y = love.mouse.getPosition()
			if
				x > value.position.x
				and x < value.position.x + value.size.x
				and y > value.position.y
				and y < value.position.y + value.size.y
			then
				love.graphics.setColor(0.3, 1, 0.3, 0.4)
				detected_region = true
			end
		end
		love.graphics.translate(-editor.camera.x, -editor.camera.y)
		love.graphics.translate(value.position.x, value.position.y)
		love.graphics.rectangle("fill", 0, 0, value.size.x, value.size.y)
		love.graphics.pop()
	end
end

return gui
