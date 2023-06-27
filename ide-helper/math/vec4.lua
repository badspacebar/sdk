
local vec4 = {}
---@class vec4
---@field new fun(x: number, y: number, z: number): vec4
---@field dot fun(v1: vec4, v2: vec4): number
---@field cross fun(v1: vec4, v2: vec4): number
---@field len fun(self: vec4): number
---@field lenSqr fun(self: vec4): number
---@field norm fun(self: vec4): vec4
---@field dist fun(v1: vec4, v2: vec4): number
---@field distSqr fun(v1: vec4, v2: vec4): number
---@field perp1 fun(self: vec4): vec4
---@field perp2 fun(self: vec4): vec4
---@field lerp fun(v1: vec4, v2: vec4, s: number): vec4
---@field clone fun(self: vec4): vec4
---@field to2D fun(self: vec4): vec2
---@field rotate fun(self: vec4, s: number): vec4
---@field print fun(self: vec4): void

_G.vec4 = vec4
