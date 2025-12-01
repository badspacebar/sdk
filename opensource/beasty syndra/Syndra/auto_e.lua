local TS = module.internal('TS')
local orb = module.internal('orb')
local pred = module.internal('pred')

local menu = module.load(header.id, 'Syndra/menu')
local spells = module.load(header.id, 'Syndra/spells')

local slot = player:spellSlot(2)
local e_rangeSqr = 825*825

cb.add(cb.spell, function(spell)
  if slot.state == 0 then
    local obj = spell.owner
    if obj and obj.type == TYPE_HERO and obj.team == TEAM_ENEMY then
      local charName = obj.charName
      if charName == 'Vi' then return end
      local m = menu[charName]
      if m then
        m = m[spell.slot]
        if m and m.enabled:get() and (not m.combat_mode:get() or menu.combat:get()) then
          if obj.path.serverPos2D:distSqr(player.path.serverPos2D) < e_rangeSqr then
            if spell.target then
              if spell.target.ptr == player.ptr then
                player:castSpell('pos', 2, obj.pos)
                return true
              end
            else
              local k = (obj.attackRange + player.boundingRadius*2)^2
              if spells[charName][spell.slot](vec3(spell.startPos), vec3(spell.endPos), k) then
                player:castSpell('pos', 2, obj.pos)
                return true
              end
            end
          end
        end
      end
    end
  end
end)

for i=0, objManager.enemies_n-1 do
  local obj = objManager.enemies[i]
  if obj.charName == 'Vi' then
    cb.add(cb.tick, function()
      if not obj.isDead and obj.buff['viq'] then 
        if obj.pos:distSqr(player.pos) < 500*500 then
          player:castSpell('pos', 2, obj.pos)
        end
      end
    end)
  end
end