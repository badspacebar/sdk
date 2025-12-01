local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local w = module.load(header.id, 'spell/w')
local push = module.load(header.id, 'pred/push')

local source = nil

local input = {
  delay = 0,
  radius = 0,
  dashRadius = 0,
  boundingRadiusModSource = 0,
  boundingRadiusModTarget = 0,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  if pred.present.get_prediction(input, obj, source) then
    res.obj = obj
    return true
  end
end

local res = {}

local get_prediction = function(pos)
  input.radius = w.radius()
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return w.is_ready()
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
  player:castSpell('self', 1)
  if pause then
    orb.core.set_server_pause()
  end
end

local get_total_radius = function()
  return w.radius()
end

local get_total_delay = function()
  return 0
end

local get_push_state = function()
  if get_spell_state() then
    local obj = push.get_prediction(get_total_delay(), get_total_radius())
    if obj then
      return {obj = obj}
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
