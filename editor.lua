editor = {}

editor_environment = {}

_ENV = editor_environment

editor.level_data = {}

editor.camera = Vector.new(0, 0)
local camera_speed = 75

editor.export_requested = Signal.new()

editor.utility = {}
editor.utility.grid = require("editor_utils.grid")
editor.utility.gui = require("editor_utils.gui")
Udimen = require("editor_utils.gui.udimen")

local editing_state = require("gridint_state")

editor.config = require("editor_config")

local state_name_label = editor.utility.gui:newFrame(Udimen.new(), Udimen.new(), { fit_content = true })
state_name_label:addElement(label("State", Udimen.new()))

local mouse_position_label =
	frame(Udimen.new(1, 1, -15, -15), Udimen.new(), { fit_content = true, anchor = Vector.new(1, 1) }):addElement(
		label("Mouse Position", Udimen.new())
	)

state_name_label.anchor = Vector.new(0, 1)

function editor.utility.drawStateNameLabel()
	love.graphics.translate(10, love.graphics.getHeight() - 15)
	state_name_label:draw()
end

editor.utility.state_name_label = state_name_label

Input.input_began.sub(function(key)
	if key == "o" then
		editor.export_requested()
		local file = io.open("exported_level.json", "w")
		file:write(TableToJson(editor.level_data))
		io.close(file)
	end
end)

function editor:load() end

function editor:update(dt)
	local camera_move_x, camera_move_y = 0, 0
	if love.keyboard.isDown("a") then
		camera_move_x = camera_move_x - 1
	elseif love.keyboard.isDown("d") then
		camera_move_x = camera_move_x + 1
	end
	if love.keyboard.isDown("w") then
		camera_move_y = camera_move_y - 1
	elseif love.keyboard.isDown("s") then
		camera_move_y = camera_move_y + 1
	end

	editor.camera = editor.camera - Vector.new(camera_move_x, camera_move_y) * camera_speed * dt

	editor.utility.gui:updateRegions()

	if editing_state then
		editing_state:update(dt)
	end
end

function editor:draw()
	love.graphics.push()
	love.graphics.translate(editor.camera.x, editor.camera.y)
	love.graphics.push()

	editor.utility.gui.resetRegisters()
	if editing_state then
		editing_state:draw()
	end

	if editor.config.draw_registers then
		editor.utility.gui:drawRegisters_Debug()
	end
	love.graphics.pop()
	local mouse_position_x, mouse_position_y = love.mouse.getPosition()
	mouse_position_x, mouse_position_y =
		math.floor(mouse_position_x - editor.camera.x), math.floor(mouse_position_y - editor.camera.y)
	mouse_position_label:setText("x: " .. mouse_position_x .. ", y: " .. mouse_position_y)
	mouse_position_label.parent:draw()
	love.graphics.pop()
end

return editor
