local scale4k = graphics.height>1080 and (graphics.height/1080)*.905 or 1
local offset_main = vec2(109*scale4k, 111*scale4k)
local offset_lower_bar = vec2(54*scale4k, 23*scale4k)
local offset_lower_player = vec2(54*scale4k, 250*scale4k)

local on_draw = function(row, str, width, color)
	if not player.isOnScreen or player.isDead then return end
	local p = player.barPos + offset_main + offset_lower_player
	graphics.draw_text_2D(str, width, p.x, p.y-100 + width*row, color)
end

return {
	on_draw = on_draw
}