local TS = module.internal('TS')
local pred = module.internal('pred')

local menu = module.load(header.id, 'Syndra/menu')
local dmg = module.load(header.id, 'Syndra/dmg')
local q = module.load(header.id, 'Syndra/q')

local r = {}
local slot = player:spellSlot(3)

local src_pos2D

local input = {
  delay = 0,
  radius = 675,
  width = 75,
  speed = 1100,
  range = 675,
  dashRadius = 0,
  boundingRadiusModSource = 0,
  boundingRadiusModTarget = 0,
  collision = {
    wall = true,
  },
}

local res_q
local is_obj_q
local is_overkill = function(obj)
  if not res_q then
    if is_obj_q > os.clock() then
      if dmg.q(obj) > obj.health then
        return true
      end
    end
  else
    if dmg.q(obj) > obj.health then
      return true
    end
  end
end

local f = function(res, obj, dist)
  if dist > 1500 then return end

  if obj.buff.judicatorintervention then return end
  if obj.buff.kayler then return end
  if obj.buff.undyingrage then return end
  if obj.buff.sionpassivezombie then return end

  if menu.r_whitelist[obj.charName]:get() then
    if pred.present.get_prediction(input, obj) then
      if dmg.r(obj) > obj.health and not is_overkill(obj) then
        
        local seg = pred.core.result()
        seg.startPos = vec2(src_pos2D.x, src_pos2D.y)
        seg.endPos = vec2(obj.pos2D.x, obj.pos2D.y)

        if not pred.collision.get_prediction(input, seg) then
          res.obj = obj
          return true
        end
      end
    end
  end
end

local res
local r_pause = 0
local get_action_state = function(q_res)
  if slot.state == 0 and os.clock() > r_pause then
    r.ign_obj = nil
    res_q = q_res
    src_pos2D = player.path.serverPos2D
    input.radius = (slot.level == 5) and 750 or 675

    res = TS.get_result(f)
    if res.obj then
      return res
    end
  end
end

local invoke_action = function()
  player:castSpell('obj', 3, res.obj)
  r.ign_obj = res.obj
  r_pause = os.clock() + network.latency + 1
end

r.get_action_state = get_action_state
r.invoke_action = invoke_action

cb.add(cb.spell, function(spell)
  if spell.owner == player then
    if spell.name == 'SyndraQ' then
      is_obj_q = os.clock() + 0.625
    end
  end
end)

return r