local menu = menu('beasty_syndra', 'Beasty Syndra')
local spells = module.load(header.id, 'Syndra/spells')

menu:header('header_keys', 'Combat')
menu:keybind('combat', 'Combat Key', 'Space', nil)
menu:keybind('q_e', 'Q to E (Out Of Q Range)', 'C', nil)
menu:keybind('r', 'R Toggle Key', nil, 'Z')


local slot = {'Q','W','E','R'}
for i = 0, objManager.enemies_n - 1 do
  local obj = objManager.enemies[i]
  local charName = obj.charName
  if spells[charName] then
    menu:header('header_e', 'Auto E')
    menu:menu(charName, charName)
    for j, name in pairs(spells[charName]) do
      menu[charName]:menu(j, type(name) == 'string' and name or slot[j+1])
      local m = menu[charName][j]
      m:boolean('enabled', 'Enable', true)
      m:boolean('combat_mode', 'Use only in Combat Mode', false)
    end
  end
end

menu:header('header_r', 'R')
menu:boolean('combat_r', 'Auto R in Combat mode only', false)
menu:menu('r_whitelist', 'Whitelist')
for i=0, objManager.enemies_n-1 do
  local charName = objManager.enemies[i].charName
  menu.r_whitelist:boolean(charName, charName, true)
end

menu:header('header_farm', 'Harass/Farm')
menu:menu('clear', 'Clear')
menu.clear:keybind('key', 'Clear Key', 'V', nil)
menu.clear:boolean('q', 'Use Q', false)
menu:menu('lasthit', 'Lasthit')
menu.lasthit:keybind('key', 'Lasthit Key', 'X', nil)
menu.lasthit:boolean('q', 'Use Q', false)
menu:menu('harass', 'Harass')
menu.harass:boolean('q', 'Use Q', true)
menu.harass:boolean('w', 'Use W', true)
menu.harass:keybind('auto_q', 'Auto Q', nil, 'Y')
menu.harass:keybind('key', 'Harass Key', 'X', nil)

menu:header('drawings', 'Drawing')
menu:menu('pentagon', 'Pentagram')
menu.pentagon:boolean('pent_enable', 'Draw Pentagram', true)
menu.pentagon:color('pent1', 'Inner color', 218, 112, 214, 255)
menu.pentagon:color('pent2', 'Outer color', 147, 112, 219, 255)

menu:menu('range', 'Spell Range')
menu.range:boolean('q', 'Draw Q range', true)
menu.range:boolean('q_e', 'Draw E into Q range', true)
menu.range:boolean('r', 'Draw R range', false)
menu.range:color('c', 'Color', 255, 89, 14, 103)

return menu