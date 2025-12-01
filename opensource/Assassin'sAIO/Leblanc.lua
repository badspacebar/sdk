local common = module.load("AssassinAIO", "common");
local menu = module.load("AssassinAIO", "menu");
--Internal:
local orb = module.internal("orb");
local ts = module.internal("TS");
local prediction = module.internal("pred");

local SpellPos = {
    ["Leblanc"] = { ["LeblancQ"] = {StartQuik = 0} }

};

local QMissele = false;
local W_Indicator = { };
local R_Indicator = { };
local Indetific = 0;

local w = { }
local e = { }

w.preinput = {
	delay = 0.6,
	radius = 260,
	speed = 1450,
	boundingRadiusMod = 0,
	collision = {hero = false, minion = false}
};

e.preinput = {
    delay = 0.5,
    range = 860,
	width = 55,
	speed = math.huge,
	boundingRadiusMod = 1,
	collision = {hero = true, minion = true, wall = true}
};

local function getPredictedPos(object, delay)
    if not common.IsValidTarget(object) or not object.path or not delay or not object.moveSpeed then
        return object.pos
    end
    pred = pred or module.internal("pred")
    local pred_pos = pred.core.lerp(object.path, network.latency + delay, object.moveSpeed)
    return vec3(pred_pos.x, object.y, pred_pos.y)
end

