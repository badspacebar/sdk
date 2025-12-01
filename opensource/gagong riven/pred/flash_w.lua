local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local menu = module.load(header.id, 'menu')

local w = module.load(header.id, 'spell/w')
local flash = module.load(header.id, 'spell/flash')

local source = nil

local input = {
  delay = 0,
  radius = 0,
  dashRadius = flash.radius,
  boundingRadiusModSource = 0,
  boundingRadiusModTarget = 0,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  local pos = pred.present.get_prediction(input, obj, source)
  if pos then
    res.obj = obj
    res.pos = pos
    return true
  end
end

local res = {}

local get_prediction = function()
  input.radius = w.radius() - 80
  return TS.get_result(f, TS.filter_set[1], false, true)
end

local get_spell_state = function()
  return flash.is_ready() and w.is_ready()
end

local get_action_state = function(pos)
  if get_spell_state() then
    source = pos
    res = get_prediction()
    if res.obj then
      return res
    end
  end
end

local invoke_action = function(pause, flash_only)
  player:castSpell('pos', flash.slot.slot, vec3(res.pos.x, res.obj.y, res.pos.y))
  if not flash_only then
    player:castSpell('self', 1)
  end
  if menu.reset_ts:get() then
    TS.selected = nil
  end
  if pause then
    orb.core.set_server_pause()
  end
end

local get_total_radius = function()
  return w.radius() + flash.radius - 80
end

local get_total_delay = function()
  return 0
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
  get_total_radius = get_total_radius,
  get_spell_state = get_spell_state,
  get_total_delay = get_total_delay,
}
