local r1 = module.load(header.id, 'spell/r1')

local slot = player:spellSlot(1)

local is_ready = function(t)
  return t and slot.cooldown < t or slot.state == 0
end

local radius = function()
  return r1.is_active and 375 or 300
end

local dmg = function()
  return 25 + slot.level*30 + player.flatPhysicalDamageMod
end

return {
  slot = slot,
  is_ready = is_ready,
  radius = radius,
  dmg = dmg,
}
