local orb = module.internal('orb')

local r1 = module.load(header.id, 'spell/r1')

local get_spell_state = function()
  return r1.is_ready()
end

local get_action_state = function()
  return get_spell_state()
end

local invoke_action = function(pause)
  player:castSpell('self', 3)
  if pause then
    orb.core.set_server_pause()
  end
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
}
