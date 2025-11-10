local tile_state = editorState:extend()

local grid = editor.utility.grid.newGrid(40)

function tile_state:draw()
	love.graphics.setColor(1, 1, 1, 0.1)
	grid:draw()
	local x, y = grid:mouseToGrid()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", x * 40, y * 40, grid.cell_size, grid.cell_size)
	editor.state_information_to_display = "State Machine: Tile Mode"
end

return tile_state
