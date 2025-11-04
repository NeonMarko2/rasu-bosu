local intState = {}

local grid_data = {}
local draw_mode = "solid"

local current_value = 3

local COLOR_OF_VALUE =
	{ { 1, 1, 1, 0.3 }, { 0.2, 0.8, 0.2, 0.3 }, { 0.8, 0.2, 0.2, 0.3 }, { 0.2, 0.2, 0.8, 0.3 }, { 0.5, 0.5, 0.2, 0.3 } }

Input.scrolled.sub(function(x, y)
	current_value = math.max(current_value + y, 1)
end)

local grid = editor.utility.grid.newGrid(40)

function intState:update(dt)
	local camera_pos = editor:getCamera()
	if love.mouse.isDown(1) then
		local mouse_x, mouse_y = love.mouse.getPosition()
		grid_x, grid_y = grid:mouseToGrid(mouse_x, mouse_y, camera_pos)

		grid_data[grid_x] = grid_data[grid_x] or {}
		grid_data[grid_x][grid_y] = current_value
	elseif love.mouse.isDown(2) then
		local mouse_x, mouse_y = love.mouse.getPosition()
		grid_x, grid_y = grid:mouseToGrid(mouse_x, mouse_y, Vector.new(camera_pos.x, camera_pos.y))

		if grid_data[grid_x] then
			grid_data[grid_x][grid_y] = nil
		end
	end
end

function intState:draw()
	local mouse_x, mouse_y = love.mouse.getPosition()
	local camera_pos = editor:getCamera()
	local x, y = grid:mouseToGrid(mouse_x, mouse_y, camera_pos)

	love.graphics.rectangle("fill", x * 40, y * 40, 40, 40)

	love.graphics.setColor(1, 1, 1, 0.3)
	for _x, collumn in pairs(grid_data) do
		for _y, item in pairs(collumn) do
			if COLOR_OF_VALUE[item] then
				love.graphics.setColor(COLOR_OF_VALUE[item])
			else
				love.graphics.setColor(1, 1, 1, 0.3)
			end
			love.graphics.rectangle("fill", _x * 40, _y * 40, 40, 40)
			love.graphics.printf(item, _x * 40, _y * 40, 40, "center")
		end
	end
	love.graphics.setColor(1, 1, 1, 1)
	editor:drawStateIdentifier({ "Grid Intiger Mode", { 1, 1, 1, 1 } })
	love.graphics.translate(0, -50)
	editor:drawStateIdentifier({ current_value, COLOR_OF_VALUE[current_value] })
end

return intState
