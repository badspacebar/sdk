local util = module.load("DivineLib", "util")
local pred = module.internal("pred")
local isRiot = hanbot.isRiot
local getBuffStacks = util.getBuffStacks
local objManager = objManager
local player = objManager.player
local hanorb = module.seek("orb") or { combat = {} }
local hanorbcore, hanorbfarm, hanorbmenu, core, farm, omenu
local function overrideHanorb()
    local horb = module.internal("orb")
    hanorbcore = {
        set_pause_move = horb.core.set_pause_move,
        set_pause_attack = horb.core.set_pause_attack,
        set_pause = horb.core.set_pause
    }
    hanorbfarm = {
        skill_farm_clear = horb.farm.skill_farm_clear,
        skill_farm_assist = horb.farm.skill_farm_assist,
        skill_farm_clear_target = horb.farm.skill_farm_clear_target
    }
    horb.core = core
    horb.farm = farm
    horb.menu = omenu
end
-- local bs = module.load("DivineLib", "bugsplat")
local orb;orb = {
    init = function()
        -- bs.log("orb.init")
        orb.init = nil
        orb.hasWindUp = player.charName ~= "Kalista" and player.charName ~= "Graves"
        orb.mayNotAttack = 0
        orb.mayNotMove = 0
        orb.isPaused = 0
        orb.lastAfkMove = game.time + 25
        orb.resetAttackSlots = {
            Blitzcrank = 2,
            Camille = 0,
            ChoGath = 3,
            Darius = 1,
            DrMundo = 2,
            Elise = 1,
            Fiora = 2,
            Garen = 0,
            Graves = 2,
            Illaoi = 1,
            Jax = 1,
            Jayce = 0,
            Kalista = 0,
            Kassadin = 1,
            Leona = 0,
            Lucian = 2,
            MasterYi = 1,
            MonkeyKing = 0,
            Mordekaiser = 0,
            Nasus = 0,
            Nautilus = 1,
            Nidalee = 0,
            Reksai = 0,
            Renekton = 1,
            Rengar = 0,
            Riven = 0,
            Shyvana = 0,
            Sivir = 1,
            Talon = 0,
            Trundle = 0,
            Vayne = 0,
            Vi = 2,
            Volibear = 0,
            XinZhao = 0,
            Yorick = 0
        }
        orb.health_pred = {}
        orb.lastAA = 0
        orb.lastMouseOverChange = 0
        orb.range = player.attackRange + player.boundingRadius
        orb.state = "IDLE"
        orb.plants = {}
        for idx, f in pairs(orb.cb) do
            cb.add(cb[idx], f)
        end
        for idx, f in pairs(orb[isRiot and "cb_riot" or "cb_cn"]) do
            cb.add(cb[idx], f)
        end
        orb.cb_self = {
            after_attack = {},
            pre_tick = {},
            out_of_range = {},
            pre_attack = {}
        }
        objManager.loop(orb.cb_cn.createobj)
        -- bs.log("orb.init.return")
    end,
    setMenu = function(_m)
        if orb.config then return orb.config end
        if isRiot then
            orb.config = _m or menu("Nebelwolfis_Orb_" .. player.charName, "Nebelwolfi's Orb Walker")
            orb.config:menu("combat", "Combat Settings")
                orb.config.combat:header("s1", "General")
                orb.config.combat:boolean("walk", "Walk", true)
                orb.config.combat:boolean("attack", "Attack", true)
                orb.config.combat:header("s2", "Attack following objects")
                orb.config.combat:boolean("champions", "Champions", true)
                orb.config.combat:boolean("pets", "Pets", true)
                orb.config.combat:boolean("plants", "Plants", false)
                orb.config.combat:boolean("structures", "Structures", true)
            orb.config:menu("hybrid", "Hybrid Settings")
                orb.config.hybrid:header("s1", "General")
                orb.config.hybrid:boolean("walk", "Walk", true)
                orb.config.hybrid:boolean("attack", "Attack", true)
                orb.config.hybrid:header("s2", "Attack following objects")
                orb.config.hybrid:boolean("champions", "Champions", true)
                orb.config.hybrid:boolean("minions", "Minions", true)
                orb.config.hybrid:boolean("pets", "Pets", true)
                orb.config.hybrid:boolean("plants", "Plants", false)
                orb.config.hybrid:boolean("structures", "Structures", true)
                orb.config.hybrid:dropdown("priority", "Priority", 2, {"Lasthit", "Harass"})
            orb.config:menu("last_hit", "Lasthit Settings")
                orb.config.last_hit:header("s1", "General")
                orb.config.last_hit:boolean("walk", "Walk", true)
                orb.config.last_hit:boolean("attack", "Attack", true)
                orb.config.last_hit:header("s2", "Attack following objects")
                orb.config.last_hit:boolean("minions", "Minions", true)
                orb.config.last_hit:boolean("pets", "Pets", true)
                orb.config.last_hit:boolean("plants", "Plants", false)
                orb.config.last_hit:boolean("structures", "Structures", true)
            orb.config:menu("lane_clear", "Laneclear Settings")
                orb.config.lane_clear:header("s1", "General")
                orb.config.lane_clear:boolean("walk", "Walk", true)
                orb.config.lane_clear:boolean("attack", "Attack", true)
                orb.config.lane_clear:header("s2", "Attack following objects")
                orb.config.lane_clear:boolean("minions", "Minions", true)
                orb.config.lane_clear:boolean("pets", "Pets", true)
                orb.config.lane_clear:boolean("plants", "Plants", false)
                orb.config.lane_clear:boolean("structures", "Structures", true)
                orb.config.lane_clear:header("s3", "Laneclear Logic")
                orb.config.lane_clear:boolean("wait", "Wait for lasthits", true)
                orb.config.lane_clear:boolean("turret", "Wait under turret", true)
                orb.config.lane_clear:slider("waitDuration", "Waitiness", 200, 100, 200, 1)
            orb.config:menu("jungle_clear", "Jungleclear Settings")
                orb.config.jungle_clear:header("s1", "General")
                orb.config.jungle_clear:boolean("walk", "Walk", true)
                orb.config.jungle_clear:boolean("attack", "Attack", true)
                orb.config.jungle_clear:header("s2", "Attack following objects")
                orb.config.jungle_clear:boolean("champions", "Champions", true)
                orb.config.jungle_clear:boolean("monsters", "Monsters", true)
                orb.config.jungle_clear:boolean("pets", "Pets", true)
                orb.config.jungle_clear:boolean("plants", "Plants", true)
                orb.config.jungle_clear:boolean("structures", "Structures", true)
                orb.config.jungle_clear:dropdown("priority1", "Priority", 2, {"Monsters", "Champions"})
                orb.config.jungle_clear:dropdown("priority2", "Priority (Monsters)", 1, {"Small Ones", "Big Ones"})
            orb.config:menu("draws", "Draw Settings")
                orb.config.draws:header("s1", "Range circles")
                orb.config.draws:boolean("ownAA", "Your range", true)
                orb.config.draws:boolean("enemyAA", "Enemy range", true)
                orb.config.draws:header("s2", "Minions")
                orb.config.draws:boolean("cutMinions", "Cut healthbar", true)
                orb.config.draws:boolean("drawMinions", "Draw lasthitmarker", true)
                orb.config.draws:boolean("moveMinions", "Animate lasthitmarker", true)
                orb.config.draws:header("s3", "Debug")
                orb.config.draws:boolean("state", "Draw current state", false)
                orb.config.draws:boolean("reatt", "Draw reattack time", false)
                orb.config.draws:boolean("windup", "Draw windup time", false)
            orb.config:menu("keys", "Key Settings")
                orb.config.keys:header("s1", "Mode Hotkeys")
                orb.config.keys:keybind("combat", "Combat mode", 'Space')
                orb.config.keys:keybind("hybrid", "Hybrid mode", 'C')
                orb.config.keys:keybind("last_hit", "Lasthit mode", 'X')
                orb.config.keys:keybind("lane_clear", "Laneclear mode", 'V')
                orb.config.keys:keybind("jungle_clear", "Jungleclear mode", 'V')
                orb.config.keys:header("s2", "Other Hotkeys")
                orb.config.keys:keybind("lane_freeze", "Lane Freeze (F6)", nil, 'F6')
            orb.config:boolean("antiAFK", "Anti AFK", true)
            orb.config:dropdown("humanize", "Humanize", 1, {"None", "Move+Attack", "Fake Clicks"})
            orb.config:dropdown("mouseOver", "Mouse over Player action", 2, {"Keep Walking", "Stop"})
            orb.config:slider("mouseOverRadius", "Mouse over Player radius", 100, 0, 300, 10)
            orb.config:boolean("leftClickLock", "Leftclick Target Lock", true)
            if player.attackRange < 425 or player.charName == "Nidalee" or player.charName == "Jayce" or player.charName == "Elise" then
                orb.config:dropdown("sticky", "Stick to Target type", 2, {"Mouse around target", "Always", "Never"})
            end
        else
            orb.config = _m or menu("Nebelwolfis_Orb_" .. player.charName, "Nebelwolfi's Orb Walker")
            orb.config:menu("combat", "战斗设置")
                orb.config.combat:header("s1", "General")
                orb.config.combat:boolean("walk", "移动", true)
                orb.config.combat:boolean("attack", "攻击", true)
                orb.config.combat:header("s2", "攻击以下目标")
                orb.config.combat:boolean("champions", "英雄", true)
                orb.config.combat:boolean("pets", "宠物", true)
                orb.config.combat:boolean("plants", "植物", false)
                orb.config.combat:boolean("structures", "建筑物", true)
            orb.config:menu("hybrid", "混合设置")
                orb.config.hybrid:header("s1", "General")
                orb.config.hybrid:boolean("walk", "移动", true)
                orb.config.hybrid:boolean("attack", "攻击", true)
                orb.config.hybrid:header("s2", "攻击以下目标")
                orb.config.hybrid:boolean("champions", "英雄", true)
                orb.config.hybrid:boolean("minions", "兵", true)
                orb.config.hybrid:boolean("pets", "宠物", true)
                orb.config.hybrid:boolean("plants", "植物", false)
                orb.config.hybrid:boolean("structures", "建筑物", true)
                orb.config.hybrid:dropdown("priority", "优先", 2, {"补刀", "骚扰"})
            orb.config:menu("last_hit", "补刀设置")
                orb.config.last_hit:header("s1", "General")
                orb.config.last_hit:boolean("walk", "移动", true)
                orb.config.last_hit:boolean("attack", "攻击", true)
                orb.config.last_hit:header("s2", "攻击以下目标")
                orb.config.last_hit:boolean("minions", "英雄", true)
                orb.config.last_hit:boolean("pets", "宠物", true)
                orb.config.last_hit:boolean("plants", "植物", false)
                orb.config.last_hit:boolean("structures", "建筑物", true)
            orb.config:menu("lane_clear", "清线设置")
                orb.config.lane_clear:header("s1", "General")
                orb.config.lane_clear:boolean("walk", "移动", true)
                orb.config.lane_clear:boolean("attack", "攻击", true)
                orb.config.lane_clear:header("s2", "攻击以下目标")
                orb.config.lane_clear:boolean("minions", "兵", true)
                orb.config.lane_clear:boolean("pets", "宠物", true)
                orb.config.lane_clear:boolean("plants", "植物", false)
                orb.config.lane_clear:boolean("structures", "建筑物", true)
                orb.config.lane_clear:header("s3", "清线逻辑")
                orb.config.lane_clear:boolean("wait", "等最后一下补刀", true)
                orb.config.lane_clear:boolean("turret", "塔下等待", true)
                orb.config.lane_clear:slider("waitDuration", "等待时间", 200, 100, 200, 1)
            orb.config:menu("jungle_clear", "清野设置")
                orb.config.jungle_clear:header("s1", "General")
                orb.config.jungle_clear:boolean("walk", "移动", true)
                orb.config.jungle_clear:boolean("attack", "攻击", true)
                orb.config.jungle_clear:header("s2", "攻击以下目标")
                orb.config.jungle_clear:boolean("champions", "英雄", true)
                orb.config.jungle_clear:boolean("monsters", "野怪", true)
                orb.config.jungle_clear:boolean("pets", "宠物", true)
                orb.config.jungle_clear:boolean("plants", "植物", true)
                orb.config.jungle_clear:boolean("structures", "建筑物", true)
                orb.config.jungle_clear:dropdown("priority1", "优先", 2, {"野怪", "英雄"})
                orb.config.jungle_clear:dropdown("priority2", "优先 (野怪)", 1, {"小怪", "大怪"})
            orb.config:menu("draws", "范围圈设置")
                orb.config.draws:header("s1", "范围圈")
                orb.config.draws:boolean("ownAA", "自己攻击范围", true)
                orb.config.draws:boolean("enemyAA", "敌人攻击范围", true)
                orb.config.draws:header("s2", "兵")
                orb.config.draws:boolean("cutMinions", "切断血量", true)
                orb.config.draws:boolean("drawMinions", "显示补刀标记", true)
                orb.config.draws:boolean("moveMinions", "动态补刀标记", true)
                orb.config.draws:header("s3", "调试")
                orb.config.draws:boolean("state", "显示目前状态", false)
                orb.config.draws:boolean("reatt", "显示下次攻击时间", false)
                orb.config.draws:boolean("windup", "显示攻击结束时间", false)
            orb.config:menu("keys", "热键设置")
                orb.config.keys:header("s1", "模式热键")
                orb.config.keys:keybind("combat", "战斗模式", 'Space')
                orb.config.keys:keybind("hybrid", "混合模式", 'C')
                orb.config.keys:keybind("last_hit", "补刀模式", 'X')
                orb.config.keys:keybind("lane_clear", "清线模式", 'V')
                orb.config.keys:keybind("jungle_clear", "清野模式", 'V')
                orb.config.keys:header("s2", "其他热键")
                orb.config.keys:keybind("lane_freeze", "控线/冻线 热键 (F6)", nil, 'F6')
            orb.config:boolean("antiAFK", "防止挂机", true)
            orb.config:dropdown("humanize", "人性化", 1, {"毫无", "移动+攻击", "假点击"})
            orb.config:dropdown("mouseOver", "鼠标停在英雄身上时", 2, {"继续移动", "停止移动"})
            orb.config:slider("mouseOverRadius", "鼠标停在英雄身上范围", 100, 0, 300, 10)
            orb.config:boolean("leftClickLock", "Leftclick Target Lock", true)
            if player.attackRange < 425 or player.charName == "Nidalee" or player.charName == "Jayce" or player.charName == "Elise" then
                orb.config:dropdown("sticky", "黏类型", 2, {"鼠标在目标周围", "总是", "永不"})
            end
        end
        orb.config.mouseOverRadius:set("callback", function() orb.lastMouseOverChange = game.time + 3 end)
        return orb.config
    end,
    isUnitUnderFriendlyTurret = function(unit)
        -- bs.log("orb.iUUFT")
        local towers = objManager.turrets
        for i = 0, towers.size[TEAM_ALLY] - 1 do
            local t = towers[TEAM_ALLY][i]
            if t.pos2D:dist(unit.pos2D) < 775 + unit.boundingRadius then
                -- bs.log("orb.iUUFT.return.true")
                return true
            end
        end
        -- bs.log("orb.iUUFT.return.false")
    end,
    getMode = function()
        local menu = orb.config.keys
        return menu.combat:get() and "combat"
            or menu.hybrid:get() and "hybrid"
            or menu.last_hit:get() and "last_hit"
            or menu.lane_clear:get() and "lane_clear"
            or menu.jungle_clear:get() and "jungle_clear"
            or "none"
    end,
    getWindUpTime = function()
        -- bs.log("orb.getWindUpTime")
        if not orb.windUpTime then
            orb.windUpTime = player:basicAttack(0).windUpTime
        end
        return orb.windUpTime
    end,
    getReattackTime = function()
        -- bs.log("orb.getReattackTime")
        if not orb.animationTime then
            orb.animationTime = player:basicAttack(0).animationTime
        end
        return orb.animationTime - network.latency
    end,
    canKill = function(minion)
        -- bs.log("orb.canKill")
        local health1 = orb.predictHealth(minion)
        local damage = util.calculateFullAADamage(minion, player) - 3.5
        -- bs.log("orb.canKill.return")
        return damage >= health1 and health1 > 0
    end,
    getTarget = function(mode)
        -- bs.log("orb.getTarget")
        local minions, target = objManager.minions
        local minion_count_enemy, minion_array_enemy = minions.size[TEAM_ENEMY], minions[TEAM_ENEMY]
        local underTurret = orb.isUnitUnderFriendlyTurret(player)
        if mode == "last_hit" then
            -- bs.log("orb.getTarget.last_hit")
            for i = 0, minion_count_enemy - 1 do
                local minion = minion_array_enemy[i]
                if util.isMinionValid(minion)
                    and minion.pos2D:dist(player.pos2D) < orb.range + minion.boundingRadius
                then
                    local trueMinion = minion.name:find("_")
                    if trueMinion and orb.config[mode].minions:get()
                        or not trueMinion and orb.config[mode].pets:get()
                    then
                        if orb.canKill(minion) then
                            -- bs.log("orb.getTarget.return1")
                            return minion
                        end
                        if underTurret or orb.isUnitUnderFriendlyTurret(minion) then
                            local damage = util.calculateFullAADamage(minion, player)
                            local health1, health2 = orb.predictHealth(minion)
                            local turretDamage = util.getTowerMinionDamage(minion)
                            if health1 > damage -- can't lasthit
                                and health2 - turretDamage > damage -- can't lasthit after turret hit
                                and health2 - turretDamage < 2 * damage -- can lasthit after turret + aa
                            then
                                -- bs.log("orb.getTarget.return2")
                                return minion
                            end
                        end
                    end
                end
            end
        elseif mode == "lane_clear" then
            -- bs.log("orb.getTarget.lane_clear")
            local shouldWait, waitOn
            for i = 0, minion_count_enemy - 1 do
                local minion = minion_array_enemy[i]
                if util.isMinionValid(minion)
                    and minion.pos2D:dist(player.pos2D) < orb.range + minion.boundingRadius
                then
                    local trueMinion = minion.name:find("_")
                    if trueMinion and orb.config[mode].minions:get()
                        or not trueMinion and orb.config[mode].pets:get()
                    then
                        local health1, health2 = orb.predictHealth(minion)
                        local damage = util.calculateFullAADamage(minion, player)
                        if health1 < damage and health1 > 0 then
                            -- bs.log("orb.getTarget.return1")
                            return minion
                        end
                        if underTurret or orb.isUnitUnderFriendlyTurret(minion) then
                            local turretDamage = util.getTowerMinionDamage(minion)
                            if health1 > damage -- can't lasthit
                                and health2 - turretDamage > damage -- can't lasthit after turret hit
                                and health2 - turretDamage < 2 * damage -- can lasthit after turret + aa
                            then
                                -- bs.log("orb.getTarget.return2")
                                return minion
                            end
                        elseif not minion.charName:find("Super") then
                            if orb.config.lane_clear.wait:get() then
                                if health2 < damage * orb.config.lane_clear.waitDuration:get() / 100
                                    and health2 < minion.health
                                then
                                    shouldWait, waitOn = true, minion
                                end
                            end
                        end
                    end
                end
            end
            if shouldWait and orb.state ~= "WINDDOWN" then
                orb.state = "WAITING"
                orb.waitingOn = waitOn
                -- bs.log("orb.getTarget.wait.return")
                return
            end
            for i = 0, minion_count_enemy - 1 do
                local minion = minion_array_enemy[i]
                if util.isMinionValid(minion)
                    and minion.pos2D:dist(player.pos2D) < orb.range + minion.boundingRadius
                then
                    local trueMinion = minion.name:find("_")
                    if trueMinion and orb.config[mode].minions:get()
                        or not trueMinion and orb.config[mode].pets:get()
                    then
                        if not target or minion.health > target.health or minion.maxHealth > target.maxHealth then
                            local health1 = orb.predictHealth(minion)
                            if health1 > 0 then
                                target = minion
                            end
                        end
                    end
                end
            end
            if target then
                -- bs.log("orb.getTarget.return")
                return target
            end
        end
        local minion_count_jungle, minion_array_jungle = minions.size[TEAM_NEUTRAL], minions[TEAM_NEUTRAL]
        if orb.config.keys.jungle_clear:get() then
            -- bs.log("orb.getTarget.jungle_clear")
            local jc_prio2 = orb.config.jungle_clear.priority2:get()
            if orb.config.jungle_clear.monsters:get() then
                for i = 0, minion_count_jungle - 1 do
                    local minion = minion_array_jungle[i]
                    if util.isMinionValid(minion)
                        and minion.pos2D:dist(player.pos2D) < orb.range + minion.boundingRadius
                    then
                        if not target or minion.health < orb.totalDamage
                            or (jc_prio2 == 1 and minion.maxHealth < target.maxHealth
                                or minion.maxHealth > target.maxHealth)
                        then
                            target = minion
                        end
                    end
                end
            end
            if orb.config.jungle_clear.champions:get()
                and (not target or orb.config.jungle_clear.priority1:get() == 2)
            then
                local threat = {}
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if hero and util.isTargetValid(hero) then
                        local d = player.pos2D:dist(hero.pos2D)
                        if d < orb.range + hero.boundingRadius then
                            threat[hero.ptr] = (1
                                                + (hero.baseAttackDamage+hero.flatPhysicalDamageMod)
                                                 * (1+hero.percentPhysicalDamageMod)
                                                 * (1+hero.crit)
                                                 * hero.attackSpeedMod
                                                 * hero.attackRange / 425
                                                + hero.flatMagicDamageMod
                                                 * (1 - hero.percentCooldownMod)
                                                 * hero.percentMagicDamageMod)
                                               * util.calculatePhysicalDamage(hero, player, 100)
                                               / (hero.health+hero.allShield)
                        end
                    end
                end
                local htarget, targetThreat
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if threat[hero.ptr] and (not htarget or targetThreat < threat[hero.ptr]) then
                        htarget, targetThreat = hero, threat[hero.ptr]
                    end
                end
                if htarget then
                    -- bs.log("orb.getTarget.returnH")
                    return htarget
                end
            end
            if target then
                -- bs.log("orb.getTarget.return")
                return target
            end
        end
        if mode == "hybrid" then
            -- bs.log("orb.getTarget.hybrid")
            if orb.config.hybrid.champions:get() then
                if orb.config.hybrid.priority:get() == 1 then
                    if orb.config.hybrid.minions:get() then
                        for i = 0, minion_count_enemy - 1 do
                            local minion = minion_array_enemy[i]
                            if util.isMinionValid(minion) and minion.pos2D:dist(player.pos2D)
                                < orb.range + minion.boundingRadius
                            then
                                local trueMinion = minion.name:find("_")
                                if trueMinion and orb.config[mode].minions:get()
                                    or not trueMinion and orb.config[mode].pets:get()
                                then
                                    if orb.canKill(minion) then
                                        -- bs.log("orb.getTarget.return1")
                                        return minion
                                    end
                                    if underTurret or orb.isUnitUnderFriendlyTurret(minion) then
                                        local damage = util.calculateFullAADamage(minion, player)
                                        local health1, health2 = orb.predictHealth(minion)
                                        local turretDamage = util.getTowerMinionDamage(minion)
                                        if health1 > damage -- can't lasthit
                                            and health2 - turretDamage > damage -- can't lasthit after turret hit
                                            and health2 - turretDamage < 2 * damage -- can lasthit after turret + aa
                                        then
                                            -- bs.log("orb.getTarget.return2")
                                            return minion
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if orb.leftClickLockedTarget and util.isTargetValid(orb.leftClickLockedTarget) and orb.leftClickLockedTarget.pos2D:dist(player.pos2D) < orb.range then
                        return orb.leftClickLockedTarget
                    end
                    local threat = {}
                    for i = 0, objManager.enemies_n - 1 do
                        local hero = objManager.enemies[i]
                        if hero and util.isTargetValid(hero) then
                            local d = player.pos2D:dist(hero.pos2D)
                            if d < orb.range + hero.boundingRadius then
                                threat[hero.ptr] = (1
                                                    + (hero.baseAttackDamage+hero.flatPhysicalDamageMod)
                                                    * (1+hero.percentPhysicalDamageMod)
                                                    * (1+hero.crit)
                                                    * hero.attackSpeedMod
                                                    * hero.attackRange / 425
                                                    + hero.flatMagicDamageMod
                                                    * (1 - hero.percentCooldownMod)
                                                    * hero.percentMagicDamageMod)
                                                * util.calculatePhysicalDamage(hero, player, 100)
                                                / (hero.health+hero.allShield)
                            end
                        end
                    end
                    local targetThreat
                    for i = 0, objManager.enemies_n - 1 do
                        local hero = objManager.enemies[i]
                        if threat[hero.ptr] and (not target or targetThreat < threat[hero.ptr]) then
                            target, targetThreat = hero, threat[hero.ptr]
                        end
                    end
                    if target then
                        -- bs.log("orb.getTarget.returnT")
                        return target
                    end
                elseif orb.config.hybrid.priority:get() == 2 then
                    if orb.leftClickLockedTarget and util.isTargetValid(orb.leftClickLockedTarget) and orb.leftClickLockedTarget.pos2D:dist(player.pos2D) < orb.range then
                        return orb.leftClickLockedTarget
                    end
                    local threat = {}
                    for i = 0, objManager.enemies_n - 1 do
                        local hero = objManager.enemies[i]
                        if hero and util.isTargetValid(hero) then
                            local d = player.pos2D:dist(hero.pos2D)
                            if d < orb.range + hero.boundingRadius then
                                threat[hero.ptr] = (1
                                                    + (hero.baseAttackDamage+hero.flatPhysicalDamageMod)
                                                    * (1+hero.percentPhysicalDamageMod)
                                                    * (1+hero.crit)
                                                    * hero.attackSpeedMod
                                                    * hero.attackRange / 425
                                                    + hero.flatMagicDamageMod
                                                    * (1 - hero.percentCooldownMod)
                                                    * hero.percentMagicDamageMod)
                                                * util.calculatePhysicalDamage(hero, player, 100)
                                                / (hero.health+hero.allShield)
                            end
                        end
                    end
                    local targetThreat
                    for i = 0, objManager.enemies_n - 1 do
                        local hero = objManager.enemies[i]
                        if threat[hero.ptr] and (not target or targetThreat < threat[hero.ptr]) then
                            target, targetThreat = hero, threat[hero.ptr]
                        end
                    end
                    if target then
                        -- bs.log("orb.getTarget.return3")
                        return target
                    end
                    if orb.config.hybrid.minions:get() then
                        for i = 0, minion_count_enemy - 1 do
                            local minion = minion_array_enemy[i]
                            if util.isMinionValid(minion) and minion.pos2D:dist(player.pos2D)
                                < orb.range + minion.boundingRadius
                            then
                                local trueMinion = minion.name:find("_")
                                if trueMinion and orb.config[mode].minions:get()
                                    or not trueMinion and orb.config[mode].pets:get()
                                then
                                    if orb.canKill(minion) then
                                        -- bs.log("orb.getTarget.return4")
                                        return minion
                                    end
                                    if underTurret or orb.isUnitUnderFriendlyTurret(minion) then
                                        local damage = util.calculateFullAADamage(minion, player)
                                        local health1, health2 = orb.predictHealth(minion)
                                        local turretDamage = util.getTowerMinionDamage(minion)
                                        if health1 > damage -- can't lasthit
                                            and health2 - turretDamage > damage -- can't lasthit after turret hit
                                            and health2 - turretDamage < 2 * damage -- can lasthit after turret + aa
                                        then
                                            -- bs.log("orb.getTarget.return5")
                                            return minion
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif orb.config.hybrid.minions:get() then
                if orb.config.hybrid.minions:get() then
                    for i = 0, minion_count_enemy - 1 do
                        local minion = minion_array_enemy[i]
                        if util.isMinionValid(minion) and minion.pos2D:dist(player.pos2D)
                            < orb.range + minion.boundingRadius
                        then
                            local trueMinion = minion.name:find("_")
                            if trueMinion and orb.config[mode].minions:get()
                                or not trueMinion and orb.config[mode].pets:get()
                            then
                                if orb.canKill(minion) then
                                    -- bs.log("orb.getTarget.return6")
                                    return minion
                                end
                                if underTurret or orb.isUnitUnderFriendlyTurret(minion) then
                                    local damage = util.calculateFullAADamage(minion, player)
                                    local health1, health2 = orb.predictHealth(minion)
                                    local turretDamage = util.getTowerMinionDamage(minion)
                                    if health1 > damage -- can't lasthit
                                        and health2 - turretDamage > damage -- can't lasthit after turret hit
                                        and health2 - turretDamage < 2 * damage -- can lasthit after turret + aa
                                    then
                                        -- bs.log("orb.getTarget.return7")
                                        return minion
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if mode == "combat" then
            -- bs.log("orb.getTarget.combat")
            if orb.config.combat.champions:get() then
                if orb.leftClickLockedTarget and util.isTargetValid(orb.leftClickLockedTarget) and orb.leftClickLockedTarget.pos2D:dist(player.pos2D) < orb.range then
                    return orb.leftClickLockedTarget
                end
                local threat = {}
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if hero and util.isTargetValid(hero) then
                        local d = player.pos2D:dist(hero.pos2D)
                        if d < orb.range then
                            threat[hero.ptr] = (1
                                                + (hero.baseAttackDamage+hero.flatPhysicalDamageMod)
                                                * (1+hero.percentPhysicalDamageMod)
                                                * (1+hero.crit)
                                                * hero.attackSpeedMod
                                                * hero.attackRange / 425
                                                + hero.flatMagicDamageMod
                                                * (1 - hero.percentCooldownMod)
                                                * hero.percentMagicDamageMod)
                                            * util.calculatePhysicalDamage(hero, player, 100)
                                            / (hero.health+hero.allShield)
                        end
                    end
                end
                target = nil
                local targetThreat = 0
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if threat[hero.ptr] and (not target or targetThreat < threat[hero.ptr]) then
                        target, targetThreat = hero, threat[hero.ptr]
                    end
                end
                if target then
                    -- bs.log("orb.getTarget.returnT")
                    return target
                end
            end
            if orb.config.combat.pets:get() then
                for i = 0, minion_count_enemy - 1 do
                    local minion = minion_array_enemy[i]
                    if util.isMinionValid(minion) and minion.pos2D:dist(player.pos2D)
                        < orb.range + minion.boundingRadius
                    then
                        if not minion.name:find("_") and orb.config[mode].pets:get() then
                            -- bs.log("orb.getTarget.returnP")
                            return minion
                        end
                    end
                end
            end
        end
        if orb.config[mode] and orb.config[mode].plants:get()
            or orb.config.keys.jungle_clear:get() and orb.config.jungle_clear.plants:get() then
            for _, minion in pairs(orb.plants) do
                if minion and minion.isTargetable and minion.isVisible and minion.health > 0
                    and minion.pos:dist(player.pos) < orb.range + minion.boundingRadius
                then
                    return minion
                end
            end
        end
        if orb.config[mode] and orb.config[mode].structures:get() then
            -- bs.log("orb.getTarget.structures")
            local towers = objManager.turrets
            for i = 0, towers.size[TEAM_ENEMY] - 1 do
                local struct = towers[TEAM_ENEMY][i]
                if struct.isTargetable and struct.health > 0 and struct.pos2D:dist(player.pos2D) < orb.range + 80 then
                    -- bs.log("orb.getTarget.returnT1")
                    return struct
                end
            end
            local inhibs = objManager.inhibs
            for i = 0, inhibs.size[TEAM_ENEMY] - 1 do
                local struct = inhibs[TEAM_ENEMY][i]
                if struct.isTargetable and struct.health > 0 and struct.pos2D:dist(player.pos2D) < orb.range + 120 then
                    -- bs.log("orb.getTarget.returnI")
                    return struct
                end
            end
            local struct = objManager.nexus[TEAM_ENEMY]
            if struct.isTargetable and struct.health > 0 and struct.pos2D:dist(player.pos2D) < orb.range + 200 then
                -- bs.log("orb.getTarget.returnN")
                return struct
            end
        end
        -- bs.log("orb.getTarget.returnT2")
        return target
    end,
    invoke = function(name)
        local c = orb.cb_self[name]
        orb.continue_invoke = true
        for i = 1, #c do
            if orb.continue_invoke then
                c[i]()
            end
        end
    end,
    attack = function(unit)
        -- bs.log("orb.attack")
        if unit and orb.mayAttack then
            local humanize = orb.config.humanize:get()
            if humanize >= 2 then
                if not orb.lastAttackTimer or orb.lastAttackTimer + network.latency + 0.07 < game.time then
                    if humanize == 3 then
                        graphics.spawn_fake_click('red', unit.pos)
                    end
                    orb.state = "ATTACKING"
                    orb.lastAA = game.time + network.latency + 0.07
                    orb.lastAttackTimer = game.time
                    orb.lastAttackPosition = vec3(unit.x, unit.y, unit.z)
                    orb.attackTarget = unit
                    orb.invoke("pre_attack")
                    player:attack(unit)
                    if not orb.hasWindUp then
                        player:move(orb.getMouseMovePosition(game.mousePos))
                    end
                end
            else
                orb.state = "ATTACKING"
                orb.lastAA = game.time + network.latency + 0.07
                orb.invoke("pre_attack")
                orb.attackTarget = unit
                player:attack(unit)
                if not orb.hasWindUp then
                    player:move(orb.getMouseMovePosition(game.mousePos))
                end
            end
        end
        -- bs.log("orb.attack.return")
    end,
    move = function(pos)
        -- bs.log("orb.move")
        if pos and orb.mayMove then
            local humanize = orb.config.humanize:get()
            if humanize >= 2 then
                if not orb.lastMovePosition
                    or (not player.path or not player.path.isActive)
                    or orb.lastMovePosition:dist(pos) > 225
                    and orb.lastMoveTimer - math.min(0.075, orb.lastMovePosition:dist(pos)/10000) < game.time
                    and (not orb.lastAttackPosition or orb.lastAttackTimer + orb.lastAttackPosition:dist(pos)/12500 < game.time)
                then
                    orb.lastMoveTimer = game.time + math.random(205, 285) / 1000
                    orb.lastMovePosition = vec3(pos.x, pos.y, pos.z)
                    if humanize == 3 then
                        graphics.spawn_fake_click('green', pos)
                    end
                    player:move(pos)
                end
            else
                orb.lastMoveTimer = game.time + math.random(205, 285) / 1000
                orb.lastMovePosition = vec3(pos.x, pos.y, pos.z)
                player:move(pos)
            end
        end
        -- bs.log("orb.move.return")
    end,
    getMouseMovePosition = function(pos)
        -- bs.log("orb.getMMPos")
        if orb.config.mouseOver:get() == 1 or game.mousePos:dist(player.pos) > orb.config.mouseOverRadius:get() then
            local dist = math.max(player.pos:dist(pos), 374 + player.boundingRadius)
            -- bs.log("orb.getMMPos.return1")
            return player.pos + (pos - player.pos):norm() * dist
        elseif player.path and player.path.isActive then
            -- bs.log("orb.getMMPos.return2")
            return player.pos
        end
    end,
    moveTarget = function(target)
        -- bs.log("orb.moveTarget")
        local movePos
        if player.attackRange < 425
            and target and target.type == TYPE_HERO
            and (orb.config.sticky:get() == 2
                or orb.config.sticky:get() == 2
                    and target.pos:dist(game.mousePos) < orb.range * 1.5)
            and target.pos2D:dist(player.pos2D) < orb.range * 2
        then
            if target.path and target.path.isActive then
                local res = pred.core.project(player.pos, target.path, 0, target.moveSpeed, player.moveSpeed)
                movePos = vec3(res.x, target.y, res.y)
            end
        end
        movePos = movePos or orb.getMouseMovePosition(game.mousePos)
        orb.move(movePos)
        -- bs.log("orb.moveTarget.return")
    end,
    canShoot = function()
        return orb.lastAA + orb.getReattackTime() < game.time
    end,
    predictHealth = function(unit, delta)
        -- bs.log("orb.pH")
        delta = delta or orb.getWindUpTime()
            + (player.attackRange > 425 and
                math.min(orb.range,
                    math.max(0, player.pos2D:dist(unit.pos2D)-unit.boundingRadius-player.boundingRadius))
                / player:basicAttack(0).static.missileSpeed
                or 0)
            + network.latency
        local delta2 = orb.getReattackTime() + delta
        -- bs.log("orb.pH.return")
        return orb.predictHealthF(unit, delta), orb.predictHealthF(unit, delta2)
    end,
    predictHealthF = function(unit, delta)
        -- bs.log("orb.pHF")
        local health = unit.health
        for ptr, attack in pairs(orb.health_pred) do
            if unit.ptr == attack.target.ptr then
                -- bs.log("orb.pHF.tlc")
                local attacker = objManager.toluaclass(ptr)
                if attacker and attacker.ptr ~= 0 and not attacker.isDead then
                    if attack.estimatedTimeOfHit < game.time then
                        -- bs.log("orb.pHF.etoh")
                        orb.health_pred[ptr] = nil
                    elseif attack.projectile
                        and attack.projectile.pos2D:dist(unit.pos2D) / attack.projectileSpeed <= delta
                        or attack.estimatedTimeOfHit <= game.time + delta
                    then
                        -- bs.log("orb.pHF.recalc")
                        health = health - util.calculateFullAADamage(unit, attacker)
                    else
                        -- bs.log("orb.pHF.nohit")
                    end
                end
            end
        end
        -- bs.log("orb.pHF.return")
        return health
    end,
    cb = {
        spell = function(spell)
            -- bs.log("orb.spell")
            if spell and spell.isBasicAttack then
                local unit = spell.owner
                local isMelee = false
                if unit.type == TYPE_MINION then
                    isMelee = unit.charName:find("Melee")
                elseif unit.type == TYPE_HERO then
                    isMelee = unit.attackRange < 425
                end
                if unit.ptr == player.ptr then
                    orb.state = "ATTACKING"
                    orb.lastAA = game.time + network.latency * 0.5
                    -- print(spell.slot, spell.windUpTime * player.attackSpeedMod, player:basicAttack(0).windUpTime)
                    -- print(spell.animationTime, 1/spell.animationTime, 1/(player.attackSpeedMod*spell.animationTime))
                    orb.windUpTime = spell.windUpTime
                    orb.animationTime = spell.animationTime
                end
                if isMelee then
                    local eta, speed = game.time + spell.windUpTime, math.huge
                    orb.health_pred[unit.ptr] = {
                        target = spell.target,
                        isMelee = isMelee,
                        estimatedTimeOfHit = eta,
                        projectileSpeed = speed
                    }
                end
            elseif spell.owner == player and orb.state == "ATTACKING" then
                orb.state = "IDLE"
                orb.lastAA = 0
            end
            -- bs.log("orb.spell.return")
        end,
        tick = function()
            -- bs.log("orb.tick")
            orb.setMenu()
            if orb.config.antiAFK:get() then
                if player.path.isActive or player.activeSpell then
                    orb.lastAfkMove = game.time + 25 + math.random(0, 25)
                elseif orb.lastAfkMove < game.time then
                    player:move(player.pos + vec3(-100+math.random(0, 200), 0, -100+math.random(0, 200)))
                    orb.lastAfkMove = game.time + 25 + math.random(0, 25)
                end
            end
            if module.seek("orb") ~= nil then
                if hanorbcore then
                    hanorbcore.set_pause_move(math.huge)
                    hanorbcore.set_pause_attack(math.huge)
                    hanorbcore.set_pause(math.huge)
                else
                    overrideHanorb()
                end
            end
            orb.totalDamage = (player.baseAttackDamage + player.flatPhysicalDamageMod) * player.percentPhysicalDamageMod
            orb.range = player.attackRange + player.boundingRadius
            orb.mode = orb.getMode()
            for ptr, attack in pairs(orb.health_pred) do
                if attack.isMelee and attack.estimatedTimeOfHit < game.time then
                    orb.health_pred[ptr] = nil
                end
            end
            orb.invoke("pre_tick")
            orb.mayAttack = orb.mayNotAttack < game.time
            orb.mayMove = orb.mayNotMove < game.time
            orb.shouldAttack = orb.mayAttack and (orb.config[orb.mode] and orb.config[orb.mode].attack:get()
                                        or orb.config.keys.jungle_clear:get() and orb.config.jungle_clear.attack:get())
            orb.shouldMove = orb.mayMove and (orb.config[orb.mode] and orb.config[orb.mode].walk:get()
                                        or orb.config.keys.jungle_clear:get() and orb.config.jungle_clear.walk:get())
            if orb.isPaused > game.time or chat.isOpened or player.isDead or not game.isWindowFocused then
                -- bs.log("orb.tick.default.return")
                return
            end
            if orb.state == "ATTACKING" then
                local attackTarget = orb.attackTarget
                if not attackTarget
                    or attackTarget.ptr == 0
                    or attackTarget.isDead
                    or attackTarget.health <= 0
                    or not attackTarget.isVisible
                    or not attackTarget.isTargetable
                then
                    orb.state = "IDLE"
                elseif not orb.hasWindUp or orb.lastAA + orb.getWindUpTime() < game.time then
                    orb.state = "WINDDOWN"
                    orb.invoke("after_attack")
                elseif player.activeSpell and not player.activeSpell.isBasicAttack then
                    --print("Attack Canceled: ", player.activeSpell.name)
                    orb.state = "IDLE"
                    orb.lastAA = 0
                end
                -- bs.log("orb.tick.attacking.return")
                return
            elseif orb.state == "WAITING" then
                local minion = orb.waitingOn
                if not minion
                    or minion.ptr == 0
                    or minion.type ~= TYPE_MINION
                    or minion.isDead
                    or minion.health <= 0
                    or not minion.isVisible
                    or not minion.isTargetable
                then
                    orb.waitingOn = nil
                    orb.state = "IDLE"
                elseif orb.canKill(orb.waitingOn) then
                    orb.attack(orb.waitingOn)
                    -- bs.log("orb.tick.wait.kill.return")
                    return
                elseif orb.config[orb.mode] then
                    local target = orb.getTarget(orb.mode)
                    if target and target.type == TYPE_HERO then
                        hanorb.combat.target = target
                    end
                    if target and orb.config[orb.mode].attack:get() then
                        orb.attack(target)
                    elseif orb.config[orb.mode].walk:get() then
                        orb.move(orb.getMouseMovePosition(game.mousePos))
                    end
                    -- bs.log("orb.tick.wait.mode.return")
                    return
                end
            elseif orb.state == "WINDDOWN" then
                if orb.canShoot() then
                    orb.state = "IDLE"
                else
                    if orb.config[orb.mode] and orb.config[orb.mode].walk:get() then
                        local target = orb.getTarget(orb.mode)
                        if target then
                            orb.moveTarget(target)
                        else
                            orb.move(orb.getMouseMovePosition(game.mousePos))
                        end
                    end
                    -- bs.log("orb.tick.winddown.return")
                    return
                end
            end
            if orb.mode == "none" then
                -- bs.log("orb.tick.none.return")
                return
            end
            local target = orb.getTarget(orb.mode)
            if target and target.type == TYPE_HERO then
                hanorb.combat.target = target
            end
            if target and orb.shouldAttack then
                orb.attack(target)
            elseif orb.shouldMove then
                if target then
                    orb.moveTarget(target)
                else
                    orb.move(orb.getMouseMovePosition(game.mousePos))
                end
            end
            -- bs.log("orb.tick.last.return")
        end,
        draw = function()
            -- bs.log("orb.draw")
            orb.setMenu()
            if orb.lastMouseOverChange > game.time then
                local alpha = orb.lastMouseOverChange - game.time
                alpha = alpha < 2.55 and math.floor(alpha * 100) or 255
                graphics.draw_circle(
                    player.pos,
                    orb.config.mouseOverRadius:get(),
                    3,
                    tonumber("0x" .. ("%x"):format(alpha) .. "ffffff"),
                    32
                )
            end
            if orb.leftClickLockedTarget and util.isTargetValid(orb.leftClickLockedTarget) and orb.leftClickLockedTarget.isOnScreen then
                graphics.draw_circle(orb.leftClickLockedTarget, orb.leftClickLockedTarget.boundingRadius, 3, 0xffffffff, 32)
                local text = "TARGET"
                local textArea = graphics.text_area(text, 25, text:len())
                local champPos2D = graphics.world_to_screen(orb.leftClickLockedTarget)
                graphics.draw_text_2D(text, 25, champPos2D.x - textArea * .5, champPos2D.y - 12, 0xffffffff)
                local text = "LOCK"
                local textArea = graphics.text_area(text, 25, text:len())
                local champPos2D = graphics.world_to_screen(orb.leftClickLockedTarget)
                graphics.draw_text_2D(text, 25, champPos2D.x - textArea * .5, champPos2D.y + 12, 0xffffffff)
            end
            local y = 250
            if orb.config.draws.state:get() then
                graphics.draw_text_2D(orb.state, 25, 250, y, 0xffffffff)
                y = y + 30
            end
            if orb.config.draws.reatt:get() then
                graphics.draw_text_2D(tostring(1 / orb.getReattackTime()), 25, 250, y, 0xffffffff)
                y = y + 30
            end
            if orb.config.draws.windup:get() then
                graphics.draw_text_2D(tostring(orb.getWindUpTime()), 25, 250, y, 0xffffffff)
            end
            if orb.config.draws.ownAA:get() and player.isOnScreen then
                graphics.draw_circle(player.pos, orb.range, 3, 0x3f00ff00, 32)
            end
            if orb.config.draws.enemyAA:get() then
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if util.isTargetValid(hero) and hero.isVisible and hero.isOnScreen then
                        graphics.draw_circle(hero.pos, hero.attackRange + player.boundingRadius + hero.boundingRadius,
                            3, 0x5fff0000, 32)
                    end
                end
            end
            local enemy_minions = objManager.minions[TEAM_ENEMY]
            for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                local minion = enemy_minions[i]
                if util.isMinionValid(minion) and minion.isVisible and minion.isOnScreen then
                    local maxWidth = (minion.charName:find("Super") and 88 or 63)
                    local drawPos = minion.barPos
                    drawPos.x = drawPos.x + 10
                    if minion.charName:find("Super") then
                        drawPos.y = drawPos.y + 199
                    else
                        drawPos.y = drawPos.y + 174 
                    end
                    local drawPos2 = drawPos + vec2(maxWidth, 0)
                    local damage = util.calculateFullAADamage(minion, player)
                    if orb.config.draws.cutMinions:get() then
                        local maxHealth = minion.maxHealth
                        for health = damage, minion.health, damage do
                            local width = maxWidth * health / maxHealth
                            graphics.draw_line_2D(
                                drawPos.x + width,
                                drawPos.y + 4,
                                drawPos.x + width,
                                drawPos.y,
                                2, 0xff000000)
                        end
                    end
                    if orb.config.draws.drawMinions:get() then
                        local predHealth, predHealth2 = orb.predictHealth(minion)
                        if predHealth < damage or predHealth2 < damage then
                            if orb.config.draws.moveMinions:get() then
                                local mBy = game.time % 2
                                drawPos.x = drawPos.x + 5 + 5 * (mBy >= 1 and - 2 + mBy - 1 or - mBy - 1)
                                drawPos2.x = drawPos2.x + 5 - 5 * (mBy >= 1 and - 2 + mBy - 1 or - mBy - 1)
                            end
                            local color = predHealth < damage and 0xff99cc32 or 0xffffffff
                            local angle = 30 * math.pi / 180
                            local length = 20
                            local width = 3
                            local posL = vec2(drawPos.x - 5, drawPos.y+1)
                            local posR = vec2(drawPos2.x - 5, drawPos2.y+1)
                            local p1 = posL + vec2(-math.cos(angle), -math.sin(angle)):norm() * length
                            local p2 = posL + vec2(-math.cos(angle), math.sin(angle)):norm() * length
                            graphics.draw_line_2D(
                                posL.x, posL.y,
                                p1.x, p1.y,
                                width, color)
                            graphics.draw_line_2D(
                                posL.x, posL.y,
                                p2.x, p2.y,
                                width, color)
                            posL = vec3(posL.x - 1 - width * (math.pi - angle), posL.y)
                            graphics.draw_line_2D(
                                posL.x, posL.y,
                                p1.x, p1.y,
                                width, color)
                            graphics.draw_line_2D(
                                posL.x, posL.y,
                                p2.x, p2.y,
                                width, color)
                            p1 = posR + vec2(math.cos(angle), -math.sin(angle)):norm() * length
                            p2 = posR + vec2(math.cos(angle), math.sin(angle)):norm() * length
                            graphics.draw_line_2D(
                                posR.x, posR.y,
                                p1.x, p1.y,
                                width, color)
                            graphics.draw_line_2D(
                                posR.x, posR.y,
                                p2.x, p2.y,
                                width, color)
                            posR = vec3(posR.x + 1 + width * (math.pi - angle), posR.y)
                            graphics.draw_line_2D(
                                posR.x, posR.y,
                                p1.x, p1.y,
                                width, color)
                            graphics.draw_line_2D(
                                posR.x, posR.y,
                                p2.x, p2.y,
                                width, color)
                        end
                    end
                end
            end
            -- bs.log("orb.draw.return")
        end,
        path = function(unit)
            -- bs.log("orb.path")
            if unit.ptr == player.ptr and unit.path.isActive then
                if orb.state == "ATTACKING" and (orb.hasWindUp or unit.charName == "Kalista" and not unit.path.isDashing) then
                    orb.state = "IDLE"
                    orb.lastAA = 0
                end
            end
            -- bs.log("orb.path.return")
        end,
        keydown = function(key)
            if key == 1 and orb.setMenu().leftClickLock:get() then
                if orb.leftClickLockedTarget then
                    orb.leftClickLockedTarget = nil
                    return
                end
                local dist, target = math.huge, nil
                for i = 0, objManager.enemies_n - 1 do
                    local hero = objManager.enemies[i]
                    if hero and util.isTargetValid(hero) then
                        local d = hero.pos:dist(game.mousePos) 
                        if d < dist then
                            dist, target = d, hero
                        end
                    end
                end
                if target and dist < target.boundingRadius + 100 then
                    orb.leftClickLockedTarget = target
                end
            end
        end
    },
    cb_cn = {
        createobj = function(obj)
            if obj.type == TYPE_MISSILE then
                orb.cb_riot.create_missile(obj)
            elseif obj.type == TYPE_MINION then
                orb.cb_riot.create_minion(obj)
            end
        end,
        deleteobj = function(obj)
            if obj.type == TYPE_MISSILE then
                orb.cb_riot.delete_missile(obj)
            elseif obj.type == TYPE_MINION then
                orb.cb_riot.delete_minion(obj)
            end
        end,
    },
    cb_riot = {
        create_missile = function(missile)
            -- bs.log("orb.create_missile")
            local spell = missile.spell
            if spell and spell.isBasicAttack then
                if spell.owner and spell.owner.ptr == player.ptr then
                    if orb.state == "ATTACKING" then
                        orb.state = "WINDDOWN"
                        orb.lastAA = game.time - spell.windUpTime - 0.07 - network.latency
                        orb.windUpTime = spell.windUpTime
                        orb.animationTime = spell.animationTime
                        orb.invoke("after_attack")
                    end
                end
                if spell.target then
                    local speed = missile.speed
                    local eta = (
                        game.time
                        + missile.pos2D:dist(spell.target.pos2D) / speed
                    )
                    local unit = spell.owner
                    orb.health_pred[unit.ptr] = {
                        target = spell.target,
                        isMelee = false,
                        estimatedTimeOfHit = eta,
                        projectile = missile,
                        projectileSpeed = speed
                    }
                end
            end
            -- bs.log("orb.create_missile.return")
        end,
        delete_missile = function(missile)
            -- bs.log("orb.delete_missile")
            for idx, attack in pairs(orb.health_pred) do
                if attack.projectile and attack.projectile.ptr == missile.ptr then
                    orb.health_pred[idx] = nil
                    break
                end
            end
            -- bs.log("orb.delete_missile.return")
        end,
        create_minion = function(minion)
            if minion.charName == "SRU_Plant_Vision"
                or minion.charName == "SRU_Plant_Satchel"
                or minion.charName == "SRU_Plant_Health"
            then
                orb.plants[minion.ptr] = minion
            end
        end,
        delete_minion = function(minion)
            -- bs.log("orb.delete_minion")
            local mptr = minion.ptr
            if orb.attackTarget and orb.attackTarget.ptr == mptr then
                orb.attackTarget = nil
                orb.state = "IDLE"
            end
            if orb.waitingOn and orb.waitingOn.ptr == mptr then
                orb.waitingOn = nil
                orb.state = "IDLE"
            end
            orb.health_pred[mptr] = nil
            orb.plants[mptr] = nil
            for idx, attack in pairs(orb.health_pred) do
                if attack.target.ptr == mptr then
                    orb.health_pred[idx] = nil
                end
            end
            -- bs.log("orb.delete_minion.return")
        end,
    }
}
orb.init()
local sM = orb.setMenu
omenu = {
    combat = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.combat[i] end }),
        get = function()sM() return orb.config.keys.combat:get() end
    },
    hybrid = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.hybrid[i] end }),
        get = function()sM() return orb.config.keys.hybrid:get() end
    },
    last_hit = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.last_hit[i] end }),
        get = function()sM() return orb.config.keys.last_hit:get() end
    },
    lane_clear = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.lane_clear[i] end }),
        get = function()sM() return orb.config.keys.lane_clear:get() end
    },
    jungle_clear = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.jungle_clear[i] end }),
        get = function()sM() return orb.config.keys.jungle_clear:get() end
    },
    lane_freeze = {
        key = setmetatable({}, { __index = function(_, i)sM() return orb.config.keys.lane_freeze[i] end }),
        get = function()sM() return orb.config.keys.lane_freeze:get() end
    }
}
hanorb.combat.is_active = function()
        sM()return orb.config.keys.combat:get()
    end
