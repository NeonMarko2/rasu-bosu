local grid_utility = {}

local grid_meta = { cell_size = 40 }
grid_meta.__index = grid_meta

function grid_meta:mouseToGrid(mouse_x, mouse_y, offset)
	mouse_x, mouse_y = mouse_x - offset.x, mouse_y - offset.y
	mouse_x = math.floor(mouse_x / self.cell_size)
	mouse_y = math.floor(mouse_y / self.cell_size)
	return mouse_x, mouse_y
end

function grid_meta:draw(offset) end

function grid_utility.newGrid(cell_size)
	local grid = { cell_size = cell_size }
	return setmetatable(grid, grid_meta)
end

return grid_utility
