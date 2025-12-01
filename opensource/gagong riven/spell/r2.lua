local r2 = {
  slot = player:spellSlot(3),
  is_active = false,

  last = 0,
  last_cast = 0,
  last_start_pos = vec2(0,0),
  last_end_pos = vec2(0,0),
  
  delay = 0.25,
  speed = 1600,
  width = 5,
  range = (1100-100)^2,
}

local spell_name_start = 'RivenFengShuiEngine'
local spell_name_end = 'RivenIzunaBlade'
local buff_name = 'rivenwindslashready'

r2.is_ready = function()
  return r2.is_active and r2.slot.state == 0
end

r2.on_recv_spell = function(spell)
  if spell.slot == 3 and spell.name == spell_name_end then
    r2.is_active = false
    r2.last_cast = os.clock()
  end
end

local buff_active = function(name)
  for i = 0, player.buffManager.count - 1 do
    local buff = player.buffManager:get(i)
    if buff and buff.valid and buff.name == name and buff.endTime > game.time then
      return buff
    end
  end
end

r2.on_update_buff = function()
  local buff = buff_active(buff_name)
  if buff and buff.endTime ~= r2.last_buff then
    r2.last_buff = buff.endTime
    r2.is_active = true
    r2.last = os.clock()
  end
end

r2.on_remove_buff = function()
  local buff = buff_active(buff_name)
  if not buff and r2.last_buff then
    r2.last_buff = nil
    r2.is_active = false
  end
end

r2.dmg = function(obj)
  local missing_health_ratio = 1 + math.min((((obj.maxHealth - obj.health)/obj.maxHealth) * 100) * 0.0267, 2)
  return (50*r2.slot.level + 50 + .6*player.flatPhysicalDamageMod)*missing_health_ratio
end

return r2