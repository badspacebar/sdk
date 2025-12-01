return {
  id = 'gagong_riven',
  name = 'Gagong Riven',
  type = 'Champion',
  load = function()
    return player.charName == 'Riven'
  end,
}