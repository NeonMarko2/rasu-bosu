local intState = editorState:extend()

local grid_data = {}
local current_int = 3

local COLOR_OF_INT = {
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

local current_int_label =
	frame(Udimen.new(), Udimen.new(), { fit_content = true, anchor = Vector.new(0, 1) }):addElement(
		label(current_int, Udimen.new())
	)

local grid = editor.utility.grid.newGrid(40)

function intState:update(dt)
	if editor.utility.gui.isOverUi() then
		return
	end
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

	if COLOR_OF_INT[current_int] then
		love.graphics.setColor(COLOR_OF_INT[current_int])
	else
		love.graphics.setColor(1, 1, 1, 0.3)
	end

	grid:draw()

	love.graphics.setColor(1, 1, 1, 0.3)
	for _x, collumn in pairs(grid_data) do
		for _y, item in pairs(collumn) do
			if COLOR_OF_INT[item] then
				love.graphics.setColor(COLOR_OF_INT[item])
			else
				love.graphics.setColor(1, 1, 1, 0.3)
			end
			love.graphics.rectangle("fill", _x * grid.cell_size, _y * grid.cell_size, grid.cell_size, grid.cell_size)
			love.graphics.printf(item, _x * grid.cell_size, _y * grid.cell_size, grid.cell_size, "center")
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	if editor.utility.gui.isOverUi() == false then
		love.graphics.rectangle("line", x * grid.cell_size, y * grid.cell_size, grid.cell_size, grid.cell_size)
	end

	editor.state_information_to_display = "Current int: " .. current_int .. "\n" .. "State Machine: Integer Grid"
	love.graphics.translate(0, -current_int_label.parent.real_size.y)
end

return intState
