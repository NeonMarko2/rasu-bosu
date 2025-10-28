Vector = require("libs.vectors")
local editor = require("editor")

function love.load()
	editor:load()
end

function love.update(dt)
	editor:update(dt)
end

function love.draw()
	editor:draw()
end
