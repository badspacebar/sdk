local slot = player:spellSlot(0)

local radius_t = {
  [0] = 225,
  [1] = 225,
  [2] = 325,
  [3] = 325,
}

local delay_t = {
  [0] = 0.225,
  [1] = 0.225,
  [2] = 0.350,
  [3] = 0.350,
}

local is_ready = function(t)
  return t and slot.cooldown < t or slot.state == 0
end

local radius = function()
  return radius_t[slot.stacks]
end

local delay = function()
  return delay_t[slot.stacks]
end

local dmg = function()
  return 100
end

return {
  slot = slot,
  is_ready = is_ready,
  radius = radius,
  delay = delay,
  dmg = dmg,
}
