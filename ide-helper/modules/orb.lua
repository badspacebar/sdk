--- Orb module for controlling the orbwalker and utility functions.
---@class orb
local orb = {}

--- Core functions for orbwalker control.
---@class core
---@field reset fun(): void
---@field can_action fun(): boolean
---@field can_attack fun(): boolean
---@field is_move_paused fun(): boolean
---@field is_attack_paused fun(): boolean
---@field set_pause fun(t: number): void
---@field set_pause_move fun(t: number): void
---@field set_pause_attack fun(t: number): void
---@field set_server_pause fun(): void
---@field set_server_pause_attack fun(): void
orb.core = {}

--- Combat functions for orbwalker control.
---@class combat
---@field is_active fun(): boolean
---@field register_f_after_attack fun(func: function): void
---@field register_f_out_of_range fun(func: function): void
---@field register_f_pre_tick fun(func: function): void
---@field set_invoke_after_attack fun(val: boolean): void
orb.combat = {}

--- Farming functions for orbwalker control.
---@class farm
---@field clear_target fun(): obj
---@field lane_clear_wait fun(): boolean
---@field predict_hp fun(obj: minion.obj, time: number): number
---@field set_ignore fun(obj: minion.obj, time: number): void
---@field skill_farm_linear fun(input: table): seg, minion.obj
---@field skill_clear_linear fun(input: table): seg, minion.obj
---@field skill_farm_circular fun(input: table): seg, minion.obj
---@field skill_clear_circular fun(input: table): seg, minion.obj
---@field skill_farm_target fun(input: table): seg, minion.obj
---@field skill_clear_target fun(input: table): seg, minion.obj
---@field set_clear_target fun(obj: minion.obj): void
orb.farm = {}

--- Utility functions for orbwalker control.
---@class utility
---@field get_missile_speed fun(obj: obj): number
---@field get_wind_up_time fun(obj: obj): number
---@field get_damage_mod fun(obj: obj): number
---@field get_damage fun(source: obj, target: obj, add_bonus: boolean): number
---@field get_hit_time fun(source: obj, target: obj): number
---@field is_high_value fun(obj: minion.obj): boolean
---@field get_bar_width fun(obj: minion.obj): number
orb.utility = {}

--- Target Selector instance for orbwalker control.
---@class TS
---@field ts TS
orb.ts = {}

--- Menu keys for different modes.
---@class menu_key
---@field get fun(): boolean
orb.menu = {
    combat = {
        key = {
            get = function() end
        }
    },
    lane_clear = {
        key = {
            get = function() end
        }
    },
    last_hit = {
        key = {
            get = function() end
        }
    },
    hybrid = {
        key = {
            get = function() end
        }
    },
}

_G.orb = orb
