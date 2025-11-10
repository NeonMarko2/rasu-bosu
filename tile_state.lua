local tile_state = editorState:extend()

local frame = frame(
	Udimen.new(0, 0, 15, 100),
	Udimen.new(0, 0, 200, 200),
	{ layout = 1 },
	{ checkBox(), button(Udimen.new(), Udimen.new(0, 0, 50, 50), function()
		error("Busted!")
	end) }
)

function tile_state:draw()
	frame:draw()
	editor.state_information_to_display = "State Machine: Tile Mode"
end

return tile_state
