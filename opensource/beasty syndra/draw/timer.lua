--[[
 The timer class receives an input table which depending on the parameters
 sets up different timers.
]]

local scale4k = graphics.height>1080 and (graphics.height/1080)*.905 or 1
local offset_main = vec2(109*scale4k, 111*scale4k)
local offset_sprite = vec2(0*scale4k, -1*scale4k)
local offset_upper_bar = vec2(54*scale4k, -2*scale4k)
local offset_lower_bar = vec2(54*scale4k, 23*scale4k)

local verify_menu_options = function(obj)
	if obj then
		if type(obj) == 'table' then
			-- multiple menu options to check
			for i=1, #obj do
				if not obj[i]:get() then return false end
			end
		else
			-- single menu option to check
			return obj:get()
		end
	end
	return true
end

local verify_check_options = function(obj)
	if obj then
		if type(obj) == 'table' then
			-- multiple function checks
			for i=1, #obj do
				if not obj[i]() then return false end
			end
		else
			-- single function check
			return obj()
		end
	end
	return true
end

local verify_player_visibility = function()
	if player.isDead then return false end
	if not player.isOnScreen then return false end
	return true
end

local verify_prefix_suffices = function(name, prefix, suffices)
	if not name:find(prefix) then return end
	local any = false
	for i=1,#suffices do
		if name:find(suffices[i]) then
			any = true
		end
	end
	return any
end

local draw_timer_at_top = function(bar_pos, bar_ratio, color)
	local p = bar_pos + offset_main + offset_upper_bar
	graphics.draw_line_2D(p.x, p.y + 5*scale4k, p.x + bar_ratio*player.barWidth*scale4k, p.y + 5*scale4k, 2*scale4k, color)
end

local draw_timer_at_bottom = function(bar_pos, bar_ratio, min_stack, max_stack, num_stacks)
	local p = bar_pos + offset_main + offset_lower_bar
	local p_pos_ratio = min_stack/num_stacks + bar_ratio*(max_stack - min_stack)/num_stacks
	local p_max_ratio = max_stack/num_stacks
	local p_max_offset = (max_stack == num_stacks and 0*scale4k or -2*scale4k)
	graphics.draw_line_2D(p.x + p_pos_ratio*player.barWidth*scale4k, p.y + 5*scale4k, p.x + p_max_ratio*player.barWidth*scale4k - p_max_offset, p.y + 5*scale4k, 3*scale4k, 0xff000000)
end

local draw_frame = function()
	local p = player.barPos + offset_main + offset_sprite
	graphics.draw_sprite('timer_sprite.png', vec3(p.x, p.y, 0), scale4k)
end

local timers = {}

local add_cb_sprite = function(arg_table)
	if arg_table.type == 'menu' then
		cb.add(cb.sprite, function()
			if arg_table.menu:get() and not player.isDead then
				draw_frame()
			end
		end)
	end
end

local add_cb_create_particle = function(arg_table)
	local label = arg_table.label and arg_table.label or 'default'
	timers[label] = {t_begin = math.huge, t_end = math.huge}
	local dist = (arg_table.dist and arg_table.dist or math.huge)

	cb.add(cb.create_particle, function(obj)
		if arg_table.type and arg_table.type == 'or-refresh' then
			if not verify_prefix_suffix(arg_table.prefix, arg_table.suffices) then return end
		else
			for i=1,#arg_table.find_name do
				if not obj.name:find(arg_table.find_name[i]) then return end
			end
		end
		if obj.pos:dist(player.pos) > dist then return end
		local timer_offset = (arg_table.offset and arg_table.offset() or 0)
		local timer_delay = (type(arg_table.delay) == 'function' and arg_table.delay() or arg_table.delay)
		timers[label].t_begin = os.clock() + timer_offset
		timers[label].t_end = timers[label].t_begin + timer_delay
	end)
end

local add_cb_spell = function(arg_table)
	local label = arg_table.label and arg_table.label or 'default'
	timers[label] = {t_begin = math.huge, t_end = math.huge}

	cb.add(cb.spell, function(spell)
		if arg_table.self and spell.owner ~= player then return end
		for i=1, #arg_table.find_name do
			if not spell.name:find(arg_table.find_name[i]) then return end
		end
		local timer_offset = (arg_table.offset and arg_table.offset() or 0)
		local timer_delay = (type(arg_table.delay) == 'function' and arg_table.delay() or arg_table.delay)
		timers[label].t_begin = os.clock() + timer_offset
		timers[label].t_end = timers[label].t_begin + timer_delay
	end)
end

local add_cb_draw = function(arg_table)
	local position = arg_table.position and arg_table.position or 'top'
	local label = arg_table.label and arg_table.label or 'default'
	if arg_table.type == 'menu' then
		if position == 'top' then
			cb.add(cb.draw, function()
				if not verify_menu_options(arg_table.menu) then return end
				if not verify_check_options(arg_table.checks) then return end
				if not verify_player_visibility() then return end
				if os.clock() > timers[label].t_begin and os.clock() < timers[label].t_end then
					local bar_ratio = (timers[label].t_end - os.clock()) / (timers[label].t_end - timers[label].t_begin)
					draw_timer_at_top(player.barPos, bar_ratio, arg_table.menu_color:get())
				end
			end)
		elseif position == 'bottom' then
			local min_stack = (arg_table.min_stack and arg_table.min_stack or 0)
			local max_stack = (arg_table.max_stack and arg_table.max_stack or arg_table.stacks)
			cb.add(cb.draw, function()
				if not verify_menu_options(arg_table.menu) then return end
				if not verify_check_options(arg_table.checks) then return end
				if not verify_player_visibility() then return end
				if os.clock() > timers[label].t_begin and os.clock() < timers[label].t_end then
					local bar_ratio = (timers[label].t_end - os.clock()) / (timers[label].t_end - timers[label].t_begin)
					draw_timer_at_bottom(player.barPos, bar_ratio, min_stack, max_stack, arg_table.stacks)
				elseif arg_table.hold and os.clock() > timers[label].t_end and arg_table.hold() then
					draw_timer_at_bottom(player.barPos, 1/player.barWidth, min_stack, max_stack, arg_table.stacks)
				end
			end)
		end
	end
end

return {
	draw_timer_at_top = draw_timer_at_top,
	draw_frame = draw_frame,
	add_cb_sprite = add_cb_sprite,
	add_cb_create_particle = add_cb_create_particle,
	add_cb_spell = add_cb_spell,
	add_cb_draw = add_cb_draw
}