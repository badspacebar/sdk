local bigint = { };

function bigint:set(input)
    if not input or input:len() == 0 then
        self.data = bigint.null.data
        self.len = bigint.null.len
    else
        self.len = input:len()
        self.data = input
    end
end

function bigint.fromHexString(str)
    local _t = ""
    str = str:gsub('%p', '')
    for i = 1, str:len(), 2 do
        _t = _t .. string.char(tonumber(str:sub(i, i+1), 16))
    end
    return bigint(_t)
end

function bigint:tostring()
    local str = ""
    for i = 1, self.len do
        str = str .. string.char(self:get(i))
    end
    return str
end

function bigint:iter()
    local n = self.len + 1
    return function()
        if n > 1 then
            n = n - 1
            return self:get(n)
        end
    end
end

function bigint:get(n)
    return string.byte(self.data:sub(n, n))
end

function bigint:trim()
    while self.data:sub(1, 1) == "\0" do
        self.data = self.data:sub(2)
        self.len = self.len - 1
    end
    return self
end

function bigint.sub(a, b)
    local res, carry = "", 0
    local ai, bi = a:iter(), b:iter()
    local an, bn = ai(), bi()
    while an or bn do
        an, bn = an or 0, bn or 0
        local t
        if carry + bn > an then
            t = 0x100 - (carry + bn) + an
            carry = 1
        else
            t = an - (carry + bn)
            carry = 0
        end
        res = string.char(bit.band(t, 0xff)) .. res
        an, bn = ai(), bi()
    end
    return bigint(res)
end

function bigint.cmp(a, b)
    a, b = a:trim(), b:trim()
    if a.len < b.len then
        return -1
    elseif a.len > b.len then
        return 1
    end
    for i = 1, a.len do
        if a:get(i) < b:get(i) then
            return -1
        elseif a:get(i) > b:get(i) then
            return 1
        end
    end
    return 0
end

function bigint.lt(a, b)
    return bigint.cmp(a, b) < 0
end

function bigint.le(a, b)
    return bigint.cmp(a, b) <= 0
end

function bigint.eq(a, b)
    return bigint.cmp(a, b) == 0
end

function bigint.mod(a, b)
    if not b then
        return a
    end
    if a > b then
        local ta = bigint(a.data)
        while ta > b do
            local t = bigint(b.data)
            local tb
            while ta > t do
                tb = t
                t = bigint.mul(t, bigint.two)
            end
            ta = bigint.sub(ta, tb)
        end
        return ta
    else
        return a
    end
end

function bigint.add(a, b)
    local res, carry = "", 0
    local ai, bi = a:iter(), b:iter()
    local an, bn = ai(), bi()
    while an or bn do
        an, bn = an or 0, bn or 0
        local t = an + bn + carry
        carry = bit.rshift(t, 8)
        res = string.char(bit.band(t, 0xff)) .. res
        an, bn = ai(), bi()
    end
    if carry > 0 then
        res = string.char(bit.band(carry, 0xff)) .. res
    end
    return bigint(res)
end

function bigint.mul(a, b, m)
    local res = bigint("")
    local ta = bigint(a.data)
    for i = 0, b.len * 8 - 1 do
        local n = b.len - math.floor(i/8)
        if 0 ~= bit.band(string.byte(b.data:sub(n, n)), bit.lshift(1, i%8)) then
            res = bigint.mod(bigint.add(res, ta), m)
        end
        ta = bigint.mod(bigint.add(ta, ta), m)
    end
    return res
end

function bigint.pow(b, e, m)
    local res = bigint.one
    local tb = bigint(b.data)
    for i = 0, e.len * 8 - 1 do
        local n = e.len - math.floor(i/8)
        if 0 ~= bit.band(string.byte(e.data:sub(n, n)), bit.lshift(1, i%8)) then
            res = bigint.mul(res, tb, m)
        end
        tb = bigint.mul(tb, tb, m)
    end
    return res:trim()
end

function bigint.lcm(a, b)
    local ta = bigint(a.data)
    local tb = bigint(b.data)
    local cmp = bigint.cmp(ta, tb)
    while cmp ~= 0 do
        if cmp < 0 then
            ta = ta + a
        else
            tb = tb + b
        end
        cmp = bigint.cmp(ta, tb)
    end
    return ta
end

bigint.mt = {
    __tostring = function(self)
        return "[" .. (
            self.data and
                self.data:gsub('.', function(x)
                    return string.format('%02X', string.byte(x))
                end)
            or "empty") ..
        "]"
    end,
    __index = bigint,
    __sub = bigint.sub,
    __add = bigint.add,
    __mul = bigint.mul,
    __lt = bigint.lt,
    __le = bigint.le,
    __eq = bigint.eq,
    __type = "bigint"
}

setmetatable(bigint, {
    __call = function(_, input)
        local b = setmetatable({}, bigint.mt)
        b:set(input)
        return b
    end
})

bigint.null = bigint.fromHexString("00")
bigint.one = bigint.fromHexString("01")
bigint.two = bigint.fromHexString("02")

return bigint