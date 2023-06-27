---@class game
---@field public mousePos fun(): vec3 @ Returns the current position of the mouse.
---@field public mousePos2D fun(): vec2 @ Returns the current position of the mouse in 2D.
---@field public cameraPos fun(): vec3 @ Returns the current position of the camera.
---@field public cameraLock fun(): boolean @ Returns true if the camera is locked.
---@field public setCameraLock fun(bool: boolean): void @ Sets the camera lock state.
---@field public cameraY fun(): number @ Returns the current camera zoom level.
---@field public cursorPos fun(): vec2 @ Returns the current cursor position.
---@field public time fun(): number @ Returns the current game time.
---@field public version fun(): string @ Returns the current game version.
---@field public selectedTarget fun(): obj @ Returns the currently selected game object.
---@field public hoveredTarget fun(): obj @ Returns the currently hovered game object.
---@field public mapID fun(): number @ Returns the current map ID.
---@field public mode fun(): string @ Returns the current game mode.
---@field public isWindowFocused fun(): boolean @ Returns true if the League of Legends window is focused.

---@type game
_G.game = {}
