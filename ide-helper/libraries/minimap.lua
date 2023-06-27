---@class minimap
---@field public x fun(): number @ Returns the screen x position of the upper left corner of the minimap.
---@field public y fun(): number @ Returns the screen y position of the upper left corner of the minimap.
---@field public width fun(): number @ Returns the screen width of the minimap.
---@field public height fun(): number @ Returns the screen height of the minimap.
---@field public bounds fun(): vec2 @ Returns the maximum map boundaries.
---@field public world_to_map fun(v1: vec2|vec3): vec2 @ Converts a world position to a screen position on the minimap.
---@field public on_map fun(v1: vec2): boolean @ Checks if a world position is hovering over the minimap.
---@field public on_map_xy fun(x: number, y: number): boolean @ Checks if a screen position (x, y) is hovering over the minimap.
---@field public draw_circle fun(v1: vec3, r: number, w: number, c: number, n: number): void @ Draws a circle on the minimap.

---@type minimap
_G.minimap = {}

--- Returns the screen x position of the upper left corner of the minimap.
---@return number
function minimap.x()
end

--- Returns the screen y position of the upper left corner of the minimap.
---@return number
function minimap.y()
end

--- Returns the screen width of the minimap.
---@return number
function minimap.width()
end

--- Returns the screen height of the minimap.
---@return number
function minimap.height()
end

--- Returns the maximum map boundaries.
---@return vec2
function minimap.bounds()
end

--- Converts a world position to a screen position on the minimap.
---@param v1 vec2|vec3
---@return vec2
function minimap.world_to_map(v1)
end

--- Checks if a world position is hovering over the minimap.
---@param v1 vec2
---@return boolean
function minimap.on_map(v1)
end

--- Checks if a screen position (x, y) is hovering over the minimap.
---@param x number
---@param y number
---@return boolean
function minimap.on_map_xy(x, y)
end

--- Draws a circle on the minimap.
---@param v1 vec3
---@param r number
---@param w number
---@param c number
---@param n number
---@return void
function minimap.draw_circle(v1, r, w, c, n)
end
