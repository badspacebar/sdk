---@class console
---@field public set_color fun(c: number) @ Sets the color of the console.
---@field public printx fun(str: string, c: number) @ Prints a message with a specific color in the console.

---@type console
_G.console = {}

--- Sets the color of the console.
---@param c number @ The color to set.
---@return void
function console.set_color(c)
end

--- Prints a message with a specific color in the console.
---@param str string @ The message to print.
---@param c number @ The color of the message.
---@return void
function console.printx(str, c)
end