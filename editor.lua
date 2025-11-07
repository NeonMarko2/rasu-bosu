editor = {}

editor.level_data = {}

editor.camera = Vector.new(0, 0)
local camera_speed = 75

editor.export_requested = Signal.new()

editor.utility = {}
editor.utility.grid = require("editor_utils.grid")
editor.utility.gui = require("editor_utils.gui")

local editing_state = require("gridint_state")

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

	editor.utility.gui.resetRegisters()
	if editing_state then
		editing_state:draw()
	end

	-- editor.utility.gui:drawRegisters_Debug()
	love.graphics.pop()
end

return editor
