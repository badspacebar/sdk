local vec2 = {}
---@class vec2
---@field new fun(x: number, y: number): vec2
---@field print fun(self: vec2): void
---@field dot fun(v1: vec2, v2: vec2): number
---@field cross fun(v1: vec2, v2: vec2): number
---@field len fun(self: vec2): number
---@field lenSqr fun(self: vec2): number
---@field norm fun(self: vec2): vec2
---@field dist fun(v1: vec2, v2: vec2): number
---@field distSqr fun(v1: vec2, v2: vec2): number
---@field perp1 fun(self: vec2): vec2
---@field perp2 fun(self: vec2): vec2
---@field lerp fun(v1: vec2, v2: vec2, s: number): vec2
---@field clone fun(self: vec2): vec2
---@field to3D fun(self: vec2, y: number): vec3

_G.vec2 = vec2
