local vector2 = {}

---@class Vector
local vectorBase = { x = 0, y = 0 }

local function addVectors(a, b)
	if (a.x and b.x) and (a.y and b.y) then
		local ax, ay, bx, by = a.x, a.y, b.x, b.y
		ax = ax + bx
		ay = ay + by
		return vector2.new(ax, ay)
	else
		error("Trying to add non vectors together")
	end
end

local function subVectors(a, b)
	if (a.x and b.x) and (a.y and b.y) then
		local ax, ay, bx, by = a.x, a.y, b.x, b.y
		ax = ax - bx
		ay = ay - by
		return vector2.new(ax, ay)
	else
		error("Trying to sub non vectors together")
	end
end

local function multiplyVector(a, b)
	if type(a) == "number" and type(b) == "table" then
		local c = a
		a = b
		b = c
	end
	if type(b) ~= "number" then
		error("Cant multiply vector by non numbers")
	end

	local ax, ay = a.x, a.y

	ax = ax * b
	ay = ay * b

	return vector2.new(ax, ay)
end

local function divideVector(a, b)
	if type(b) ~= "number" then
		error("Cant divide vector by non numbers")
	end

	local ax, ay = a.x, a.y

	ax = ax / b
	ay = ay / b

	return vector2.new(ax, ay)
end

local function tableToString(table)
	return "x: " .. table.x .. ",   y: " .. table.y .. " "
end

local function unaryMinus(table)
	return vector2.new(-table.x, -table.y)
end

function vectorBase:magnitude()
	local x, y = 0, 0
	x = self.x * self.x
	y = self.y * self.y
	return math.sqrt(x + y)
end

---returns a copy of the vector
---@return Vector
function vectorBase:copy()
	return vector2.new(self.x, self.y)
end

---@param point Vector
function vectorBase:dot(point)
	local x, y = self.x, self.y
	return x * point.x + y * point.y
end

---Normalizes the calling vector,
---turning it into a unit vector
function vectorBase:normalized()
	local magnitude = self:magnitude()
	return vector2.new(self.x / magnitude, self.y / magnitude)
end

---@private
vectorBase.__add = addVectors
---@private
vectorBase.__sub = subVectors
---@private
vectorBase.__mul = multiplyVector
---@private
vectorBase.__div = divideVector
---@private
vectorBase.__tostring = tableToString
---@private
vectorBase.__unm = unaryMinus
---@private
vectorBase.__index = vectorBase

---@param xPos number
---@param yPos number
---@return Vector
function vector2.new(xPos, yPos)
	local vector = { x = xPos, y = yPos }

	return setmetatable(vector, vectorBase)
end

return vector2
