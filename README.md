https://github.com/user-attachments/assets/87a053a1-2975-4981-8370-159b896c3760

Parallax logic with multiple repeating layers for Love2D.

Using a list of layers (images), Lookout is able to calculate the individual movement positions based on each layer's depth, along with the viewpoint position.

```lua
local lookout = require("lookout")

local layerData = {
    { img = images.far, depth = 8 }, 
    { img = images.mid, depth = 4 },
    { img = images.near, depth = 2 }
}

local look = lookout:create(layerData, { spoofX = 1000 })
```
```lua
-- put in the update loop
look:update(dt, cameraX, cameraY)

-- put in the draw method
look:draw()
```

`spoofX` and `spoofY` automatically offset layers over time. They can also be changed at runtime with `look:setSpoofDir(x, y)`.

## Options

Pass these options as the second argument to `lookout:create(layerData, args)`:

- `scale`: Default scale for all layers. A layer can override it with its own `scale` value.
- `spoofX`, `spoofY`: Automatic movement in pixels per second.
- `drawSides`, `drawVertical`: Whether layers repeat horizontally and vertically. Both default to `true`.
- `fixedX`, `fixedY`: Make all layers fixed on an axis by default. A layer can override either flag.

Each layer requires `img` and accepts `depth` (default `3`), `scale`, `alpha`, `offX`, `offY`, `spoofX`, `spoofY`, `drawSides`, `drawVertical`, `fixedX`, and `fixedY`.

Call `look:setScale(scale)` to update the scale of existing layers.

You can include this entire project as a runnable Love2D example, copy `lookout.lua` directly into a project, or use `init.lua` as the module entry point. See `main.lua` for the complete Love2D example.
