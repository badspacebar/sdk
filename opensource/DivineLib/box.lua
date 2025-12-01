local function identity(x)
    return x
end

local box;box = setmetatable({identity = bidentity, tostring = btostring, even = beven, odd = bodd},
{ __call = function(_, tbl)
    local b = setmetatable({ ref = tbl, count = #tbl },
        {
            __tostring = function(self)
                return self.fold(tostring)
            end
        })
    b.skip = function(where, amount)
        if type(where) == "number" then where, amount = "begin", where end
        local newref = {}
        for i = 1 + (where == "begin" and amount or 0), #b.ref - (where == "end" and amount or 0) do
            newref[#newref + 1] = b.ref[i]
        end
        return box(newref)
    end
    b.where = function(t)
        local newref = {}
        local t_type = type(t)
        if t_type == "string" then
            local env = {}
            env.__predicate = t:sub(1, t:find("=>") - 1):gsub(" ", "")
            t = load("return " .. t:sub(t:find("=>") + 2), nil, "t", env)
            for i = 1, #b.ref do
                env[env.__predicate] = b.ref[i]
                if t() then
                    newref[#newref + 1] = b.ref[i]
                end
            end
        elseif t_type == "function" then
            for i = 1, #b.ref do
                if t(b.ref[i]) then
                    newref[#newref + 1] = b.ref[i]
                end
            end
        end
        return box(newref)
    end
    b.filter = function(t)
        local newref = {}
        local t_type = type(t)
        if t_type == "string" then
            local env = {}
            env.__predicate = t:sub(1, t:find("=>") - 1):gsub(" ", "")
            t = load("return " .. t:sub(t:find("=>") + 2), nil, "t", env)
            for i = 1, #b.ref do
                env[env.__predicate] = b.ref[i]
                if not t() then
                    newref[#newref + 1] = b.ref[i]
                end
            end
        elseif t_type == "function" then
            for i = 1, #b.ref do
                if not t(b.ref[i]) then
                    newref[#newref + 1] = b.ref[i]
                end
            end
        end
        return box(newref)
    end
    b.map = function(func)
        for i, v in pairs(b.ref) do
            b.ref[i] = func(v)
        end
        return b
    end
    b.fold = function(func)
        local t, o = false
        for _, v in pairs(b.ref) do
            if not t then
                t, o = true, func(v)
            else
                o = func(o, v)
            end
        end
        return o
    end
    b.apply = function(t)
        local t_type = type(t)
        if t_type == "string" then
            local env = {}
            env.__predicate = t:sub(1, t:find("=>") - 1):gsub(" ", "")
            t = load("return " .. t:sub(t:find("=>") + 2), nil, "t", env)
            for _, e in pairs(b.ref) do
                env[env.__predicate] = e
                b.ref[_] = t()
            end
        end
        if t_type == "table" then
            for _, e in pairs(b.ref) do
                for i, v in pairs(t) do
                    b.ref[_] = v(e)
                end
            end
        end
        return b
    end
    b.order = function(t)
        local t_type = type(t)
        if t_type == "string" then
            local env = {}
            local predicate = t:sub(1, t:find("=>") - 1):gsub(" ", "")
            local var1 = predicate:sub(1, predicate:find(",") - 1)
            local var2 = predicate:sub(predicate:find(",") + 1)
            t = load("return " .. t:sub(t:find("=>") + 2), nil, "t", env)
            local sorted = #b.ref == 0
            while not sorted do
                sorted = true
                for i = 1, #b.ref - 1 do
                    env[var1] = b.ref[i]
                    env[var2] = b.ref[i + 1]
                    if t() then
                        b.ref[i], b.ref[i + 1] = b.ref[i + 1], b.ref[i]
                        sorted = false
                    end
                end
            end
        elseif t_type == "function" then
            local sorted = #b.ref == 0
            while not sorted do
                sorted = true
                for i = 1, #b.ref - 1 do
                    if t(b.ref[i], b.ref[i + 1]) then
                        b.ref[i], b.ref[i + 1] = b.ref[i + 1], b.ref[i]
                        sorted = false
                    end
                end
            end
        end
        return b
    end
    return b
end }); return box