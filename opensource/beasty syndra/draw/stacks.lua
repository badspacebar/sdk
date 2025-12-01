local scale4k = graphics.height>1080 and (graphics.height/1080)*.905 or 1
local offset_main = vec2(109*scale4k, 111*scale4k)
local offset_lower_bar = vec2(54*scale4k, 23*scale4k)

local stacks = 0
local stacks_hurricane_recv = 0
local stacks_timer = math.huge
local stacks_pause = {}

local draw_stacks_at_bottom = function(bar_pos, num_stacks, max_stacks, color)
	local p = bar_pos + offset_main + offset_lower_bar
	for k=0,num_stacks-1 do
		if k == max_stacks-1 then
			graphics.draw_line_2D(p.x + k*player.barWidth/max_stacks*scale4k, p.y + 5*scale4k, p.x + (k + 1)*player.barWidth/max_stacks*scale4k, p.y + 5*scale4k, 3*scale4k, color)
		else
			graphics.draw_line_2D(p.x + k*player.barWidth/max_stacks*scale4k, p.y + 5*scale4k, p.x + (k + 1)*player.barWidth/max_stacks*scale4k - 2*scale4k, p.y + 5*scale4k, 3*scale4k, color)
		end
	end
end

local draw_frame = function()
	local p = player.barPos + offset_main
	graphics.draw_sprite('stacks_sprite.png', vec3(p.x, p.y, 0), scale4k)
end

local add_cb_sprite = function(arg_table)
	if arg_table.type == 'menu' then
		cb.add(cb.sprite, function()
			if arg_table.menu:get() then
				if not player.isDead then
					draw_frame()
				end
			end
		end)
	end
end

local add_cb_create_particle = function(arg_table)
  local max_stacks = arg_table.max and arg_table.max or math.huge
  local delay = arg_table.delay and arg_table.delay or 0
  local keyword_pause = arg_table.keyword_pause and 0.07 or 0

  if arg_table.type == 'clear' then
    cb.add(cb.create_particle, function(obj)
      if not obj.name:find(arg_table.prefix) then return end
      if arg_table.conditions then
        for i=1,#arg_table.conditions do
          if not arg_table.conditions[i]() then return end
        end
      end
      for i=1,#arg_table.or_keywords do
        if obj.name:find(arg_table.or_keywords[i]) then
          stacks = 0
        end
      end
    end)
  elseif arg_table.type == 'reset-on-spell-at-max' then
    cb.add(cb.create_particle, function(obj)
      if stacks < max_stacks then return end
      if not obj.name:find(arg_table.prefix) then return end
      if arg_table.conditions then
        for i=1,#arg_table.conditions do
          if not arg_table.conditions[i]() then return end
        end
      end
      for i=1,#arg_table.or_keywords do
        if obj.name:find(arg_table.or_keywords[i]) then
          stacks = 0
        end
      end
    end)
  elseif arg_table.type == 'increment' then
    cb.add(cb.create_particle, function(obj)
      for i=1,#arg_table.find_name do
        if not obj.name:find(arg_table.find_name[i]) then return end
      end
      stacks = math.min(stacks + 1, max_stacks)
      stacks_timer = os.clock() + delay
    end)
  elseif arg_table.type == 'or-increment' then
    cb.add(cb.create_particle, function(obj)
      if not obj.name:find(arg_table.prefix) then return end
      if arg_table.conditions then
        for i=1,#arg_table.conditions do
          if not arg_table.conditions[i]() then return end
        end
      end
      for i=1,#arg_table.or_keywords do
        if obj.name:find(arg_table.or_keywords[i]) then
          if os.clock() >= (stacks_pause[obj.name] and stacks_pause[obj.name] or 0) then
            stacks = math.min(stacks + 1, max_stacks)
            stacks_timer = os.clock() + delay
            stacks_pause[obj.name] = os.clock() + keyword_pause
          end
        end
      end
      end)
  elseif arg_table.type == 'map' then
    cb.add(cb.create_particle, function(obj)
      if not obj.name:find(arg_table.prefix) then return end
      for i=1,#arg_table.suffix_map do
        if obj.name:find(arg_table.suffix_map[i][1]) then
          stacks = arg_table.suffix_map[i][2]
          stacks_timer = os.clock() + delay
        end
      end
    end)
  elseif arg_table.type == 'hurricane' then
    cb.add(cb.create_particle, function(obj)
      local range = arg_table.max_range and arg_table.max_range or -math.huge
      if obj.pos:dist(player.pos) > range then return end
      for i=1,#arg_table.find_name do
        if not obj.name:find(arg_table.find_name[i]) then return end
      end
      stacks = math.min(stacks + 1 + stacks_hurricane_recv, arg_table.max_stacks and arg_table.max_stacks or math.huge)
      stacks_timer = os.clock() + delay
      stacks_hurricane_recv = 0
    end)
    cb.add(cb.create_missile, function(missile)
      if missile.name:find('ItemHurricaneAttack') then
        if missile.spell.owner == player then
          stacks_hurricane_recv = stacks_hurricane_recv + 1
        end
      end
    end)
  end
end

local add_cb_tick = function(arg_table)
	if arg_table.type == 'clear' then
		cb.add(cb.tick, function()
			if os.clock() > stacks_timer then
				stacks = 0
				stacks_timer = math.huge
			end
		end)
	elseif arg_table.type == 'decrement' then
		cb.add(cb.tick, function()
			if os.clock() > stacks_timer then
				stacks = stacks - 1
				stacks_timer = (stacks == 0) and math.huge or stacks_timer + arg_table.delay
			end
		end)
	elseif arg_table.type == 'slowfastlineardecrement' then
		cb.add(cb.tick, function()
			if os.clock() > stacks_timer then
				stacks = stacks - 1
				stacks_timer = (stacks == 0) and math.huge or (stacks_timer + arg_table.delay + network.latency)
			end
		end)
	end
end

local add_cb_draw = function(arg_table)
	if arg_table.type == 'menu' then
		cb.add(cb.draw, function()
			if arg_table.menu:get() then
				if not player.isDead then
					draw_stacks_at_bottom(player.barPos, stacks, arg_table.max_stacks, arg_table.menu_color:get())
				end
			end
		end)
	elseif arg_table.type == 'spellname' then
		cb.add(cb.draw, function()
			if arg_table.menu:get() then
				draw_stacks_at_bottom(player.barPos, arg_table.stacks[player:spellSlot(arg_table.spell_slot).name], arg_table.max_stacks, arg_table.menu_color:get())
			end
		end)
	end
end

return {
	draw_stacks_at_bottom = draw_stacks_at_bottom,
	draw_frame = draw_frame,
	add_cb_sprite = add_cb_sprite,
	add_cb_create_particle = add_cb_create_particle,
	add_cb_tick = add_cb_tick,
	add_cb_draw = add_cb_draw
}