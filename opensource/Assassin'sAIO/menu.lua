local champmenu = {}

if player.charName == "Akali" then
    champmenu.akalimenu = menu("AssassinAIO", "Assassin - ".. player.charName);
    --Combo
    champmenu.akalimenu:menu("Combo", "Combo");
    champmenu.akalimenu.Combo:keybind("keyflash", "Use Flash In Burts", "T", nil);
    champmenu.akalimenu.Combo:boolean("flash", "Use Flash In Combo", false);
    champmenu.akalimenu.Combo:header('comboq', 'Five Point Strike - Q');
    champmenu.akalimenu.Combo:boolean("cq", "Use Q", true);
    champmenu.akalimenu.Combo:header('combow', 'Twilight Shroud - W');
    champmenu.akalimenu.Combo:boolean("cw", "Use W", true);
    champmenu.akalimenu.Combo:header('comboe', 'Shuriken Flip - E');
    champmenu.akalimenu.Combo:boolean("ce", "Use E", true);
    champmenu.akalimenu.Combo:boolean("ce2", "Use E2", true);
    champmenu.akalimenu.Combo:header('combor', 'Perfect Execution - R');
    champmenu.akalimenu.Combo:boolean("cr", "Use R", true);
    champmenu.akalimenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Harass
    champmenu.akalimenu:menu("Harass", "Harass");
    champmenu.akalimenu.Harass:keybind("barharass", "Harass", "C", nil)
    champmenu.akalimenu.Harass:header('harassq', 'Five Point Strike - Q');
    champmenu.akalimenu.Harass:boolean("haraq", "Use Q", true);
    champmenu.akalimenu.Harass:header('harassw', 'Twilight Shroud - W');
    champmenu.akalimenu.Harass:boolean("haraw", "Use W", false);
    champmenu.akalimenu.Harass:header('harasse', 'Shuriken Flip - E');
    champmenu.akalimenu.Harass:boolean("harae", "Use E", false);
    --Lane
    champmenu.akalimenu:menu("Cleading", "Clear/Jungler");
    champmenu.akalimenu.Cleading:keybind("keyclear", "LaneClear", "V", nil);
    champmenu.akalimenu.Cleading:header('laeq', 'Five Point Strike - Q');
    champmenu.akalimenu.Cleading:boolean("laneq", "Use Q", true);
    champmenu.akalimenu.Cleading:boolean("onlylast", "Use Q Only LastHit", true);
    --Misc
    champmenu.akalimenu:menu("Miscing", "Misc");
    champmenu.akalimenu.Miscing:boolean("autc", "Auto Combo", false);
    champmenu.akalimenu.Miscing:header('miscr', 'Five Point Strike - R');
    champmenu.akalimenu.Miscing:boolean("intrreupt", "Use R for Interrupt Spells", true);
    --Drawissssssss
    champmenu.akalimenu:menu("dirw", "Drawings Spells");
    champmenu.akalimenu.dirw:header('dqq', 'Five Point Strike - Q');
    champmenu.akalimenu.dirw:boolean("dq", "Use Q Drawing", true);
    champmenu.akalimenu.dirw:header('dww', 'Twilight Shroud - W');
    champmenu.akalimenu.dirw:boolean("dw", "Use W Drawing", false);
    champmenu.akalimenu.dirw:header('dee', 'Shuriken Flip - E');
    champmenu.akalimenu.dirw:boolean("de", "Use E Drawing", false);
    champmenu.akalimenu.dirw:header('drr', 'Perfect Execution - R');
    champmenu.akalimenu.dirw:boolean("dr", "Use R Drawing", false);
