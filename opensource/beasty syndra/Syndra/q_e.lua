local TS = module.internal('TS')
local pred = module.internal('pred')

local q_slot = player:spellSlot(0)
local e_slot = player:spellSlot(2)

local min_range = 800
local max_range = 1100

local input = {
  delay = 0.32,
  speed = 2000,
  width = 100,
  boundingRadiusMod = 1,
  collision = {
    hero = true,
    minion = false,
    wall = false,
  },
}

local f = function(res, obj, dist)
  if dist > 3000 then return end
  local seg = pred.linear.get_prediction(input, obj)
  if seg then
    local dist = seg.startPos:dist(seg.endPos)
    if dist < max_range and dist > min_range then
      local castpos = seg.startPos:lerp(seg.endPos, 750/dist)
      res.obj = obj
      res.pos = castpos
      return true
    end
  end
end

local t = function(res)
  if pred.trace.newpath(res.obj, 0.033, 0.500) then
    return true
  end
end

local res
local get_action_state = function()
  if q_slot.state == 0 and e_slot.state == 0 then
    res = TS.get_result(f)
    if res.obj and t(res) then
      return res
    end
  end
end

local invoke_action = function()
  local pos = vec3(res.pos.x, res.obj.y, res.pos.y)
  player:castSpell('pos', 0, pos)
  player:castSpell('pos', 2, pos)
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
}