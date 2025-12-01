--[[
	salsa20
		.crypt(key, counter, nonce, text)
			Returns encrypted data with salsa20 alg
			Input:
				- key, byte array of length 32
				- counter, [0 - 0xffffffffffffffff]
				- nonce, byte array of length 8
				- text to en/decrypt
]]

local struct = module.load("DivineLib", "struct")
local table = module.load("DivineLib", "table")

local function qround(st,x,y,z,w)
	local a, b, c, d = st[x], st[y], st[z], st[w]
	local t
	t = bit.band((a + d), 0xffffffff)
	b = bit.bxor(b, bit.band(bit.bor(bit.lshift(t, 7), bit.rshift(t, 25)), 0xffffffff))
	t = bit.band((b + a) , 0xffffffff)
	c = bit.bxor(c, bit.band(bit.bor(bit.lshift(t, 9), bit.rshift(t, 23)), 0xffffffff))
	t = bit.band((c + b) , 0xffffffff)
	d = bit.bxor(d, bit.band(bit.bor(bit.lshift(t, 13), bit.rshift(t, 19)), 0xffffffff))
	t = bit.band((d + c) , 0xffffffff)
	a = bit.bxor(a, bit.band(bit.bor(bit.lshift(t, 18), bit.rshift(t, 14)), 0xffffffff))
	st[x], st[y], st[z], st[w] = a, b, c, d
	return st
end

local salsa20_state = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local salsa20_working_state = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

local salsa20_block = function(key, counter, nonce)
	local st = salsa20_state
	local wst = salsa20_working_state
	st[1], st[6], st[11], st[16] =
		0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
	for i = 1, 4 do
		st[i+1] = key[i]
		st[i+11] = key[i+4]
	end
	st[7], st[8], st[9], st[10] = nonce[1], nonce[2], counter[1], counter[2]
	for i = 1, 16 do
		wst[i] = st[i]
	end
	for _ = 1, 10 do
		qround(wst, 1,5,9,13)
		qround(wst, 6,10,14,2)
		qround(wst, 11,15,3,7)
		qround(wst, 16,4,8,12)
		qround(wst, 1,2,3,4)
		qround(wst, 6,7,8,5)
		qround(wst, 11,12,9,10)
		qround(wst, 16,13,14,15)
	end
	for i = 1, 16 do
		st[i] = bit.band((st[i] + wst[i]), 0xffffffff)
	end
	return st
end

local pat16 = "<I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4"
local pat8 = "<I4I4I4I4I4I4I4I4"

local function salsa20_encrypt_block(key, counter, nonce, pt, ptidx)
	local rbn = #pt - ptidx + 1
	if rbn < 64 then
		local tmp = string.sub(pt, ptidx)
		pt = tmp .. string.rep('\0', 64 - rbn)
		ptidx = 1
	end
	local ba = table.pack(struct.unpack(pat16, pt, ptidx))
	local keystream = salsa20_block(key, counter, nonce)
	for i = 1, 16 do
		ba[i] = bit.bxor(ba[i], keystream[i])
	end
	local es = struct.pack(pat16, table.unpack(ba))
	if rbn < 64 then
		es = string.sub(es, 1, rbn)
	end
	return es
end

local salsa20_encrypt = function(key, counter, nonce, pt)
	local keya = table.pack(struct.unpack(pat8, key))
	local noncea = table.pack(struct.unpack("<I4I4", nonce))
	local countera = {bit.band(counter, 0xffffffff), counter > 0xffffffff and bit.rshift(counter, 32) or 0}
	local t = {}
	local ptidx = 1
	while ptidx <= #pt do
		t[#t+1] = salsa20_encrypt_block(keya, countera, noncea, pt, ptidx)
		ptidx = ptidx + 64
		countera[1] = countera[1] + 1
		if countera[1] > 0xffffffff then
			countera[1] = 0
			countera[2] = countera[2] + 1
		end
	end
	return table.concat(t)
end

return { crypt = salsa20_encrypt }