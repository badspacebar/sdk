local bigint = module.load("DivineLib", "bigint")

local rsa;rsa = {
    public_crypt = function(self, message)
        local ret = ""
        for i = 1, message:len(), self.n.len do
            local block = bigint(message:sub(i, i + self.n.len - 1))
            ret = ret .. bigint.pow(block, self.e, self.n).data:gsub('.', function(x)
                return string.format('%02X', string.byte(x))
            end)
        end
        return bigint.fromHexString(ret):tostring()
    end,
    private_crypt = function(self, message)
        local ret = ""
        for i = 1, message:len(), self.n.len do
            local block = bigint(message:sub(i, i + self.n.len - 1))
            ret = ret .. bigint.pow(block, self.d, self.n).data:gsub('.', function(x)
                return string.format('%02X', string.byte(x))
            end)
        end
        return bigint.fromHexString(ret):tostring()
    end,
    bytes = function(_, message)
        return bigint.fromHexString(message):tostring()
    end
}
rsa.mt = {
    __index = rsa
}
return setmetatable(rsa, { __call = function() return setmetatable({}, rsa.mt) end })