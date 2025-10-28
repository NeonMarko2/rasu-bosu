local editor = {}

local camera_pos = Vector.new(0, 0)
local camera_speed = 75

function drawGrid()
	love.graphics.push()
	local GRID_SIZE = 40
	love.graphics.translate(
		-math.floor(camera_pos.x / GRID_SIZE) * GRID_SIZE,
		-math.floor(camera_pos.y / GRID_SIZE) * GRID_SIZE
	)
	for x = -1, 20, 1 do
		for y = -1, 20, 1 do
			love.graphics.rectangle("line", x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE)
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
	drawGrid()
	love.graphics.pop()
end

return editor