end
if player.charName == "Katarina" then
    champmenu.katarinamenu = menu("AssassinAIO", "Assassin - ".. player.charName);
    champmenu.katarinamenu:menu("Combo", "Combo");
    champmenu.katarinamenu.Combo:keybind("toggleTF", "Settings E", "T", nil)
    champmenu.katarinamenu.Combo.toggleTF:set('callback', function(var) 

        if champmenu.katarinamenu.Combo.use:get() == 1 and var then
            champmenu.katarinamenu.Combo.use:set("value", 2)
            return
        end
        if champmenu.katarinamenu.Combo.use:get() == 2 and var then
            champmenu.katarinamenu.Combo.use:set("value", 1)
            return
        end
    end)
    champmenu.katarinamenu.Combo:dropdown('use', 'Setting -> E Combo', 1, { "Only E: Dagger", "Only E: Target"})
    champmenu.katarinamenu.Combo:header('comboq', 'Bouncing Blade - Q');
    champmenu.katarinamenu.Combo:boolean("cq", "Use Q", true);
    champmenu.katarinamenu.Combo:header('combow', 'Preparation - W');
    champmenu.katarinamenu.Combo:boolean("cw", "Use W", true);
    champmenu.katarinamenu.Combo:header('comboe', 'Shunpo - E');
    champmenu.katarinamenu.Combo:boolean("ce", "Use W", true);
    champmenu.katarinamenu.Combo:header('combor', 'Death Lotus - R');
    champmenu.katarinamenu.Combo:boolean("cr", "Use R", true);
    champmenu.katarinamenu.Combo:boolean("cancelR", "Cancel R?", true);
    champmenu.katarinamenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Harass
    champmenu.katarinamenu:menu("Harass", "Harass");
    champmenu.katarinamenu.Harass:keybind("barharass", "Harass", "C", nil)
    champmenu.katarinamenu.Harass:header('harassq', 'Bouncing Blade - Q');
    champmenu.katarinamenu.Harass:boolean("haraq", "Use Q", true);
    champmenu.katarinamenu.Harass:header('harassw', 'Preparation - W');
    champmenu.katarinamenu.Harass:boolean("haraw", "Use W", true);
    champmenu.katarinamenu.Harass:header('harae', 'Shunpo - E');
    champmenu.katarinamenu.Harass:boolean("harae", "Use E", true);
    --Lane
    champmenu.katarinamenu:menu("Cleading", "Clear/Jungler");
    champmenu.katarinamenu.Cleading:keybind("keyclear", "LaneClear", "V", nil);
    champmenu.katarinamenu.Cleading:header('laeq', 'Bouncing Blade - Q');
    champmenu.katarinamenu.Cleading:boolean("laneq", "Use Q", true);
    champmenu.katarinamenu.Cleading:header('law', 'Preparation - W');
    champmenu.katarinamenu.Cleading:boolean("lanew", "Use W", true);
    champmenu.katarinamenu.Cleading:header('lwewa', 'Shunpo - E');
    champmenu.katarinamenu.Cleading:boolean("lanee", "Use E", true);
    --Misc
    champmenu.katarinamenu:menu("Miscing", "Misc");
    champmenu.katarinamenu.Miscing:boolean("autc", "Auto Preparation", false);
    champmenu.katarinamenu.Miscing:header('miscr', 'Shunpo - E');
    champmenu.katarinamenu.Miscing:boolean("eturrent", "Don't Use E UnderTurret", true);
    --Draws
    champmenu.katarinamenu:menu("dirw", "Drawings Spells");
    champmenu.katarinamenu.dirw:header('dwq', 'Bouncing Blade - Q');
    champmenu.katarinamenu.dirw:boolean("dq", "Use Q Drawing", true);
    champmenu.katarinamenu.dirw:header('dwe', 'Preparation - E');
    champmenu.katarinamenu.dirw:boolean("de", "Use E Drawing", true);
    champmenu.katarinamenu.dirw:header('dwr', 'Shunpo - R');
    champmenu.katarinamenu.dirw:boolean("dr", "Use R Drawing", true);
