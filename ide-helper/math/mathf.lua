local mathf = {}
---@class mathf
---@field PI number
---@field cos fun(n: number): number
---@field sin fun(n: number): number
---@field round fun(n: number, d: number): number
---@field sqr fun(n: number): number
---@field clamp fun(min: number, max: number, n: number): number
---@field sect_line_line fun(v1: vec2, v2: vec2, v3: vec2, v4: vec2): vec2
---@field dist_line_vector fun(v1: vec2, v2: vec2, v3: vec2): number
---@field angle_between fun(v1: vec2, v2: vec2, v3: vec2): number
---@field mec fun(pts: vec2[], n: number): vec2, number
---@field project fun(v1: vec2, v2: vec2, v3: vec2, s1: number, s2: number): vec2, number
---@field dist_seg_seg fun(v1: vec2, v2: vec2, v3: vec2, v4: vec2): number
---@field closest_vec_line fun(v1: vec2, v2: vec2, v3: vec2): vec2
---@field closest_vec_line_seg fun(v1: vec2, v2: vec2, v3: vec2): vec2
---@field col_vec_rect fun(v1: vec2, v2: vec2, v3: vec2, w1: number, w2: number): boolean
---@field sect_circle_circle fun(v1: vec2, r1: number, v2: vec2, r2: number): vec2, vec2
---@field sect_line_circle fun(v1: vec2, v2: vec2, v3: vec2, r: number): vec2, vec2
---@field mat2 fun(): double[2][2]
---@field mat3 fun(): double[3][3]
---@field mat4 fun(): double[4][4]

_G.mathf = mathf
