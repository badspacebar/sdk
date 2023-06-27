---@class input
---@field public lock fun(input_type: number): void @ Locks the specified input type. Valid options: LOCK_MOVEMENT | LOCK_ABILITIES | LOCK_SUMMONERSPELLS | LOCK_SHOP | LOCK_CHAT | LOCK_MINIMAPMOVEMENT | LOCK_CAMERAMOVEMENT
---@field public unlock fun(input_type: number): void @ Unlocks the specified input type. Valid options: LOCK_MOVEMENT | LOCK_ABILITIES | LOCK_SUMMONERSPELLS | LOCK_SHOP | LOCK_CHAT | LOCK_MINIMAPMOVEMENT | LOCK_CAMERAMOVEMENT
---@field public islocked fun(input_type: number): boolean @ Returns true if the specified input type is locked. Valid options: LOCK_MOVEMENT | LOCK_ABILITIES | LOCK_SUMMONERSPELLS | LOCK_SHOP | LOCK_CHAT | LOCK_MINIMAPMOVEMENT | LOCK_CAMERAMOVEMENT
---@field public lock_slot fun(slot: number): void @ Locks the input for the specified slot.
---@field public unlock_slot fun(slot: number): void @ Unlocks the input for the specified slot.
---@field public islocked_slot fun(slot: number): boolean @ Returns true if the input for the specified slot is locked.

---@type input
_G.input = {}
