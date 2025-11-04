editor = {}

local camera_pos = Vector.new(0, 0)
local camera_speed = 75

local DEFAULT_GRID_SIZE = 40

editor.utility = {}
editor.utility.grid = require("editor_utils.grid")

local editing_state = require("gridint_state")

local STATE_IDENTIFIER_FONT = love.graphics.newFont(30, "mono", 5)

function editor:getCamera()
	return camera_pos
end

function editor:drawStateIdentifier(colored_text)
	love.graphics.push()
	love.graphics.translate(-camera_pos.x, -camera_pos.y)
	love.graphics.translate(0, love.graphics.getHeight())
	love.graphics.setColor(0, 0, 0, 0.8)
	love.graphics.rectangle("fill", 0, -50, STATE_IDENTIFIER_FONT:getWidth(colored_text[1]) + 25, 50)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(colored_text, STATE_IDENTIFIER_FONT, 10, -50, 999, "left")
	love.graphics.pop()
end

local function drawGrid(grid_size)
	love.graphics.push()

	grid_size = grid_size or DEFAULT_GRID_SIZE

	love.graphics.translate(
		-math.floor(camera_pos.x / grid_size) * grid_size,
		-math.floor(camera_pos.y / grid_size) * grid_size
	)

	local GRID_HORIZONTAL_LENGTH = love.graphics.getWidth() / grid_size
	local GRID_VERTICAL_LENGTH = love.graphics.getHeight() / grid_size

	for x = -1, GRID_HORIZONTAL_LENGTH, 1 do
		for y = -1, GRID_VERTICAL_LENGTH, 1 do
			love.graphics.rectangle("line", x * grid_size, y * grid_size, grid_size, grid_size)
		end
	end
	love.graphics.pop()
end

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

	camera_pos = camera_pos - Vector.new(camera_move_x, camera_move_y) * camera_speed * dt

	if editing_state then
		editing_state:update(dt)
	end
end

function editor:draw()
	love.graphics.push()
	love.graphics.translate(camera_pos.x, camera_pos.y)
	drawGrid(40)

	if editing_state then
		editing_state:draw()
	end

	love.graphics.pop()
end

return editor
