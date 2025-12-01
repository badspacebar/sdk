local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local q = module.load(header.id, 'spell/q')
local e = module.load(header.id, 'spell/e')
local w = module.load(header.id, 'spell/w')
local r2 = module.load(header.id, 'spell/r2')

local source = nil

local input = {
  delay = r2.delay,
  width = r2.width,
  speed = r2.speed,
  boundingRadiusMod = 1,
}

local consider_killable = function(obj, dist)
  local raw = player.baseAttackDamage + player.flatPhysicalDamageMod
  if w.is_ready() and dist < w.radius() then
    raw = raw + w.dmg()
  end
  if q.is_ready() and dist < q.radius() then
    raw = raw + q.dmg()
  end
  raw = raw + r2.dmg(obj)
  return raw * (100 / (100 + obj.armor)) > obj.health
end

local f = function(res, obj, dist)
  if dist > 1500 then return end
  if e.is_ready() then
    source = player.path.serverPos2D:lerp(obj.path.serverPos2D, 225/dist)
  end
  local seg = pred.linear.get_prediction(input, obj, source)
  if seg and seg.startPos:distSqr(seg.endPos) < r2.range then
    if consider_killable(obj, dist) then
      res.obj = obj
      res.pos = seg.endPos
      res.src = source
      return true
    end
  end
end

local res = {}

local get_prediction = function()
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return r2.is_ready()
end 

local get_action_state = function()
  if get_spell_state() then
    source = nil
    res = get_prediction()
    if res.obj then
      return res
    end
  end
end

local invoke_action = function(pause)
  if e.is_ready() then
    player:castSpell('pos', 2, vec3(res.src.x, res.obj.y, res.src.y))
  end
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
