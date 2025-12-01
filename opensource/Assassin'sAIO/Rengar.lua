local common = module.load("AssassinAIO", "common");
local menu = module.load("AssassinAIO", "menu");
--Internal:
local orb = module.internal("orb");
local ts = module.internal("TS");
local prediction = module.internal("pred");

local interruptor = {
    --FiddleSticks:
    ["FiddleSticks"] = { ["Crowstorm"] = { StartTime = 0 } },
    --JhinR:
    ["Jhin"] = { ["JhinR"] = { StartTime = 0 } },
    --Karthus:
    ["Karthus"] = { ["KarthusFallenOne"] = { StartTime = 0 } },
    --Katarina:
    ["Katarina"] = { ["KatarinaR"] = { StartTime = 0 } },
    --Lucian:
    ["Lucian"] = { ["LucianR"] = { StartTime = 0 } },
    --Malzahar:
    ["Malzahar"] = { ["Malzahar"] = { StartTime = 0 } },
    --MissFortune:
    ["MissFortune"] = { ["MissFortuneBulletTime"] = { StartTime = 0 } },
    --Nunu:
    ["Nunu"] = { ["AbsoluteZero"] = { StartTime = 0 } },
    --Pantheon:
    ["Pantheon"] = { ["PantheonRJump"] = { StartTime = 0 } },
    --Shen:
    ["Shen"] = { ["ShenR"] = { StartTime = 0 } },
    --Velkoz
    ["VelKoz"] = { ["VelkozR"] = { StartTime = 0 } }
}



