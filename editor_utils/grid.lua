local grid_utility = {}

local grid_meta = { cell_size = 40 }
grid_meta.__index = grid_meta

function grid_meta:mouseToGrid()
	local mouse_x, mouse_y = love.mouse.getPosition()
	local offset = editor.camera
	mouse_x, mouse_y = mouse_x - offset.x, mouse_y - offset.y
	mouse_x = math.floor(mouse_x / self.cell_size)
	mouse_y = math.floor(mouse_y / self.cell_size)
	return mouse_x, mouse_y
end

function grid_meta:positionToGrid(position_x, position_y)
	position_x = math.floor(position_x / self.cell_size)
	position_y = math.floor(position_y / self.cell_size)
	return position_x, position_y
end

function grid_meta:gridToPosition(grid_x, grid_y)
	return grid_x * self.cell_size, grid_y * self.cell_size
end

function grid_meta:draw(offset)
	love.graphics.push()

	offset = offset or 0
	local cell_size = self.cell_size

	love.graphics.translate(
		-math.floor(editor.camera.x / cell_size) * cell_size,
		-math.floor(editor.camera.y / cell_size) * cell_size
	)

	local GRID_HORIZONTAL_LENGTH = love.graphics.getWidth() / cell_size
	local GRID_VERTICAL_LENGTH = love.graphics.getHeight() / cell_size

	for x = -1, GRID_HORIZONTAL_LENGTH, 1 do
		for y = -1, GRID_VERTICAL_LENGTH, 1 do
			love.graphics.rectangle("line", x * cell_size, y * cell_size, cell_size, cell_size)
		end
	end
	love.graphics.pop()
end

function grid_utility.newGrid(cell_size)
	local grid = { cell_size = cell_size }
	return setmetatable(grid, grid_meta)
end

return grid_utility
