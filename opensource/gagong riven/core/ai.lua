math.randomseed(os.time())

local TS = module.internal('TS')
local orb =  module.internal('orb')

local menu = module.load(header.id, 'menu')

local spell = module.load(header.id, 'spell/main')
local pred = module.load(header.id, 'pred/main')

local crescent_wrapper = module.load(header.id, 'item/crescent_wrapper')

local on_end_func = nil
local on_end_time = 0
local on_end_start = 0
local f_spell_map = {}

local last_e = 0
local double_cast_timeout = 1.050

local pre_r2 = false

local last_spell = 0

local on_cast_qx = {}
local on_end_qx = {}

local can_double_cast = function()
  return os.clock() + network.latency < last_e + double_cast_timeout
end

local on_after_attack = function()
  --print("after attack", os.clock())
  if menu.push:get() then
    if menu.push_e:get() and menu.push_w:get() then
      if pred.e_w.get_push_state() then
        if pred.e_q.get_spell_state() then
          pred.e_w.invoke_action(true)
          if crescent_wrapper.is_ready() then
            crescent_wrapper.invoke_action(true)
          end
          orb.combat.set_invoke_after_attack(false)
          return true
        end
      end
    end
    if crescent_wrapper.is_ready() then
      crescent_wrapper.invoke_action(true)
      orb.combat.set_invoke_after_attack(false)
      return true
    end
    local w = pred.w.get_push_state()
    if menu.push_w:get() then
      if w then
        if pred.q.get_spell_state() then
          if can_double_cast() then
            pred.w.invoke_action(true)
            player:castSpell('obj', 0, w.obj)
            orb.combat.set_invoke_after_attack(false)
            return true
          end
        end
      end
    end
    if pred.q.get_push_state() then
      pred.q.invoke_action(true)
      orb.combat.set_invoke_after_attack(false)
      return true
    end
    if menu.push_w:get() then
      if w then
        pred.w.invoke_action(true)
        orb.combat.set_invoke_after_attack(false)
        return true
      end
    end
    if menu.push_e:get() then
      if pred.e.get_push_state() then
        pred.e.invoke_action()
      end
    end
  end

  if not menu.combat:get() then return end

  local w = pred.w.get_action_state()
  local q = pred.q.get_action_state()
  local rh = crescent_wrapper.get_action_state()
  local th = false--t_hydra.get_action_state()
  local e_w = pred.e_w.get_action_state()
  local e = pred.e.get_action_state()

  if menu.r1:get() and orb.core.cur_attack_target and orb.core.cur_attack_target.type == TYPE_HERO then
    if pred.r1.get_action_state() then
      if e_w then
        pred.e_w.invoke_action(true)
      elseif e then
        pred.e.invoke_action(true)
      end
      pred.r1.invoke_action()
      orb.combat.set_invoke_after_attack(false)
      return true
    end
  end

  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
    return true
  end

  if e_w and math.random()*100 <= menu.e_double_cast_weight:get() then
    pred.e_w.invoke_action(true)
    if crescent_wrapper.get_spell_state() then
      crescent_wrapper.invoke_action(true)
    end
    orb.combat.set_invoke_after_attack(false)
    return true
  end

  if w then
    if e_w then
      if e_w.obj.ptr ~= w.obj.ptr then
        pred.e_w.invoke_action(true)
        if crescent_wrapper.is_ready() then
          crescent_wrapper.invoke_action()
        end
        orb.combat.set_invoke_after_attack(false)
        return true -- aa->e->w
      end
    end
    if e then
      if e.obj.ptr ~= w.obj.ptr then
        pred.e.invoke_action(true)
        if crescent_wrapper.is_ready() then
          crescent_wrapper.invoke_action()
        end
        orb.combat.set_invoke_after_attack(false)
        return true -- aa->e->w
      end
    end
    if q then
      --print("1")
      if w.obj.ptr ~= q.obj.ptr then
        pred.q.invoke_action(true)
        orb.combat.set_invoke_after_attack(false)
        return true -- aa->q
      end
      if can_double_cast() then
        pred.w.invoke_action(true)
        pred.q.invoke_action(true)
        orb.combat.set_invoke_after_attack(false)
        return true -- aa->w+q
      end
    end
    pred.w.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->w
  end

  if e_w then
    pred.e_w.invoke_action(true)
    if crescent_wrapper.is_ready() then
      crescent_wrapper.invoke_action()
    end
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->e->w
  end

  if e then
    pred.e.invoke_action(true)
    if crescent_wrapper.is_ready() then
      crescent_wrapper.invoke_action()
    end
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->e->aa
  end

  if rh then
    crescent_wrapper.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->rh
  end

  if th then
    t_hydra.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->th
  end
  
  if q then
    --print("2")
    pred.q.invoke_action(true)
    orb.combat.set_invoke_after_attack(false)
    return true -- aa->q
  end

