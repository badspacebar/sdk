local TS =  module.internal('TS')
local gpred =  module.internal('pred')

local menu = module.load(header.id, 'menu')

local ai = module.load(header.id, 'core/ai')
local push = module.load(header.id, 'pred/push')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')

local crescent_wrapper = module.load(header.id, 'item/crescent_wrapper')

local get_flash_combo = function()
  local p2 = player.path.serverPos2D
  
  if pred.e_flash_w.get_spell_state() then
    local p1 = gpred.core.get_pos_after_time(TS.selected, pred.e_flash_w.get_total_delay())
    if p1:distSqr(p2) > mathf.sqr(pred.flash_w.get_total_radius()) then
      local r1 = pred.flash_w.get_total_radius()
      local r2 = pred.e_flash_w.get_total_radius()
      if pred.r1.get_spell_state() then
        if pred.e_q.get_spell_state() then
          return p1, r1, r2, 'E+R1->[F+W+Q]'
        end
        return p1, r1, r2, 'E+R1->[F+W]'
      end
      if pred.r2.get_spell_state() then
        if pred.e_q.get_spell_state() then
          return p1, r1, r2, 'E+R2->[F+W+Q]'
        end
        return p1, r1, r2, 'E+R2->[F+W]'
      end
      if not menu.flash_only_r:get() then
        if pred.e_q.get_spell_state() then
          return p1, r1, r2, 'E->[F+W+Q]'
        end
        return p1, r1, r2, 'E->[F+W]'
      end
    end
  end

  if pred.e_flash_q.get_spell_state() then
    if not pred.w.get_spell_state() then
      local p1 = gpred.core.get_pos_after_time(TS.selected, pred.e_flash_q.get_total_delay())
      if p1:distSqr(p2) > mathf.sqr(pred.flash_q.get_total_radius()) then
        local r1 = pred.flash_q.get_total_radius()
        local r2 = pred.e_flash_q.get_total_radius()
        if pred.r1.get_spell_state() then
          return p1, r1, r2, 'E+R1->[F+Q]'
        end
        if pred.r2.get_spell_state() then
          return p1, r1, r2, 'E+R2->[F+Q]'
        end
        if not menu.flash_only_r:get() then
          if not menu.flash_only_r:get() then
            return p1, r1, r2, 'E->[F+Q]'
          end
        end
      end
    end
  end

  if menu.flash_only_r:get() then
    return
  end

  if pred.flash_w.get_spell_state() then
    local p1 = gpred.present.get_source_pos(TS.selected)
    if p1:distSqr(p2) > mathf.sqr(pred.e_w.get_total_radius()) then
      local r1 = pred.e_w.get_total_radius()
      local r2 = pred.flash_w.get_total_radius()
      if pred.q.get_spell_state() then
        if pred.e.get_spell_state() then
          return p1, r1, r2, 'E+F+W+Q->[?]'
        end
        if ai.can_double_cast() then
          return p1, r1, r2, 'F+W+Q->[?]'
        end
      end
      return p1, r1, r2, 'F+W->[?]'
    end
  end

  if pred.flash_q.get_spell_state() then
    if not pred.w.get_spell_state() then
      local p1 = gpred.present.get_source_pos(TS.selected)
      if p1:distSqr(p2) > mathf.sqr(pred.e_q.get_total_radius()) then
        local r1 = pred.e_q.get_total_radius()
        local r2 = pred.flash_q.get_total_radius()
        return p1, r1, r2, 'F+Q->[?]'
      end
    end
  end

end

