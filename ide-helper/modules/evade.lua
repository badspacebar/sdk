--- Evade module for spell evasion and avoidance.
---@class evade
local evade = {}

--- Core functions for Evade control.
---@class core
---@field set_server_pause fun(): void
---@field set_pause fun(t: number): void
---@field is_paused fun(): boolean
---@field is_active fun(): boolean
---@field is_action_safe fun(v1: vec2|vec3, speed: number, delay: number): boolean
evade.core = {}

--- Sets the Evade module to pause, preventing it from taking any action for the specified duration.
---@param t number The duration in seconds to pause the Evade module.
---@return void
function evade.core.set_pause(t)
end

--- Checks if the Evade module is currently paused.
---@return boolean Returns true if the Evade module is currently paused.
function evade.core.is_paused()
end

--- Checks if the Evade module is currently evading a spell.
---@return boolean Returns true if the Evade module is currently evading a spell.
function evade.core.is_active()
end

--- Checks if the action is safe based on the given parameters.
---@param v1 vec2|vec3 The target position.
---@param speed number The speed of the action.
---@param delay number The delay of the action.
---@return boolean Returns true if the action is safe.
function evade.core.is_action_safe(v1, speed, delay)
end

_G.evade = evade