end

local general = function()

  if menu.push:get() then
    if pred.aa.get_push_state() then
      pred.aa.invoke_action(true)
      return true
    end
    if menu.push_e:get() and menu.push_w:get() then
      if pred.e_w.get_push_state() then
        if pred.e_q.get_spell_state() then
          pred.e_w.invoke_action(true)
          if crescent_wrapper.is_ready() then
            crescent_wrapper.invoke_action(true)
          end
          return true
        end
      end
    end
    if menu.push_e:get() then
      if not menu.push_w:get() or not pred.w.get_spell_state() then
        if pred.e_q.get_push_state() then
          pred.e_q.invoke_action(true)
          return true
        end
      end
    end
    if pred.q.get_push_state() then
      pred.q.invoke_action(true)
      return true
    end
    if orb.core.can_action() then
      player:move(mousePos)
    end
  end

  if not menu.combat:get() then return end
  
  local q = pred.q.get_action_state()
  local w = pred.w.get_action_state()
  local e = pred.e.get_action_state()
  local e_w = pred.e_w.get_action_state()
  local e_q = pred.e_q.get_action_state()

  if TS.selected and menu.flash:get() then
    --local t = os.clock()
    local flash_q = pred.flash_q.get_action_state()
    local flash_w = pred.flash_w.get_action_state()
    local e_flash_w = pred.e_flash_w.get_action_state()
    local e_flash_q = pred.e_flash_q.get_action_state()
    --local t = os.clock() - t
    --print("benchmark", t)

    if flash_w and not menu.flash_only_r:get() then
      if not w and not q and not e_w then
        if pred.q.get_spell_state() then
          if pred.e.get_spell_state() then
            player:castSpell('pos', 2, vec3(flash_w.pos.x, flash_w.obj.y, flash_w.pos.y))
            pred.flash_w.invoke_action(true)
            player:castSpell('obj', 0, flash_w.obj)
            return true
          end
          if can_double_cast() then
            pred.flash_w.invoke_action(true)
            player:castSpell('obj', 0, flash_w.obj)
            return true
          end
        end
        pred.flash_w.invoke_action(true)
        return true
      end
    end

    if flash_q and not menu.flash_only_r:get() then
      if not q and not e_q then
        if not pred.w.get_spell_state() then
          pred.flash_q.invoke_action(true)
          return true
        end
      end
    end

    if e_flash_w then
      if not e_w then
        if pred.r1.get_action_state() then
          pred.e_flash_w.invoke_action(true)
          pred.r1.invoke_action(true)
          return true
        end
        pre_r2 = true
        local pos = e_flash_w.pos
        if math.random()*100 <= menu.r2_flash:get() then
          pre_r2 = false
          local d = player.path.serverPos2D:dist(pos)
          pos = player.path.serverPos2D:lerp(pos, d/225)
        end
        if pred.r2.get_action_state(pos) then
          pred.e_flash_w.invoke_action(true)
          pred.r2.invoke_action(true)
          return true
        end
        if not menu.flash_only_r:get() then
          pred.e_flash_w.invoke_action(true)
          return true
        end
      end
    end

    if e_flash_q then
      if not e_q then
        if not pred.w.get_spell_state() then
          if pred.r1.get_action_state() then
            pred.e_flash_q.invoke_action(true)
            pred.r1.invoke_action(true)
            return true
          end
          pre_r2 = true
          local pos = e_flash_w.pos
          if math.random()*100 <= menu.r2_flash:get() then
            pre_r2 = false
            local d = player.path.serverPos2D:dist(pos)
            pos = player.path.serverPos2D:lerp(pos, d/225)
          end
          if pred.r2.get_action_state(pos) then
            pred.e_flash_q.invoke_action(true)
            pred.r2.invoke_action(true)
            return true
          end
          if not menu.flash_only_r:get() then
            pred.e_flash_q.invoke_action(true)
            return true
          end
        end
      end
    end
  end
  --if true then return true end
  if not orb.combat.target and os.clock() + network.latency > on_end_time  then
    if pred.r2_dmg.get_action_state() then
      pred.r2_dmg.invoke_action(true)
      return true
    end
    local ooc = os.clock() - last_spell
    if (menu.gap_e_w:get() or ooc < 0.75) and e_w then
      pred.e_w.invoke_action(true)
      if menu.r1:get() and pred.r1.get_action_state() then
        pred.r1.invoke_action(true)
      elseif crescent_wrapper.get_spell_state() then
        crescent_wrapper.invoke_action(true)
      end
      return true
    end 
    if (menu.gap_e_w:get() or ooc < 0.75) and e_q then
      if not pred.w.get_spell_state() then
        pred.e_q.invoke_action(true)
        if menu.r1:get() and pred.r1.get_action_state() then
          pred.r1.invoke_action(true)
        elseif crescent_wrapper.get_spell_state() then
          crescent_wrapper.invoke_action(true)
        end
        return true
      end
    end
    if (menu.gap_q:get() or ooc < 0.75) and q then
      if (menu.gap_e_aa:get() or ooc < 0.75) and e then
        if menu.r1:get() and pred.r1.get_action_state() then
          pred.e.invoke_action(true)
          pred.r1.invoke_action(true)
          return true
        elseif crescent_wrapper.get_spell_state() then
          pred.e.invoke_action(true)
          crescent_wrapper.invoke_action(true)
          return true
        end
      end
      pred.q.invoke_action(true)
      return true
    end
    if (menu.gap_e_aa:get() or ooc < 0.75) and e then
      pred.e.invoke_action(true)
      if menu.r1:get() and pred.r1.get_action_state() then
        pred.r1.invoke_action(true)
      elseif crescent_wrapper.get_spell_state() then
        crescent_wrapper.invoke_action(true)
      end
      return true
    end
  end

