local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local slot = player:spellSlot(0)
local rangeSqr = 800*800

local input = {
  delay = 0.625,
  range = 800,
  speed = math.huge,
  radius = 210,
  boundingRadiusMod = 0,
  damage = function(obj)
    local p = slot.level>4 and 1.25 or 1
    return 30 + 40*slot.level + (player.totalAp*0.6)*p
  end,
}

local f = function(res, obj, dist)
  if dist > 2000 then return end
  local seg = pred.circular.get_prediction(input, obj)
  if seg and seg.startPos:distSqr(seg.endPos) < rangeSqr then
    res.obj = obj
    res.pos = seg.endPos
    return true
  end
end

local res
local q_pause = 0
local get_action_state = function()
  if slot.state == 0 and os.clock() > q_pause then 
    res = TS.get_result(f)
    if res.pos then
      return res
    end
  end
end

local invoke_action = function()
  local pos = vec3(res.pos.x, res.obj.y, res.pos.y)
  player:castSpell('pos', 0, pos)
  q_pause = os.clock() + network.latency + 0.5
end

local seg, obj
local get_clear_state = function()
  if slot.state == 0 and os.clock() > q_pause then
    seg, obj = orb.farm.skill_clear_circular(input)
    if seg then
      return true
    end
  end
end

local invoke_clear = function()
  local pos = vec3(seg.endPos.x, obj.pos.y, seg.endPos.y)
  player:castSpell('pos', 0, pos)
  q_pause = os.clock() + network.latency + 0.5
end

local get_farm_state = function()
  if slot.state == 0 and os.clock() > q_pause then
    seg, obj = orb.farm.skill_farm_circular(input)
    if seg then
      return true
    end
  end
end

local invoke_farm = function()
  local pos = vec3(seg.endPos.x, obj.pos.y, seg.endPos.y)
  player:castSpell('pos', 0, pos)
  q_pause = os.clock() + network.latency + 0.5
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_clear_state = get_clear_state,
  invoke_clear = invoke_clear,
  get_farm_state = get_farm_state,
  invoke_farm = invoke_farm,
}