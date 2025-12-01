local menu = module.load(header.id, 'Syndra/menu')   

local spheres = {}
local sphere_boundingRadius = 48

local on_cast_q = function(spell)
	if spell.name == 'SyndraQ' and spell.owner == player then
		table.insert(spheres, {
			start_time = os.clock(),
			exp_time = os.clock() + 0.625,
			pos = vec3(spell.endPos),
		})
  end
end

local on_create_minion = function(obj)
	if obj.name == 'Seed' and obj.owner == player then
		local min_index, min_dist = nil, math.huge
    for i=1, #spheres do
      local sphere = spheres[i]
      if sphere.exp_time then
  			local dist = obj.pos:dist(sphere.pos) 
  			if dist < min_dist then
  				min_dist = dist
  				min_index = i
  			end
      end
		end
  	if min_index then
  		spheres[min_index] = {
        obj = obj,
        start_time = os.clock(),
        exp_time = os.clock() + 6,
        pos = obj.pos,
      }
  	else 
  		table.insert(spheres, {
        obj = obj,
        start_time = os.clock(),
        exp_time = os.clock() + 6,
        pos = obj.pos,
      })
  	end
  end
end

local e_endtime = 0
local e_startpos, e_endpos = nil, nil
local e_slot = player:spellSlot(2)
local on_cast_e = function(spell)
 if spell.owner and spell.owner == player then
    if spell.slot == 2 then
      e_startpos = vec2(spell.startPos.x, spell.startPos.z)
      e_endpos = vec2(spell.endPos.x, spell.endPos.z)
      e_endtime = os.clock() + 0.525
    end
  end
end

local is_in_e = function(pos)
  if os.clock() + network.latency < e_endtime then
    if e_startpos:distSqr(pos) < 800*800 then
      local angle = mathf.angle_between(e_startpos, e_endpos, pos)
      local a = e_slot.level == 5 and 0.7 or 0.46
      return angle and angle>-a and angle<a
    end
  end
end

local is_valid_e = function(src_pos, range, delay)
  local res = {}
  for i=1, #spheres do
    local sphere = spheres[i]
    local rangeSqr = (range+sphere_boundingRadius)^2
    local sphere_pos2D = vec2(sphere.pos.x, sphere.pos.z)
    local distSqr = src_pos:distSqr(sphere_pos2D)
    
    if distSqr < rangeSqr then 
      if distSqr < 400*400 then
        if os.clock() + network.latency > sphere.start_time + 0.4 then
          table.insert(res, {pos = sphere_pos2D})--, t = collision_time})
        end
      else
        table.insert(res, {pos = sphere_pos2D})--, t = collision_time})
      end
    end
  end
  return res
  --local cast_time = os.clock() + network.latency + delay
  --local collision_time = math.max(sphere_pos2D:dist(sourcePos2D) - boundingRadius, 0) / 2000
  --if cast_time + collision_time < sphere.exp_time then
end

local is_valid_tar = function(src_pos, e_range, push_dist, t_boundingRadius)
  local res = {}
  for i=1, #spheres do
    local sphere = spheres[i]
    local sphere_pos2D = sphere.pos:to2D()
    local max_dist = e_range + push_dist + t_boundingRadius
    if src_pos:distSqr(sphere_pos2D) < max_dist*max_dist then
      table.insert(res, {pos = sphere_pos2D})
    end
  end
  return res
end

local get_minion_to_grab = function()
  for i=0, objManager.minions.size[TEAM_ENEMY]-1 do
    local obj = objManager.minions[TEAM_ENEMY][i]
    if not obj.isDead and obj.isTargetable and obj.isVisible then
      if player.path.serverPos2D:distSqr(obj.path.serverPos2D) < 826*826 then
        return obj
      end
    end
  end
end

local get_sphere_to_grab = function()
  local min_obj, min_t = nil, math.huge
  for i=1, #spheres do
    local sphere = spheres[i]
    if sphere.obj then
      if not sphere.obj.path.isDashing then
        if player.path.serverPos2D:distSqr(sphere.pos:to2D()) < 826*826 then
          if not is_in_e(sphere.pos:to2D()) then
            if sphere.start_time < min_t then
              min_t = sphere.start_time
              min_obj = sphere.obj
            end
          end
        end
      end
    end
  end
  return min_obj
end

local get_grabbable_obj = function()
  return get_sphere_to_grab() or get_minion_to_grab()
end

local count = function()
  local n = 0 
  for i=1, #spheres do
    local sphere = spheres[i]
    if sphere.obj then 
      if player.pos2D:distSqr(sphere.obj.pos2D) < 3000*3000 then
        n = n + 1
      end
    end 
  end
  return n
end

local pts_add = {
  vec3(10,0,-5),
  vec3(-5,0,-10),
  vec3(-10,0,5),
  vec3(-5,0,10),
  vec3(10,0, 5),
}

local idle = {}
cb.add(cb.create_particle, function(obj)
  if obj.pos:dist(player.pos) < 1000 then
    local name = obj.name
    if name:find('Q_idle') or name:find('Q_Lv5_idle') then
      table.insert(idle, obj)
    end
  end
end)

cb.add(cb.delete_particle, function(obj)
  for i = #idle, 1, -1 do
    if obj.ptr == idle[i].ptr then
      table.remove(idle, i)
    end
  end
end)

local on_draw_pent = function(c_pent)
  if not menu.pentagon.pent_enable:get() then return end
  local p1, p2 = {}, {}

  local c1, c2 = menu.pentagon.pent1:get(), menu.pentagon.pent2:get()
  
  for l = 1, #idle do
    local idle = idle[l]
    for i = 1, 5 do
      p1[i] = idle.pos + vec3(c_pent[i].x, 0, c_pent[i].z)
    end
    for i = 1, 4 do
      p2[i] = p1[i]:lerp(p1[i+1], 0.5) + pts_add[i]
    end
    p2[5] = p1[5]:lerp(p1[1], 0.5) + pts_add[5]
  
    if #p1 > 0 then
      for i = 1, 4 do 
        graphics.draw_line(p1[i], p1[i+1], 1.5, c1)
        graphics.draw_line(p2[i], p2[i+1], 1.5, c2)
      end
      graphics.draw_line(p1[5], p1[1], 1.5, c1)
      graphics.draw_line(p2[5], p2[1], 1.5, c2)
    end
  end
end

local update = function() 
  if player.isDead then
    for i = #spheres, 1, -1 do
      table.remove(spheres, i)
    end
    for i = #idle, 1, -1 do
      table.remove(idle, i)
    end
  end
  
  for i=#spheres, 1, -1 do
    local sphere = spheres[i]
    if sphere.obj then
      if sphere.obj.isDead then
        table.remove(spheres, i)
      end
    end
  end
end

return {
  spheres = spheres,
  on_create_minion = on_create_minion,
  on_cast_q = on_cast_q,
  on_cast_e = on_cast_e,
  update = update,
  on_draw_pent = on_draw_pent,
  count = count,
  is_within_range = is_within_range,
  get_grabbable_obj = get_grabbable_obj,
  is_in_e = is_in_e,
  is_valid_e = is_valid_e,
  is_valid_tar = is_valid_tar,
}