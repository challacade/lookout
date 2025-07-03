-- This project can be run as a Love2D game, main.lua is the starting point
function love.load()
    local images = {} -- load images for the parallax layers
    images.far = love.graphics.newImage("stars/far.png")
    images.mid = love.graphics.newImage("stars/mid.png")
    images.near = love.graphics.newImage("stars/near.png")

    -- Create the lookout
    local lookout = require("lookout")
    local layerData = {
        { img = images.far, depth = 8 }, -- depth represents how 'far away' the layer is
        { img = images.mid, depth = 4 }, -- lower depth means the layer moves faster
        { img = images.near, depth = 2 }, -- at 0, the layer matches the look (view) position
    }

    local args = { spoofX = 1000 } -- Initial spoof direction for the lookout
    look = lookout:create(layerData, args) -- lookout instance is stored in a global variable called 'look'
    look.font = love.graphics.newFont(16) -- Set a font for the lookout
end

function love.update(dt)
    local mag = 1000
    local dirX, dirY = getDirFromKeyboard()

    -- using the keyboard input, we can set the spoof direction of the lookout
    if dirX ~= 0 or dirY ~= 0 then look:setSpoofDir(dirX * mag, dirY * mag) end

    local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    look:update(dt, centerX, centerY) -- lookout position is the center of the screen
    -- if there's a camera, use camX and camY instead of centerX and centerY
end

function love.draw()
    love.graphics.setColor(1,1,1,1)
    look:draw() -- draws all parallax layers
    
    love.graphics.setFont(look.font)
    love.graphics.print("Use the arrow keys!", 10, 10)
end

function getDirFromKeyboard()
    local dirX, dirY = 0, 0
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then dirX = -1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then dirX = 1 end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then dirY = -1 end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then dirY = 1 end
    return dirX, dirY
end
