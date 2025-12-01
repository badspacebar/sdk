local TS = module.internal('TS')
local pred = module.internal('pred')

local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')

local slot = player:spellSlot(2)
local range = 825
local sphere_push_dist = 1100

local src_pos2D
local valid_spheres = {}

local input = {
  delay = 0.25,
  speed = 2000,
  width = 100,
  boundingRadiusMod = 1,
  collision = {
    hero = true,
  },
}

local endpos
local f = function(res, obj, dist)
  if dist > 2000 then return end

  for i=1, #valid_spheres do
    local sphere_pos2D = valid_spheres[i].pos
    endpos = src_pos2D:lerp(sphere_pos2D, sphere_push_dist/dist)
    
    local seg = pred.core.result()
    seg.startPos = vec2(sphere_pos2D.x, sphere_pos2D.y)
    seg.endPos = vec2(endpos.x, endpos.y)
    --input.delay = valid_spheres[i].t + 0.25

    if pred.collision.get_prediction(input, seg) then
      res.obj = obj
      res.pos = seg.startPos
      return true
    end
  end
end

local res
local e_pause = 0
local get_action_state = function()
  if slot.state == 0 and os.clock() > e_pause then
    src_pos2D = pred.present.get_source_pos(player)
    valid_spheres = sphere_manager.is_valid_e(src_pos2D, range, input.delay)
    if valid_spheres[1] then
      res = TS.get_result(f)
      if res.obj then
        return res
      end
    end
  end
end

local invoke_action = function()
  local pos = vec3(res.pos.x, res.obj.y, res.pos.y)
  player:castSpell('pos', 2, pos)
  e_pause = os.clock() + network.latency + 0.5
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
}