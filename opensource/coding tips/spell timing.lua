local menu = menu('menu_example', 'Menu Example')
menu:keybind('key', 'key', 'N', nil)

local pred = module.internal('pred')
local orb = module.internal('orb')

local q = {
  slot = player:spellSlot(_Q),
  range = 1150,
  pred_input = {
    delay = 0.25,
    speed = 2000,
    width = 60,
    boundingRadiusMod = 1,
  },
}

local w = {
  slot = player:spellSlot(_W),
  range = 900,
  pred_input = {
    delay = 0.25,
    speed = 1700,
    width = 60,
    boundingRadiusMod = 1,
  },
}

local pred_linear = function(spell, target)
  local seg = pred.linear.get_prediction(spell.pred_input, target)
  if seg.startPos:dist(seg.endPos) < spell.range then
    return seg.endPos:to3D(target.y)
  end
end

cb.add(cb.tick, function()
  if not menu.key:get() then
    return
  end

  local target = game.selectedTarget
  if not target then
    return
  end

  if w.slot.state == 0 and not orb.core.is_spell_locked() then
    local pos = pred_linear(w, target)
    if pos then
      player:castSpell('pos', _W, pos)
      print(os.clock(), 'cast spell w')
    end
  end

  if q.slot.state == 0 and not orb.core.is_spell_locked() then
    local pos = pred_linear(q, target)
    if pos then
      player:castSpell('pos', _Q, pos)
      print(os.clock(), 'cast spell q')
    end
  end
end)
