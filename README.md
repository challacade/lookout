# lookout
Parallax logic with multiple moving layers, written in Lua.

Lookout receives a list of layers (images) along with the corresponding depth value. Using this information, each layer is able to calculate its independent movement position based on its depth, along with the viewpoint position. A view can also be assigned a 'spoof' direction, which means the view will automatically offset over time (travel) based on the spoof X & Y properties.

To use lookout, you can include this entire project, or copy/paste lookout.lua directly into your codebase. See main.lua for an example of how a parallax view can be created for a Love2D project. The inline comments walk through every step of the process.
