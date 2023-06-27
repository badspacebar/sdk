---@class ping
---@field public ALERT number @ Represents the "Alert" ping type.
---@field public DANGER number @ Represents the "Danger" ping type.
---@field public MISSING_ENEMY number @ Represents the "Missing Enemy" ping type.
---@field public ON_MY_WAY number @ Represents the "On My Way" ping type.
---@field public RETREAT number @ Represents the "Retreat" ping type.
---@field public ASSIST_ME number @ Represents the "Assist Me" ping type.
---@field public AREA_IS_WARDED number @ Represents the "Area is Warded" ping type.
---@field public send fun(pos: vec3, ping_type?: number, target?: game.obj): void @ Sends a ping at the specified position.
---@field public recv fun(pos: vec3, ping_type?: number, target?: game.obj): void @ Receives a ping at the specified position.

---@type ping
_G.ping = {}

--- Sends a ping at the specified position.
---@param pos vec3 @ The position to send the ping to.
---@param ping_type number @ (optional) The type of ping to send. Defaults to ALERT if not provided.
---@param target game.obj @ (optional) The target object for the ping.
---@return void
function ping.send(pos, ping_type, target)
end

--- Receives a ping at the specified position.
---@param pos vec3 @ The position of the received ping.
---@param ping_type number @ (optional) The type of the received ping. Defaults to ALERT if not provided.
---@param target game.obj @ (optional) The target object of the received ping.
---@return void
function ping.recv(pos, ping_type, target)
end
