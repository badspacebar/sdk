---@class keyboard
---@field public isKeyDown fun(key_code: number): boolean @ Returns true if the specified key code is currently pressed. Valid key codes depend on the platform.
---@field public getClipboardText fun(): string @ Returns the text that was copied to the clipboard.
---@field public setClipboardText fun(text: string): void @ Copies the specified text to the clipboard.
---@field public keyCodeToString fun(key_code: number): string @ Returns the corresponding character of the specified key code. Valid key codes depend on the platform.
---@field public stringToKeyCode fun(key: string): number @ Returns the corresponding key code of the specified character.

---@type keyboard
_G.keyboard = {}
