local editor = {}

local camera_pos = Vector.new(0, 0)
local camera_speed = 75

local DEFAULT_GRID_SIZE = 40

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
end

function editor:draw()
	love.graphics.push()
	love.graphics.translate(camera_pos.x, camera_pos.y)
	drawGrid(40)
	love.graphics.pop()
end

return editor
