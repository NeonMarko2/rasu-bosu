local intState = {}

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

local function createFrame()
	local frame = editor.utility.gui:newFrame(
		Vector.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2),
		Vector.new(200, 200)
	)
	frame:addLabel("Frame this is")
	frame:addLabel("This is a frame", Vector.new(50, 25))
	frame:addLabel("This is a frame", Vector.new(-15, 66))
	frame:addCheckBox()
	return frame
end

local current_int_label =
	editor.utility.gui:newFrame(Vector.new(0, 0), Vector.new(0, 0)):addLabel(current_int, Vector.new(0, 0))
current_int_label.parent.fit_content = true
current_int_label.parent.anchor = Vector.new(0, 1)

local frame = createFrame()
local frame2 = createFrame()

frame2["title"] = "Title"
frame2.layout = 1

frame.anchor = Vector.new(0.5, 0.5)
frame2.anchor = Vector.new(0.5, 0.5)

frame.position.x = frame.position.x - 150
frame2.position.x = frame2.position.x + 150

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
	if editor.utility.gui.isOverUi() == false then
		love.graphics.rectangle("fill", x * grid.cell_size, y * grid.cell_size, grid.cell_size, grid.cell_size)
	end

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

	frame:draw()
	frame2:draw()

	editor.utility.state_name_label.elements[1]:setText("Integer Grid")
	editor.utility.drawStateNameLabel()
	love.graphics.translate(0, -current_int_label.parent.size.y)
	current_int_label:setText(current_int)
	current_int_label.parent:draw()
end

return intState
