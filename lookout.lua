local lookout = {
    _LICENSE = "This software is distributed under the MIT license. See LICENSE for details.",
    _URL = "https://github.com/challacade/lookout",
    _VERSION = "1.0.0",
    _DESCRIPTION = "Parallax logic with multiple moving layers",
}

function lookout:create(newLayerData, args)
    local look = {}
    look.x = 0 -- look perspective position
    look.y = 0
    look.spoofX = 0 -- automatic movement of the look position
    look.spoofY = 0

    -- any additional properties you would like to set for the look
    if args then for k, v in pairs(args) do look[k] = v end end

    function look:reset()
        look.layers = {}
        look.layerData = nil
    end

    function look:addLayerData(data)
        if not data then error("addLayerData requires a table of layers, or single layer") end
        if type(data) ~= "table" then error("addLayerData parameter must be a table") end
        if next(data) == nil then error("addLayerData parameter cannot be an empty table") end
        if not data[1] then data = { data } end -- parameter is a single layer

        if not self.layerData then self.layerData = {} end
        for i, ld in ipairs(data) do table.insert(self.layerData, ld) end
    end

    function look:newLayer(img, args)
        if not img then error("newLayer requires an image") end

        -- Stores all data about the layer
        -- NOTE: any property can be overridden by passing it in args
        local layer = {}
        layer.img = img -- image to draw
        layer.x = 0 -- position of the layer, call update to set properly
        layer.y = 0 -- position of the layer
        layer.scale = 1
        layer.alpha = 1
        layer.drawSides = true -- draw duplicates on left and right
        layer.drawVertical = true -- draw duplicates on top and bottom
        layer.look = look -- reference to the look this layer belongs to

        -- Stores the position from the previous frame
        layer.oldLookX = 0
        layer.oldLookY = 0

        -- Relative position of the layer compared to the actual position
        layer.relX = 0
        layer.relY = 0

        -- Number of pixels the look position has to move before the layer moves
        layer.depth = 3

        -- Manual offset of the layer
        layer.offX = 0
        layer.offY = 0

        -- automatic movement of the layer
        layer.spoofX = 0
        layer.spoofY = 0

        if args then for k,v in pairs(args) do layer[k] = v end end

        layer.baseWidth = layer.img:getWidth()
        layer.width = layer.baseWidth * layer.scale
        layer.baseHeight = layer.img:getHeight()
        layer.height = layer.baseHeight * layer.scale

        -- TODO: verify you can pass an anim8 anim, adjust above values for it

        function layer:update(dt) -- calculate parallax positioning
            if layer.anim then layer.anim:update(dt) end

            if layer.look.spoofX ~= 0 then layer.spoofX = layer.spoofX + layer.look.spoofX * dt end
            if layer.look.spoofY ~= 0 then layer.spoofY = layer.spoofY + layer.look.spoofY * dt end

            local vpx, vpy = layer.look:getPosition() -- get the look position
            layer.x, layer.y = vpx, vpy

            vpx = vpx + layer.spoofX -- apply spoofing to the look position
            vpy = vpy + layer.spoofY

            local diffX = vpx - layer.oldLookX
            local diffY = vpy - layer.oldLookY

            if not layer.fixedX then layer.relX = layer.relX - (diffX / layer.depth) end
            if not layer.fixedY then layer.relY = layer.relY - (diffY / layer.depth) end

            if layer.relX < -1 * layer.width then layer.relX = layer.relX + layer.width end
            if layer.relX > layer.width then layer.relX = layer.relX - layer.width end

            if layer.relY < -1 * layer.height then layer.relY = layer.relY + layer.height end
            if layer.relY > layer.height then layer.relY = layer.relY - layer.height end

            layer.oldLookX = vpx
            layer.oldLookY = vpy
        end
        
        function layer:reset()
            self.relX = 0
            self.relY = 0
            self.oldLookX = self.x
            self.oldLookY = self.y
        end
        
        function layer:draw()
            local alph = self.alpha
            local imgW = self.baseWidth * self.scale
            local imgH = self.baseHeight * self.scale
            love.graphics.setColor(1, 1, 1, alph)

            for i=-1, 2 do
                if self.drawVertical or i == 0 then
                    local lx = layer.x + (layer.relX * self.scale) + (layer.offX * self.scale)
                    local ly = layer.y + (layer.relY * self.scale) + (layer.offY * self.scale)

                    love.graphics.draw(self.img, lx + (0 * imgW), ly + (i * imgH), nil, self.scale, nil, self.width/2, self.height/2)
                    if self.drawSides then love.graphics.draw(self.img, lx + (1 * imgW), ly + (i * imgH), nil, self.scale, nil, self.width/2, self.height/2) end
                    if self.drawSides then love.graphics.draw(self.img, lx + (-1 * imgW), ly + (i * imgH), nil, self.scale, nil, self.width/2, self.height/2) end
                end
            end      
        end

        table.insert(look.layers, layer)
    end

    function look:setScale(scale)
        if not scale then return end
        for i, layer in ipairs(look.layers) do
            layer.scale = scale
            layer.width = layer.baseWidth * layer.scale
            layer.height = layer.baseHeight * layer.scale
        end
    end
    -- NOTE: call look:update and look:draw to see changes (applies to all set methods)

    function look:setPosition(x, y)
        if x then look.x = x end
        if y then look.y = y end
    end

    function look:setSpoofDir(x, y)
        if x then look.spoofX = x end
        if y then look.spoofY = y end
    end

    function look:getPosition()
        return look.x, look.y
    end

    function look:getNormalizedSpoofDir()
        local len = math.sqrt(look.spoofX^2 + look.spoofY^2)
        if len == 0 then return 0, 0 end
        return look.spoofX / len, look.spoofY / len
    end

    function look:update(dt, x, y)
        look:setPosition(x, y)

        for i, layer in ipairs(look.layers) do
            layer:update(dt, look.x, look.y)
        end
    end

    function look:draw()
        for i, layer in ipairs(look.layers) do
            layer:draw()
        end
    end

    function look:init(nld)
        look:reset()
        look:addLayerData(nld)

        for i, ld in ipairs(look.layerData) do -- create all layers
            local img = ld.img
            ld.img = nil -- remove img from layer data
            look:newLayer(img, ld)
        end
    end

    if newLayerData then
        look:init(newLayerData) -- initialize layer data
    else
        print("call look:init(newLayerData) to start")
    end

    return look
end

return lookout