end

local on_end_q1 = function()
  on_end_func = nil
  orb.core.reset()
  orb.core.set_pause(0)
  --print("hi", os.clock(), orb.combat.target and 1 or 0)
  --print('end q1', os.clock())
  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end
  if not orb.combat.target then
    if pred.w.get_action_state() then
      pred.w.invoke_action(true)
    end
  end
end

local on_end_q2 = function()
  on_end_func = nil
  orb.core.reset()
  orb.core.set_pause(0)
  --print('end q2', os.clock())
  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end
  if not orb.combat.target then
    if pred.w.get_action_state() then
      pred.w.invoke_action(true)
    end
  end
end

local on_end_q3 = function()
  on_end_func = nil
  orb.core.reset()
  orb.core.set_pause(0)
  --print('end q3', os.clock())
  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end
  if not orb.combat.target then
    if pred.w.get_action_state() then
      pred.w.invoke_action(true)
    end
  end
end

local on_end_w = function()
  on_end_func = nil
  orb.core.set_pause(0)
  
  if not menu.combat:get() then return end

  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end

  local q = pred.q.get_action_state()
  local e = pred.e.get_action_state()
  local e_q = pred.e_q.get_action_state()
  local rh = crescent_wrapper.get_action_state()
  local r1 = pred.r1.get_action_state()

  if e_q and q then
    if e_q.obj.ptr ~= q.obj.ptr then
      e_q.invoke_action(true)
      if r1 and menu.r1:get() then
        pred.r1.invoke_action(true)
      end
      return true
    end
  end

  if e and q then
    if e.obj.ptr ~= q.obj.ptr then
      e.invoke_action(true)
      if r1 and menu.r1:get() then
        pred.r1.invoke_action(true)
      end
      return true
    end
  end

  if not orb.core.can_attack() then
    if q then
      --print("4")
      pred.q.invoke_action(true)
      return true -- w->q
    end
    if rh then
      crescent_wrapper.invoke_action(true)
      return true -- w->rh
    end
  end

end

