local clipper = {}
--@class clipper_enum
---@field PolyFillType_EvenOdd number
---@field PolyFillType_NonZero number
---@field PolyFillType_Positive number
---@field PolyFillType_Negative number
---@field JoinType_Square number
---@field JoinType_Round number
---@field JoinType_Miter number
---@field ClipType_Intersection number
---@field ClipType_Union number
---@field ClipType_Difference number
---@field ClipType_Xor number
---@field PolyType_Subject number
---@field PolyType_Clip number

---@class clipper_polygon
---@field Add fun(v1: vec2): void
---@field ChildCount fun(): number
---@field Childs fun(i: number): vec2
---@field Area fun(): number
---@field Clean fun(dist: number): void
---@field Simplify fun(PolyFillType: number): clipper_polygons
---@field Orientation fun(): number
---@field Reverse fun(): void
---@field Contains fun(v1: vec2): number
---@field Draw2D fun(width: number, color: number): void
---@field Draw3D fun(y: number, width: number, color: number): void
---@field OnScreen2D fun(): boolean
---@field OnScreen3D fun(y: number): boolean

---@class clipper_polygons
---@field Add fun(polygon: clipper_polygon): void
---@field ChildCount fun(): number
---@field Childs fun(i: number): clipper_polygon
---@field Reverse fun(): void
---@field Clean fun(dist: number): void
---@field Simplify fun(PolyFillType: number): clipper_polygons
---@field Offset fun(delta: number, JoinType: number, limit: number): clipper_polygons

---@class clipper_clipper
---@field AddPath fun(polygon: clipper_polygon, PolyType: number, closed: boolean): void
---@field AddPaths fun(polygons: clipper_polygons, PolyType: number, closed: boolean): void
---@field Clear fun(): void
---@field Execute fun(ClipType: number, PolyFillType: number, PolyFillType: number): clipper_polygons

---@class clipper
---@field polygon clipper_polygon
---@field polygons clipper_polygons
---@field clipper clipper_clipper
---@field enum clipper_enum

local clip = module.internal('clipper')
local polygon = clip.polygon
local polygons = clip.polygons
local clipper = clip.clipper
local clipper_enum = clip.enum

_G.clipper = clipper
