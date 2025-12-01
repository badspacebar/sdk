--[[
    item library
        .find(index, name)
            Finds item in players current items
            Input:
                index ["name", "tags", "into", ...]
                name to match index with
            Returns item table or nil
        .get(id)
            Gets item table from data directly
            Input:
                item id
            Returns item
        .recache
            Forces recache of current players items

]]

local itemData = module.load("DivineLib", "itemData")

local itemPrototype = setmetatable({}, {
    __call = function(_, input)
        local b = {}
        local _t = type(input)
        if _t == "table" then
            for i, v in pairs(input) do
                b[i] = v
            end
        elseif _t == "number" or _t == "string" then
            input = itemData[tostring(input)]
            if input then
                for i, v in pairs(input) do
                    b[i] = v
                end
            end
        else
            return {
                name = "itemPrototypeEmpty"
            }
        end
        return b
    end
})

local item;item = {
    cache = {},
    cacheT = 0,
    get = itemPrototype,
    find = function(index, name)
        for i = 1, 6 do
            local _item = item.cache[i]
            if _item and _item[index] then
                local _t = type(_item[index])
                if _t == "table" then
                    for _, v in pairs(_item[index]) do
                        if type(v) == "string" and v:find(name) then
                            return _item
                        end
                    end
                elseif _t == "string" then
                    if _item[index]:find(name) then
                        return _item
                    end
                end
            end
        end
    end,
    recache = function()
        for i = 0, 6 do
            local id = objManager.player:itemID(i)
            if id > 0 then
                item.cache[i] = item.get(id)
                item.cache[i].slot = i + 6
                item.cache[i].id = id
            end
        end
    end,
    tick = function()
        if item.cacheT < game.time then
            item.cacheT = game.time + 5
            item.recache()
        end
    end
}
cb.add(cb.tick, item.tick)
return item