local on_end_e = function()
  on_end_func = nil
  orb.core.set_pause(0)

  if menu.push:get() then
    if menu.push_w:get() then
      local w = pred.w.get_push_state()
      if w then
        pred.w.invoke_action(true)
        if pred.q.get_spell_state() then
          player:castSpell('obj', 0, w.obj)
        end
        return true
      end
    end
    if pred.q.get_push_state() then
      pred.q.invoke_action(true)
      return true
    end
  end

  if not menu.combat:get() then return end

  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end

  local w = pred.w.get_action_state(spell.e.pos)
  local q = pred.q.get_action_state(spell.e.pos)
  local flash_w = pred.flash_w.get_action_state(spell.e.pos)
  local flash_q = pred.flash_q.get_action_state(spell.e.pos)

  if TS.selected and menu.flash:get() then
    if flash_w then
      if not w and not q then
        pred.flash_w.invoke_action(true)
        if pred.q.get_spell_state() then
          player:castSpell('obj', 0, flash_w.obj)
        end
        return true
      end
    end
    if flash_q then
      if not q then
        if not pred.w.get_spell_state() then
          pred.flash_q.invoke_action(true)
          return true
        end
      end
    end
  end

  if menu.e_aa:get() then
    if orb.combat.target and orb.core.can_attack() then
      return true
    end
  end
  
  if w then
    if q then
      if w.obj.ptr ~= q.obj.ptr then
        pred.q.invoke_action(true)
        return true -- e->q
      end
      pred.w.invoke_action(true)
      pred.q.invoke_action(true)
      return true -- e->w+q
    end
    pred.w.invoke_action(true)
    return true -- e->w
  end

  if q then
    pred.q.invoke_action(true)
    return true -- e->q
  end

end

local on_end_r1 = function()
  on_end_func = nil
  orb.core.set_pause(0)

  if not menu.combat:get() then return end
  
  local pos = nil

  if os.clock() - last_e < 0.3 then
    pos = spell.e.pos
  end

  local w = pred.w.get_action_state(pos)
  local q = pred.q.get_action_state(pos)
  local flash_w = pred.flash_w.get_action_state(pos)
  local flash_q = pred.flash_q.get_action_state(pos)

  if TS.selected and menu.flash:get() then
    if flash_w then
      if not w and not q then
        pred.flash_w.invoke_action(true)
        if can_double_cast() and pred.q.get_spell_state() then
          player:castSpell('obj', 0, flash_w.obj)
        end
        return true
      end
    end
    if flash_q then
      if not q then
        if not pred.w.get_spell_state() then
          pred.flash_q.invoke_action(true)
          return true
        end
      end
    end
  end

  if menu.e_aa:get() then
    if orb.combat.target and orb.core.can_attack() then
      return true
    end
  end

  if w then
    if q then
      if w.obj.ptr ~= q.obj.ptr then
        pred.q.invoke_action(true)
        return true -- e->q
      end
      pred.w.invoke_action(true)
      pred.q.invoke_action(true)
      return true -- e->w+q
    end
    pred.w.invoke_action(true)
    return true -- e->w
  end

  if q then
    pred.q.invoke_action(true)
    return true -- e->q
  end

end

local pre_flash = false

local on_end_r2 = function()
  on_end_func = nil
  orb.core.set_pause(0)

  local q = pred.q.get_action_state()
  local w = pred.w.get_action_state()
  local e = pred.e.get_action_state()
  local e_w = pred.e_w.get_action_state()
  local flash_q = pred.flash_q.get_action_state()
  local flash_w = pred.flash_w.get_action_state()

  if not pre_r2 then
    if TS.selected and menu.flash:get() then

      if flash_w then
        if not w and not q and not e_w then
          if pred.q.get_spell_state() then
            if can_double_cast() then
              pred.flash_w.invoke_action(true)
              player:castSpell('obj', 0, flash_w.obj)
              return true
            end
          end
          pred.flash_w.invoke_action(true)
          return true
        end
      end

      if flash_q then
        if not q then
          if not pred.w.get_spell_state() then
            pred.flash_q.invoke_action(true)
            return true
          end
        end
      end
    end
  end

  if pre_flash then
    if flash_w then
      if not w and not q and not e_w then
        if pred.q.get_spell_state() then
          if pred.e.get_spell_state() then
            player:castSpell('pos', 2, vec3(flash_w.pos.x, flash_w.obj.y, flash_w.pos.y))
            pred.flash_w.invoke_action(true)
            player:castSpell('obj', 0, flash_w.obj)
            return true
          end
          if can_double_cast() then
            pred.flash_w.invoke_action(true)
            player:castSpell('obj', 0, flash_w.obj)
            return true
          end
        end
        pred.flash_w.invoke_action(true)
        return true
      end
    end
    if flash_q then
      if not w and not q and not e_w then
        pred.flash_q.invoke_action(true)
        return true
      end
    end
  end

  if not menu.combat:get() then return end
  
  local pos = nil

  if os.clock() - spell.flash.last_cast < 0.2 then
    pos = spell.flash.last_cast_pos
  end

  if w then
    if q then
      if w.obj.ptr ~= q.obj.ptr then
        pred.q.invoke_action(true)
        return true -- aa->q
      end
      if can_double_cast() then
        pred.w.invoke_action(true)
        pred.q.invoke_action(true)
        return true -- aa->w+q
      end
    end
    pred.w.invoke_action(true)
    return true -- aa->w
  end

  if q then
    pred.q.invoke_action(true)
    return true -- aa->q
  end
