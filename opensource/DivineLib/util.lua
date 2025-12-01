local function assert(b, t)
    if not b then
        console.set_color(42)
        print("[ERROR]", t)
        console.set_color(15)
    end
end

local _da
local function setDelayAction(func, delay, args)
    if not _da then
        _da = {}
        cb.add(cb.tick, function()
            for t, d in pairs(_da) do
                if game.time >= t then
                    for i = 1, #d do
                        d[i][1](d[i][2] and unpack(d[i][2]) or nil)
                    end
                    _da[t] = nil
                end
            end
        end)
    end
    local t = game.time + (delay or 0)
    _da[t] = _da[t] or {}
    _da[t][#_da[t] + 1] = { func, args }
end

local _ia
local function setIntervalAction(func, delay, count, args)
    if not _ia then
        _ia = {}
        cb.add(cb.tick, function()
            for i = 1, #_ia do
                local d = _ia[i]
                if game.time >= d[1] + d[3] then
                    d[4](d[5] and unpack(d[5]) or nil)
                    d[2] = d[2] - 1
                    d[1] = game.time
                    if d[2] <= 0 then
                        _ia[i] = #_ia > i and _ia[#_ia] or nil
                        i = i - 1
                    end
                end
            end
        end)
    end
    _ia[#_ia + 1] = { game.time, count, delay or 0, func, args }
end

local function getPhysicalReduction(target, source)
    source = source or player
    local armor = ( target.bonusArmor
                     * source.percentBonusArmorPenetration
                    + target.armor
                    - target.bonusArmor
                  ) * source.percentArmorPenetration
    local lethality = source.type == TYPE_HERO and
                    (source.physicalLethality
                      *(  .4
                        + .6
                        * source.levelRef
                        / 18)) or 0
    return armor >= 0 and (100 / (100 + armor - lethality)) or 1
end

local function getMagicalReduction(target, source)
    source = source or player
    local magicResist = target.spellBlock * source.percentMagicPenetration - source.flatMagicPenetration
    return magicResist >= 0 and (100 / (100 + magicResist)) or (2 - (100 / (100 - magicResist)))
end

local buffReduces = {
    ["FerociousHowl"] = function(target)
        return (.55 - .1 * target:spellSlot(3).level)
    end,
    ["AnnieE"] = function(target)
        return (.9 - .06 * target:spellSlot(1).level)
    end,
    ["Meditate"] = function(target)
        return (.5 - .05 * target:spellSlot(1).level)
    end,
    ["braumeshieldbuff"] = function(target)
        return (.725 - .025 * target:spellSlot(2).level)
    end,
    ["GalioW"] = function(target, bPhysical)
        if bPhysical then
            return (.925 - .025 * target:spellSlot(1).level - target.bonusSpellBlock * 0.04)
        else
            return (.85 - .05 * target:spellSlot(1).level - target.bonusSpellBlock * 0.08)
        end
    end,
    ["WarwickE"] = function(target)
        return (.70 - .05 * target:spellSlot(2).level)
    end,
    ["ireliawdefense"] = function(target)
        if bPhysical then
            return (.5 - .07 * target.flatMagicDamageMod * target.percentMagicDamageMod)
        else
            return 1
        end
    end,
    ["malzaharpassiveshield"] = function()
        return .1
    end,
    ["GarenW"] = function()
        return .4
    end,
    ["gragaswself"] = function(target)
        return (.92 - .02 * target:spellSlot(2).level - .04 * target.flatMagicDamageMod * target.percentMagicDamageMod)
    end,
}

local function getBuffValid(target, name)
    assert(target, "getBuffValid: no target")
    assert(name, "getBuffValid: no buffname/type")
    local buff = target.buff[type(name) == "string" and name:lower() or name]
    return buff and buff.endTime > game.time and math.max(buff.stacks, buff.stacks2) > 0
end

local function getBuffStacks(target, name, validate)
    assert(target, "getBuffStacks: no target")
    assert(name, "getBuffStacks: no buffname/type")
    local buff = target.buff[type(name) == "string" and name:lower() or name]
    return buff and (validate == false or buff.endTime > game.time) and math.max(buff.stacks, buff.stacks2) or 0
end

local function getBuffStartTime(target, name)
    assert(target, "getBuffStartTime: no target")
    assert(name, "getBuffStartTime: no buffname/type")
    local buff = target.buff[type(name) == "string" and name:lower() or name]
    return buff and (validate == false or buff.endTime > game.time) and buff.startTime or 0
end

local function getBuffEndTime(target, name)
    assert(target, "getBuffEndTime: no target")
    assert(name, "getBuffEndTime: no buffname/type")
    local buff = target.buff[type(name) == "string" and name:lower() or name]
    return buff and (validate == false or buff.endTime > game.time) and buff.endTime or 0
end

local function getTotalDamageReduction(target, source, bPhysical)
    local multiplier = 1
    if target.type == TYPE_HERO then
        for name, buffReduce in pairs(buffReduces) do
            local buff = target.buff[name]
            if buff and buff.endTime > game.time then
                multiplier = multiplier * buffReduce(target, bPhysical)
            end
        end
    end
    if not bPhysical and target.charName == "Kassadin" then
        multiplier = multiplier * 0.85
    end
    for i = 0, source.buffManager.count - 1 do
        local buff = source.buffManager:get(i)
        if buff and buff.valid and buff.endTime > game.time then
            if buff.name == "summonerexhaustdebuff" then
                multiplier = multiplier * .6
            elseif buff.name == "itemsmitechallenge" then
                multiplier = multiplier * .6
            elseif buff.name == "itemphantomdancerdebuff" and buff.source.ptr == target.ptr then
                multiplier = multiplier * 88
            elseif buff.name == "abyssalscepteraura" and not bPhysical then
                multiplier = multiplier * 1.15
            end
        end
    end
    return multiplier
end

local function getTotalAD(obj)
    obj = obj or player
    return (obj.baseAttackDamage + obj.flatPhysicalDamageMod) * obj.percentPhysicalDamageMod
end

local function getBonusAD(obj)
    obj = obj or player
    return (obj.baseAttackDamage + obj.flatPhysicalDamageMod) * obj.percentPhysicalDamageMod - obj.baseAttackDamage
end

local function getTotalAP(obj)
    obj = obj or player
    return obj.flatMagicDamageMod * obj.percentMagicDamageMod
end

local function calculatePhysicalDamage(target, source, ad_dmg)
    assert(target, "calculatePhysicalDamage: target is nil")
    if type(source) == "number" then
        source, ad_dmg = ad_dmg, source
    end
    source = source or player
    return (ad_dmg or getTotalAD(source))
            * getPhysicalReduction(target, source)
            * getTotalDamageReduction(target, source, true)
end

local function calculateMagicalDamage(target, source, ap_dmg)
    assert(target, "calculateMagicalDamage: target is nil")
    if type(source) == "number" then
        source, ap_dmg = ap_dmg, source
    end
    source = source or player
    return (ap_dmg or getTotalAP(source))
            * getMagicalReduction(target, source)
            * getTotalDamageReduction(target, source)
end


local gravesDmgTable = { -- ...
{ 0.75, 0.76, 0.78, 0.79, 0.81, 0.83, 0.84, 0.86, 0.88,
  0.90, 0.92, 0.95, 0.97, 0.99, 1.01, 1.04, 1.07, 1.10 },
{ 0.25, 0.25, 0.26, 0.26, 0.27, 0.28, 0.28, 0.29, 0.29,
  0.30, 0.31, 0.32, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37 }
}

local bonusDamageTable = { -- TODO: Lulu, Rumble, Nautilus, TwistedFate, Ziggs
    ["Aatrox"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg+(getBuffStacks(source, "aatroxpassive")>0 and 35*source:spellSlot(1).level+25 or 0), APDmg, TRUEDmg
    end,
    ["Ashe"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg*(getBuffStacks(source, "asheqattack")>0 and 5*(0.01*source:spellSlot(0).level+0.22) or getBuffStacks(target, "ashepassiveslow")>0 and (1.1+source.crit) or 1), APDmg, TRUEDmg
    end,
    ["Bard"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg+(getBuffStacks(source, "bardpspiritammocount")>0 and 30+source.levelRef*15+0.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Blitzcrank"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg*(getBuffStacks(source, "powerfist")+1), APDmg, TRUEDmg
    end,
    ["Caitlyn"] = function(source, target, ADDmg, APDmg, TRUEDmg, missile)
        return ADDmg + (getBuffStacks(source, "caitlynheadshot") > 0 and (source.baseAttackDamage + source.flatPhysicalDamageMod) * source.percentPhysicalDamageMod * ((source.levelRef > 12 and 1 or source.levelRef > 6 and .75 or .5)+source.crit) or 0), APDmg, TRUEDmg
    end,
    ["Chogath"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "vorpalspikes") > 0 and 15*source:spellSlot(2).level+5+.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), APDmg, TRUEDmg
    end,
    ["Corki"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg, TRUEDmg + (getBuffStacks(source, "rapidreload") > 0 and .1*(ADDmg) or 0)
    end,
    ["Darius"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "dariusnoxiantacticsonh") > 0 and .4*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Diana"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "dianaarcready") > 0 and math.max(5*source.levelRef+15,10*source.levelRef-10,15*source.levelRef-60,20*source.levelRef-125,25*source.levelRef-200)+.8*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Draven"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "dravenspinning") > 0 and (.1*source:spellSlot(0).level+.35)*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Ekko"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "ekkoeattackbuff") > 0 and 30*source:spellSlot(2).level+20+.2*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Fizz"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "fizzseastonepassive") > 0 and 5*source:spellSlot(1).level+5+.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Garen"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "garenq") > 0 and 25*source:spellSlot(0).level+5+.4*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Gragas"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "gragaswattackbuff") > 0 and 30*source:spellSlot(1).level-10+.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod+(.01*source:spellSlot(1).level+.07)*(target.maxHealth) or 0), TRUEDmg
    end,
    ["Graves"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        local dist = source.pos2D:dist(target.pos2D)
        return ADDmg*(gravesDmgTable[1][source.levelRef] + gravesDmgTable[2][source.levelRef] * (dist < 100 and 3 or dist < 200 and 2 or dist < 300 and 1 or 0)), APDmg, TRUEDmg
    end,
    ["Irelia"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, 0, TRUEDmg + (getBuffStacks(source, "ireliahitenstylecharged") > 0 and 25*source:spellSlot(0).level+5+.4*(ADDmg) or 0)
    end,
    ["Jax"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "jaxempowertwo") > 0 and 35*source:spellSlot(1).level+5+.6*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Jayce"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "jaycepassivemeleeatack") > 0 and 40*source:spellSlot(3).level-20+.4*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Jhin"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return (getBuffStacks(source, "jhinpassiveattackbuff") > 0 and (target.maxHealth-target.health)*(source.levelRef < 6 and 0.15 or source.levelRef < 11 and 0.2 or 0.25) or 0), APDmg, TRUEDmg
    end,
    ["Jinx"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "jinxq") > 0 and .1*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Kalista"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg * 0.9, APDmg, TRUEDmg
    end,
    ["Kassadin"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "netherbladebuff") > 0 and 20+.1*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0) + (getBuffStacks(source, "netherblade") > 0 and 25*source:spellSlot(1).level+15+.6*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Kayle"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "kaylerighteousfurybuff") > 0 and 5*source:spellSlot(2).level+5+.15*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0) + (getBuffStacks(source, "judicatorrighteousfury") > 0 and 5*source:spellSlot(2).level+5+.15*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Leona"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "leonashieldofdaybreak") > 0 and 30*source:spellSlot(0).level+10+.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0), TRUEDmg
    end,
    ["Lux"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(target, "luxilluminatingfraulein") > 0 and 10+(source.levelRef*8)+(source.flatPhysicalDamageMod * source.percentPhysicalDamageMod*0.2) or 0), TRUEDmg
    end,
    ["MasterYi"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "doublestrike") > 0 and .5*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Nocturne"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "nocturneumrablades") > 0 and .2*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Orianna"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + 2 + 8 * math.ceil(source.levelRef/3) + 0.15*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod, TRUEDmg
    end,
    ["RekSai"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "reksaiq") > 0 and 10*source:spellSlot(0).level+5+.2*(ADDmg) or 0), TRUEDmg
    end,
    ["Rengar"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "rengarqbase") > 0 and math.max(30*source:spellSlot(0).level+(.05*source:spellSlot(0).level-.05)*(ADDmg)) or 0) + (getBuffStacks(source, "rengarqemp") > 0 and math.min(15*source.levelRef+15,10*source.levelRef+60)+.5*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Shyvana"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "shyvanadoubleattack") > 0 and (.05*source:spellSlot(0).level+.75)*(ADDmg) or 0), APDmg, TRUEDmg
    end,
    ["Talon"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "talonnoxiandiplomacybuff") > 0 and 30*source:spellSlot(0).level+.3*(source.flatPhysicalDamageMod * source.percentPhysicalDamageMod) or 0), APDmg, TRUEDmg
    end,
    ["Teemo"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + 10*source:spellSlot(2).level+0.3*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod, TRUEDmg
    end,
    ["Trundle"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "trundletrollsmash") > 0 and 20*source:spellSlot(0).level+((0.05*source:spellSlot(0).level+0.095)*(ADDmg)) or 0), APDmg, TRUEDmg
    end,
    ["Varus"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg, APDmg + (getBuffStacks(source, "varusw") > 0 and (4*source:spellSlot(1).level+6+.25*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod) or 0) , TRUEDmg
    end,
    ["Vayne"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "vaynetumblebonus") > 0 and (.05*source:spellSlot(0).level+.45)*(ADDmg) or 0), APDmg, TRUEDmg + (getBuffStacks(target, "vaynesilvereddebuff") > 1 and 15*source:spellSlot(1).level+35+((0.025*source:spellSlot(1).level+0.015)*target.maxHealth) or 0)
    end,
    ["Vi"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "vie") > 0 and 15*source:spellSlot(2).level-10+.15*(ADDmg)+.7*source.flatPhysicalDamageMod * source.percentPhysicalDamageMod or 0) , APDmg, TRUEDmg
    end,
    ["Volibear"] = function(source, target, ADDmg, APDmg, TRUEDmg)
        return ADDmg + (getBuffStacks(source, "volibearq") > 0 and 30*source:spellSlot(0).level or 0), APDmg, TRUEDmg
    end
}

