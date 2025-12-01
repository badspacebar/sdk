local TS = module.internal('TS')
local pred = module.internal('pred')

local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')

local slot = player:spellSlot(2)
local range = 825
local rangeSqr = 825*825

local push_dist  = 100
local push_speed = 1600
local m_speed = 2000

local c_interval = 0.05
local c_lifetime = 2
local pa = vec2.array(c_lifetime/c_interval)

local sphere_br = 48
local s_pos

local input = {
  delay = 0.25,
  radius = 825,
  dashRadius = 0,
  boundingRadiusModSource = 1,
  boundingRadiusModTarget = 1,
}

local num_angles = 8
local min_hits = 2
local dynamic_iterations = 5

local is_sphere_collision = function(t_pos, t_boundingRadius, time)
  local spheres = sphere_manager.is_valid_tar(s_pos, range, push_dist, t_boundingRadius)
  if spheres[1] then
    local valid_dist = t_boundingRadius + sphere_br
    for i=1, #spheres do
      local s = spheres[i]
      if (t_pos:dist(s.pos) < valid_dist) then
        return true
      end
    end
  end
  return false
end

local v1 = vec2(1,0)
local is_enough_surrounding_hits = function(t_pos, t_mspd, t_boundingRadius)
  local num_hits = 0
  for i=1, num_angles do
    local dir = v1:rotate(i / num_angles * 2 * math.pi)
    local dyn_dist = s_pos:dist(t_pos)
    local dyn_pos = t_pos
    local f_dyn_time
    local f_dyn_pos

    for j=1, dynamic_iterations do
      local dyn_time = dyn_dist / m_speed + input.delay + network.latency
      dyn_pos = t_pos + dyn_time * t_mspd * dir
      dyn_dist = s_pos:dist(dyn_pos)
      f_dyn_time = dyn_time
    end
    f_dyn_pos  = s_pos:lerp(dyn_pos, push_dist/dyn_dist + 1)

    --[[
    cb.add(cb.draw, function()
      if f_dyn_pos then
        local pos = vec3(f_dyn_pos.x, player.y, f_dyn_pos.y)
        graphics.draw_circle(pos, 25, 2, 0xffffffff, 32)
      end
    end)
    ]]

    f_dyn_time = f_dyn_time + push_dist / push_speed
    if is_sphere_collision(f_dyn_pos, t_boundingRadius, f_dyn_time) then
      num_hits = num_hits + 1
    end
  end
  return (num_hits >= min_hits)
end

local get_cone_travel_time = function(path, c_speed, path_start_t)
  if not path.isActive then
    return s_pos:dist(path.point2D[0])/c_speed, 0
  end

  pa[0] = pred.core.lerp(path, path_start_t, c_speed)

  local j = 1
  for i = path_start_t + c_interval, c_lifetime, c_interval do
    pa[j] = pred.core.lerp(path, i, c_speed)
    if pa[j]:dist(s_pos) < c_speed*c_interval then
      break
    end
    j = j + 1
  end

  return j*c_interval + s_pos:dist(pa[j])/c_speed, j
end

local f = function(res, obj, dist)
  if dist > 2000 then return end

  if pred.present.get_prediction(input, obj) then
    local t_pos = obj.path.serverPos2D
    local t_mspd = obj.moveSpeed
    local t_boundingRadius = obj.boundingRadius
    
    local estimated_time = get_cone_travel_time(obj.path, m_speed, input.delay+network.latency)
    local on_hit_time = estimated_time + input.delay + network.latency
    local path_pos, path_index, path_end = pred.core.lerp(obj.path, on_hit_time, t_mspd)
    local pushed_pos = s_pos:lerp(path_pos, push_dist/s_pos:dist(path_pos) + 1)

    --[[
    cb.add(cb.draw, function()
      if pushed_pos then
        local pos = vec3(pushed_pos.x, player.y, pushed_pos.y)
        graphics.draw_circle(pos, 25, 2, 0xffffffff, 32)
      end
    end)
    ]]

    if obj.path.isActive then
      if is_sphere_collision(pushed_pos, t_boundingRadius, on_hit_time) then  
        if is_enough_surrounding_hits(t_pos, t_mspd, t_boundingRadius) then
          res.obj = obj
          res.pos = obj.pos
          return true
        end
      end
    else
      local pushed_pos = t_pos:lerp(path_pos, push_dist/t_pos:dist(path_pos) + 1)
      if is_sphere_collision(pushed_pos, t_boundingRadius, on_hit_time) then
        if is_enough_surrounding_hits(t_pos, t_mspd, t_boundingRadius) then
          res.obj = obj
          res.pos = obj.pos
          return true
        end
      end
    end
  end
end

local res
local e_pause = 0
local get_action_state = function()
  if slot.state == 0 and os.clock() > e_pause then
    s_pos = player.path.serverPos2D
    res = TS.get_result(f)
    if res.obj then
      return res
    end
  end
end

local invoke_action = function()
  player:castSpell('pos', 2, res.pos)
  e_pause = os.clock() + network.latency + 0.25
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
}