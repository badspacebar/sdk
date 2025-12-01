local orb =  module.internal('orb')

local push = module.load(header.id, 'pred/push')

local res = {}

local get_spell_state = function()
  return orb.core.can_attack() and not orb.core.is_paused() and not orb.core.is_attack_paused()
end

local invoke_action = function(pause)
  player:attack(res.obj)
  if pause then
    orb.core.set_server_pause()
  end
end

local get_total_radius = function()
  return player.attackRange + player.boundingRadius
end

local get_display_radius = function()
  return get_total_radius() + 50
end

local get_total_delay = function()
  return 0
end

local get_push_state = function()
  res = {}
  if get_spell_state() then
    local obj = push.get_prediction(get_total_delay(), get_total_radius(), true)
    if obj then
      res.obj = obj
      return res
    end
  end
end

local get_push_result = function()
  return res.obj and res
end

return {
  invoke_action = invoke_action,
  get_spell_state = get_spell_state,
  get_total_radius = get_total_radius,
  get_display_radius = get_display_radius,
  get_total_delay = get_total_delay,
  get_push_state = get_push_state,
  get_push_result = get_push_result,
}
