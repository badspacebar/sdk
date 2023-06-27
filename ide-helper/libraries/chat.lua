---@class chat
---@field public isOpened fun(): boolean @ Returns true if the chat is open.
---@field public send fun(str: string): void @ Sends a message in the chat.
---@field public print fun(str: string): void @ Prints a message in the chat.

---@type chat
local chat = {}

--- Sends a message in the chat.
---@param str string @ The message to send.
---@return void
function chat.send(str)
end

--- Prints a message in the chat.
---@param str string @ The message to print.
---@return void
function chat.print(str)
end

---@type chat
_G.chat = chat
