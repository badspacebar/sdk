return {
    id = "DivineLib",
    name = "DivineLib",
    load = function()
        return true
    end,
    flag = {
        text = "Nebelwolfi",
            color = {
            text = 0xFFa5c5a7,
            background1 = 0x87f6fd68,
            background2 = 0x99000000
        }
    },
    lib = true,
    shard = {
		'b64', 'bigint', 'box', 'bugsplat',
		'header', 'item', 'itemData', 'json',
		'main', 'md5', 'net', 'notify', 'orb',
		'rsa', 'salsa20', 'struct', 'table',
		'util'
    },
    dualversion = true
}