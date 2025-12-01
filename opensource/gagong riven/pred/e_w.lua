local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local w = module.load(header.id, 'spell/w')
local e = module.load(header.id, 'spell/e')
local push = module.load(header.id, 'pred/push')

local input = {
  delay = e.delay,
  radius = 0,
  dashRadius = e.radius,
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
  input.radius = w.radius() - 80
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return e.is_ready() and w.is_ready(0.150)
end

local get_action_state = function(raw)
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
  return w.radius() + e.radius - 80
end

local get_total_delay = function()
  return e.delay
end

local get_push_state = function()
  if get_spell_state() then
    local obj, pos = push.get_prediction(get_total_delay(), get_total_radius())
    if obj then
      local p1 = pred.present.get_source_pos(player)
      local p2 = p1:lerp(pos, 250/p1:dist(pos))
      res = {obj = obj, pos = p2}
      return res
    end
  end
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
  get_total_radius = get_total_radius,
  get_total_delay = get_total_delay,
  get_push_state = get_push_state,
}
