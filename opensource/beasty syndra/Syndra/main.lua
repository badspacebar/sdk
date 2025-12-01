local core = module.load(header.id, 'Syndra/core')
local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')
local w_cast = module.load(header.id, 'Syndra/w_cast')

local c_pent = {}
for i=0, 4 do
  table.insert(c_pent, {
    x = (65*mathf.cos(((360 - 72*i)*mathf.PI)/180)),
    z = (65*mathf.sin(((360 - 72*i)*mathf.PI)/180)),
  })
end

cb.add(cb.tick, function()
  core.get_action()
end)

cb.add(cb.spell, function(spell)
  sphere_manager.on_cast_q(spell)
  sphere_manager.on_cast_e(spell)
  w_cast.on_cast_w(spell)
end)

cb.add(cb.create_minion, function(obj)
  sphere_manager.on_create_minion(obj)
end)

cb.add(cb.draw, function()
  core.on_draw_info()
  core.on_draw_range()
  sphere_manager.on_draw_pent(c_pent)
end)

return {}