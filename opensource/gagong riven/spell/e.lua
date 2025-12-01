local e = {
  slot = player:spellSlot(2),
  delay = 0.233,
  radius = 250,
  pos = vec2(0,0),
}

e.is_ready = function(t)
  return t and e.slot.cooldown < t or e.slot.state == 0
end

e.on_new_path = function(spell)
  if spell.slot == 2 then
    local p = spell.startPos:lerp(spell.endPos, 250/spell.startPos:dist(spell.endPos))
    e.pos = vec2(p.x, p.z)
  end
end

--cb.add(cb.draw, function()
--  graphics.draw_circle(vec3(e.pos.x,player.y,e.pos.y),30,3,graphics.argb(255,255,255,0),33)
--end)

return e