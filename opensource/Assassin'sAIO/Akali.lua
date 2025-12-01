local common = module.load("AssassinAIO", "common");
local menu = module.load("AssassinAIO", "menu");

--internal:
local orb = module.internal("orb");
local ts = module.internal("TS");
local prediction = module.internal("pred");
local FlashSummoner = nil;

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

local r = {}
local q = {}
r.predinput = {
    range = 750,
    delay = 0.25,
    width = 105,
    speed = 2000,
    boundingRadiusMod = 0
}
q.predinput = {
    range = 500,
    delay = 0.25,
    width = (15 * math.pi / 60),
    speed = 3100,
    boundingRadiusMod = 1
}
local epredinput = {
    range = 650,
    delay = 0.5,
    width = 75,
    speed = math.huge,
    boundingRadiusMod = 1,
    collision = {
		hero = false,
		minion = true
	}
}

local function TargetSelec(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 1000 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end

local function TargetSelecFlash(res, object, dist)
    if object and not object.isDead and object.isVisible and object.isTargetable and not object.buff[17] then
        if (dist > 3000 or object.buff["rocketgrab"] or object.buff["bansheesveil"] or  object.buff["itemmagekillerveil"] or object.buff["nocturneshroudofdarkness"] or object.buff["sivire"] or object.buff["fioraw"] or object.buff["blackshield"]) then return end
        res.object = object
        return true 
    end 
end
local function EnemyTarget()
    return ts.get_result(TargetSelec, ts.filter_set[1], false, true).object
end

local function EnemyTargetFlash()
    return ts.get_result(TargetSelecFlash, ts.filter_set[1], false, true).object
end
--[[Damage
local DamageQ = common.GetSpellDamage[player.charName].DamageQ
local DamageE = common.GetSpellDamage[player.charName].DamageE
local DamageDash = common.GetSpellDamage[player.charName].DamageDash
local DamageR = common.GetSpellDamage[player.charName].DamageR
local DamageDashR = common.GetSpellDamage[player.charName].DamageDashR]]

local function Trace_filter(seg, obj, pred_input) --
    if seg.startPos:dist(seg.endPos) > r.predinput.range then return false end

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

if player:spellSlot(4).name == "SummonerFlash" then
	FlashSummoner = 4
elseif player:spellSlot(5).name == "SummonerFlash" then
	FlashSummoner = 5
end

--Function:
local function Akali_QDamage(target)
    local damage = 0
    local damage_Q = {25, 50, 75, 100, 125};
	if player:spellSlot(0).level > 0 and player:spellSlot(0).state == 0 then
		damage = common.CalculateMagicDamage(target, damage_Q[player:spellSlot(0).level] + (player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod  *.65 +  player.flatMagicDamageMod * player.percentMagicDamageMod*.50) 
	end
	return damage
end

local function Akali_EDamage(target)
    local damage = 0
    local damage_E = {70, 105, 140, 175, 210};
    if player:spellSlot(2).level > 0  and player:spellSlot(2).state == 0 then
		damage = common.CalculateMagicDamage(target, damage_E[player:spellSlot(2).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*.70)
	end
	return damage
end
local function Akali_E2Damage(target)
    local damage = 0
    local damage_DashE = {50, 80, 110, 140, 170};
    if player:spellSlot(2).name == "AkalieEb" and player:spellSlot(2).state == 0 then
        common.CalculateMagicDamage(target, damage_DashE[player:spellSlot(2).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*1.40)
	end
	return damage
end

local function Akali_RDamage(target)
    local damage = 0
    local damage_R = {85, 150, 215};
    if player:spellSlot(3).level > 0 and player:spellSlot(3).state == 0 then
		damage =  common.CalculateMagicDamage(target, damage_R[player:spellSlot(3).level] + ((player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod) - player.baseAttackDamage*0.50)
	end
    return damage
end

local function Akali_R2Damage(target)
    local damage = 0
    local damage_DashR = {85, 150, 215};
    if player:spellSlot(3).level > 0 and player:spellSlot(3).state == 0 then
		common.CalculateMagicDamage(target, damage_DashR[player:spellSlot(3).level] + player.flatMagicDamageMod * player.percentMagicDamageMod*.30)
	end
	return damage
end


cb.add(cb.spell, function(spell)
    if spell.owner.team == TEAM_ENEMY and spell.owner.type == TYPE_HERO then
        if player:spellSlot(3).state == 0 then
            if interruptor[spell.owner.charName] and interruptor[spell.owner.charName][spell.name] and not spell.owner.buff["karthusdeathdefiedbuff"] then
                interruptor[spell.owner.charName][spell.name].StartTime = os.clock() + 1.5 - network.latency
            end
        end
    end
end)

local function r_interruptor()
    for i = 0, objManager.enemies_n - 1 do

        local enemy = objManager.enemies[i]

        if enemy and not enemy.isDead and enemy.isVisible and interruptor[enemy.charName] and enemy.activeSpell then

            local channeling = interruptor[enemy.charName][enemy.activeSpell.name]
            if channeling and channeling.StartTime > os.clock() then

                local seg = prediction.linear.get_prediction(r.predinput, enemy)
                if seg and seg.startPos:dist(seg.endPos) <= 600 then
                    local hit_time = seg.startPos:dist(seg.endPos) / r.predinput.speed + r.predinput.delay
                    local remaining_channel_time = channeling.StartTime - os.clock()
                    if hit_time < remaining_channel_time then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, enemy.y, seg.endPos.y))
                        orb.core.set_server_pause()
                        return true
                    end
                end
            end
        end
    end
end

local CastQ = 0;
local function Combo()
    local useq = menu.akalimenu.Combo.cq:get();
    local usew = menu.akalimenu.Combo.cw:get();
    local usee = menu.akalimenu.Combo.ce:get();
    local usee2 = menu.akalimenu.Combo.ce2:get();
    local user = menu.akalimenu.Combo.cr:get();
    local useflash = menu.akalimenu.Combo.flash:get();
    local target = EnemyTarget();
    local targetFlash = EnemyTargetFlash();
    if target and common.IsValidTarget(target) then
        if player:spellSlot(0).state == 0 and useq then
            if target.pos:dist(player.pos) < q.predinput.range then 
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if not seg then return end 
                if seg.startPos:dist(seg.endPos) <= q.predinput.range and not player.path.isDashing then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    CastQ = game.time;
                    return;
                end
            end
        end
        if target.pos:dist(player.pos) <= 625 and player:spellSlot(0).state ~= 0 and game.time - CastQ > 0 and user and player.buff["akalipmaterialvfx"] then
            if player:spellSlot(3).name ~= "AkaliRb"  then
                local seg = prediction.linear.get_prediction(r.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= 625  then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    return;
                end
            end 
        end
        if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and player:spellSlot(3).name == "AkaliRb" and not player.path.isDashing and usee then
            local iseg = prediction.linear.get_prediction(epredinput, target)
            if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                if not prediction.collision.get_prediction(epredinput, iseg, target) and Trace_filter(iseg, target, epredinput) then
                    player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                end
            end 
        end
        if target.buff["akaliemis"] and player:spellSlot(2).name == "AkaliEb" and usee2 then --cooldown
            player:castSpell("obj", 2, target)
        end
        if (player:spellSlot(3).name == "AkaliRb" and player:spellSlot(3).state == 0) and target.pos:dist(player.pos) < 750 and player:spellSlot(2).state ~= 0 and user then
            local seg = prediction.linear.get_prediction(r.predinput, target)
            if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range then
                player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
            end
        end
        --Comb2
        if player:spellSlot(3).state ~= 0 then
            if player:spellSlot(0).state == 0 then
                if target.pos:dist(player.pos) < q.predinput.range then 
                    local seg = prediction.linear.get_prediction(q.predinput, target)
                    if not seg then return end 
                    if seg.startPos:dist(seg.endPos) <= q.predinput.range then
                        player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end
            end
            if target.pos:dist(player.pos) <= 350 + 50 and usew then 
                local deathbitch = player.pos - (target.pos + player.pos):norm()* -50
                player:castSpell("pos", 1,  deathbitch) 
            end
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and usee then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) and Trace_filter(iseg, target, epredinput) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            if target.buff["akaliemis"] and target.pos:dist(player.pos) <= 100000 and usee2 then --cooldown
                player:castSpell("pos", 2, target.pos)
            end
        end
    end
    if targetFlash and common.IsValidTarget(targetFlash) then
        if useflash and player.par / player.maxPar * 100 >= 90 then 
            if targetFlash.pos:dist(player.pos) <= 3000 then
                if player:spellSlot(3).state == 0 and targetFlash.pos:dist(player.pos) <= 1300 and Akali_RDamage(targetFlash) >= common.HealthPercent(targetFlash) and targetFlash.pos:dist(player.pos) > common.GetTrueAttackRange(player) and targetFlash.pos:dist(player.pos) > epredinput.range then
                    if (FlashSummoner and player:spellSlot(FlashSummoner).state == 0) then
                        player:castSpell("pos", FlashSummoner, targetFlash.pos)
                    end
                end
            end
            if player:spellSlot(0).state == 0 and useq then
                if targetFlash.pos:dist(player.pos) < q.predinput.range then 
                    local seg = prediction.linear.get_prediction(q.predinput, targetFlash)
                    if not seg then return end 
                    if seg.startPos:dist(seg.endPos) <= q.predinput.range then
                        player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                        CastQ = game.time;
                        return;
                    end
                end
            end
            if targetFlash.pos:dist(player.pos) <= 625 and player:spellSlot(0).state ~= 0 and game.time - CastQ > 0 and user and player.buff["akalipmaterialvfx"] then
                if player:spellSlot(3).name ~= "AkaliRb"  then
                    local seg = prediction.linear.get_prediction(r.predinput, targetFlash)
                    if seg and seg.startPos:dist(seg.endPos) <= 625  then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                        return;
                    end
                end 
            end
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and player:spellSlot(3).name == "AkaliRb" and usee then
                local iseg = prediction.linear.get_prediction(epredinput, targetFlash)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, targetFlash) and Trace_filter(iseg, targetFlash, epredinput) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            if targetFlash.buff["akaliemis"] and usee2 then --cooldown
                player:castSpell("pos", 2, targetFlash.pos)
            end
            if (player:spellSlot(3).name == "AkaliRb" and player:spellSlot(3).state == 0) and targetFlash.pos:dist(player.pos) < 750 and player:spellSlot(2).state ~= 0 and user then
                local seg = prediction.linear.get_prediction(r.predinput, targetFlash)
                if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end
    end
    --[[if player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0 and player:spellSlot(3).state == 0 then
        if target and common.IsValidTarget(target) then
            --Q
            if target.pos:dist(player.pos) <= 500 and useq then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    gameq = game.time
                end
            end
            --R
            if target.pos:dist(player.pos) <= 625 and game.time - gameq > 0 and user then
                if player:spellSlot(3).name ~= "AkaliRb"then
                    local seg = prediction.linear.get_prediction(r.predinput, target)
                    if seg and seg.startPos:dist(seg.endPos) <= 625  then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end 
            end
            --E1
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and player:spellSlot(3).name == "AkaliRb" and usee then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            --E2
            if target.buff["akaliemis"] and target.pos:dist(player.pos) <= 2500 and usee2 then --cooldown
                player:castSpell("pos", 2, target.pos)
            end
            if (player:spellSlot(3).name == "AkaliRb" and player:spellSlot(3).state == 0) and target.pos:dist(player.pos) < 750 and player:spellSlot(2).state ~= 0 and user then
                local seg = prediction.linear.get_prediction(r.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end
    end
    if player:spellSlot(0).state == 0 and player:spellSlot(1).state == 0 and player:spellSlot(2).state == 0 and player:spellSlot(3).state == 0 then
        if target and common.IsValidTarget(target) then
            --W
            if target.pos:dist(player.pos) < 250 + common.GetTrueAttackRange(player) and usew and player.pos:dist(target) >= 250 then 
                local deathbitch = player.pos - (target.pos + player.pos):norm()* -300
                player:castSpell("pos", 1, player.pos) 
            end
            --Q
            if target.pos:dist(player.pos) < 500 and useq then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
            --R
            if target.pos:dist(player.pos) < 625 and (player.buff["akalipmaterialvfx"] or player:spellSlot(0).state ~= 0) and user then
                if player:spellSlot(3).name ~= "AkaliRb"then
                    local seg = prediction.linear.get_prediction(r.predinput, target)
                    if seg and seg.startPos:dist(seg.endPos) <= 625  then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                    end
                end 
            end
            --E1
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and player:spellSlot(3).name == "AkaliRb" and usee then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, game.mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            --E2
            if target.buff["akaliemis"] and usee2 and target.pos:dist(player.pos) <= 2500 then --cooldown
                player:castSpell("obj", 2, target)
            end
            if(player:spellSlot(3).name == "AkaliRb" and player:spellSlot(3).state == 0) and target.pos:dist(player.pos) <= 750 and user then
                local seg = prediction.linear.get_prediction(r.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= 750 then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end
    end
    if player:spellSlot(0).state == 0 and player:spellSlot(1).state == 0 and player:spellSlot(2).state == 0 then
        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) <= 250 + 50 and usew and player.pos:dist(target) >= 250 then 
                local deathbitch = player.pos - (target.pos + player.pos):norm()* -300
                player:castSpell("pos", 1, deathbitch) 
            end
            --Q
            if target.pos:dist(player.pos) < 500 and useq then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and usee then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, game.mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            if target.buff["akaliemis"] and usee2 and target.pos:dist(player.pos) <= 2500 then --cooldown
                player:castSpell("obj", 2, target)
            end
        end
    end
    if player:spellSlot(0).state == 0 and player:spellSlot(2).state ~= 0 and player:spellSlot(3).state ~= 0  then
        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) < 500 then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end
    end
    if player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0 then

        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) < 500 then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and usee then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, game.mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            if target.buff["akaliemis"] and target.pos:dist(player.pos) <= 2500 and usee2 then --cooldown
                player:castSpell("obj", 2, target)
            end
        end
    end
    if player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0 and player:spellSlot(3).state == 0 and useflash then
        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) < 1500 then
                if player:spellSlot(3).state == 0 and target.pos:dist(player.pos) < 550 + 750 and Akali_RDamage(target) >= common.HealthPercent(target) and target.pos:dist(player.pos) > common.GetTrueAttackRange(player) and target.pos:dist(player.pos) > epredinput.range then
                    if player:spellSlot(2).state == 0 then
                        local unitpos = player.pos + (target.pos - player.pos):norm() * -700 
                        player:castSpell("pos", 2, unitpos)
                    end
                    if (FlashSummoner and player:spellSlot(FlashSummoner).state == 0) then
                        player:castSpell("pos", FlashSummoner, target.pos)
                    end
                end
            end 
        end
    end
    if player:spellSlot(0).state == 0 then
        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) < 500 then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
                end
            end
        end 
    end]]
