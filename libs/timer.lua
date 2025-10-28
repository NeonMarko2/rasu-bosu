---@class timer
local timer = {}
---@private
timer.__index = timer

---@private
timer.requests = {}

---@param seconds number
---@param func function
function timer:after(seconds, func)
	self.requests[#self.requests + 1] = {
		type = "after",
		time = seconds,
		func = func,
	}
end

---@param seconds number
---@param func function
function timer:every(seconds, func)
	self.requests[#self.requests + 1] = {
		type = "every",
		time = seconds,
		originalTime = seconds,
		func = func,
	}
end

---@param seconds number
---@param func function
function timer:forr(seconds, func)
	self.requests[#self.requests + 1] = {
		type = "for",
		time = seconds,
		func = func,
	}
end

---@param func function
---Iterates through all requests and cancels
---every single one with the given function
function timer:cancel(func)
	for index, request in ipairs(self.requests) do
		if request.func == func then
			table.remove(self.requests, index)
		end
	end
end

---Ticks down the timers
function timer:update(dt)
	for index, request in ipairs(self.requests) do
		request.time = request.time - dt

		if request.time <= 0 then
			if request.type == "after" then
				request.func()
				table.remove(self.requests, index)
			elseif request.type == "every" then
				request.func()
				request.time = request.time + request.originalTime
			elseif request.type == "for" then
				table.remove(self.requests, index)
			end
		end

		if request.type == "for" then
			request.func()
		end
	end
end

---@return timer
---Creates a new timer that functions independently
---from the global timer
function timer:group()
	local newGroup = { requests = {} }
	return setmetatable(newGroup, timer)
end

return timer
