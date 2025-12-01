local champs = {
  Leblanc = true,
  Akali = true,
  Rengar = true,
  Qiyana = true,
  Talon = true,
}

return { 
  id = "AssassinAIO", 
  name = "Assassin's AIO - " .. player.charName, 
  type = "Champion",
  load = function()
    return champs[player.charName]
  end,
  shard = {
    "main",
    "common",
    "menu",
    
    "Leblanc",
    "Akali",
    "Rengar",
    "Qiyana",
    "Talon",
  }
}