local get_gapclose_combo = function(obj)
  local p2 = player.path.serverPos2D
  
  if menu.gap_e_w:get() and pred.e_w.get_spell_state() then
    local p1 = gpred.core.get_pos_after_time(obj, pred.e_w.get_total_delay())
    if p1:distSqr(p2) > mathf.sqr(pred.aa.get_display_radius()) then
      local r1 = pred.aa.get_display_radius()
      local r2 = pred.e_w.get_total_radius()
      if menu.r1:get() and pred.r1.get_spell_state() then
        if pred.q.get_spell_state() then
          if menu.e_aa:get() then
            return p1, r1, r2, 'E+R1->[AA->[W+Q]]'
          end
          return p1, r1, r2, 'E+R1->[W+Q]'
        end
        if menu.e_aa:get() then
          return p1, r1, r2, 'E+R1->[AA->[W]]'
        end
        return p1, r1, r2, 'E+R1->[W]'
      end
      if crescent_wrapper.get_spell_state() then
        if pred.q.get_spell_state() then
          if menu.e_aa:get() then
            return p1, r1, r2, 'E+H->[AA->[W+Q]]'
          end
          return p1, r1, r2, 'E+H->[W+Q]'
        end
        if menu.e_aa:get() then
          return p1, r1, r2, 'E+H->[AA->[W]]'
        end
        return p1, r1, r2, 'E+H->[W]'
      end
      if pred.q.get_spell_state() then
        if menu.e_aa:get() then
          return p1, r1, r2, 'E->[AA->[W+Q]]'
        end
        return p1, r1, r2, 'E->[W+Q]'
      end
      if menu.e_aa:get() then
        return p1, r1, r2, 'E->[AA->[W]]'
      end
      return p1, r1, r2, 'E->[W]'
    end
  end

  if menu.gap_e_q:get() and pred.e_q.get_spell_state() then
    local p1 = gpred.core.get_pos_after_time(obj, pred.e_q.get_total_delay())
    if p1:distSqr(p2) > mathf.sqr(pred.aa.get_display_radius()) then
      local r1 = pred.aa.get_display_radius()
      local r2 = pred.e_q.get_total_radius()
      if menu.r1:get() and pred.r1.get_spell_state() then
        if menu.e_aa:get() then
          return p1, r1, r2, 'E+R1->[AA->[Q]]'
        end
        return p1, r1, r2, 'E+R1->[Q]'
      end
      if crescent_wrapper.get_spell_state() then
        if menu.e_aa:get() then
          return p1, r1, r2, 'E+H->[AA->[Q]]'
        end
        return p1, r1, r2, 'E+H->[Q]'
      end
      if menu.e_aa:get() then
        return p1, r1, r2, 'E->[AA->[Q]]'
      end
      return p1, r1, r2, 'E->[Q]'
    end
  end

  if menu.gap_q:get() and pred.q.get_spell_state() then
    local p1 = gpred.core.get_pos_after_time(obj, pred.q.get_total_delay())
    if p1:distSqr(p2) > mathf.sqr(pred.aa.get_display_radius()) then
      local r1 = pred.q.get_display_radius()
      local r2 = pred.aa.get_display_radius()
      return p1, r1, r2, 'Q->[?]'
    end
  end

  if menu.gap_e_aa:get() and pred.e.get_spell_state() then
    local p1 = gpred.core.get_pos_after_time(obj, pred.e.get_total_delay())
    if p1:distSqr(p2) > mathf.sqr(pred.aa.get_display_radius()) then
      local r1 = pred.e.get_display_radius()
      local r2 = pred.aa.get_display_radius()
      if menu.r1:get() and pred.r1.get_spell_state() then
        return p1, r1, r2, 'E+R1->[?]'
      end
      return p1, r1, r2, 'E->[?]'
    end
  end


end

local v1, v2 = vec3(0,0,0), vec3(0,0,0)
local draw_combo = function(p1, r1, r2, combo, color, obj)

  local p2 = player.pos2D
  local dx = p1:dist(p2)

  local q1 = p1:lerp(p2, r1/dx)
  local q2 = p1:lerp(p2, r2/dx)

  local norm = (p2-p1):norm()
  local perp1 = norm:perp1()*125
  local perp2 = norm:perp2()*125

  v1.x = q1.x + perp1.x
  v1.y = obj.y
  v1.z = q1.y + perp1.y

  v2.x = q1.x + perp2.x
  v2.y = obj.y
  v2.z = q1.y + perp2.y
  
  graphics.draw_line(v1, v2, 2, color)

  v1.x = q2.x + perp1.x
  v1.z = q2.y + perp1.y

  v2.x = q2.x + perp2.x
  v2.z = q2.y + perp2.y
  
  graphics.draw_line(v1, v2, 2, color)

  local t = q1:lerp(q2, 0.5)

  v1.x = t.x
  v1.z = t.y

  local p = graphics.world_to_screen(v1)

  local dx = graphics.text_area(combo, 15)

  graphics.draw_text_2D(combo, 15, p.x - dx*0.5, p.y, color)