hanorb.combat.can_action = function()
        return orb.state ~= "ATTACKING"
    end
hanorb.combat.can_attack = function()
        return orb.state == "IDLE" or orb.state == "WAITING"
    end
hanorb.combat.register_f_after_attack = function(f)
        local c = orb.cb_self["after_attack"]
        c[#c + 1] = f
    end
hanorb.combat.register_f_pre_tick = function(f)
        local c = orb.cb_self["pre_tick"]
        c[#c + 1] = f
    end
hanorb.combat.register_f_pre_attack = function(f)
        local c = orb.cb_self["pre_attack"]
        c[#c + 1] = f
    end
hanorb.combat.register_f_out_of_range = function(f)
        local c = orb.cb_self["out_of_range"]
        c[#c + 1] = f
    end
hanorb.combat.set_invoke_after_attack = function(b)
        orb.continue_invoke = b
    end
core = {
        reset = function()
            orb.state = "IDLE"
            orb.lastAA = 0
        end,
        can_action = function(time)
            if time then
                if orb.state == "WINDDOWN" then
                    return time < orb.lastAA + orb.getReattackTime() - game.time
                else
                    return orb.state ~= "ATTACKING"
                end
            else
                return orb.state ~= "ATTACKING"
            end
        end,
        can_attack = function()
            return orb.state == "IDLE" or orb.state == "WAITING"
        end,
        is_paused = function()
            return orb.isPaused > game.time
        end,
        is_move_paused = function()
            return orb.mayNotMove > game.time
        end,
        is_attack_paused = function()
            return orb.mayNotAttack > game.time
        end,
        set_pause = function(time)
            orb.isPaused = game.time + time
        end,
        set_pause_move = function(time)
            orb.mayNotMove = game.time + time
        end,
        set_pause_attack = function(time)
            orb.mayNotAttack = game.time + time
        end,
        set_server_pause = function()
            orb.isPaused = game.time + network.latency + 0.01
        end,
        set_server_pause_attack = function()
            orb.mayNotAttack = game.time + network.latency + 0.01
        end
    }
farm = {
    lane_clear_wait = function()
        return orb.state == "WAITING"
    end,
    predict_hp = orb.predictHealthF,
    get_damage = util.calculateFullAADamage,
    skill_farm_clear = function(...) if not hanorbfarm then overrideHanorb() end return hanorbfarm.skill_farm_clear(...) end,
    skill_farm_assist = function(...) if not hanorbfarm then overrideHanorb() end return hanorbfarm.skill_farm_assist(...) end,
    skill_farm_clear_target = function(...) if not hanorbfarm then overrideHanorb() end return hanorbfarm.skill_farm_clear_target(...) end,
    set_ignore = function(...) end
}

if module.seek("orb") then
    overrideHanorb()
end

return setmetatable({
    core = core,
    menu = omenu,
    farm = farm,
}, {
    __index = hanorb,
    __call = function(_, ...) orb.setMenu(...) return _ end
})