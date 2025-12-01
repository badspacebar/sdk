local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local q = module.load(header.id, 'spell/q')
local e = module.load(header.id, 'spell/e')
local flash = module.load(header.id, 'spell/flash')

local input = {
  delay = 0,
  radius = 0,
  dashRadius = 0,
  boundingRadiusModSource = 0,
  boundingRadiusModTarget = 0,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  local pos = pred.present.get_prediction(input, obj)
  if pos then
    res.obj = obj
    res.obj_pos = pos
    return true
  end
end

local res = {}

local get_prediction = function()
  input.delay = q.delay() + e.delay
  input.radius = player.attackRange - 100
  input.dashRadius = q.radius() + e.radius + flash.radius
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return e.is_ready() and flash.is_ready(0.150) and q.is_ready(0.150)
end

local get_action_state = function()
  if get_spell_state() then
    res = get_prediction()
    if res.obj then
      local p = pred.present.get_source_pos(player)
      res.pos = p:lerp(res.obj_pos, 250/p:dist(res.obj_pos))
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
  return q.radius() + e.radius + flash.radius + player.attackRange - 100
end

local get_total_delay = function()
  return q.delay() + e.delay
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
  get_total_radius = get_total_radius,
  get_total_delay = get_total_delay,
}
