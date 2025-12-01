local common = module.load("AssassinAIO", "common");
local menu = module.load("AssassinAIO", "menu");
local SummonerDot = nil;

local orb = module.internal("orb");
local ts = module.internal("TS");
local prediction = module.internal("pred");

if player:spellSlot(4).name == "SummonerDot" then
	SummonerDot = 4
elseif player:spellSlot(5).name == "SummonerDot" then
	SummonerDot = 5
end
--Predign
local w = {}
w.predinput = {
    range = 900,
    delay = 0.25,
    width = (15 * math.pi / 22),
    speed = 2500,
    boundingRadiusMod = 1
}

local function Passive(unit) -- Passive
    local stacks = 0;
	if unit.buff["talonpassivestack"] then
		stacks = unit.buff["talonpassivestack"].stacks
	end
	return stacks;
end

local function TargetSelec(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 1000 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end

local function EnemyTarget()
    return ts.get_result(TargetSelec, ts.filter_set[1], false, true).object
end

local function Combo()
    local useq = menu.talonmenu.Combo.cq:get();
    local usew = menu.talonmenu.Combo.cw:get();
    local user = menu.talonmenu.Combo.cr:get();
    local target = EnemyTarget();
    --local StackPassive = Passive(target);
    if target and common.IsValidTarget(target) then
        if player:spellSlot(0).state == 0 and useq then
            if target.pos:dist(player.pos) < 575 then 
                player:castSpell("obj", 0, target)
            end
        end
        if player:spellSlot(1).state == 0 and usew then
            if Passive(target) > 0 then 
                if target.pos:dist(player.pos) < 900 then 
                    local seg = prediction.linear.get_prediction(w.predinput, target)
                    if not seg then return end 
                    if seg.startPos:dist(seg.endPos) <= w.predinput.range then
                        player:castSpell("pos", 1, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end
            end 
        end
        if player:spellSlot(1).state == 0 and usew then
            if target.pos:dist(player.pos) < 850 and  target.pos:dist(player.pos) > 575 then 
                local seg = prediction.linear.get_prediction(w.predinput, target)
                if not seg then return end 
                if seg.startPos:dist(seg.endPos) <= w.predinput.range then
                    player:castSpell("pos", 1, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end
        if (SummonerDot and player:spellSlot(SummonerDot).state == 0) and Passive(target) == 3 then
            player:castSpell("obj", SummonerDot, target)
        end
        if player:spellSlot(3).state == 0 and user then
            if player:spellSlot(0).state == 0 and target.pos:dist(player.pos) < 600 and  target.pos:dist(player.pos) > 575 then  
                player:castSpell("self", 3)
            end
        end
    end
end 

local function Harass()
    local useq = menu.talonmenu.Harass.haraq:get();
    local usew = menu.talonmenu.Harass.haraw:get();
    local target = EnemyTarget();
    --local StackPassive = Passive(target);
    if target and common.IsValidTarget(target) then
        if player:spellSlot(0).state == 0 and useq then
            if target.pos:dist(player.pos) < 575 then 
                player:castSpell("obj", 0, target)
            end
        end
        if player:spellSlot(1).state == 0 and not player.buff["talonrstealth"] and usew then
            if Passive(target) > 0 then 
                if target.pos:dist(player.pos) < 900 then 
                    local seg = prediction.linear.get_prediction(w.predinput, target)
                    if not seg then return end 
                    if seg.startPos:dist(seg.endPos) <= w.predinput.range then
                        player:castSpell("pos", 1, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end
            end 
        end
        if player:spellSlot(1).state == 0  and not player.buff["talonrstealth"]  and usew then
            if target.pos:dist(player.pos) < 875 and  target.pos:dist(player.pos) > 575 then 
                local seg = prediction.linear.get_prediction(w.predinput, target)
                if not seg then return end 
                if seg.startPos:dist(seg.endPos) <= w.predinput.range then
                    player:castSpell("pos", 1, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end
        if (SummonerDot and player:spellSlot(SummonerDot).state == 0) and common.HealthPercent(target) < 50 and Passive(target) == 3 then
            player:castSpell("obj", SummonerDot, target)
        end
    end
end 

local function Clearginh()
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        local useqlane = menu.talonmenu.Cleading.laneq:get();
        local usewlane = menu.talonmenu.Cleading.lanew:get();
        if minion and common.IsValidTarget(minion) and not minion.name:find("Ward") and player.par / player.maxPar * 100 >= menu.talonmenu.Cleading.maxPar:get() then
            if useqlane and minion.pos:dist(player.pos) <= 500 then 
                player:castSpell("obj", 0, minion)
            end
            if usewlane and minion.pos:dist(player.pos) <= 875 then 
                player:castSpell("pos", 1, minion.pos)
            end
        end
    end
    --Jungle
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local jungle = objManager.minions[TEAM_NEUTRAL][i]
        local useqlane = menu.talonmenu.Cleading.laneq:get();
        local usewlane = menu.talonmenu.Cleading.lanew:get();
        if jungle and common.IsValidTarget(jungle) and not jungle.name:find("Ward") and player.par / player.maxPar * 100 >= menu.talonmenu.Cleading.maxPar:get() then
            if useqlane and jungle.pos:dist(player.pos) <= 500 then 
                player:castSpell("obj", 0, jungle)
            end 
            if usewlane and jungle.pos:dist(player.pos) <= 875 then 
                player:castSpell("pos", 1, jungle.pos)
            end
        end
    end
end

cb.add(cb.tick, function() --unit.buff["talonpassivestack"] TalonRHaste or TalonRStealth
    if menu.talonmenu.Combo.attack:get() then 
        if player.buff["talonrhaste"] then 
            orb.core.set_pause_attack(math.huge)
        else 
            orb.core.set_pause_attack(0)
        end
    end
    if menu.talonmenu.Combo.stogglebar:get() then
        Combo();
    end
    if menu.talonmenu.Harass.barharass:get() then
        Harass();
    end
    if menu.talonmenu.Cleading.keyclear:get() then
        Clearginh();
    end
end)

cb.add(cb.draw, function()
    local drawq = menu.talonmenu.dirw.dq:get()
    local draww = menu.talonmenu.dirw.dw:get()
    local drawe = menu.talonmenu.dirw.de:get()
    local drawr = menu.talonmenu.dirw.dr:get()
    if player.isOnScreen and common.IsValidTarget(player) then
        if player:spellSlot(0).state == 0 and drawq then
            graphics.draw_circle(player.pos, 575, 2, graphics.argb(255, 240, 255, 0), 100)
        end
        if player:spellSlot(1).state == 0 and draww then
            graphics.draw_circle(player.pos, 900, 2, graphics.argb(255, 240, 255, 0), 100)
        end
        if player:spellSlot(2).state == 0 and drawe then
            graphics.draw_circle(player.pos, 725, 2, graphics.argb(255, 240, 255, 0), 100)
        end
        if player:spellSlot(3).state == 0 and drawr then
            graphics.draw_circle(player.pos, 600, 2, graphics.argb(255, 240, 255, 0), 100)
        end
    end
end)