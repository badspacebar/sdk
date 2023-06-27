
---@class cb
---@field public draw number @ Represents the draw callback.
---@field public tick number @ Represents the tick callback.
---@field public spell number @ Represents the spell callback.
---@field public keyup number @ Represents the key up callback.
---@field public keydown number @ Represents the key down callback.
---@field public issueorder number @ Represents the issue order callback.
---@field public issue_order number @ Represents the issue order callback (alternative).
---@field public castspell number @ Represents the cast spell callback.
---@field public cast_spell number @ Represents the cast spell callback (alternative).
---@field public pre_tick number @ Represents the pre-tick callback.
---@field public delete_minion number @ Represents the delete minion callback.
---@field public create_minion number @ Represents the create minion callback.
---@field public delete_particle number @ Represents the delete particle callback.
---@field public create_particle number @ Represents the create particle callback.
---@field public delete_missile number @ Represents the delete missile callback.
---@field public create_missile number @ Represents the create missile callback.
---@field public path number @ Represents the path callback.
---@field public draw2 number @ Represents the draw2 callback.
---@field public sprite number @ Represents the sprite callback.
---@field public error number @ Represents the error callback.
local cb = {}

--- Adds a callback function to the specified callback enum.
---@param cb_enum number @ The callback enum to add the function to.
---@param callback function @ The callback function to add.
function cb.add(cb_enum, callback)
end

--- Removes a callback function from the specified callback enum.
---@param cb_enum number @ The callback enum to remove the function from.
---@param callback function @ The callback function to remove.
function cb.remove(cb_enum, callback)
end

---@type cb
_G.cb = {}