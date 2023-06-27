---@class menu
---@field public header fun(var: string, text: string): void @ Adds a header to the menu.
---@field public boolean fun(var: string, text: string, value: boolean): void @ Adds a boolean option to the menu.
---@field public slider fun(var: string, text: string, value: number, min: number, max: number, step: number): void @ Adds a slider option to the menu.
---@field public keybind fun(var: string, text: string, key: string?, toggle: string?): void @ Adds a keybind option to the menu.
---@field public dropdown fun(var: string, text: string, value: number, options: table): void @ Adds a dropdown option to the menu.
---@field public button fun(var: string, text: string, buttonText: string, callback: function): void @ Adds a button option to the menu.
---@field public color fun(var: string, text: string, red: number, green: number, blue: number, alpha: number): void @ Adds a color option to the menu.
---@field public isopen fun(): boolean @ Returns true if the menu is currently open.
---@field public set fun(property: string, value: any): void @ Sets a property of the menu to the specified value.

---@type menu
_G.menu = {}
