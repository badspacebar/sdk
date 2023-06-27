--- Target Selector module for selecting targets.
---@class TS
local TS = {}

--- Retrieves the result of the target selection based on the provided function and filter.
---@param func function The function used for target selection.
---@param filter table (optional) The filter table to apply during target selection.
---@param ign_sel boolean (optional) Whether to ignore the selected target.
---@param hard boolean (optional) Whether to apply hard filtering.
---@return table The result of the target selection.
function TS.get_result(func, filter, ign_sel, hard)
end

--- Retrieves the active filter table used by the target selector.
---@return table The active filter table.
function TS.get_active_filter()
end

--- Loops through the targets using the specified function and filter.
---@param func function The function to execute for each target.
---@param filter table (optional) The filter table to apply during iteration.
---@return table The looped targets.
function TS.loop(func, filter)
end

--- Loops through the allies using the specified function and filter.
---@param func function The function to execute for each ally.
---@param filter table (optional) The filter table to apply during iteration.
---@return table The looped allies.
function TS.loop_allies(func, filter)
end

--- Creates a new filter table for target selection.
---@return table The new filter table.
function TS.filter.new()
end

--- Represents a set of filter conditions for target selection.
---@class filter_set
local filter_set = {}

_G.ts = TS
