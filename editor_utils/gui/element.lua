local element = {}

---@class Element
---@field position Vector
---@field size Vector

function element.new(position, size)
	local _element = { position = position, size = size }
	return _element
end

return element
