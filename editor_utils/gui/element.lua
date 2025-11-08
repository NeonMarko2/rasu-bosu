element = {}

---@class Element
---@field position Udimen
---@field size Udimen
---@field parent Element?

---@param position Udimen
---@param size Udimen
function element.new(position, size)
	local _element = { position = position, size = size }
	return _element
end

return element