end

local function Burts()
    local target = EnemyTargetFlash();
    if player:spellSlot(0).state == 0 and player:spellSlot(2).state == 0 and player:spellSlot(3).state == 0 then
        if target and common.IsValidTarget(target) then
            if target.pos:dist(player.pos) < 2000 then
                if player:spellSlot(3).state == 0 and target.pos:dist(player.pos) < 100 + 550 + 750 and Akali_RDamage(target) >= common.HealthPercent(target) and target.pos:dist(player.pos) > common.GetTrueAttackRange(player) and target.pos:dist(player.pos) > epredinput.range then
                    if (FlashSummoner and player:spellSlot(FlashSummoner).state == 0) then
                        player:castSpell("pos", FlashSummoner, target.pos)
                    end
                end
            end
            if target.pos:dist(player.pos) <= 500  then
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
            --R
            if target.pos:dist(player.pos) <= 625 and (player.buff["akalipmaterialvfx"] or player:spellSlot(0).state ~= 0)  then
                if player:spellSlot(3).name ~= "AkaliRb"then
                    local seg = prediction.linear.get_prediction(r.predinput, target)
                    if seg and seg.startPos:dist(seg.endPos) <= 625  then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end 
            end
            --E1
            if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and player:spellSlot(3).name == "AkaliRb" then
                local iseg = prediction.linear.get_prediction(epredinput, target)
                if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                    if not prediction.collision.get_prediction(epredinput, iseg, target) then
                        player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                    end
                end 
            end
            --E2
            if target.buff["akaliemis"] and target.pos:dist(player.pos) <= 2500  then --cooldown
                player:castSpell("pos", 2, target.pos)
            end
            if (player:spellSlot(3).name == "AkaliRb" and player:spellSlot(3).state == 0) and target.pos:dist(player.pos) < 750 and player:spellSlot(2).state ~= 0 then
                local seg = prediction.linear.get_prediction(r.predinput, target)
                if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range then
                    player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end  
    end
