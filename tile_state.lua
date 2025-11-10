local tile_state = editorState:extend()

local grid = editor.utility.grid.newGrid(40)

local tile_rules_frame =
	frame(Udimen.new(0, 0, 15, 100), Udimen.new(0, 0, 200, 200), { layout = 1, padding = Vector.new(0, 0) })

tile_rules_frame:addElement(
	frame(Udimen.new(), Udimen.new(1, 0, 0, 50), { outline = { 0, 0, 0, 0 }, color = { 0, 0, 1, 1 } }, {
		label("new rule ->", Udimen.new()),
		button(Udimen.new(0.8, 0, 0, 0), Udimen.new(0, 0, 30, 30), love.event.quit),
	})
)
local function create_tile_rule()
	return frame(Udimen.new(), Udimen.new(1, 0, 0, 50))
end

tile_rules_frame:addElement(create_tile_rule(), create_tile_rule())

function tile_state:draw()
	love.graphics.setColor(1, 1, 1, 0.1)
	grid:draw()
	local x, y = grid:mouseToGrid()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", x * 40, y * 40, grid.cell_size, grid.cell_size)
	tile_rules_frame:draw()
	editor.state_information_to_display = "State Machine: Tile Mode"
end

return tile_state