--[[Target]]
local function TargetSelec(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 600*2 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end

local function TargetGapCloser(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 700*2 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end
local function TargetPadron()
    return ts.get_result(TargetSelec, ts.filter_set[1], false, true).object
end

local function TargetGap()
    return ts.get_result(TargetGapCloser, ts.filter_set[1], false, true).object
end

local function Trace_filter(seg, obj, pred_input) --
    if seg.startPos:dist(seg.endPos) > 600*2 then return false end

    if prediction.trace.linear.hardlock(pred_input, seg, obj) then
        return true
    end
    if prediction.trace.linear.hardlockmove(pred_input, seg, obj) then
        return true
    end
    if prediction.trace.newpath(obj, 0.033, 0.500) then
        return true
    end
end

--[[Damage]]
local function Damage_Malice(target) --Q
    if target and common.IsValidTarget(target) then
		local damage = 0
		local damagespell = {55, 80, 105, 130, 155}
        if player:spellSlot(0).state == 0 then
			damage = (damagespell[player:spellSlot(0).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .3))
        end
		return common.CalculateMagicDamage(target, damage)
	end
	return 0
end

local function Damage_Marked(target) --Maked Q
    if target and common.IsValidTarget(target) then
		local damage = 0
        local damagemarked = {110, 160, 210, 260, 310}
        if target.buff["leblancqmark"] then 
            damage = (damagemarked[player:spellSlot(0).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .6))
        end
        return common.CalculateMagicDamage(target, damage)
    end
    return 0
end

local function Damage_Distortion(target) -- W
    if target and common.IsValidTarget(target) then
		local damage = 0
		local damagespell = {75, 115, 155, 195, 235}
        if player:spellSlot(1).state == 0 then
			damage = (damagespell[player:spellSlot(1).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .6))
        end
		return common.CalculateMagicDamage(target, damage)
	end
	return 0
end 

local function Damage_Chains(target) --E
    if target and common.IsValidTarget(target) then
		local Damage = 0
		local damagespell = {40, 60, 80, 100, 120}
        if player:spellSlot(2).state == 0 then
			Damage = (damagespell[player:spellSlot(2).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .3))
        end
		return common.CalculateMagicDamage(target, Damage)
	end
	return 0
end

local function Damage_Mimic(target) --R
    if target and common.IsValidTarget(target) then
        local damage =  0;
        local DamageRq = {70, 140, 210};
        local DamageRw  = {150, 300, 450};
        local DmageRe = {70, 140, 210};

        --Q
        if player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRQ" then
            damage = (DamageRq[player:spellSlot(3).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .4))
            Indetific = 1;
        end
        --W
        if player:spellSlot(3).state == 0 and  player:spellSlot(3).name == "LeblancRW"  then
            damage = (DamageRw[player:spellSlot(3).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .75))
            Indetific = 2;
        end
        --E
        if player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRE" then
            damage = (DmageRe[player:spellSlot(3).level] + (player.flatMagicDamageMod * player.percentMagicDamageMod * .4))
            Indetific = 3;
        end
        --return true
        return common.CalculateMagicDamage(target, damage)
    end
    return 0
end 

--Targets Possibles

cb.add(cb.spell, function(spell)
    if spell.owner.team == TEAM_ALLY and spell.owner.type == TYPE_HERO then
        if SpellPos[spell.owner.charName] and SpellPos[spell.owner.charName][spell.name] then 
            SpellPos[spell.owner.charName][spell.name].StartQuik = os.clock() + 1.5 - network.latency
        end
    end
end)

local function KillStealSmart()
    for i = 0, objManager.enemies_n - 1 do
        local unit = objManager.enemies[i]
        if unit and common.IsValidTarget(unit) then
            local dmgq = Damage_Chains(unit);
            local dmgmaked = Damage_Marked(unit);
            local dmgw = Damage_Distortion(unit);
            local dmge = Damage_Malice(unit);
            local dmgR = Damage_Mimic(unit);
            if unit.pos:dist(player.pos) <= 700 and player:spellSlot(0).state == 0 and dmgq > unit.health then 
                player:castSpell("obj", 0, unit)
            end
            if unit.pos:dist(player.pos) <= 700 and player:spellSlot(0).state == 0 and (dmgR * dmgmaked > unit.health) then 
                if player:spellSlot(3).state == 0 then 
                    player:castSpell("obj", 0, unit)
                end 
            end 
            if unit.pos:dist(player.pos) <= 700 and dmgR * dmgmaked > unit.health and Indetific == 1 then 
                if player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRQ" then 
                    player:castSpell("obj", 3, unit)
                end 
            end 
            if unit.pos:dist(player.pos) <= 800 and player:spellSlot(1).state == 0 and player:spellSlot(1).name ~= "LeblancWReturn" and dmgw * dmgmaked > unit.health  then 
                local res = prediction.circular.get_prediction(w.preinput, unit)
			    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                    player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    chat.print("1");
                end
            end 
            if unit.pos:dist(player.pos) <= 800 and player:spellSlot(1).name ~= "LeblancWReturn" and player:spellSlot(1).state == 0 and dmgw > unit.health  then 
                local res = prediction.circular.get_prediction(w.preinput, unit)
			    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                    player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    chat.print("2");
                end
            end 
            if unit.pos:dist(player.pos) <= 800 and player:spellSlot(3).state == 0 and Indetific == 2 and not player:spellSlot(3).name == "LeblancRWReturn" and player:spellSlot(3).name == "LeblancRW" and dmgR > unit.health  then 
                local res = prediction.circular.get_prediction(w.preinput, unit)
			    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                    player:castSpell("pos", 3, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                end
            end 
            if player:spellSlot(2).state == 0  and player.path.serverPos:dist(unit.path.serverPos) < 865 and dmge > unit.health then
                local seg = prediction.linear.get_prediction(e.preinput, unit)
                if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(unit, 0.5) then
                    if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end
            if player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRE" and player.path.serverPos:dist(unit.path.serverPos) < 865 and dmge > unit.health then
                local seg = prediction.linear.get_prediction(e.preinput, unit)
                if seg and seg.startPos:dist(seg.endPos) < 865 and Indetific == 3 and dmgR > unit.health then
                    if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end
            if unit.pos:dist(player.pos) <= (600*2+700) then
                local RReady = player:spellSlot(3).name == "LeblancRQ" or player:spellSlot(3).name == "LeblancRW"  or player:spellSlot(3).name == "LeblancRE";
                local WReady = player:spellSlot(1).name ~= "LeblancWReturn" and player:spellSlot(1).state == 0;
                local wpos = player.pos + (unit.pos - player.pos):norm() * 600;
                local QDmg = Damage_Chains(unit)
                local WDmg = Damage_Distortion(unit);
                local EDmg = Damage_Malice(unit);
                local RDmg = Damage_Mimic(unit);
                if player:spellSlot(3).state == 0  and unit.pos:dist(player.pos) < 700 then
                    if QDmg < unit.health or not player:spellSlot(0).state == 0 then
                        if RDmg > unit.health then
                            if unit.pos:dist(player.pos) <= 700 and player:spellSlot(3).name == "LeblancRQ" and player:spellSlot(3).state == 0 then
                                player:castSpell("obj", 3, unit)
                            elseif unit.pos:dist(player.pos) <= 600 and player:spellSlot(3).name == "LeblancRW" and player:spellSlot(3).state == 0 then
                                player:castSpell("pos", 3, unit.pos)
                            elseif unit.pos:dist(player.pos) <= 860 and player:spellSlot(3).name == "LeblancRE" and player:spellSlot(3).state == 0 then
                                local seg = prediction.linear.get_prediction(e.preinput, unit)
                                if seg and seg.startPos:dist(seg.endPos) < 860 and player:spellSlot(2).state == 0 then
                                    if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                                        player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                                    end
                                end
                            end
                        end
                    end
                end
                if (QDmg + WDmg + EDmg > unit.health) then
                    if unit.pos:dist(player.pos) <= 700 and player:spellSlot(0).state == 0 then
                        player:castSpell("obj", 0, unit)
                    end
                    if unit.pos:dist(player.pos) <= 600 and player:spellSlot(1).name ~= "LeblancWReturn" and player:spellSlot(1).state == 0 then
                        player:castSpell("pos", 1, unit.pos)
                        chat.print("3");
                    end
                    if unit.pos:dist(player.pos) <= 860 and player:spellSlot(2).state == 0  then
                        local seg = prediction.linear.get_prediction(e.preinput, unit)
                        if seg and seg.startPos:dist(seg.endPos) < 860 and player:spellSlot(2).state == 0 then
                            if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                                player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                            end
                        end
                    end
                end
                if player:spellSlot(0).state == 0 and QDmg > unit.health then
                    if unit.pos:dist(player.pos) <= 700+600 then
                        if unit.pos:dist(player.pos) <= 700 then
                            player:castSpell("obj", 0, unit)
                        elseif (WReady) then
                            if (600 + 700 > player.pos:dist(unit.pos)) then
                                if player:spellSlot(1).name ~= "LeblancWReturn" then
                                    player:castSpell("pos", 1, wpos)
                                    chat.print("4");
                                end
                            end 
                        elseif (RReady) then
                            if (600 + 700 > player.pos:dist(unit.pos)) then
                                if player:spellSlot(3).name ~= "LeblancRWReturn" and player:spellSlot(3).name == "LeblancRW" then
                                    player:castSpell("pos", 3, wpos)
                                end
                            end
                        end
                    elseif unit.pos:dist(player.pos) <= 700+600*2 and player:spellSlot(0).state == 0 and WReady and RReady then
                        if unit.pos:dist(player.pos) <= 700 then
                            player:castSpell("obj", 0, unit)
                        elseif player:spellSlot(1).name ~= "LeblancRWReturn" then
                            player:castSpell("pos", 1, wpos)
                            chat.print("5");
                            player:castSpell("pos", 3, wpos) 
                        end
                    end
                elseif (player:spellSlot(2).state == 0 and EDmg > unit.health) then
                    if (860 + 700 > player.pos:dist(unit.pos)) then
                        if (player:spellSlot(2).state == 0) then
                            local seg = prediction.linear.get_prediction(e.preinput, unit)
                            if seg and seg.startPos:dist(seg.endPos) < 860 and player:spellSlot(2).state == 0 then
                                if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                                end
                            end
                        elseif (WReady) then
                            if (860 + 700 > player.pos:dist(unit.pos)) then
                                if player:spellSlot(1).name ~= "LeblancWReturn" then
                                    player:castSpell("pos", 1, wpos)
                                    chat.print("6");
                                end
                            end 
                        elseif (RReady) then
                            if (860 + 700 > player.pos:dist(unit.pos)) then
                                if player:spellSlot(3).name ~= "LeblancRWReturn" and player:spellSlot(3).name == "LeblancRW" then
                                    player:castSpell("pos", 3, wpos)
                                end
                            end
                        end 
                    elseif unit.pos:dist(player.pos) <= (860+600*2) and player:spellSlot(2).state == 0 and WReady and RReady then 
                        if (unit.pos:dist(player.pos) <= 860) then
                            local seg = prediction.linear.get_prediction(e.preinput, unit)
                            if seg and seg.startPos:dist(seg.endPos) < 860 and player:spellSlot(2).state == 0 then
                                if not prediction.collision.get_prediction(e.preinput, seg, unit) then
                                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                                end
                            end
                        elseif player:spellSlot(1).name ~= "LeblancWReturn" then
                            player:castSpell("pos", 1, wpos)
                            chat.print("7");
                            if player:spellSlot(1).name ~= "LeblancWReturn" then
                                player:castSpell("pos", 3, wpos) 
                            end
                        end 
                    end
                elseif (WReady and WDmg > unit.health) then
                    if unit.pos:dist(player.pos) <= 600 then
                        if player:spellSlot(1).name ~= "LeblancWReturn" then
                            player:castSpell("pos", 1, unit.pos)
                            chat.print("8");
                        elseif player:spellSlot(1).name ~= "LeblancWReturn" then
                            if unit.pos:dist(player.pos) <= 600*2 then
                                player:castSpell("pos", 3, wpos)
                            end
                        end
                    end
                end
            end
        end 
    end
end

local function Combo()
    local target = TargetPadron();
    local useq = menu.leblancmenu.Combo.cq:get();
    local usew = menu.leblancmenu.Combo.cw:get();
    local usee = menu.leblancmenu.Combo.ce:get();
    local RETURN = menu.leblancmenu.Miscing.returnw:get();
    local user = menu.leblancmenu.Combo.cr:get();
    if target and common.IsValidTarget(target) then 
        local QDmg = Damage_Chains(target)
        local WDmg = Damage_Distortion(target);
        local EDmg = Damage_Malice(target);
        local RDmg = Damage_Mimic(target);
        if player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 and usee then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(target, 0.5) then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(0).state == 0 and useq then
            player:castSpell("obj", 0, target)
        end
        if player and common.IsValidTarget(player) and SpellPos[player.charName] and player.activeSpell then
            local channeling = SpellPos[player.charName][player.activeSpell.name]
            if channeling and channeling.StartQuik > os.clock() then
                if player:spellSlot(1).name ~= "LeblancWReturn" and usew then
                    if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then
                        local res = prediction.circular.get_prediction(w.preinput, target)
                        if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                            player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                        end
                    end
                end
            end
        end
        if player:spellSlot(1).name ~= "LeblancWReturn" and usew then
            if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) and (target.buff["leblancqmark"] or target.buff["leblancrqmark"]) then
                local res = prediction.circular.get_prediction(w.preinput, target)
                if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                    player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                end
            end
        end
        if player:spellSlot(1).name ~= "LeblancWReturn"and usew then
            if (player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0 or player.levelRef == 1) then 
                if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then
                    local res = prediction.circular.get_prediction(w.preinput, target)
                    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                        player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    end
                end
            end
        end
        if player:spellSlot(1).name ~= "LeblancRWReturn" and user then
            if player:spellSlot(0).state ~= 0 and player:spellSlot(2).state ~= 0 then 
                if player:spellSlot(3).name == "LeblancRW" and  player:spellSlot(3).state == 0 then
                    if player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then 
                        local res = prediction.circular.get_prediction(w.preinput, target)
                        if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                            player:castSpell("pos", 3, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                        end
                    end
                end
            end
        end
        if player:spellSlot(3).name == "LeblancRE" and  player:spellSlot(3).state == 0 and user then
            if (player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0) then
                if player.path.serverPos:dist(target.path.serverPos) < 865 then
                    local seg = prediction.linear.get_prediction(e.preinput, target)
                    if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(target, 0.5) then
                        if not prediction.collision.get_prediction(e.preinput, seg, target)and Trace_filter(seg, target, e.preinput) then
                            player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                        end
                    end
                end
            end
        end
        if player:spellSlot(3).name == "LeblancRE" and  player:spellSlot(3).state == 0 and user then
            if (player:spellSlot(0).state ~= 0 and player:spellSlot(2).state ~= 0 and player:spellSlot(1).state ~= 0) then
                if player.path.serverPos:dist(target.path.serverPos) < 865 then
                    local seg = prediction.linear.get_prediction(e.preinput, target)
                    if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(target, 0.5) then
                        if not prediction.collision.get_prediction(e.preinput, seg, target)and Trace_filter(seg, target, e.preinput) then
                            player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                        end
                    end
                end
            end
        end
        if player:spellSlot(3).name == "LeblancRQ" and  player:spellSlot(3).state == 0 and user  then
            if (player:spellSlot(1).name ~= "LeblancWReturn" or player:spellSlot(2).state == 0 or player:spellSlot(0).state == 0 or target.buff["leblance"]  or target.buff["leblancqmark"]  or (player:spellSlot(1).cooldown > 0 and player:spellSlot(1).cooldown <= 4) or (player:spellSlot(2).cooldown > 0 and player:spellSlot(2).cooldown <= 4)) then
                if player.path.serverPos:dist(target.path.serverPos) < 710 then
                    player:castSpell("obj", 3, target)
                end
            end
        end 
        if (QDmg + WDmg + EDmg > target.health) then
            if player:spellSlot(1).name ~= "LeblancWReturn" and usew then
                if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) and target.buff["leblancqmark"] then
                    local res = prediction.circular.get_prediction(w.preinput, target)
                    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                        player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    end
                end
            end
            if player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 and usee then
                local seg = prediction.linear.get_prediction(e.preinput, target)
                if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(target, 0.5) then
                    if not prediction.collision.get_prediction(e.preinput, seg, target) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end 
            if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(0).state == 0 and useq then
                player:castSpell("obj", 0, target)
            end
        end
        for _, W_Inter in pairs(W_Indicator) do
            if W_Inter then
                if W_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(1).name == "LeblancWReturn" and player:spellSlot(3).name == "LeblancRW" and player:spellSlot(3).state == 0 and Indetific == 2 and RDmg > target.health then 
                    player:castSpell("pos", 1, player.pos)
                end
                if W_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(1).name == "LeblancWReturn" and player:spellSlot(0).state == 0 and QDmg > target.health then 
                    player:castSpell("pos", 1, player.pos)
                end
                if W_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(1).name == "LeblancWReturn" and player:spellSlot(2).state == 0 and EDmg > target.health then  
                    player:castSpell("pos", 1, player.pos)
                end
                if RETURN and W_Inter.pos:dist(target.pos) <= 750 and player:spellSlot(1).name == "LeblancWReturn" and target.buff["leblance"] then 
                    player:castSpell("pos", 1, player.pos)
                end
            end
        end
        for _, R_Inter in pairs(R_Indicator) do
            if R_Inter then
                if R_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(3).name == "LeblancRWReturn" and player:spellSlot(1).name == "LeblancW" and player:spellSlot(1).state == 0 and WDmg > target.health then 
                    player:castSpell("pos", 3, player.pos)
                end
                if R_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(3).name == "LeblancRWReturn" and player:spellSlot(0).state == 0 and QDmg > target.health then 
                    player:castSpell("pos", 3, player.pos)
                end
                if R_Inter.pos:dist(target.pos) <= 800 and player:spellSlot(3).name == "LeblancRWReturn" and player:spellSlot(2).state == 0 and EDmg > target.health then  
                    player:castSpell("pos", 3, player.pos)
                end
            end
        end
    end
    local GapTarget = TargetGap();
    if GapTarget and common.IsValidTarget(GapTarget) then 
        local QDmg = Damage_Chains(GapTarget)
        local WDmg = Damage_Distortion(GapTarget);
        local EDmg = Damage_Malice(GapTarget);
        local RDmg = Damage_Mimic(GapTarget);
        local wpos = player.pos + (GapTarget.pos - player.pos):norm() * 600;
        if Indetific == 2 and QDmg + RDmg > GapTarget.health and GapTarget.pos:dist(player.pos) <= 680*2 then 
            if player:spellSlot(0).state == 0 and player:spellSlot(3).state == 0 then
                if player:spellSlot(1).name ~= "LeblancWReturn" then
                    player:castSpell("pos", 1, wpos)
                end
                if player:spellSlot(3).name ~= "LeblancRWReturn" and player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRW"  then
                    if player.path.serverPos:distSqr(GapTarget.path.serverPos) < (750 * 750) then 
                        local res = prediction.circular.get_prediction(w.preinput, GapTarget)
                        if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                            player:castSpell("pos", 3, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                        end
                    end
                end
            end
            if player.path.serverPos:dist(GapTarget.path.serverPos) < 710 and player:spellSlot(0).state == 0 then
                player:castSpell("obj", 0, GapTarget)
            end
        end 
    end
end

local function Harass() 
    local useq = menu.leblancmenu.Harass.harassq:get();
    local usew = menu.leblancmenu.Harass.harassw:get();
    local usee = menu.leblancmenu.Harass.harasse:get();
    local target = TargetPadron();
    if target and common.IsValidTarget(target) then 
        if player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 and usee then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 865  and getPredictedPos(target, 0.5) then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(0).state == 0 and useq then
            player:castSpell("obj", 0, target)
        end
        if player and common.IsValidTarget(player) and SpellPos[player.charName] and player.activeSpell then
            local channeling = SpellPos[player.charName][player.activeSpell.name]
            if channeling and channeling.StartQuik > os.clock() then
                if player:spellSlot(1).name ~= "LeblancWReturn" and usew then
                    if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then
                        local res = prediction.circular.get_prediction(w.preinput, target)
                        if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                            player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                        end
                    end
                end
            end
        end
    end
end

local function BurtsCombo()
    local target = TargetGap();
    if target and common.IsValidTarget(target) then 
        if player.path.serverPos:dist(target.path.serverPos) <= 1300 then 
            if player:spellSlot(1).name ~= "LeblancWReturn" then
                if target.pos:dist(player.pos) < 600 and player:spellSlot(1).state == 0 then
                    local res = prediction.circular.get_prediction(w.preinput, target)
                    if res and res.startPos:dist(res.endPos) < 1200 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                        player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    end
                elseif player:spellSlot(1).name == "LeblancW" then
                    if player:spellSlot(1).name ~= "LeblancWReturn" then
                        if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (1200 * 1200) then
                            local res = prediction.circular.get_prediction(w.preinput, target)
                            if res and res.startPos:dist(res.endPos) < 1200 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                                player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                            end
                        end
                    end
                end
            end
            if player:spellSlot(3).name == "LeblancRW" and  player:spellSlot(3).state == 0 then
                if player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then 
                    local res = prediction.circular.get_prediction(w.preinput, target)
                    if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
                        player:castSpell("pos", 3, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
                    end
                end
            end
            for _, R_Inter in pairs(R_Indicator) do
                if R_Inter then
                    if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(0).state == 0 then
                        player:castSpell("obj", 0, target)
                    end
                    if player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 then
                        local seg = prediction.linear.get_prediction(e.preinput, target)
                        if seg and seg.startPos:dist(seg.endPos) < 865 and getPredictedPos(target, 0.5) then
                            if not prediction.collision.get_prediction(e.preinput, seg, target) then
                                player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                            end
                        end
                    end
                end 
            end
        end
    end
end

orb.combat.register_f_pre_tick(function()
    if menu.leblancmenu.Combo.stogglebar:get() then
        Combo();
    end
end)

cb.add(cb.tick, function()
    if menu.leblancmenu.Miscing.smartkill:get() then 
        KillStealSmart();
    end
    --Burts
    if menu.leblancmenu.Combo.toggleTF:get() then
        BurtsCombo();
        player:move(game.mousePos)
    end
    --Harass
    if menu.leblancmenu.Harass.barharass:get() then
        Harass();
    end
end)

cb.add(cb.create_particle, function(object)
    if object then
        local ObjectPtr = object.ptr;
        if object.name:find("W_return_indicator") then
            W_Indicator[ObjectPtr] = object;
        end
        if object.name:find("RW_return_indicator") then
            R_Indicator[ObjectPtr] = object;
        end
    end
end)

cb.add(cb.delete_particle, function(object) 
    if object then
        local ObjectPtr = object.ptr;
        if object.name:find("W_return_indicator") then
            W_Indicator[ObjectPtr] = nil;
        end
        if object.name:find("RW_return_indicator") then
            R_Indicator[ObjectPtr] = nil;
        end
    end
end)


cb.add(cb.draw, function()
    local drawq = menu.leblancmenu.dirw.dq:get();
    local draww = menu.leblancmenu.dirw.dw:get();
    local drawe = menu.leblancmenu.dirw.de:get();
    local drawr = menu.leblancmenu.dirw.dr:get();
    if player.isOnScreen and common.IsValidTarget(player) then
        if player:spellSlot(0).state == 0 and drawq then
            graphics.draw_circle(player.pos, 700, 2, graphics.argb(255,147, 59, 160), 100)
        end
        if player:spellSlot(1).state == 0 and draww then
            graphics.draw_circle(player.pos, 695, 2, graphics.argb(255,147, 59, 160), 100)
        end
        if player:spellSlot(2).state == 0 and drawe then
            graphics.draw_circle(player.pos, 860, 2, graphics.argb(255,147, 59, 160), 100)
        end
        if player:spellSlot(3).name == "LeblancRQ" and drawr and player:spellSlot(3).state == 0 then 
            graphics.draw_circle(player.pos, 700, 2, graphics.argb(255, 181, 20, 209), 100)
        end
        if player:spellSlot(3).name == "LeblancRW" and drawr and player:spellSlot(3).state == 0 then 
            graphics.draw_circle(player.pos, 695, 2, graphics.argb(255, 181, 20, 209), 100)
        end
        if player:spellSlot(3).name == "LeblancRE" and drawr and player:spellSlot(3).state == 0 then 
            graphics.draw_circle(player.pos, 860, 2, graphics.argb(255, 181, 20, 209), 100)
        end
        --W
        for _, W_Inter in pairs(W_Indicator) do
            if W_Inter then
                graphics.draw_circle(W_Inter.pos, 100, 2, graphics.argb(255, 255, 252, 169), 10)
            end
        end
        --R
        for _, R_Inter in pairs(R_Indicator) do
            if R_Inter then
                graphics.draw_circle(R_Inter.pos, 100, 2, graphics.argb(255,147, 59, 160), 10)
            end
        end
    end
end)