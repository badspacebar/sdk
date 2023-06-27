---@class navmesh
---@field public getTerrainHeight fun(x: number, z: number): number @ Returns the terrain height at the specified coordinates.
---@field public isGrass fun(v1: vec2|vec3): boolean @ Checks if the given position is in grass.
---@field public isWall fun(v1: vec2|vec3): boolean @ Checks if the given position is a wall.
---@field public isStructure fun(v1: vec2|vec3): boolean @ Checks if the given position is a structure.
---@field public isInFoW fun(v1: vec2|vec3): boolean @ Checks if the given position is in the fog of war.
---@field public getNearstPassable fun(v1: vec2|vec3): vec2 @ Returns the nearest passable position to the given position.

---@type navmesh
_G.navmesh = {}