local function getTowerMinionDamage(minion)
    if minion.charName:find("Siege") then
        return minion.maxHealth * 0.175
    end
    if minion.charName:find("Cannon") then
        return minion.maxHealth * 0.14
    end
    if minion.charName:find("Ranged") then
        return minion.maxHealth * 0.625
    end
    return 0.425
end

local function calculateFullAADamage(target, source, addad, addap, addtrue)
    if source.type == TYPE_HERO then
        local ad = (addad or 0) + (source.baseAttackDamage + source.flatPhysicalDamageMod) * source.percentPhysicalDamageMod
        local ap, tr = addap or 0, addtrue or 0
        local crit = source.crit > 0.875
        local items = {}
        for i = 0, 6 do
            local id = source:itemID(i)
            if id > 0 then
                items[id] = true
            end
        end
        if crit then
            if source.charName == "Yasuo" then
                ad = ad * 0.75
            end
            if items[3031] then
                if target.type == TYPE_MINION then
                    ad = ad * 2.5
                else
                    tr, ad = ad * 0.2, ad * 1.8
                end
            else
                ad = ad * 2
            end
        end
        if source.charName == "Kalista" then
            ad = ad * 0.9
        end
        if items[1416] or items[1418] or items[1419] then
            if target.type == TYPE_HERO then
                ad = ad + 0.04 * target.maxHealth
            else
                ad = ad + math.min(75, 0.04 * target.maxHealth)
            end
        end
        if items[3153] then
            if target.type == TYPE_HERO then
                ad = ad + math.max(15, 0.08 * target.health)
            else
                ad = ad + math.max(15, math.min(60, 0.08 * target.health))
            end
        end
        if items[1043] then
            ad = ad + 15
        end
        if source.buff["itemstatikshankcharge"] then
            if items[2015] then
                ap = ap + 40
            elseif items[3094] then
                ap = ap + math.floor(49.5+math.max((source.levelRef-5)*8.5,0))
            elseif items[3087] then
                ap = ap + (crit and 2 or 1) * math.floor(50.75+math.max((source.levelRef-5)*5.25,0))
            end
        end
        if bonusDamageTable[source.charName] then
            ad, ap, tr = bonusDamageTable[source.charName](source, target, ad, ap, tr)
        end
        return calculatePhysicalDamage(target, source, ad)
            + calculateMagicalDamage(target, source, ap) + (tr or 0)
    elseif source.type == TYPE_MINION then
        if target.type == TYPE_MINION then
            return calculatePhysicalDamage(target, source, source.baseAttackDamage * source.percentDamageToBarracksMinionMod) - target.flatDamageReductionFromBarracksMinionMod
        else
            return calculatePhysicalDamage(target, source, source.baseAttackDamage)
        end
    elseif source.type == TYPE_TURRET then
        if target.type == TYPE_MINION then
            return getTowerMinionDamage(target)
        else
            return calculatePhysicalDamage(target, source, source.baseAttackDamage)
        end
    end
    return 0
