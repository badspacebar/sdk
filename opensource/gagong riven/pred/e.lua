local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local e = module.load(header.id, 'spell/e')

local input = {
  delay = e.delay,
  radius = 0,
  dashRadius = e.radius,
  boundingRadiusModSource = 1,
  boundingRadiusModTarget = 1,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  local pos = pred.present.get_prediction(input, obj)
  if pos then
    res.obj = obj
    res.pos = pos
    return true
  end
end

local res = {}

local get_prediction = function()
  input.radius = player.attackRange - 80
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return e.is_ready()
end

local get_action_state = function()
  if get_spell_state() then
    res = get_prediction()
    if res.obj then
      local p = pred.present.get_source_pos(player)
      res.pos = p:lerp(res.pos, 250/p:dist(res.pos))
      return res
    end
  end
end

local invoke_action = function(pause)
  player:castSpell('pos', 2, vec3(res.pos.x, res.obj.y, res.pos.y))
  if pause then
    orb.core.set_server_pause()
  end
end

local get_total_radius = function()
  return e.radius + player.attackRange - 80
end

local get_display_radius = function()
  return get_total_radius() + 50
end

local get_total_delay = function()
  return e.delay
end

local get_push_state = function()
  if get_spell_state() then
    res.obj = player
    res.pos = vec2(mousePos.x, mousePos.z)
    return true
  end
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
  get_total_radius = get_total_radius,
  get_display_radius = get_display_radius,
  get_total_delay = get_total_delay,
  get_push_state = get_push_state,
}
