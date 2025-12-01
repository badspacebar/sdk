local flash = {
  slot = nil,
  delay = 0,
  radius = 400,
  last_cast = 0,
  last_cast_pos = vec2(0, 0)
}

local update = 0
cb.add(cb.tick, function()
  if os.clock() > update then
    update = os.clock() + 10
    slot = nil
    for i = 4, 5 do
      local spell = player:spellSlot(i)
      if spell.isNotEmpty and spell.name:lower():find('flash') then
        flash.slot = spell
      end
    end
  end
end)

cb.add(cb.castspell, function(slot, startPos, endPos)
  if flash.slot and flash.slot.slot == slot then
    flash.last_cast = os.clock()
    flash.last_cast_pos = vec2(startPos.x, startPos.z)
  end
end)

flash.is_ready = function(t)
  if flash.slot then
    return t and flash.slot.cooldown < t or flash.slot.state == 0
  end
end

return flash