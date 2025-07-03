-- This project can be run as a Love2D game, where main.lua is the entry point.
function love.load()
    local images = {}
    images.far = love.graphics.newImage("stars/far.png")
    images.mid = love.graphics.newImage("stars/mid.png")
    images.near = love.graphics.newImage("stars/near.png")

    -- Create the lookout view
    local lookout = require("lookout")
    local layerData = {
        { img = images.far, depth = 8 },
        { img = images.mid, depth = 4 },
        { img = images.near, depth = 2 },
    }

    local viewArgs = { spoofX = 1000 } -- Initial spoof direction
    view = lookout:newView(layerData, viewArgs)
    view.font = love.graphics.newFont(16) -- Set a font for the view
end

function love.update(dt)
    local mag = 1000
    local dirX, dirY = getDirFromKeyboard()
    if dirX ~= 0 or dirY ~= 0 then view:setSpoofDir(dirX * mag, dirY * mag) end

    local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    view:update(dt, centerX, centerY)
end

function love.draw()
    love.graphics.setColor(1,1,1,1)
    view:draw()
    
    love.graphics.setFont(view.font)
    love.graphics.print("Steer with the arrow keys!", 10, 10)
end

function getDirFromKeyboard()
    local dirX, dirY = 0, 0
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then dirX = -1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then dirX = 1 end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then dirY = -1 end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then dirY = 1 end
    return dirX, dirY
end
