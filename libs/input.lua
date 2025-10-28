local input = {}

input.state = {}

input.actions = {
	WALK_LEFT = { "a", "left" },
	WALK_RIGHT = { "d", "right" },
	JUMP = { "space" },
	FIRE = { "j" },
	SWITCH_WEAPON_1 = { "i" },
	SWITCH_WEAPON_2 = { "o" },
	SWITCH_WEAPON_3 = { "p" },
}

function input:isDown(action_index) end

function input:setActions(table_of_actions) end

input.action_began = Signal.new()
input.action_ended = Signal.new()
input.input_began = Signal.new()
input.input_ended = Signal.new()

---@param key string
---@param input_state string
---| "began"
---| "ended"
function input:sendInput(key, input_state)
	if input_state == "began" then
		input.state[key] = key
		input.input_began(key)
	elseif input_state == "ended" then
		input.state[key] = nil
		input.input_ended(key)
	end
end

function input:group()
	local new_input = {}
	new_input.action_began = Signal.new()
	new_input.action_ended = Signal.new()
	new_input.actions = input.actions
	return setmetatable(new_input, input)
end

return input
