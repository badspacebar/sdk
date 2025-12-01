local info = module.load(header.id, 'draw/info')
local circle = module.load(header.id, 'draw/circle')

local auto_e = module.load(header.id, 'Syndra/auto_e')
local menu = module.load(header.id, 'Syndra/menu')
local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')   
local q = module.load(header.id, 'Syndra/q')
local q_e = module.load(header.id, 'Syndra/q_e')
local e_on_q = module.load(header.id, 'Syndra/e_on_q')
local e_on_tar = module.load(header.id, 'Syndra/e_on_tar')
local w = module.load(header.id, 'Syndra/w')
local w_cast = module.load(header.id, 'Syndra/w_cast')
local r = module.load(header.id, 'Syndra/r')

local e_pause = 0
local q_e_pause = 0

local get_action = function()

  sphere_manager.update()
  
  local res_q = q.get_action_state()
  
  if menu.r:get() then
    if not menu.combat_r:get() or menu.combat:get() then
      if r.get_action_state(res_q) then
        r.invoke_action()
      end
    end
  end

  if menu.harass.auto_q:get() and res_q then
    q.invoke_action()
  end

  if menu.combat:get() then
    if os.clock() > q_e_pause then
      if e_on_q.get_action_state() then
        e_on_q.invoke_action()
        e_pause = os.clock() + network.latency + 0.25
      end
      if res_q then
        q.invoke_action()
      end
      if os.clock() > e_pause then
        if e_on_q.get_action_state() then
          e_on_q.invoke_action()
        end
      end
      if os.clock() > e_pause then
        if e_on_tar.get_action_state() then
          e_on_tar.invoke_action()
        end
      end
    end
    if w.get_action_state() then
      w.invoke_action()
    end
    if w_cast.get_action_state() then
      w_cast.invoke_action()
    end
  end

  if menu.combat:get() then return end

  if menu.q_e:get() then
    if q_e.get_action_state() then
      q_e.invoke_action()
      q_e_pause = os.clock() + network.latency + 0.25
    end
  end

  if menu.harass.key:get() then
    if menu.harass.q:get() and res_q then
      q.invoke_action()
    end
    if menu.harass.w:get() then
      if w.get_action_state() then
        w.invoke_action()
      end
      if w_cast.get_action_state() then
        w_cast.invoke_action()
      end
    end
  end

  if menu.clear.key:get() then
    if menu.clear.q:get() then
      if q.get_clear_state() then
        q.invoke_clear()
      end
    end
  end
  if menu.lasthit.key:get() then
    if menu.lasthit.q:get() then
      if q.get_farm_state() then
        q.invoke_farm()
      end
    end
  end
end

local str = 'Auto Q Enabled'
local on_draw_info = function()
  if not player.isOnScreen or player.isDead then return end
  if menu.harass.auto_q:get() then
    info.draw(str, 15, player.pos, 0xffffffff)
  end
  info.draw('Use R: '..(menu.r:get() and 'ON' or 'OFF'), 15, vec3(player.pos.x, player.pos.y, player.pos.z+20), 0xffffffff)
end

local on_draw_range = function()
  if not player.isOnScreen or player.isDead then return end
  local color = menu.range.c:get()
  if menu.range.q:get() then
    circle.on_draw(800, 10, player.pos.xzz, color)
  end
  if menu.range.q_e:get() then
    circle.on_draw(1100, 10, player.pos.xzz, color)
  end
  if menu.range.r:get() then
    local range = player:spellSlot(3).level == 3 and 750 or 675
    circle.on_draw(range, 10, player.pos.xzz, color)
  end
end

return {
  get_action = get_action,
  on_draw_info = on_draw_info,
  on_draw_range = on_draw_range,
}