local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local r2 = module.load(header.id, 'spell/r2')

local source = nil

local input = {
  delay = r2.delay,
  width = r2.width,
  speed = r2.speed,
  boundingRadiusMod = 1,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  local seg = pred.linear.get_prediction(input, obj, source)
  if seg and seg.startPos:distSqr(seg.endPos) < r2.range then
    res.obj = obj
    res.pos = seg.endPos
    return true
  end
end

local res = {}

local get_prediction = function()
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return r2.is_ready()
end 

local get_action_state = function(pos)
  if get_spell_state() then
    source = pos
    res = get_prediction()
    if res.obj then
      return res
    end
  end
end

local invoke_action = function(pause)
  player:castSpell('pos', 3, vec3(res.pos.x, res.obj.y, res.pos.y))
  r2.last_start_pos = source
  r2.last_end_pos = res.pos
  if pause then
    orb.core.set_server_pause()
  end
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
}
