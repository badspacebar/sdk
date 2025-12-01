local common = module.load("AssassinAIO", "common");
local menu = module.load("AssassinAIO", "menu");
--Internal:
local orb = module.internal("orb");
local ts = module.internal("TS");
local prediction = module.internal("pred");

local q = { }
local q_buff = { }
local r = { }

q.preinput = {
    delay = 0.25,
    range = 500,
	width = math.huge,
	speed = math.huge,
	boundingRadiusMod = 0,
	collision = {hero = false, minion = true, wall = true}
};

q_buff.preinput =  { 
    delay = 0.25,
    range = 900,
	width = math.huge,
	speed = math.huge,
	boundingRadiusMod = 0,
	collision = {hero = false, minion = true, wall = true}
}

r.preinput = {
    delay = 0.5,
    range = 950,
	width = 55,
	speed = math.huge,
	boundingRadiusMod = 1,
	collision = {hero = true, minion = true, wall = true}
};

local function trace_filter(seg, pred_input, obj)
    if seg.startPos:dist(seg.endPos) > 1100 then return false end

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

local function TargetQ(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 500 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        local seg = prediction.linear.get_prediction(q.preinput, object)
        if not seg then return false end
        --if not trace_filter(seg, r.preinput, object) then return false end
        res.object = object
        return true 
    end 
end

local function TargetQ_Buff(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 950 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        local seg = prediction.linear.get_prediction(q_buff.preinput, object)
        if not seg then return false end
        ---if prediction.collision.get_prediction(q_buff.preinput, seg, object) then return end
        --if not trace_filter(seg, q_buff.preinput, object) then return false end
        res.object = object
        return true 
    end 
end

local function TargetE(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 650 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end

local function TargetR(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 900 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        local seg = prediction.linear.get_prediction(r.preinput, object)
        if not seg then return false end
        --if not trace_filter(seg, r.preinput, object) then return false end
        res.object = object
        return true 
    end 
end

local GetTargetQ = function()
    return ts.get_result(TargetQ).object
end
local GetTargetQ2 = function()
    return ts.get_result(TargetQ_Buff).object
end

local GetTargetE = function()
    return ts.get_result(TargetE).object
end

local GetTargetR = function()
    return ts.get_result(TargetR).object
end

local function qdmg(target) --Q
    if target and common.IsValidTarget(target) then
		local damage = 0
        local damagespell = {80, 100, 120, 140, 160}
        local bonus = {128, 160, 192, 224, 256}
        if player:spellSlot(0).state == 0 then
			damage = (damagespell[player:spellSlot(0).level] + (common.BonusPhysical() * .9))
        elseif player:spellSlot(0).state == 0 and (player:spellSlot(0).name == "QiyanaQ_Rock" or player:spellSlot(0).name == "QiyanaQ_Water" or player:spellSlot(0).name == "QiyanaQ_Grass") then
            damage = (bonus[player:spellSlot(0).level] + (common.BonusPhysical()* 1.44))
        end
		return common.CalculatePhysicalDamage(target, damage)
	end
	return 0
end

local function IsImmune(unit)
    if (unit.buff['kindredrnodeathbuff'] or unit.buff['undyingrage']) and common.HealthPercent(unit) <= 10 then
        return true
    end
    if unit.buff['vladimirsanguinepool'] or unit.buff['judicatorintervention'] or unit.buff['zhonyasringshield'] then
        return true
    end
    return false
end

local function IsRangeTarget(unit, range, checkTeam, from)
    local range = range == nil and math.huge or range
    if unit == nil  or not unit.isVisible or unit.isDead or not unit.isTargetable or IsImmune(unit) or (checkTeam and unit.team ~= 200) then
        return false
    end
    return unit.pos:dist(from) < range
end

local function Combo()
    local q1 = menu.qiyananmenu.Combo.cq:get()
    local targetE = GetTargetE();
    if targetE and common.IsValidTarget(targetE) then 
        if player:spellSlot(2).state == 0 and IsRangeTarget(targetE, 650, false, player.pos) then 
            player:castSpell("obj", 2, targetE)
        end 
    end
    local targetQ1 = GetTargetQ();
    if targetQ1 and common.IsValidTarget(targetQ1) then 
        if player:spellSlot(0).state == 0 and q1 and player:spellSlot(0).name == "QiyanaQ" then
            local seg = prediction.linear.get_prediction(q.preinput, targetQ1)
            if not seg then return false end
            --if not trace_filter(seg, q.preinput, targetQ1) then return false end
            if seg and seg.startPos:dist(seg.endPos) < 500 then
                player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
            end
        end
    end
    local targetQ2 = GetTargetQ2();
    if targetQ2 and common.IsValidTarget(targetQ2) then 
        if player:spellSlot(0).state ~= 0 and player:spellSlot(1).state == 0 then
            if IsRangeTarget(targetQ2, 950, false, player.pos) then 
                player:castSpell("pos", 1, game.mousePos)
            end
        end
        if player:spellSlot(1).state == 0 and targetQ2.pos:dist(player.pos) <= common.GetTrueAttackRange(player, targetQ2) then
            local sidePos = targetQ2.pos + (player.pos - targetQ2.pos):norm() * 150
            player:castSpell("pos", 1, sidePos)
        end
        if (player:spellSlot(0).name == "QiyanaQ_Rock" or player:spellSlot(0).name == "QiyanaQ_Water" or player:spellSlot(0).name == "QiyanaQ_Grass") then
            if player:spellSlot(0).state == 0 then
                local seg = prediction.linear.get_prediction(q_buff.preinput, targetQ2)
                if not seg then return false end
                --if not trace_filter(seg, q_buff.preinput, targetQ2) then return false end
                if seg and seg.startPos:dist(seg.endPos) < 950 then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end
    end
    local target = GetTargetR();
    if target and (common.IsValidTarget(target) and IsRangeTarget(target, r.preinput.range, false, player.pos)) then
        targetPos = vec3(target.x, target.y, target.z)
        path = target.path.serverPos
        time = target.moveSpeed * 0.425
        playerPos = vec3(player.x, player.y, player.z)
        posAfterTime = targetPos + (targetPos - path):norm() * time
        --
        for i = 15, 410, 75 do
            final = posAfterTime + (posAfterTime - playerPos):norm() * i
            finalT = targetPos + (targetPos - playerPos):norm() * i

            if common.IsImmobile(target) then
                final = finalT
            end
            --
            if navmesh.isWall(final) and navmesh.isWall(finalT) then
                local seg = prediction.linear.get_prediction(r.preinput, target)
                if not seg then return false end
                --if not trace_filter(seg, r.preinput, target) then return false end
                if seg and seg.startPos:dist(seg.endPos) < 950 then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end 
        end
    end 
end
orb.combat.register_f_pre_tick(function()
    if menu.qiyananmenu.Combo.stogglebar:get() then
        Combo();
    end
end)


cb.add(cb.draw, function()
    local drawq = menu.qiyananmenu.dirw.dq:get();
    local draww = menu.qiyananmenu.dirw.dw:get();
    local drawe = menu.qiyananmenu.dirw.de:get();
    local drawr = menu.qiyananmenu.dirw.dr:get(); 
    if player.isOnScreen and common.IsValidTarget(player) then
        if player:spellSlot(0).state == 0 and drawq and player:spellSlot(0).name == "QiyanaQ" then
            graphics.draw_circle(player.pos, 500, 2, graphics.argb(255, 241, 233, 143), 100)
        end
        if player:spellSlot(1).state == 0 and draww then
            graphics.draw_circle(player.pos, 1100, 2, graphics.argb(255, 241, 233, 143), 100)
        end
        if player:spellSlot(2).state == 0 and drawe then
            graphics.draw_circle(player.pos, 650, 2, graphics.argb(255, 241, 233, 143), 100)
        end
        if player:spellSlot(0).name == "QiyanaQ_Rock" and player:spellSlot(0).state == 0 and drawq then 
            graphics.draw_circle(player.pos, 900, 2, graphics.argb(255, 179, 111, 38), 100)
        end
        if player:spellSlot(0).name == "QiyanaQ_Grass" and player:spellSlot(0).state == 0 and drawq then 
            graphics.draw_circle(player.pos, 900, 2, graphics.argb(255, 33, 195, 149), 100)
        end
        if player:spellSlot(0).name == "QiyanaQ_Water" and player:spellSlot(0).state == 0 and drawq then 
            graphics.draw_circle(player.pos, 900, 2, graphics.argb(255, 30, 205, 251), 100)
        end
        if player:spellSlot(3).state == 0 and drawr then
            graphics.draw_circle(player.pos, 950, 2, graphics.argb(255, 255, 255, 143), 100)
        end
        local pos = graphics.world_to_screen(player.pos)
        if menu.qiyananmenu.Combo.use:get() == 1 then
            graphics.draw_text_2D("Primority: ", 17, pos.x - 95, pos.y + 40, graphics.argb(255, 255, 255, 255))
            graphics.draw_text_2D("Brush", 20, pos.x - 5, pos.y + 40, graphics.argb(255, 33, 195, 149))
        end
        if menu.qiyananmenu.Combo.use:get() == 2 then
            graphics.draw_text_2D("Primority: ", 17, pos.x - 95, pos.y + 40, graphics.argb(255, 255, 255, 255))
            graphics.draw_text_2D("River", 20, pos.x - 5, pos.y + 40, graphics.argb(255, 30, 205, 251))
        end 
        if menu.qiyananmenu.Combo.use:get() == 3 then
            graphics.draw_text_2D("Primority: ", 17, pos.x - 95, pos.y + 40, graphics.argb(255, 255, 255, 255))
            graphics.draw_text_2D("Terrains", 20, pos.x - 5, pos.y + 40, graphics.argb(255, 179, 111, 38))
        end
    end
    local targetQ2 = GetTargetQ2();
    if targetQ2 and common.IsValidTarget(targetQ2) then 
        if player:spellSlot(1).state == 0 and targetQ2.pos:dist(player.pos) <= common.GetTrueAttackRange(player, targetQ2) then
            local sidePos = targetQ2.pos + (player.pos - targetQ2.pos):norm() * 150
            graphics.draw_circle(sidePos, 150, 2, graphics.argb(255, 30, 205, 251), 100)
        end
    end
end)