Vector = require("libs.vectors")
Signal = require("libs.signal")
Console = require("libs.console")
Input = require("libs.input")
Serializer = require("libs.jsonlizer")
local editor = require("editor")

function love.load()
	editor:load()
end

function love.update(dt)
	editor:update(dt)
end

function love.keypressed(key)
	Input:sendInput(key, "began")
end

function love.wheelmoved(x, y)
	Input:sendScrolled(x, y)
end

function love.draw()
	editor:draw()
	Console:draw()
end
