local signal = {}

---@package
signal.__call = function(_signal, ...)
	for index, subscribedFunction in ipairs(_signal.subscribers) do
		subscribedFunction(unpack({ ... }))
	end
end

function signal.new()
	---@class Signal
	local newSignal = {}

	---@private
	newSignal.subscribers = {}

	---@param func function
	---Subscribes the given function to the signal.
	---The function gets called whenever the signal is called => signalName()
	function newSignal.sub(func)
		newSignal.subscribers[#newSignal.subscribers + 1] = func
	end

	---@param func function
	---Unsubscribes a function from the signal.
	function newSignal.unsub(func)
		for index, subscribedFunctions in ipairs(newSignal.subscribers) do
			if subscribedFunctions == func then
				table.remove(newSignal.subscribers, index)
			end
		end
	end

	return setmetatable(newSignal, signal)
end

return signal