end

local function isInvincible(object)
    for i = 0, object.buffManager.count - 1 do
        local buff = object.buffManager:get(i)
        if buff and buff.valid and buff.type == 17 then
            return true
        end
    end
end

local function isTargetValid(object)
    return (
        object
        and object.ptr ~= 0
        and not object.isDead
        and object.isVisible
        and object.isTargetable
        and not isInvincible(object)
    )
end

local function isHeroValid(object, range)
    return (
        object
        and object.ptr ~= 0
        and object.type == TYPE_HERO
        and not object.isDead
        and object.isVisible
        and (object.team == player.team
            or object.isTargetable
            and not isInvincible(object))
        and (not range or object.pos2D:distSqr(player.pos2D) < range * range)
    )
end

local function isMinionValid(object, ignoreTeam)
    return (
        object
        and object.ptr ~= 0
        and object.type == TYPE_MINION
        and (ignoreTeam or object.team ~= TEAM_ALLY)
        and not object.isDead
        and object.isVisible
        and object.isTargetable
        and object.health > 0
        and object.moveSpeed > 0
        and object.maxHealth > 5
        and object.maxHealth < 100000
    )
end

local pred
local function getPredictedPos(object, delay)
    if not isTargetValid(object) or not object.path or not delay or not object.moveSpeed then
        return object.pos
    end
    pred = pred or module.internal("pred")
    local pred_pos = pred.core.lerp(object.path, network.latency + delay, object.moveSpeed)
    return vec3(pred_pos.x, object.y, pred_pos.y)