end
if player.charName == "Talon" then
    champmenu.talonmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
    champmenu.talonmenu:menu("Combo", "Combo");
    champmenu.talonmenu.Combo:header('comboq', 'Noxian Diplomacy - Q');
    champmenu.talonmenu.Combo:boolean("cq", "Use Q", true);
    champmenu.talonmenu.Combo:header('combow', 'Rake - W');
    champmenu.talonmenu.Combo:boolean("cw", "Use W", true);
    champmenu.talonmenu.Combo:header('combor', 'Shadow Assault - R');
    champmenu.talonmenu.Combo:boolean("fire", "Use Dont In Combo", true);
    champmenu.talonmenu.Combo:boolean("cr", "Use R", true);
    champmenu.talonmenu.Combo:boolean("attack", "Use R and not Atacck", true);
    champmenu.talonmenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Harass
    champmenu.talonmenu:menu("Harass", "Harass");
    champmenu.talonmenu.Harass:keybind("barharass", "Harass", "C", nil)
    champmenu.talonmenu.Harass:header('harassq', 'Noxian Diplomacy - Q');
    champmenu.talonmenu.Harass:boolean("haraq", "Use Q", true);
    champmenu.talonmenu.Harass:header('harassw', 'Rake - W');
    champmenu.talonmenu.Harass:boolean("haraw", "Use W", true);
    --Lane
    champmenu.talonmenu:menu("Cleading", "Clear/Jungler");
    champmenu.talonmenu.Cleading:keybind("keyclear", "LaneClear", "V", nil);
    champmenu.talonmenu.Cleading:header('laeq', 'Noxian Diplomacy - Q');
    champmenu.talonmenu.Cleading:boolean("laneq", "Use Q", true);
    champmenu.talonmenu.Cleading:header('law', 'Rake - W');
    champmenu.talonmenu.Cleading:boolean("lanew", "Use W", true);
    champmenu.talonmenu.Cleading:header('manawq', 'Mana Champion');
    champmenu.talonmenu.Cleading:slider("maxPar", "Checking Mana > %", 60, 1, 100, 1)
    --Draws
    champmenu.talonmenu:menu("dirw", "Drawings Spells");
    champmenu.talonmenu.dirw:header('dqq', 'Noxian Diplomacy - Q');
    champmenu.talonmenu.dirw:boolean("dq", "Use Q Drawing", true);
    champmenu.talonmenu.dirw:header('dww', 'Rake - W');
    champmenu.talonmenu.dirw:boolean("dw", "Use W Drawing", false);
    champmenu.talonmenu.dirw:header('dee', 'Assassin Path - E');
    champmenu.talonmenu.dirw:boolean("de", "Use E Drawing", false);
    champmenu.talonmenu.dirw:header('drr', 'Shadow Assault - R');
    champmenu.talonmenu.dirw:boolean("dr", "Use R Drawing", false);
end
if player.charName == "Leblanc" then
    champmenu.leblancmenu= menu("AssassinAIO", "Assassin - ".. player.charName);
    champmenu.leblancmenu:menu("Combo", "Combo");
    champmenu.leblancmenu.Combo:keybind("toggleTF", "Burts - TF", "T", nil)
    champmenu.leblancmenu.Combo:header('comboq', 'Sigil of Malice - Q');
    champmenu.leblancmenu.Combo:boolean("cq", "Use Q", true);
    champmenu.leblancmenu.Combo:header('combow', 'Distortion - W');
    champmenu.leblancmenu.Combo:boolean("cw", "Use W", true);
    champmenu.leblancmenu.Combo:header('combow', 'Ethereal Chains - E');
    champmenu.leblancmenu.Combo:boolean("ce", "Use E", true);
    champmenu.leblancmenu.Combo:header('combor', 'Mimic - R');
    champmenu.leblancmenu.Combo:boolean("cr", "Use R", true);
    champmenu.leblancmenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Harass
    champmenu.leblancmenu:menu("Harass", "Harass");
    champmenu.leblancmenu.Harass:keybind("barharass", "Harass", "C", nil)
    champmenu.leblancmenu.Harass:header('harassq', 'Sigil of Malice - Q');
    champmenu.leblancmenu.Harass:boolean("haraq", "Use Q", true);
    champmenu.leblancmenu.Harass:header('harassw', 'Distortion - W');
    champmenu.leblancmenu.Harass:boolean("haraw", "Use W", true);
    champmenu.leblancmenu.Harass:header('combow', 'Ethereal Chains - E');
    champmenu.leblancmenu.Harass:boolean("harasse", "Use E", true);
    --Misc
    champmenu.leblancmenu:menu("Miscing", "Misc");
    champmenu.leblancmenu.Miscing:boolean("smartkill", "Use Smart Kill", true);
    champmenu.leblancmenu.Miscing:header('miscr', 'Distortion- W');
    champmenu.leblancmenu.Miscing:boolean("returnw", "Returned - W", true);
    --Draws
    champmenu.leblancmenu:menu("dirw", "Drawings Spells");
    champmenu.leblancmenu.dirw:header('dqq', 'Sigil of Malice - Q');
    champmenu.leblancmenu.dirw:boolean("dq", "Use Q Drawing", true);
    champmenu.leblancmenu.dirw:header('dww', 'Distortion - W');
    champmenu.leblancmenu.dirw:boolean("dw", "Use W Drawing", false);
    champmenu.leblancmenu.dirw:header('dee', 'Ethereal Chains - E');
    champmenu.leblancmenu.dirw:boolean("de", "Use E Drawing", false);
    champmenu.leblancmenu.dirw:header('drr', 'Mimic - R');
    champmenu.leblancmenu.dirw:boolean("dr", "Use R Drawing", false);