end

local function Harass()
    local useq = menu.akalimenu.Harass.harassq:get();
    local usew = menu.akalimenu.Harass.harassw:get();
    local usee = menu.akalimenu.Harass.harasse:get();
    local target = EnemyTarget();
    if target and common.IsValidTarget(target) then
        if player:spellSlot(0).state == 0 then
            if target.pos:dist(player.pos) < q.predinput.range and useq then 
                local seg = prediction.linear.get_prediction(q.predinput, target)
                if not seg then return end 
                if seg.startPos:dist(seg.endPos) <= q.predinput.range then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                end
            end
        end
        if target.pos:dist(player.pos) <= 350 + 50 and usew then 
            local deathbitch = player.pos - (target.pos + player.pos):norm()* -50
            player:castSpell("pos", 1,  deathbitch) 
        end
        if player:spellSlot(2).name == "AkaliE" and player:spellSlot(2).state == 0 and usee then
            local iseg = prediction.linear.get_prediction(epredinput, target)
            if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range  then
                if not prediction.collision.get_prediction(epredinput, iseg, target) and Trace_filter(iseg, target, epredinput) then
                    player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                end
            end 
        end
        if target.buff["akaliemis"] and target.pos:dist(player.pos) <= 100000 and usee2 then --cooldown
            player:castSpell("pos", 2, target.pos)
        end
    end
