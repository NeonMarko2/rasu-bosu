local sprite_state = editorState:extend()

function sprite_state:draw()
	editor.state_information_to_display = "State Machine: Spriter Control"
end

return sprite_state