end
if player.charName == "Ekko" then
    champmenu.ekkomenu = menu("AssassinAIO", "Assassin - ".. player.charName);
end
if player.charName == "Kassadin" then
    champmenu.kassadinmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
end
if player.charName == "Khazix" then
    champmenu.kahzixmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
end
if player.charName == "Rengar" then
    champmenu.rengarmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
    champmenu.rengarmenu:menu("Combo", "Combo");
    champmenu.rengarmenu.Combo:keybind("toggleTF", "Burts", "T", nil)
    champmenu.rengarmenu.Combo.toggleTF:set('callback', function(var) 

        if champmenu.rengarmenu.Combo.use:get() == 1 and var then
            champmenu.rengarmenu.Combo.use:set("value", 2)
            return
        end
        if champmenu.rengarmenu.Combo.use:get() == 2 and var then
            champmenu.rengarmenu.Combo.use:set("value", 1)
            return
        end
    end)
    champmenu.rengarmenu.Combo:dropdown('use', 'Use Burts Combo', 1, { "Disabled", "Burts: On"})
    champmenu.rengarmenu.Combo:header('comboq', 'Savagery - Q');
    champmenu.rengarmenu.Combo:boolean("cq", "Use Q", true);
    champmenu.rengarmenu.Combo:header('combow', 'Battle Roar - W');
    champmenu.rengarmenu.Combo:boolean("cw", "Use W", true);
    champmenu.rengarmenu.Combo:header('comboe', 'Bola Strike - E');
    champmenu.rengarmenu.Combo:boolean("ce", "Use W", true);
    champmenu.rengarmenu.Combo:header('combor', 'Thrill of the Hunt - R');
    champmenu.rengarmenu.Combo:boolean("cr", "Use R", true);
    champmenu.rengarmenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Harass
    champmenu.rengarmenu:menu("Harass", "Harass");
    champmenu.rengarmenu.Harass:keybind("barharass", "Harass", "C", nil)
    champmenu.rengarmenu.Harass:header('harassq', 'Savagery - Q');
    champmenu.rengarmenu.Harass:boolean("haraq", "Use Q", true);
    champmenu.rengarmenu.Harass:header('harassw', 'Battle Roar - W');
    champmenu.rengarmenu.Harass:boolean("haraw", "Use W", true);
    champmenu.rengarmenu.Harass:header('harae', 'Bola Strike - E');
    champmenu.rengarmenu.Harass:boolean("harae", "Use E", true);
    --Lane
    champmenu.rengarmenu:menu("Cleading", "Clear/Jungler");
    champmenu.rengarmenu.Cleading:keybind("keyclear", "LaneClear", "V", nil);
    champmenu.rengarmenu.Cleading:header('laeq', 'Savagery - Q');
    champmenu.rengarmenu.Cleading:boolean("laneq", "Use Q", true);
    champmenu.rengarmenu.Cleading:header('law', 'Battle Roar - W');
    champmenu.rengarmenu.Cleading:boolean("lanew", "Use W", true);
    champmenu.rengarmenu.Cleading:header('lwewa', 'Bola Strike - E');
    champmenu.rengarmenu.Cleading:boolean("lanee", "Use E", true);
    --Misc
    champmenu.rengarmenu:menu("Miscing", "Misc");
    champmenu.rengarmenu.Miscing:boolean("autc", "Auto W", false);
    champmenu.rengarmenu.Miscing:header('miscr', 'Bola Strike - E');
    champmenu.rengarmenu.Miscing:boolean("intrreupt", "Use E for Interrupt Spells", true);
    --Draws
    champmenu.rengarmenu:menu("dirw", "Drawings Spells");
    champmenu.rengarmenu.dirw:header('dww', 'Battle Roar - W');
    champmenu.rengarmenu.dirw:boolean("dw", "Use W Drawing", true);
    champmenu.rengarmenu.dirw:header('dee', 'Bola Strike - E');
    champmenu.rengarmenu.dirw:boolean("de", "Use E Drawing", true);
