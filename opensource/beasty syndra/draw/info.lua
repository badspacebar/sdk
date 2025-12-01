local on_draw = function(str, width, pos, color, check)
  if not player.isOnScreen or player.isDead then return end
  if not check then return end

  local dx = graphics.text_area(str, width)
  local p = graphics.world_to_screen(pos)
  graphics.draw_text_2D(str, width, p.x-dx*0.5, p.y+37, color)
end

local draw = function(str, width, pos, color)
  if not player.isOnScreen or player.isDead then return end

  local dx = graphics.text_area(str, width)
  local p = graphics.world_to_screen(pos)
  graphics.draw_text_2D(str, width, p.x-dx*0.5, p.y+37, color)
end

return {
  on_draw = on_draw,
  draw = draw,
}