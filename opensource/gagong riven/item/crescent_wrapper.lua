local items = module.internal('items')

local crescent_wrapper = {}

local is_spell_state = false
local is_action_state = false

local ready_crescent = false
local ready_halting_slash = false

crescent_wrapper.get_spell_state = function()
  is_spell_state = true
  is_action_state = false

  ready_crescent = items.crescent.get_spell_state()
  ready_halting_slash = items.halting_slash.get_spell_state()
  return ready_crescent or ready_halting_slash
end

local action_state_crescent = false
local action_state_halting_slash = false

crescent_wrapper.get_action_state = function()
  is_spell_state = false
  is_action_state = true

  action_state_crescent = items.crescent.get_action_state()
  action_state_halting_slash = items.halting_slash.get_action_state()
  return action_state_crescent or action_state_halting_slash
end

crescent_wrapper.invoke_action = function()
  if is_spell_state then
    if ready_crescent then
      items.crescent.invoke_action()
      return true
    end
    if ready_halting_slash then
      items.halting_slash.invoke_action()
      return true
    end
  end
  if is_action_state then
    if action_state_crescent then
      items.crescent.invoke_action()
      return true
    end
    if action_state_halting_slash then
      items.halting_slash.invoke_action()
      return true
    end
  end
end

crescent_wrapper.is_ready = crescent_wrapper.get_spell_state

items.disable('crescent')
items.disable('halting_slash')

return crescent_wrapper
