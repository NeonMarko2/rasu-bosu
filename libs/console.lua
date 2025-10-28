local console = {}

local output = ""

local enabled = false

local font = love.graphics.newFont(25, "mono", 1)
love.graphics.setFont(font)

local shouldAlert = false

function console:open()
	enabled = true
end

function console:close()
	enabled = false
	shouldAlert = false
end

function console:toggle()
	if enabled then
		console:close()
	else
		console:open()
	end
end

local function renderConsole()
	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(1, 1, 1, 1)
	local _, lines = font:getWrap(output, love.graphics.getWidth())
	love.graphics.printf(
		output,
		love.math.newTransform(0, love.graphics.getHeight() - #lines * font:getHeight()),
		love.graphics.getWidth()
	)
end

local function renderPrintWindow()
	love.graphics.push()
	love.graphics.translate(25, 25)
	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth() / 2, font:getHeight() + 8)
	love.graphics.setColor(1, 1, 1, 1)
	local _, lines = font:getWrap(output, love.graphics.getWidth())
	love.graphics.print(lines[#lines], font, love.math.newTransform(4, 4))
	love.graphics.pop()
end

function console:draw()
	if enabled == true then
		renderConsole()
	else
		if shouldAlert then
			renderPrintWindow()
		end
	end
end

function print(arg1)
	output = output .. "\n" .. tostring(arg1)
	shouldAlert = true
end

return console
