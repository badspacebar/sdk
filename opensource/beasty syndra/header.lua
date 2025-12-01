local AIO = {
  -- Aatrox = true,
  -- Cassiopeia = true,
  -- Ezreal = true,
  -- Irelia = true,
  -- Jinx = true,
  -- Lillia = true,
  -- KogMaw = true,
  -- Samira = true,
  -- Swain = true,
  Syndra = true,
  -- Vayne = true,
  -- Velkoz = true,
  -- Veigar = true,
  -- Yone = true,
  -- Yasuo = true,
}

return {
  name = 'Beasty '..(player and player.charName or ''),
  id = 'beasty_syndra',
  riot = true,
  hprotect = true,
  flag = {
    text = "Beasty",
    color = {
      text = 0xFF11EEEE ,
      background1 = 0xFF11EEEE,
      background2 = 0xFF000000,    
    },
  },
  load = function()
    return AIO[player.charName]
  end,

  shard = {
    'main',

    --draw
    'draw/chat',
    'draw/circle',
    'draw/color',
    'draw/info',
    'draw/stacks',
    'draw/text',
    'draw/timer',

    --Syndra
    'Syndra/auto_e',
    'Syndra/core',
    'Syndra/dmg',
    'Syndra/e_on_q',
    'Syndra/e_on_tar',
    'Syndra/main',
    'Syndra/menu',
    'Syndra/q',
    'Syndra/q_e',
    'Syndra/r',
    'Syndra/spells',
    'Syndra/sphere_manager',
    'Syndra/w',
    'Syndra/w_cast',

  },

  resources = {
    -- 'stacks_sprite.png',
    -- 'timer_sprite.png',
  },
 
  author = 'Beasty',

  telegram_url = 'https://t.me/joinchat/I2UCckjpXDTxpFEOLmwbuA',

  shard_url = 'https://raw.githubusercontent.com/stressimasu/beasty/master/hanbot_beasty.shard',

  icon_url = 'https://i.imgur.com/kq0Ana3.jpg',

  description = [[
Supported Scripts
[CLICK FOR DETAILS]

++++++++++++++
  + Aatrox
  + Cassiopeia
  + Ezreal
  + Irelia
  + Jinx
  + Lillia
  + KogMaw
  + Samira
  + Swain
  + Syndra
  + Vayne
  + Veigar
  + Velkoz
  + Yasuo
  + Yone
++++++++++++++

t.me/hanbot3_beasty
]],
  
  description_cn = [[]],
}