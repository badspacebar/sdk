local menu = module.load(header.id, 'menu')

local width = 3
local circle_quality = 32
local color_white = graphics.argb(255, 255, 255, 255)

cb.add(cb.draw, function()
  if not menu.boolean_test:get() then
    return
  end
  local color = menu.color_test:get()
  local radius = menu.slider_test:get()
  if menu.keybind_test:get() then
    color = color_white
  end
  graphics.draw_circle(player.pos, radius, width, color, circle_quality)
end)

print('menu example loaded')