end

local function SmartKill()
    for i = 0, objManager.enemies_n - 1 do
        local unit = objManager.enemies[i]
        if unit and common.IsValidTarget(unit) then
            local dmq = Akali_QDamage(unit);
            local dme = Akali_EDamage(unit);
            local dme2 = Akali_E2Damage(unit);
            local dmr = Akali_RDamage(unit);
            local dmr2 = Akali_R2Damage(unit);
            if player:spellSlot(0).state == 0 and unit and unit.pos:dist(player.pos) < 500 and dmq >= common.HealthPercent(unit) then
                local seg = prediction.linear.get_prediction(q.predinput, unit)
                if seg and seg.startPos:dist(seg.endPos) <= q.predinput.range and Trace_filter(seg, unit, q.predinput) then
                    player:castSpell("pos", 0, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    orb.core.set_server_pause();
                end
            end
            if player:spellSlot(2).state == 0 and unit.pos:dist(player.pos) < 650 and dme >= common.HealthPercent(unit) then
                if player:spellSlot(2).name ~= "AkaliEb" then
                    local iseg = prediction.linear.get_prediction(epredinput, unit)
                    if iseg and iseg.startPos:dist(iseg.endPos) <= epredinput.range and Trace_filter(iseg, unit, epredinput) then
                        if not prediction.collision.get_prediction(epredinput, iseg, unit) then
                            player:castSpell("pos", 2, vec3(iseg.endPos.x, mousePos.y, iseg.endPos.y))
                            orb.core.set_server_pause();
                        end
                    end 
                end
            end
            if unit.buff["akaliemis"] and unit.pos:dist(player.pos) < 10000 then
                player:castSpell("pos", 2, unit.pos)
            end
            if player:spellSlot(2).state == 0 and  unit.buff["akaliemis"]  and dme2 >= common.HealthPercent(unit) then 
                player:castSpell("pos", 2, unit.pos)
            end
            if player:spellSlot(3).state == 0 and unit.pos:dist(player.pos) < 600 and dmr >= common.HealthPercent(unit) then
                if player:spellSlot(3).name ~= "AkaliRb" then
                    local seg = prediction.linear.get_prediction(r.predinput, unit)
                    if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range and Trace_filter(seg, unit, r.predinput) then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                else
                    local seg = prediction.linear.get_prediction(r.predinput, unit)
                    if seg and seg.startPos:dist(seg.endPos) <= r.predinput.range and Trace_filter(seg, unit, r.predinput) then
                        player:castSpell("pos", 3, vec3(seg.endPos.x, mousePos.y, seg.endPos.y))
                    end
                end
            end
            if player:spellSlot(3).state == 0 and unit.pos:dist(player.pos) < 1000 and dmr >= common.HealthPercent(unit) and unit.pos:dist(player.pos) > common.GetTrueAttackRange(player) and unit.pos:dist(player.pos) > epredinput.range then
                if player:spellSlot(2).state == 0 then
                    local unitpos = player.pos + (unit.pos - player.pos):norm() * -700 
                    player:castSpell("pos", 2, unitpos)
                end
            end
        end
    end
end

local function Clearginh()
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        local useqlane = menu.akalimenu.Cleading.laneq:get();
        local onlyht = menu.akalimenu.Cleading.onlylast:get();
        if minion and common.IsValidTarget(minion) and not minion.name:find("Ward") and player.par / player.maxPar * 100 >= 90 then
            if useqlane and minion.pos:dist(player.pos) <= 500 then 
                if not onlyht then
                    player:castSpell("pos", 0, minion.pos)
                else 
                    if Akali_QDamage(minion) > common.HealthPercent(minion) then
                        player:castSpell("pos", 0, minion.pos)
                    end 
                end
            end
        end
    end
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local jungle = objManager.minions[TEAM_NEUTRAL][i]
        local useqlane = menu.akalimenu.Cleading.laneq:get();
        if jungle and common.IsValidTarget(jungle) and not jungle.name:find("Ward") and player.par / player.maxPar * 100 >= 90 then 
            if useqlane and jungle.pos:dist(player.pos) <= 500 then 
                player:castSpell("pos", 0, jungle.pos)
            end 
        end
    end
end

orb.combat.register_f_pre_tick(function()
    if menu.akalimenu.Combo.keyflash:get() then
        Burts();
        orb.core.can_attack()
        player:move(game.mousePos)
    end
    --EGapCloseing();
    --[[for i = 0, objManager.enemies_n - 1 do
        local unit = objManager.enemies[i]
        if player and common.IsValidTarget(player) then
            for i = 0, player.buffManager.count - 1 do
                local buff = player.buffManager:get(i)
                if buff and buff.valid then
                    print(buff.name)
                end
            end
            if unit.buff["akaliemis"] then
                print("hereee")
            end
        end
    end
    if player.buff["akalipmaterialvfx"] then
        chat.print("hereee")
    end]]
    if menu.akalimenu.Harass.barharass:get() then
        Harass();
    end
    if menu.akalimenu.Miscing.autc:get() then
        SmartKill();
    end
    if menu.akalimenu.Combo.stogglebar:get() then
        Combo();
    end
    --[[for i = 0, objManager.enemies_n - 1 do
        local unit = objManager.enemies[i]
        if unit then
            if unit.buff["akaliemis"] then 
                chat.print('Miss')
            end
        end
    end]]
    if menu.akalimenu.Cleading.keyclear:get() then
        Clearginh();
    end
end)
cb.add(cb.tick, function()
    --AkaliEb
    if menu.akalimenu.Miscing.intrreupt:get() and player:spellSlot(3).state == 0 then
        r_interruptor();
    end
end)

cb.add(cb.draw, function()
    local drawq = menu.akalimenu.dirw.dq:get()
    local draww = menu.akalimenu.dirw.dw:get()
    local drawe = menu.akalimenu.dirw.de:get()
    local drawr = menu.akalimenu.dirw.dr:get()
    if player.isOnScreen and common.IsValidTarget(player) then
        if player:spellSlot(0).state == 0 and drawq then
            graphics.draw_circle(player.pos, 500, 2, graphics.argb(255, 0, 255, 0), 100)
        end
        if player:spellSlot(1).state == 0 and draww then
            graphics.draw_circle(player.pos, 250, 2, graphics.argb(255, 0, 255, 0), 100)
        end
        if player:spellSlot(2).state == 0 and drawe then
            graphics.draw_circle(player.pos, 650, 2, graphics.argb(255, 0, 255, 0), 100)
        end
        if player:spellSlot(3).state == 0 and drawr and player:spellSlot(3).name ~= "AkaliRb" then
            graphics.draw_circle(player.pos, 600, 2, graphics.argb(255, 0, 255, 0), 100)
        end
        if player:spellSlot(3).name ~= "AkaliRb" and drawr and player:spellSlot(3).state == 0 then 
            graphics.draw_circle(player.pos, 750, 2, graphics.argb(255, 0, 255, 0), 100)
        end
    end
end)