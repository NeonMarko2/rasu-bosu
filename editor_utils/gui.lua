local gui = {}

local regions = {}

local hovering_over = nil

gui.label = require("editor_utils.gui.label")
gui.checkBox = require("editor_utils.gui.checkBox")
gui.frame = require("editor_utils.gui.frame")
local checkBox = gui.checkBox
local frame = gui.frame
checkBox.gui = gui
frame.gui = gui

local STATE_IDENTIFIER_FONT = love.graphics.newFont(30, "mono", 5)

function gui:newFrame(position, scale, properties, elements)
	return frame:newFrame(position, scale, properties, elements)
end

---@param type string
---| "clickable"
---| "blocker"
---@param position Vector
---@param size Vector
---@return table
function gui.registerRegion(type, position, size)
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

function gui.resetRegisters()
	regions = {}
end

function gui.addRegion(region)
	regions[#regions + 1] = region
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

function gui.isOverUi()
	return hovering_over ~= nil
end

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
