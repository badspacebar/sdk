local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local q = module.load(header.id, 'spell/q')
local push = module.load(header.id, 'pred/push')

local source = nil

local input = {
  delay = 0,
  radius = 0,
  dashRadius = 0,
  boundingRadiusModSource = 1,
  boundingRadiusModTarget = 1,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  if pred.present.get_prediction(input, obj, source) then
    res.obj = obj
    return true
  end
end

local res = {}

local get_prediction = function()
  input.delay = q.delay()
  input.radius = player.attackRange - 80
  input.dashRadius = q.radius()
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return q.is_ready() 
end

local get_action_state = function(pos)
  if get_spell_state() then
    source = pos
    res = get_prediction(pos)
    if res.obj then
      return res
    end
  end
end

local invoke_action = function(pause)
  player:castSpell('obj', 0, res.obj)
  if pause then
    orb.core.set_server_pause()
  end
end

local get_total_radius = function()
  return q.radius() + player.attackRange - 80
end

local get_display_radius = function()
  return get_total_radius() + 50
end

local get_total_delay = function()
  return q.delay()
end

local get_push_state = function()
  if get_spell_state() then
    local obj = push.get_prediction(get_total_delay(), get_total_radius())
    if obj then
      res = {obj = obj}
      return res
    end
  end
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_total_radius = get_total_radius,
  get_display_radius = get_display_radius,
  get_spell_state = get_spell_state,
  get_total_delay = get_total_delay,
  get_push_state = get_push_state,
}
