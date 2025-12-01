local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')

local q_slot = player:spellSlot(0)
local w_cast_slot = player:spellSlot(1)
local e_slot = player:spellSlot(2)
local r_slot = player:spellSlot(3)

local calc = function(obj)
  local mr = obj.spellBlock*player.percentMagicPenetration - player.flatMagicPenetration
  local mr_red = mr>-1 and (100 / (100 + mr)) or 1
  return mr_red
end

local q = function(obj)
	local p = q_slot.level>4 and 1.25 or 1
  local dmg = 30 + 40*q_slot.level + player.totalAp*0.65*p
  local mr_red = calc(obj)
  return dmg * mr_red
end

local w_cast = function(obj)  
  local p = w_cast_slot>4 and 1.2 or 1
  local dmg = 30 + 40*w_cast_slot.level + player.totalAp*0.7*p
  local mr_red = calc(obj)
  return dmg * mr_red
end

local e = function(obj)  
  local dmg = 40 + 45*e_slot.level + player.totalAp*0.6
  local mr_red = calc(obj)
  return dmg * mr_red
end

local r = function(obj)  
  local sphere_n = sphere_manager.count()
  local dmg = 120 + 150*r_slot.level + player.totalAp*0.6 + sphere_n*(40 + r_slot.level*50 + player.totalAp*0.2)
  local mr_red = calc(obj)
  return dmg * mr_red
end

return {
  q = q,
  w = w,
  e = e,
  r = r,
  calc = calc,
}