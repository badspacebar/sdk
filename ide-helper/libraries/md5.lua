---@class md5
---@field public file fun(path: string): string @ Computes the MD5 hash of a file.
---@field public sum fun(str: string): string @ Computes the MD5 hash of a string.
---@field public tohex fun(str: string, upper: boolean): string @ Converts an MD5 hash to its hexadecimal representation.

---@type md5
_G.md5 = {}
