local function time_and_time_again(d)
    local m = math.floor(d / 60);
    local s = math.floor(d % 3600 % 60);
    return m .. ":" .. ('0' .. s):sub(-2);
end
local isRiot = hanbot.isRiot
local default_path = hanbot.libpath .. "/DivineLib/bugsplat.txt"
local bs;bs = {
    file = function(path)
        bs.path = io.open(path, "w+")
        if not bs.cb.reg then
            for i = 1, 2 do
                local c = bs.cb[i]
                cb.add(cb[c], function() bs.log(c) end)
            end
            for i = 1, 2 do
                local c = bs[isRiot and "cb_riot" or "cb_cn"][i]
                cb.add(cb[c], function() bs.log(c) end)
            end
            bs.cb.reg = true
        end
        bs.renew = function()
            bs.path:close()
            bs.path = io.open(path, "w+")
        end
        return bs
    end,
    log = function(f)
        bs[bs.path and "path" or "default"]:write(time_and_time_again(game.time), '\t', f, '\n')
        return bs
    end,
    cb = {
        "draw",
        "spell",
        reg = false
    },
    cb_cn = {
        "createobj",
        "deleteobj",
    },
    cb_riot = {
        "delete_minion",
        "create_missile",
        "delete_missile",
    }
}
bs.default = io.open(default_path, "w+")
cb.add(cb.tick, function()
    if bs.renew then
        bs.renew()
    end
    bs.default:close()
    bs.default = io.open(default_path, "w+")
    bs.log("tick")
end)
return bs