local function TargetSelec(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 1000 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end

local function Target_SelectedTarget(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if player and player.buff['rengarr'] then
            if (dist > 3000 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
            res.object = object
            return true 
        end
    end 
end


local function Target_Select()
    return ts.get_result(TargetSelec, ts.filter_set[1], false, true).object
end

local function SelectedTarget()
    return ts.get_result(Target_SelectedTarget, ts.filter_set[1], false, true).object
end

local e = { }

e.preinput = {
	delay = 0.25,
	width = 50,
	speed = math.huge,
	boundingRadiusMod = 1,
	collision = {hero = true, minion = true, wall = true}
};

local function Trace_filter(seg, obj, pred_input) --
    if seg.startPos:dist(seg.endPos) > 1000 then return false end

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

cb.add(cb.spell, function(spell)
    if spell.owner.team == TEAM_ENEMY and spell.owner.type == TYPE_HERO then
        if player:spellSlot(2).state == 0 and player.mana == 4 then
            if interruptor[spell.owner.charName] and interruptor[spell.owner.charName][spell.name] and not spell.owner.buff["karthusdeathdefiedbuff"] then
                interruptor[spell.owner.charName][spell.name].StartTime = os.clock() + 1.5 - network.latency
            end
        end
    end
end)

local function Combo()
    local target = Target_Select();
    local useq = menu.rengarmenu.Combo.cq:get();
    local usew = menu.rengarmenu.Combo.cw:get();
    local usee = menu.rengarmenu.Combo.ce:get();
    if target and common.IsValidTarget(target) and not player.buff['rengarr'] then 
        if useq and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and (player.buff['rengarpassivebuff'] or not player.buff['rengarpassivebuff'])) and (player.path.isDashing or not player.path.isDashing) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usee and player:spellSlot(2).state == 0 and (player:spellSlot(0).state ~= 0 and player:spellSlot(1).state ~= 0) and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.serverPos:dist(target.path.serverPos) > common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff'] and not player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usew and player:spellSlot(1).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 450 then
            --if player:spellSlot(0).state ~= 0 then 
                player:castSpell("pos", 1, target.pos)
            --end
        end
        if (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            for i = 6, 11 do
                local item = player:spellSlot(i).name
                if item and (item == "ItemTiamatCleave") then
                    player:castSpell("obj", i, target)
                end
                if item and (item == "ItemTitanicHydraCleave") then
                    player:castSpell("obj", i, target)
                end
            end
        end
        if useq and player.mana == 4 and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing and player.mana == 4 and target.pos:dist(player.pos) > common.GetTrueAttackRange(player, target) then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) and Trace_filter(seg, target, e.preinput) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
    end
    if menu.rengarmenu.Combo.use:get() == 2 then 
        local target = SelectedTarget();
        local useq = menu.rengarmenu.Combo.cq:get();
        local usew = menu.rengarmenu.Combo.cw:get();
        local usee = menu.rengarmenu.Combo.ce:get();
        if target and common.IsValidTarget(target) then 
            if (player:spellSlot(3).state == 0) then 
                player:castSpell("self", 3);
            end
            if player.buff['rengarr'] then return end
            if useq and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and (player.buff['rengarpassivebuff'] or not player.buff['rengarpassivebuff'])) and (player.path.isDashing or not player.path.isDashing) then
                player:castSpell("self", 0)
            end
            if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.isDashing then
                local seg = prediction.linear.get_prediction(e.preinput, target)
                if seg and seg.startPos:dist(seg.endPos) < 1000 then
                    if not prediction.collision.get_prediction(e.preinput, seg, target) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end 
            if usee and player:spellSlot(2).state == 0 and (player:spellSlot(0).state ~= 0 and player:spellSlot(1).state ~= 0) and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing then
                local seg = prediction.linear.get_prediction(e.preinput, target)
                if seg and seg.startPos:dist(seg.endPos) < 1000 then
                    if not prediction.collision.get_prediction(e.preinput, seg, target) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end 
            if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.serverPos:dist(target.path.serverPos) > common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff'] and not player.path.isDashing then
                local seg = prediction.linear.get_prediction(e.preinput, target)
                if seg and seg.startPos:dist(seg.endPos) < 1000 then
                    if not prediction.collision.get_prediction(e.preinput, seg, target) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end 
            if usew and player:spellSlot(1).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 450 then
                --if player:spellSlot(0).state ~= 0 then 
                    player:castSpell("pos", 1, target.pos)
                --end
            end
            if (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
                for i = 6, 11 do
                    local item = player:spellSlot(i).name
                    if item and (item == "ItemTiamatCleave") then
                        player:castSpell("obj", i, target)
                    end
                    if item and (item == "ItemTitanicHydraCleave") then
                        player:castSpell("obj", i, target)
                    end
                end
            end
            if useq and player.mana == 4 and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
                player:castSpell("self", 0)
            end
            if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing and player.mana == 4 and target.pos:dist(player.pos) > common.GetTrueAttackRange(player, target) then
                local seg = prediction.linear.get_prediction(e.preinput, target)
                if seg and seg.startPos:dist(seg.endPos) < 1000 then
                    if not prediction.collision.get_prediction(e.preinput, seg, target) and Trace_filter(seg, target, e.preinput) then
                        player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end
            end 
        end
    end
end 

local function Harass()
    local target = Target_Select();
    local useq = menu.rengarmenu.Harass.haraq:get();
    local usew = menu.rengarmenu.Harass.haraw:get();
    local usee = menu.rengarmenu.Harass.harae:get();
    if target and common.IsValidTarget(target) and not player.buff['rengarr'] then 
        if useq and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and (player.buff['rengarpassivebuff'] or not player.buff['rengarpassivebuff'])) and (player.path.isDashing or not player.path.isDashing) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usee and player:spellSlot(2).state == 0 and (player:spellSlot(0).state ~= 0 and player:spellSlot(1).state ~= 0 ) and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usew and player:spellSlot(1).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 450 then
            --if player:spellSlot(0).state ~= 0 then 
                player:castSpell("pos", 1, target.pos)
            --end
        end
        if (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            for i = 6, 11 do
                local item = player:spellSlot(i).name
                if item and (item == "ItemTiamatCleave") then
                    player:castSpell("obj", i, target)
                end
                if item and (item == "ItemTitanicHydraCleave") then
                    player:castSpell("obj", i, target)
                end
            end
        end
        if useq and player.mana == 4 and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing and player.mana == 4 and target.pos:dist(player.pos) > common.GetTrueAttackRange(player, target) then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) and Trace_filter(seg, target, e.preinput) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end
    end 
end 

--[[local function BurtsCombo()
    local target = SelectedTarget();
    local useq = menu.rengarmenu.Combo.cq:get();
    local usew = menu.rengarmenu.Combo.cw:get();
    local usee = menu.rengarmenu.Combo.ce:get();
    if target and common.IsValidTarget(target) then 
        if (player:spellSlot(3).state == 0) then 
            player:castSpell("self", 3);
        end
        if player.buff['rengarr'] then return end
        if useq and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and (player.buff['rengarpassivebuff'] or not player.buff['rengarpassivebuff'])) and (player.path.isDashing or not player.path.isDashing) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usee and player:spellSlot(2).state == 0 and (player:spellSlot(0).state ~= 0 and player:spellSlot(1).state ~= 0) and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and player.path.serverPos:dist(target.path.serverPos) > common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff'] and not player.path.isDashing then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
        if usew and player:spellSlot(1).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 450 then
            --if player:spellSlot(0).state ~= 0 then 
                player:castSpell("pos", 1, target.pos)
            --end
        end
        if (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            for i = 6, 11 do
                local item = player:spellSlot(i).name
                if item and (item == "ItemTiamatCleave") then
                    player:castSpell("obj", i, target)
                end
                if item and (item == "ItemTitanicHydraCleave") then
                    player:castSpell("obj", i, target)
                end
            end
        end
        if useq and player.mana == 4 and player:spellSlot(0).state == 0 and (target.pos:dist(player) <= common.GetTrueAttackRange(player, target) and not player.buff['rengarpassivebuff']) then
            player:castSpell("self", 0)
        end
        if usee and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 1000 and not player.path.isDashing and player.mana == 4 and target.pos:dist(player.pos) > common.GetTrueAttackRange(player, target) then
            local seg = prediction.linear.get_prediction(e.preinput, target)
            if seg and seg.startPos:dist(seg.endPos) < 1000 then
                if not prediction.collision.get_prediction(e.preinput, seg, target) and Trace_filter(seg, target, e.preinput) then
                    player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
    end
end]]

local function AutoW()
    if player and common.IsValidTarget(player) then 
        if common.IsImmobile(player) and (player:spellSlot(1).state == 0 and player.mana == 4) and not player.path.isDashing then 
            player:castSpell("self", 1)
        end
    end
end

local function Clearginh()
    local target = {Mosnter = nil, health = 0}
	local RangeMobs = common.GetTrueAttackRange(player, target.Mosnter)
	for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
		local obj = objManager.minions[TEAM_NEUTRAL][i]
		if player.pos:dist(obj.pos) <= RangeMobs and obj.maxHealth > target.health then
			target.Mosnter = obj
			target.health = obj.maxHealth
		end
    end
    local useqlane = menu.rengarmenu.Cleading.laneq:get();
    local usewlane = menu.rengarmenu.Cleading.lanew:get();
    local useelane = menu.rengarmenu.Cleading.lanee:get();
    if target.Mosnter and common.IsValidTarget(target.Mosnter) then
        if useqlane and player:spellSlot(0).state == 0 then
            player:castSpell("self", 0)
        end
        if usewlane and player:spellSlot(1).state == 0 and not player.buff['rengarpassivebuff'] then
            player:castSpell("pos", 1, target.Mosnter.pos)
        end
        if useelane and player:spellSlot(2).state == 0 then
            player:castSpell("pos", 2, target.Mosnter.pos)
        end
        if (target.Mosnter.pos:dist(player) <= common.GetTrueAttackRange(player, target.Mosnter) and not player.buff['rengarpassivebuff']) then
            for i = 6, 11 do
                local item = player:spellSlot(i).name
                if item and (item == "ItemTiamatCleave") then
                    player:castSpell("obj", i, target.Mosnter)
                end
                if item and (item == "ItemTitanicHydraCleave") then
                    player:castSpell("obj", i, target.Mosnter)
                end
            end
        end
	end
end

orb.combat.register_f_pre_tick(function()
    if menu.rengarmenu.Combo.stogglebar:get() then
        Combo();
    end
end)

cb.add(cb.tick, function()
    if menu.rengarmenu.Miscing.intrreupt:get() and player:spellSlot(2).state == 0 and player.mana == 4 then
        for i = 0, objManager.enemies_n - 1 do

            local enemy = objManager.enemies[i]
    
            if enemy and not enemy.isDead and enemy.isVisible and interruptor[enemy.charName] and enemy.activeSpell then
    
                local channeling = interruptor[enemy.charName][enemy.activeSpell.name]
                if channeling and channeling.StartTime > os.clock() then
                    local seg = prediction.linear.get_prediction(e.predinput, enemy)
                    if seg and seg.startPos:dist(seg.endPos) <= 1000 then
                        local hit_time = seg.startPos:dist(seg.endPos) / e.predinput.speed + e.predinput.delay
                        local remaining_channel_time = channeling.StartTime - os.clock()
                        if hit_time < remaining_channel_time then
                            player:castSpell("pos", 2, vec3(seg.endPos.x, enemy.y, seg.endPos.y))
                            orb.core.set_server_pause()
                            return true
                        end
                    end
                end
            end
        end
    end
    --Burts
    if menu.rengarmenu.Combo.toggleTF:get() then
        --
    end
    --Harass
    if menu.rengarmenu.Harass.barharass:get() then
        Harass();
    end
    if player.buff['rengarr'] then 
        --chat.print('r')
    end 
    if menu.rengarmenu.Cleading.keyclear:get() then
        Clearginh();
    end
    if menu.rengarmenu.Miscing.autc:get() then
        AutoW();
    end
end)

cb.add(cb.draw, function()
    local draww = menu.rengarmenu.dirw.dw:get();
    local drawe = menu.rengarmenu.dirw.de:get();
    if player.isOnScreen and common.IsValidTarget(player) then
        if player:spellSlot(1).state == 0 and draww then
            graphics.draw_circle(player.pos, 450, 2, graphics.argb(255, 70, 133, 170), 100)
        end
        if player:spellSlot(2).state == 0 and drawe then
            graphics.draw_circle(player.pos, 1000, 2, graphics.argb(255, 70, 133, 170), 100)
        end
        local target = Target_Select();
        if target and common.IsValidTarget(target) then 
            graphics.draw_circle(target.pos, 70, 3, graphics.argb(255, 70, 133, 170), 10)
        end
        local target_Sle = SelectedTarget();
        if target_Sle and common.IsValidTarget(target_Sle) then 
            graphics.draw_circle(target_Sle.pos, 70, 3, graphics.argb(255, 255, 0, 0), 10)
        end
        local pos = graphics.world_to_screen(player.pos)
        if menu.rengarmenu.Combo.use:get() == 1 then
            graphics.draw_text_2D("Burts Combo: Off", 15, pos.x - 95, pos.y + 40, graphics.argb(255, 255, 255, 255))
        end
        if menu.rengarmenu.Combo.use:get() == 2 then
            graphics.draw_text_2D("Burts Combo: Active", 15, pos.x - 95, pos.y + 40, graphics.argb(255, 255, 255, 255))
        end
    end 
end)