end
if player.charName == "Evelynn" then
    champmenu.evellynmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
end
if player.charName == "Qiyana" then
    champmenu.qiyananmenu = menu("AssassinAIO", "Assassin - ".. player.charName);
    --Primority
    champmenu.qiyananmenu:menu("Combo", "Settings Qiyana");
    champmenu.qiyananmenu.Combo:keybind("toggleTF", "Settings Primority", "T", nil)
    champmenu.qiyananmenu.Combo.toggleTF:set('callback', function(var) 

        if champmenu.qiyananmenu.Combo.use:get() == 1 and var then
            champmenu.qiyananmenu.Combo.use:set("value", 2)
            return
        end
        if champmenu.qiyananmenu.Combo.use:get() == 2 and var then
            champmenu.qiyananmenu.Combo.use:set("value", 3)
            return
        end
        if champmenu.qiyananmenu.Combo.use:get() == 3 and var then
            champmenu.qiyananmenu.Combo.use:set("value", 1)
            return
        end
    end)
    champmenu.qiyananmenu.Combo:dropdown('use', 'Use Primority Combo', 1, { "Primority: BRUSH", "Primority: RIVER", "Primority: TERRAIN"})

    champmenu.qiyananmenu.Combo:header('comboq', 'Edge of Ixtal	- Q');
    champmenu.qiyananmenu.Combo:boolean("cq", "Use Q", true);
    champmenu.qiyananmenu.Combo:menu('cqm', 'Settigns Edge - Q');
    champmenu.qiyananmenu.Combo.cqm:header('cbrush', 'Brush - Q');
    champmenu.qiyananmenu.Combo.cqm:boolean("cqbs", "Use Q Brush", true);
    champmenu.qiyananmenu.Combo.cqm:boolean("cqgap", "Use Q Brush for Gapclose", true);
    champmenu.qiyananmenu.Combo.cqm:header('cqri', 'River - Q');
    champmenu.qiyananmenu.Combo.cqm:boolean("cqr", "Use Q River", true);
    champmenu.qiyananmenu.Combo.cqm:boolean("cqgap", "Use Q River for Interrupt Spells", true);
    champmenu.qiyananmenu.Combo.cqm:header('cqte', 'Terrain - Q');
    champmenu.qiyananmenu.Combo.cqm:boolean("cqr", "Use Q Terrain", true);
    champmenu.qiyananmenu.Combo.cqm:boolean("cqgap", "Use Q River for Gapclose", true);

    champmenu.qiyananmenu.Combo:header('combow', 'Terrashape - W');
    champmenu.qiyananmenu.Combo:boolean("cw", "Use W", true);

    champmenu.qiyananmenu.Combo:header('comboe', 'Audacity - E');
    champmenu.qiyananmenu.Combo:boolean("ce", "Use E", true);
    --champmenu.qiyananmenu.Combo:boolean("cegap", "Use E for Interrupt Spells", true);

    champmenu.qiyananmenu.Combo:header('combor', 'Supreme Display of Talent - R');
    champmenu.qiyananmenu.Combo:boolean("cr", "Use R", true);
    champmenu.qiyananmenu.Combo:dropdown("rusage", "R Usage", 1, {"Always", "Only if Killable", "Never"})
    champmenu.qiyananmenu.Combo:header('comboke', 'Keys');
    champmenu.qiyananmenu.Combo:keybind("stogglebar", "Space ^- Combo", "Space", nil)
    --Draws
    champmenu.qiyananmenu:menu("dirw", "Drawings Spells");
    champmenu.qiyananmenu.dirw:header('dww', 'Edge of Ixtal - Q');
    champmenu.qiyananmenu.dirw:boolean("dq", "Use Q Drawing", true);
    champmenu.qiyananmenu.dirw:header('dee', 'Terrashape - W');
    champmenu.qiyananmenu.dirw:boolean("dw", "Use W Drawing", true);
    champmenu.qiyananmenu.dirw:header('dee', 'Audacity - E');
    champmenu.qiyananmenu.dirw:boolean("de", "Use E Drawing", true);
    champmenu.qiyananmenu.dirw:header('dere', 'Supreme Display of Talent - R');
    champmenu.qiyananmenu.dirw:boolean("dr", "Use R Drawing", true);
end

return champmenu