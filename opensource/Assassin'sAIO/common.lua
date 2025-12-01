local common = { }
function common.ChatPrint(string)
    return chat.print(string);
end

function common.IsUnderTurretEnemy(pos)
    if not pos then return false; end
    for i = 0, objManager.turrets.size[TEAM_ENEMY] - 1 do
        local tower = objManager.turrets[TEAM_ENEMY][i]
        if  tower and not tower.isDead and tower.health > 0 then
            local turretPos = vec3(tower.x, tower.y, tower.z)
			if turretPos:dist(pos) < 915 then
				return true;
            end
        else 
            tower = nil;
		end
	end
    return false;
end

function common.IsImmobile(unit, delay) 
    local BuffeTipe, TimerBuffer = {} , game.time + (delay or 0)
    for i = 0, unit.buffManager.count - 1 do
        local buff = unit.buffManager:get(i)
        if buff and buff.valid and TimerBuffer <= buff.endTime then
            BuffeTipe[buff.type] = true
        end
    end
    if  BuffeTipe[5] or BuffeTipe[8] or BuffeTipe[11] or BuffeTipe[18] or BuffeTipe[24] or BuffeTipe[29] then            
        return true
    end            
end

function common.IsImmortal(obj)
    --local tipebugg = 17;
    for i = 0, obj.buffManager.count - 1 do
        local buff = obj.buffManager:get(i)
        if buff and buff.valid and buff.type == 17 then
            return true
        end
    end
end

function common.IsValidTarget(obj, range)
    return obj and not obj.isDead and obj.isVisible and obj.isTargetable and not common.IsImmortal(obj) and (not range or player.pos:dist(obj.pos) <= range)

end
function common.MagicReduction(target, damageSource)
    local damageSource = damageSource or player
    local magicResist = (target.spellBlock * damageSource.percentMagicPenetration) - damageSource.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end
function common.DamageReduction(damageType, target, damageSource)
    local damageSource = damageSource or player
    local reduction = 1
    if damageType == "AD" then
    end
    if damageType == "AP" then
    end
    return reduction
end

function common.PhysicalReduction(target, damageSource)
    local damageSource = damageSource or player
    local armor = ((target.bonusArmor * damageSource.percentBonusArmorPenetration) + (target.armor - target.bonusArmor)) * damageSource.percentArmorPenetration
    local lethality = (damageSource.physicalLethality * .4) + ((damageSource.physicalLethality * .6) * (damageSource.levelRef / 18))
    return armor >= 0 and (100 / (100 + (armor - lethality))) or (2 - (100 / (100 - (armor - lethality))))
end
function common.CalculateMagicDamage(target, damage, damageSource)
    local damageSource = damageSource or player
    if target then
      return (damage * common.MagicReduction(target, damageSource)) * common.DamageReduction("AP", target, damageSource)
    end
    return 0
end

function common.CalculatePhysicalDamage(target, damage)
    local armor = ((target.bonusArmor * player.percentBonusArmorPenetration) + (target.armor - target.bonusArmor)) * player.percentArmorPenetration
    local lethality = (player.physicalLethality * .4) + ((player.physicalLethality * .6) * (player.levelRef / 18))
    if target then
      return (damage * armor) * (1);
    end
    return 0
end


common.GetSpellDamage ={
    ["Akali"] = {
        --[[DamageQ = 
        function(target) return 
            common.CalculateMagicDamage(target, damage_Q[player:spellSlot(0).level] + (player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod  *.65 +  player.flatMagicDamageMod * player.percentMagicDamageMod*.50) 
        end;
        DamageE = 
        function(target) return 
            common.CalculateMagicDamage(target, damage_E[player:spellSlot(2).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*.70)
        end;
        DamageDash =
        function(target) return
            common.CalculateMagicDamage(target, damage_DashE[player:spellSlot(2).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*1.40)
        end;
        DamageR = 
        function(target) return
            common.CalculateMagicDamage(target, damage_R[player:spellSlot(3).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*0.50)
        end;
        DamageDashR = 
        function(target) return
            common.CalculateMagicDamage(target, damage_DashR[player:spellSlot(3).level] + player.flatMagicDamageMod * player.percentMagicDamageMod*.30)
        end;]]
    },
    ["Ekko"] = {

    },
    ["Leblanc"] = {

    },
    ["Talon"] = {

    },
    ["Kassadin"] = {

    },
    ["Khazix"] = {

    },
    ["Rengar"] = {

    },
    ["Evelynn"] = {

    },
}
function common.TotalPhysical()
    return (player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod
end
function common.TotalMagical()
    return player.flatMagicDamageMod * player.percentMagicDamageMod
end

function common.BonusPhysical()
    return ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage
end


function common.CalculateAADamage(target, damageSource)
    local damageSource = damageSource or player

    if target then

        return common.TotalPhysical(damageSource) * common.PhysicalReduction(target, damageSource)
    end
    
    return 0
end


function common.HealthPercent(unit)
    return unit.maxHealth > 5 and unit.health/unit.maxHealth * 100 or 100
end

function common.ManaPercent(unit)
    return unit.maxMana > 0 and unit.mana/unit.maxMana * 100 or 100
end

function common.GetTrueAttackRange(source, target)
    return source.attackRange + source.boundingRadius + (target and target.boundingRadius or 0)
end

function common.GetEnemyHeroes(range) 
    local t = {}
    for i = 0, objManager.enemies_n - 1 do
        local enemy = objManager.enemies[i]
        if player.pos:dist(enemy) < range and common.IsValidTarget(enemy) then
            t[#t + 1] = enemy
        end
    end
    return t
end

return common;