end

local on_end_pre_r2 = function()
  on_end_func = on_end_r2
  on_end_time = spell.r2.last_cast + 0.267

  if not pre_r2 then return end

  if not menu.combat:get() then return end

  local pos = nil

  if os.clock() - last_e < 0.3 then
    pos = spell.e.pos
  end
 
  local q = pred.q.get_action_state(pos)
  local w = pred.w.get_action_state(pos)
  local flash_w = pred.flash_w.get_action_state(pos)
  local flash_q = pred.flash_q.get_action_state(pos)

  pre_flash = false

  if TS.selected and menu.flash:get() then
    if flash_w then
      if not w and not q then
        pred.flash_w.invoke_action(true, true)
        pre_flash = true
        return true
      end
    end
    if flash_q then
      if not q then
        if not pred.w.get_spell_state() then
          pred.flash_q.invoke_action(true, true)
          pre_flash = true
          return true
        end
      end
    end
  end

end

local on_end_r_hydra = function()
  on_end_func = nil
  orb.core.set_pause(0)

  if menu.push:get() then
    if menu.push_e:get() and menu.push_w:get() then
      if pred.e_w.get_push_state() then
        if pred.e_q.get_spell_state() then
          pred.e_w.invoke_action(true)
          if crescent_wrapper.is_ready() then
            crescent_wrapper.invoke_action(true)
          end
          return true
        end
      end
    end
    if pred.q.get_push_state() then
      pred.q.invoke_action(true)
      return true
    end
    if menu.push_w:get() then
      if pred.w.get_push_state() then
        pred.w.invoke_action(true)
        return true
      end
    end
  end

  if not menu.combat:get() then return end

  if pred.r2_dmg.get_action_state() then
    pred.r2_dmg.invoke_action(true)
    return true
  end

  local w = pred.w.get_action_state()
  local q = pred.q.get_action_state()
  local e = pred.e.get_action_state()
  local e_w = pred.e_w.get_action_state()
  
  if menu.r1:get() then
    if pred.r1.get_action_state() then
      if e_w then
        pred.e_w.invoke_action(true)
      elseif e then
        pred.e.invoke_action(true)
      end
      pred.r1.invoke_action()
      orb.combat.set_invoke_after_attack(false)
    end
  end

  if w then
    if q then
      if w.obj.ptr ~= q.obj.ptr then
        pred.q.invoke_action(true)
        return true -- rh->q
      end
      pred.w.invoke_action(true)
      pred.q.invoke_action(true)
      return true -- rh->w+q
    end
    pred.w.invoke_action(true)
    return true -- rh->w
  end
  
  if not orb.core.can_attack(0.2) then
    if q then
      pred.q.invoke_action(true)
      return true -- rh->q
    end
  end

end

local move_to_mouse = function(d)
  local p1 = mousePos
  local p2 = player.path.serverPos
  if p1 == p2 then
    if orb.combat.target then
      p1 = orb.combat.target.path.serverPos
    end
    if menu.push:get() then
      local res = pred.aa.get_push_result()
      if res then
        p1 = res.obj.path.serverPos
      end
    end
    if p1 == p2 then
      p1 = vec3(p1.x+math.random()*10, p1.y, p1.z+math.random()*10)
    end
  end
  player:move(p2:lerp(p1, d/p1:dist(p2)))
end


local on_move_q1 = function()
  --print('move q1')
  move_to_mouse(400)
  on_end_func = on_end_q1
  on_end_time = on_end_time + 0.150 + 0.125
end

local on_move_q2 = function()
  --print('move q2')
  move_to_mouse(400)
  on_end_func = on_end_q2
  on_end_time = on_end_time + 0.150 + 0.125
