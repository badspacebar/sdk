local TS = module.internal('TS')
local pred = module.internal('pred')

local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')

local slot = player:spellSlot(1)
local rangeSqr = 950*950

local input = {
  delay = 0.1,
	speed = 1450,
	radius = 200, --225
	boundingRadiusMod = 0,
}

local f = function(res, obj, dist)
  if dist > 2000 then return end
  
  local seg = pred.circular.get_prediction(input, obj)
  if seg then
    local d = seg.startPos:dist(seg.endPos)
    if d < 950 then
      if sphere_manager.is_in_e(obj.path.serverPos2D) then
        local castpos = seg.startPos:lerp(seg.endPos, 100/d + 1)
        if seg.startPos:distSqr(castpos) < rangeSqr then
          seg.endPos = castpos
        end
      end
      res.obj = obj
      res.pos = seg.endPos
      return true
    end
  end
end

local w_pause = 0
local on_cast_w = function(spell)
  if spell.owner == player and spell.name == 'SyndraW' then
    w_pause = os.clock() + 0.25
  end
end

local res
local w_cast_pause = 0 
local get_action_state = function()
  if slot.state == 0 and slot.name == 'SyndraWCast' then
    if os.clock() > w_cast_pause and os.clock() > w_pause then
      res = TS.get_result(f)
      if res.obj then
        return res
      end
    end
  end
end

local invoke_action = function()
  local pos = vec3(res.pos.x, res.obj.y, res.pos.y)
  player:castSpell('pos', 1, pos)
  w_cast_pause = os.clock() + network.latency + 0.5
end

return {
  on_cast_w = on_cast_w,
  get_action_state = get_action_state,
  invoke_action = invoke_action,
}