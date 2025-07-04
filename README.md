https://github.com/user-attachments/assets/87a053a1-2975-4981-8370-159b896c3760

Parallax logic with multiple moving layers, written in Lua✨

Using a list of layers (images), Lookout is able to calculate the individual movement positions based on each layer's depth, along with the viewpoint position.

```
local lookout = require("lookout")

local layerData = {
    { img = images.far, depth = 8 }, 
    { img = images.mid, depth = 4 },
    { img = images.near, depth = 2 }
}

look = lookout:create(layerData, {spoofX = 1000})
```
```
-- put in the update loop
look:update(dt, cameraX, cameraY)

-- put in the draw method
look:draw()
```

You can assign a 'spoof' direction, which means the lookout will automatically offset (travel) over time based on the spoofX & spoofY properties.

To use Lookout, you can include this entire project, or copy/paste lookout.lua directly into your codebase. See main.lua for an example of how a parallax view can be created for a Love2D project. The inline comments walk through every step of the process.
