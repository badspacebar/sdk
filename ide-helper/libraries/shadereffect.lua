---@class shadereffect
---@field public construct fun(effect_description: string, is_3D: boolean): shadereffect @ Constructs a shader effect.
---@field public begin fun(effect: shadereffect, height: number, is_3D: boolean): void @ Begins the shader effect.
---@field public set_float fun(effect: shadereffect, varname: string, var: number): void @ Sets a float variable in the shader effect.
---@field public set_vec2 fun(effect: shadereffect, varname: string, var: vec2): void @ Sets a vec2 variable in the shader effect.
---@field public set_vec3 fun(effect: shadereffect, varname: string, var: vec3): void @ Sets a vec3 variable in the shader effect.
---@field public set_vec4 fun(effect: shadereffect, varname: string, var: vec4): void @ Sets a vec4 variable in the shader effect.
---@field public set_float_array fun(effect: shadereffect, varname: string, var: number[], size: number): void @ Sets a float array variable in the shader effect.
---@field public set_color fun(effect: shadereffect, varname: string, var: color): void @ Sets a color variable in the shader effect.

---@type shadereffect
_G.shadereffect = {}