end

local function isFleeing(object, source)
    if not isTargetValid(object) or not object.path or not object.path.isActive or not object.moveSpeed then
        return false
    end
    pred = pred or module.internal("pred")
    local pred_pos = pred.core.lerp(object.path, network.latency + .25, object.moveSpeed)
    return vec3(pred_pos.x, object.y, pred_pos.y):dist(source.pos) > object.pos:dist(source.pos)
end

local function isFleeingFromMe(object)
    return isFleeing(object, objManager.player)
end

local function isPosOnScreen(pos)
    local pos2D = graphics.world_to_screen(pos)
    if pos2D.x < 0 or pos2D.x > graphics.width
        or pos2D.y < 0 or pos2D.y > graphics.height
    then
        return false
    end
    return true
end

local function makeGetPercentStatFunc(_type)
    local min, max = _type, "max" .. _type:sub(1, 1):upper() .. _type:sub(2)
    return (function(obj) obj = obj or player return 100 * obj[min] / obj[max] end)
end

local function makeObjectInRangeFunc(_type, _team)
    if _type == TYPE_HERO then
        local ref = _team == player.team and "allies" or "enemies"
        return (function(range, pos)
            pos = pos or player.pos
            range = range * range
            local result = {}
            for h = 0, objManager[ref .. "_n"] - 1 do
                local hero = objManager[ref][h]
                if isHeroValid(hero) and hero.pos:distSqr(pos) < range then
                    result[#result + 1] = hero
                end
            end
            return result
        end)
    elseif _type == TYPE_MINION then
        return (function(range, pos, _t)
            if type(pos) == "number" then pos, _t = _t, pos end
            pos = pos or player.pos
            range = range * range
            _t = _t or _team or TEAM_ENEMY
            local result, minions = {}, objManager.minions[_t]
            for m = 0, objManager.minions.size[_t] - 1 do
                local minion = minions[m]
                if isMinionValid(minion, true) and minion.pos:distSqr(pos) < range then
                    result[#result + 1] = minion
                end
            end
            return result
        end)
    end
end

local yasuoShield = {100, 105, 110, 115, 120, 130, 140, 150, 165, 180, 200, 225, 255, 290, 330, 380, 440, 510}
local function getShieldedHealth(damageType, target)
    local shield = 0 -- bitwise flags when :/
    if damageType:find"AD" then
      shield = target.physicalShield
    elseif damageType:find"AP" then
      shield = target.magicalShield
    elseif damageType:find"ALL" then
      shield = target.allShield + (target.charName == "Yasuo" and target.mana == target.maxMana and yasuoShield[target.levelRef] or 0)
    end
    return target.health + shield
end

local function getKSHealth(hero)
    local health = hero.healthRegenRate
    for s = 4, 5 do
        local spell = hero:spellSlot(s)
        if spell then
            if spell.name:lower():find"heal" then
                health = health + (spell.state == 0 and 75 + hero.levelRef * 15 or 0)
            end
            if spell.name:lower():find"barrier" then
                health = health + (spell.state == 0 and 95 + hero.levelRef * 20 or 0)
            end
        end
    end
    return health
end

local function getAARange(obj, source)
    source = source or player
    return player.attackRange + player.boundingRadius + (obj and obj.boundingRadius or 0)
end

local function getIgniteDamage(target)
    local damage = 55 + (25 * player.levelRef)
    if target then
      damage = damage - (getShieldedHealth("AD", target) - target.health)
    end
    return damage
end

local enemyHeroes
local function getEnemyHeroes()
    if enemyHeroes then
        return enemyHeroes
    end
    enemyHeroes = {}
    for h = 0, objManager.enemies_n - 1 do
        local hero = objManager.enemies[h]
        enemyHeroes[#enemyHeroes + 1] = hero
    end
    return enemyHeroes
end

local allyHeroes
local function getAllyHeroes()
    if allyHeroes then
        return allyHeroes
    end
    allyHeroes = {}
    for h = 0, objManager.allies_n - 1 do
        local hero = objManager.allies[h]
        allyHeroes[#allyHeroes + 1] = hero
    end
    return allyHeroes
end

local function VectorPointProjectionOnLineSegment(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = vec2(ax + rL * (bx - ax), ay + rL * (by - ay))
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or vec2(ax + rS * (bx - ax), ay + rS * (by - ay))
    return pointSegment, pointLine, isOnSegment
end

local function VectorIntersection(a1, b1, a2, b2)
    local x1, y1, x2, y2, x3, y3, x4, y4 = a1.x, a1.z or a1.y, b1.x, b1.z or b1.y, a2.x, a2.z or a2.y, b2.x, b2.z or b2.y
    local r, s, u, v, k, l = x1 * y2 - y1 * x2, x3 * y4 - y3 * x4, x3 - x4, x1 - x2, y3 - y4, y1 - y2
    local px, py, divisor = r * u - v * s, r * k - l * s, v * k - l * u
    return divisor ~= 0 and vec2(px / divisor, py / divisor)
end

local function CountObjectsOnLineSegment(source, EndPos, width, objects, count, valid)
    local n = 0
    for i = 0, count - 1 do
        local object = objects[i]
        if valid(object) then
            local pointSegment, _, isOnSegment = VectorPointProjectionOnLineSegment(source, EndPos, object)
            local w = width
            if isOnSegment and object.pos2D:distSqr(pointSegment) < w * w
                           and source:distSqr(EndPos) > source:distSqr(object.pos) then
                n = n + 1
            end
        end
    end
    return n
end

local function GetLineFarmPosition(source, range, width, objects, count, valid)
    local BestPos
    local BestHit = 0
    for i = 0, count - 1 do
        local object = objects[i]
        if valid(object) and object.pos:distSqr(source.pos) < range*range then
            if object.name:find("Dragon") or object.name:find("Herald") or object.name:find("Baron") then
                return object, 1
            end
            local EndPos = source.pos + range * (object.pos - source.pos):norm()
            local hit = CountObjectsOnLineSegment(source.pos, EndPos, width, objects, count, valid)
            if hit > BestHit then
                BestHit = hit
                BestPos = object
                if BestHit == count - 1 then
                    break
                end
            end
        end
    end
    return BestPos, BestHit
end

local function CountObjectsNearPos(pos, radius, objects, count, valid)
    local n, o = 0, nil
    for i = 0, count - 1 do
        local object = objects[i]
        if valid(object) and pos:distSqr(object.pos) <= radius * radius then
            n = n + 1
            if not o or o.health > object.health then
                o = object
            end
        end
    end
    return n, o
end

return {
    setDelayAction = setDelayAction,
    setIntervalAction = setIntervalAction,
    calculateMagicalDamage = calculateMagicalDamage,
    calculatePhysicalDamage = calculatePhysicalDamage,
    calculateFullAADamage = calculateFullAADamage,
    isTargetValid = isTargetValid,
    isMinionValid = isMinionValid,
    isValidTarget = isTargetValid,
    isValidMinion = isMinionValid,
    isFleeing = isFleeing,
    isFleeingFromMe = isFleeingFromMe,
    getPredictedPos = getPredictedPos,
    getBuffValid = getBuffValid,
    getBuffStacks = getBuffStacks,
    getBuffStartTime = getBuffStartTime,
    getBuffEndTime = getBuffEndTime,
    isPosOnScreen = isPosOnScreen,
    getShieldedHealth = getShieldedHealth,
    getAARange = getAARange,
    getIgniteDamage = getIgniteDamage,
    getKSHealth = getKSHealth,
    getEnemyHeroes = getEnemyHeroes,
    getAllyHeroes = getAllyHeroes,
    getTotalAP = getTotalAP,
    getTotalAD = getTotalAD,
    getBonusAD = getBonusAD,
    getPhysicalReduction = getPhysicalReduction,
    getMagicalReduction = getMagicalReduction,
    getTowerMinionDamage = getTowerMinionDamage,
    
    makeGetPercentStatFunc = makeGetPercentStatFunc,
    makeObjectInRangeFunc = makeObjectInRangeFunc,

    DelayAction = setDelayAction,
    SetInterval = setIntervalAction,
    GetPercentHealth = makeGetPercentStatFunc("health"),
    GetPercentMana = makeGetPercentStatFunc("mana"),
    GetPercentPar = makeGetPercentStatFunc("par"),
    GetPercentSar = makeGetPercentStatFunc("sar"),
    GetAllyHeroesInRange = makeObjectInRangeFunc(TYPE_HERO, TEAM_ALLY),
    GetEnemyHeroesInRange = makeObjectInRangeFunc(TYPE_HERO, TEAM_ENEMY),
    GetAllyMinionsInRange = makeObjectInRangeFunc(TYPE_MINION, TEAM_ALLY),
    GetEnemyMinionsInRange = makeObjectInRangeFunc(TYPE_MINION, TEAM_ENEMY),
    GetMinionsInRange = makeObjectInRangeFunc(TYPE_MINION),
    CheckBuff = getBuffValid,
    CheckBuffType = getBuffValid,
    StartTime = getBuffStartTime,
    EndTime = getBuffEndTime,
    CountBuff = getBuffStacks,
    GetShieldedHealth = getShieldedHealth,
    CalculateMagicDamage = calculateMagicalDamage,
    CalculatePhysicalDamage = calculatePhysicalDamage,
    CalculateAADamage = calculatePhysicalDamage,
    CalculateFullAADamage = calculateFullAADamage,
    GetAARange = getAARange,
    GetPredictedPos = getPredictedPos,
    GetIgniteDamage = getIgniteDamage,
    IsValidTarget = isTargetValid,
    GetEnemyHeroes = getEnemyHeroes,
    GetAllyHeroes = getAllyHeroes,
    GetTotalAP = getTotalAP,
    GetTotalAD = getTotalAD,
    GetBonusAD = getBonusAD,
    PhysicalReduction = getPhysicalReduction,
    MagicalReduction = getMagicalReduction,
    MagicReduction = getMagicalReduction,
    
    GetLineFarmPosition = GetLineFarmPosition,
    CountObjectsNearPos = CountObjectsNearPos,
    VectorPointProjectionOnLineSegment = VectorPointProjectionOnLineSegment,
    VectorIntersection = VectorIntersection,

}