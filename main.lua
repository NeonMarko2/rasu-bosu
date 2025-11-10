Object = require("libs.classic")
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

function love.filedropped(file)
	editor:fileDropped(file)
end

function love.directorydropped(path)
	editor:directoryDropped(path)
end

function love.keypressed(key)
	Input:sendInput(key, "began")

	if key == "escape" then
		love.event.quit(0)
	end
end

function love.mousepressed(x, y, button)
	Input:sendMouseInput(button, "click")
end

function love.wheelmoved(x, y)
	Input:sendScrolled(x, y)
end

function love.draw()
	editor:draw()
	Console:draw()
end
