local orb = module.internal('orb')

local menu = module.load(header.id, 'menu')

local core = module.load(header.id, 'core/main')
local spell = module.load(header.id, 'spell/main')

orb.combat.register_f_pre_tick(function()
  spell.r2.on_update_buff()
  spell.r2.on_remove_buff()
  spell.r1.on_remove_buff()
  core.ai.get_action()
end)

local on_draw = function()
  core.draw.flash_combo()
  core.draw.gapclose()
  core.draw.push()
  core.draw.r1()
  core.draw.e_aa()
end

local on_recv_spell = function(proc)
  if proc.owner.ptr == player.ptr then
    spell.e.on_new_path(proc)
    spell.r1.on_recv_spell(proc)
    spell.r2.on_recv_spell(proc)
    core.ai.on_recv_spell(proc)
  end
end

local on_new_path = function(obj)
  if obj.ptr == player.ptr then
    spell.e.on_new_path()
  end
end

local on_create_obj = function(obj)
  core.ai.on_create_obj(obj)
end

cb.add(cb.draw, on_draw)
cb.add(cb.spell, on_recv_spell)
--cb.add(cb.path, on_new_path)
cb.add(cb.create_particle, on_create_obj)
