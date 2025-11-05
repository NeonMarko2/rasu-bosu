local intState = {}

local grid_data = {}
local current_int = 3

local COLOR_OF_VALUE = {
	{ 1, 1, 1, 0.3 },
	{ 0.2, 0.8, 0.2, 0.3 },
	{ 0.8, 0.2, 0.2, 0.3 },
	{ 0.2, 0.2, 0.8, 0.3 },
	{ 0.5, 0.5, 0.2, 0.3 },
	{ 0.5, 0.8, 0.5, 0.3 },
	{ 0.2, 0.8, 0.8, 0.3 },
	{ 0.8, 0.2, 0.8, 0.3 },
}

Input.scrolled.sub(function(_, y)
	current_int = math.max(current_int + y, 1)
end)

editor.export_requested.sub(function()
	local data = {}
	for x, collumn in pairs(grid_data) do
		for y, value in pairs(collumn) do
			data[#data + 1] = { x, y, value }
		end
	end
	editor.level_data.int_grid = data
end)

local frame = editor.utility.gui:newFrame(
	Vector.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2),
	Vector.new(200, 200)
)
local grid = editor.utility.grid.newGrid(40)

function intState:update(dt)
	if love.mouse.isDown(1) then
		local grid_x, grid_y = grid:mouseToGrid()

		grid_data[grid_x] = grid_data[grid_x] or {}
		grid_data[grid_x][grid_y] = current_int
	elseif love.mouse.isDown(2) then
		local grid_x, grid_y = grid:mouseToGrid()

		if grid_data[grid_x] then
			grid_data[grid_x][grid_y] = nil
		end
	end
end

function intState:draw()
	local x, y = grid:mouseToGrid()

	love.graphics.rectangle("fill", x * grid.cell_size, y * grid.cell_size, grid.cell_size, grid.cell_size)

	if COLOR_OF_VALUE[current_int] then
		love.graphics.setColor(COLOR_OF_VALUE[current_int])
	else
		love.graphics.setColor(1, 1, 1, 0.3)
	end

	grid:draw()

	love.graphics.setColor(1, 1, 1, 0.3)
	for _x, collumn in pairs(grid_data) do
		for _y, item in pairs(collumn) do
			if COLOR_OF_VALUE[item] then
				love.graphics.setColor(COLOR_OF_VALUE[item])
			else
				love.graphics.setColor(1, 1, 1, 0.3)
			end
			love.graphics.rectangle("fill", _x * grid.cell_size, _y * grid.cell_size, grid.cell_size, grid.cell_size)
			love.graphics.printf(item, _x * grid.cell_size, _y * grid.cell_size, grid.cell_size, "center")
		end
	end
	love.graphics.push()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.translate(0, -50)
	editor.utility.gui:drawLabel("Grid Intiger Mode", Vector.new(0, love.graphics.getHeight()))
	love.graphics.translate(0, -50)
	editor.utility.gui:drawLabel(current_int, Vector.new(0, love.graphics.getHeight()))
	love.graphics.pop()
	frame:draw()
end

return intState