end

local flash = false
local str_f = 'Flash combo ready'
local dx_f = graphics.text_area(str_f, 15)
local flash_combo = function()
  flash = false
  if TS.selected and spell.flash.is_ready() then

    local p1, r1, r2, combo = get_flash_combo()

    if not p1 then
      if true then return end
      if player.pos:distSqr(TS.selected.pos) > 600*600 then
        local q1 = player.pos2D:lerp(TS.selected.pos2D, 0.5)
        v1.x = q1.x
        v1.y = TS.selected.y
        v1.z = q1.y
        local p = graphics.world_to_screen(v1)
        local dx = graphics.text_area('No Flash Combo Ready', 15)
        graphics.draw_text_2D('No Flash Combo Ready', 15, p.x - dx*0.5, p.y, 0xffff0000)
      end
      return
    end

    draw_combo(p1, r1, r2, combo, 0xffffff00, TS.selected)

    flash = true

    if player.isOnScreen then
      local p = graphics.world_to_screen(player.pos)
      graphics.draw_text_2D(str_f, 15, p.x-math.floor(dx_f*0.5), p.y+37, 0xffffff00)
    end

  end
end

local get_nearest_enemy = function()
  if TS.selected then
    return TS.selected
  end
  local t, min = nil, math.huge
  local p = player.pos
  for i = 0, objManager.enemies_n - 1 do
    local obj = objManager.enemies[i]
    if not obj.isDead and obj.isTargetable and obj.isVisible then
      local d = p:distSqr(obj.pos)
      if d < min then
        t, min = obj, d
      end
    end
  end
  return t
end

local gapclose = function()
  if not flash and player.isOnScreen then
    local obj = get_nearest_enemy()
    if obj and obj.isOnScreen then
      local p1, r1, r2, combo = get_gapclose_combo(obj)
      if p1 then
        draw_combo(p1, r1, r2, combo, 0xffffd1de, obj)
      end
    end
  end
end

local str = 'Panic Clear'
local dx = graphics.text_area(str, 15)
local push = function()
  if not flash and player.isOnScreen and menu.push:get() then
    local p = graphics.world_to_screen(player.pos)
    graphics.draw_text_2D(str, 15, p.x-dx*0.5, p.y+37, 0xffFF69B4)
    local obj = push.get_nearest_minion_to_mouse()
    if obj and obj.isOnScreen then
      graphics.draw_circle(obj.pos, 16, 2, 0xffFF69B4, 4)
    end
  end
end

local str = 'Use R1 in next combo'
local dx = graphics.text_area(str, 15)
local r1 = function()
  if not flash and player.isOnScreen and not menu.push:get() then
    local p = graphics.world_to_screen(player.pos)
    if menu.r1:get() then
      graphics.draw_text_2D(str, 15, p.x-math.floor(dx*0.5), p.y+37, 0xffCBFDCB)
    end
  end
end

local str = 'Consider E[+?]->[AA->[?]]'
local dx = graphics.text_area(str, 15)
local e_aa = function()
  if not flash and player.isOnScreen then
    local p = graphics.world_to_screen(player.pos)
    if menu.e_aa:get() then
      graphics.draw_text_2D(str, 15, p.x-math.floor(dx*0.5), p.y+52, 0x33ffffff)
    end
  end
end

return {
  flash_combo = flash_combo,
  gapclose = gapclose,
  push = push,
  r1 = r1,
  e_aa = e_aa,
}