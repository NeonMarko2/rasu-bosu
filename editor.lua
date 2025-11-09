editor = {}

editor_environment = {}

_ENV = editor_environment

Udimen = require("editor_utils.gui.udimen")
editor.utility = {}
editor.utility.grid = require("editor_utils.grid")
editor.utility.gui = require("editor_utils.gui")
require("editor_state")

editor.level_data = {}

editor.camera = Vector.new(0, 0)
local camera_speed = 75

editor.export_requested = Signal.new()

editor.should_draw_state_information = true
editor.state_information_to_display = ""
local state_information_label =
	frame(Udimen.new(0, 1, 15, -15), Udimen.new(), { fit_content = true, anchor = Vector.new(0, 1) }):addElement(
		label("State Information", Udimen.new())
	)

editor.should_draw_mouse_cordinates = false
local mouse_position_label =
	frame(Udimen.new(1, 1, -15, -15), Udimen.new(), { fit_content = true, anchor = Vector.new(1, 1) }):addElement(
		label("Mouse Position", Udimen.new())
	)

local states = {}
states[1] = require("gridint_state")()
states[2] = require("sprite_state")()

local editing_state = states[1]

Input.input_began.sub(function(key)
	if key == "1" then
		editing_state = states[1]
	elseif key == "2" then
		editing_state = states[2]
	end
end)

editor.config = require("editor_config")

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
	if editor.should_draw_state_information then
		state_information_label:setText(editor.state_information_to_display)
		state_information_label.parent:draw()
	end
	if editor.should_draw_mouse_cordinates then
		local mouse_position_x, mouse_position_y = love.mouse.getPosition()
		mouse_position_x, mouse_position_y =
			math.floor(mouse_position_x - editor.camera.x), math.floor(mouse_position_y - editor.camera.y)
		mouse_position_label:setText("x: " .. mouse_position_x .. ", y: " .. mouse_position_y)
		mouse_position_label.parent:draw()
	end
	love.graphics.pop()
end

return editor
