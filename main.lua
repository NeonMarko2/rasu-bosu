Vector = require("libs.vectors")
Signal = require("libs.signal")
Console = require("libs.console")
Input = require("libs.input")
local editor = require("editor")

function love.load()
	editor:load()
	print(love.system.getOS())
end

function love.update(dt)
	editor:update(dt)
end

function love.wheelmoved(x, y)
	Input:sendScrolled(x, y)
end

function love.draw()
	editor:draw()
	Console:draw()
end