end

local on_move_q3 = function()
  --print('move q3')
  move_to_mouse(400)
  on_end_func = on_end_q3
  on_end_time = on_end_time + 0.250 + 0.125
end

local on_cast_q1 = function()
  on_end_func = on_move_q1
  on_end_time = os.clock() + 0.15
end

local on_cast_q2 = function()
  --print('q2')
  on_end_func = on_move_q2
  on_end_time = os.clock() + 0.15
end

local on_cast_q3 = function()
  --print('q3')
  on_end_func = on_move_q3
  on_end_time = os.clock() + 0.25
end

local on_cast_q = function()
  last_e = 0
  orb.core.set_pause(2)
  on_cast_qx[spell.q.slot.stacks]()
end

local on_create_obj = function(obj)
  if true then
    if on_end_qx[obj.name] then
        --print("XX", obj.name)
      --print('override', obj.name, os.clock())
      on_end_func = on_end_qx[obj.name]
      on_end_time = os.clock() + 0.125
    end
  end
end

local on_cast_w = function()
  if os.clock() + 0.267 > on_end_time then
    on_end_func = on_end_w
    on_end_time = os.clock() + 0.267
    orb.core.set_pause(2)
  end
end

local on_cast_e = function()
  last_e = os.clock()
  if os.clock() + 0.237 > on_end_time then
    on_end_func = on_end_e
    on_end_time = os.clock() + 0.237
    if not menu.e_aa:get() then
      orb.core.set_pause(2)
    end
  end
end

local on_cast_r1 = function()
  if os.clock() + 0.250 > on_end_time then
    on_end_func = on_end_r1
    on_end_time = os.clock() + 0.250
    if os.clock() - last_e < 0.033 then
      on_end_time = os.clock() + 0.267
    end
    orb.core.set_pause(2)
  end
end

local on_cast_r2 = function()
  if os.clock() + 0.250 > on_end_time then
    on_end_func = on_end_pre_r2
    on_end_time = os.clock() + 0.175
    orb.core.set_pause(2)
  end
end

local on_cast_r_hydra = function(spell)
  if os.clock() + spell.windUpTime > on_end_time then
    on_end_func = on_end_r_hydra
    on_end_time = os.clock() + spell.windUpTime
    orb.core.set_pause(2)
  end
end

local get_action = function()
  if on_end_func then
    if os.clock() + network.latency > on_end_time then
      on_end_func()
    end
  end
  if orb.core.can_action() and not orb.core.is_paused() then
    general()
  end
end

local on_recv_spell = function(spell)
  --print(spell.name, spell.windUpTime, os.clock(), spell.isBasicAttack)
  if f_spell_map[spell.name] then
    f_spell_map[spell.name](spell)
    last_spell = os.clock()
  end
end

--cb.add(cb.missile, function(m)
  --print(m.name..' '..m.spell.static.lineWidth..' '..m.speed)
  --print(m.startPos:dist(m.endPos))
--end)

f_spell_map['RivenTriCleave'] = on_cast_q
f_spell_map['RivenMartyr'] = on_cast_w
f_spell_map['RivenFeint'] = on_cast_e
f_spell_map['RivenFengShuiEngine'] = on_cast_r1
f_spell_map['RivenIzunaBlade'] = on_cast_r2
f_spell_map['ItemTiamatCleave'] = on_cast_r_hydra

on_cast_qx[0] = on_cast_q1
on_cast_qx[1] = on_cast_q2
on_cast_qx[2] = on_cast_q3
on_cast_qx[3] = on_cast_q3

on_end_qx['Riven_Base_Q_01_detonate'] = on_end_q1
on_end_qx['Riven_Base_Q_02_detonate'] = on_end_q2
on_end_qx['Riven_Base_Q_03_detonate'] = on_end_q3
on_end_qx['Riven_Base_Q_01_detonate_ult'] = on_end_q1
on_end_qx['Riven_Base_Q_02_detonate_ult'] = on_end_q2
on_end_qx['Riven_Base_Q_03_detonate_ult'] = on_end_q3

orb.combat.register_f_after_attack(on_after_attack)
--orb.combat.register_f_out_of_range(on_out_of_range)

return {
  on_recv_spell = on_recv_spell,
  on_create_obj = on_create_obj,
  get_action = get_action,
  can_double_cast = can_double_cast,
}