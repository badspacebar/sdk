-- luacheck: ignore table
--[[
    extends table
        .print(tbl)
            Prints a table
            Input: table
        .pack(vararg)
            Packs varargs into a table
            Input: vararg
            Returns table with varargs as members
        .unpack
            Copy of 'unpack'
        .swap(tbl, i1, i2)
            Swaps two table members [GOTCHA: does not make a copy!]
            Input:
                - table
                - index 1
                - index 2
            Returns table with swapped members
]]
local table = table

table.print = function(tbl)
    for i, v in pairs(tbl) do
        if type(v) == "table" then
            print(i .. " ") table.print(v)
        else
            print(i .. " " .. tostring(v))
        end
    end
end

table.pack = function(...)
    return { ... }
end

table.unpack = unpack

table.swap = function(tbl, i1, i2)
    local tmp = tbl[i1]
    tbl[i1] = tbl[i2]
    tbl[i2] = tmp
    return tbl
end

table.set = function(tbl)
    local b = {}
    for i = 1, #tbl do
        b[tbl[i]] = true
    end
    return b
end

return table