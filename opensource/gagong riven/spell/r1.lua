local menu = module.load(header.id, 'menu')

local r1 = {
  slot = player:spellSlot(3),
  is_active = false,
  last = 0,
}

local spell_name = 'RivenFengShuiEngine'
local buff_name = 'RivenFengShuiEngine'

r1.is_ready = function(t)
  if r1.is_active then
    return false
  end
  return t and r1.slot.cooldown < t or r1.slot.state == 0
end

r1.on_recv_spell = function(spell)
  if spell.slot == 3 and spell.name == spell_name then
    r1.is_active = true
    r1.last = os.clock()
    --print('r1 start '..os.clock())
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

r1.on_remove_buff = function(buff)
  if os.clock() > r1.last + 2 then
    local buff = buff_active(buff_name)
    if not buff and r1.is_active then
      r1.is_active = false
      --print('r1 end '..os.clock())
    end
  end
end

return r1
