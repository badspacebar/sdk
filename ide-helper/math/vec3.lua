local vec3 = {}
---@class vec3
---@field new fun(x: number, y: number, z: number): vec3
---@field print fun(self: vec3): void
---@field dot fun(v1: vec3, v2: vec3): number
---@field cross fun(v1: vec3, v2: vec3): number
---@field len fun(self: vec3): number
---@field lenSqr fun(self: vec3): number
---@field norm fun(self: vec3): vec3
---@field dist fun(v1: vec3, v2: vec3): number
---@field distSqr fun(v1: vec3, v2: vec3): number
---@field perp1 fun(self: vec3): vec3
---@field perp2 fun(self: vec3): vec3
---@field lerp fun(v1: vec3, v2: vec3, s: number): vec3
---@field clone fun(self: vec3): vec3
---@field to2D fun(self: vec3): vec2
---@field rotate fun(self: vec3, s: number): vec3

_G.vec3 = vec3