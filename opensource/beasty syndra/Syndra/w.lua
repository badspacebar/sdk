local TS = module.internal('TS')
local pred = module.internal('pred')

local sphere_manager = module.load(header.id, 'Syndra/sphere_manager')
local r = module.load(header.id, 'Syndra/r')

local slot = player:spellSlot(1)

local input = {
  delay = 0.2,
  radius = 825,
  dashRadius = 0,
  boundingRadiusModSource = 0,
  boundingRadiusModTarget = 0,
}

local f = function(res, obj, dist)
  if dist > 1500 then return end
  if obj == r.ign_obj then return end
  
  if pred.present.get_prediction(input, obj) then
    res.obj = obj
    return true
  end
end

local res
local w_pause = 0
local get_action_state = function()
  if slot.state == 0 and os.clock() > w_pause then
    if slot.name == 'SyndraW' then
      local source = sphere_manager.get_grabbable_obj()
      if source then
        res = TS.get_result(f)
        if res.obj then
          res.pos = source.pos
          return res
        end
      end
    end
  end
end
  
local invoke_action = function()
  player:castSpellAdmin('pos', 1, res.pos)
  w_pause = os.clock() + network.latency + 0.25
end

return {
  get_action_state = get_action_state,
  invoke_action = invoke_action,
}