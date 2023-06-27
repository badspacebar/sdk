--- Pred module for advanced prediction calculations.
---@class pred
---@field trace linear.trace
---@field core linear.core
---@field linear linear.prediction
---@field circular circular.prediction
---@field present present.prediction
---@field collision collision.prediction

--- Linear trace functions.
---@class linear.trace
---@field hardlock fun(input: table, seg: seg, obj: obj): boolean
---@field hardlockmove fun(input: table, seg: seg, obj: obj): boolean

--- Core functions for interpolation and projection.
---@class linear.core
---@field lerp fun(path: path.obj, delay: number, speed: number): vec2, number, boolean
---@field project fun(pos: vec2, path: path.obj, delay: number, projectileSpeed: number, pathSpeed: number): vec2, number, boolean
---@field project_off fun(pos: vec2, path: path.obj, delay: number, projectileSpeed: number, pathSpeed: number, offset: vec2): vec2, number, boolean
---@field get_pos_after_time fun(obj: obj, time: number): vec2

--- Linear prediction functions.
---@class linear.prediction
---@field get_prediction fun(input: table, tar: obj, src?: obj): seg

--- Circular prediction functions.
---@class circular.prediction
---@field get_prediction fun(input: table, tar: obj, src?: obj): seg

--- Present prediction functions.
---@class present.prediction
---@field get_source_pos fun(obj: obj): vec2
---@field get_prediction fun(input: table, tar: obj, src?: obj): vec2

--- Collision prediction functions.
---@class collision.prediction
---@field get_prediction fun(input: table, pred_result: seg, ign_obj?: obj): table|nil

---@type pred
_G.pred = {}
