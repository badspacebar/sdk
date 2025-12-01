local spells = {
  Hecarim = {[46] = 'E Attack'},
  JarvanIV = {[3] = true},
  Alistar = {[1] = true},
  Pantheon = {[1] = true},
  Fizz = {[0] = true},
  Diana = {[2] = true},
  Irelia = {[0] = true},
  Jax = {[0] = true},
  XinZhao = {[2] = true},
  Poppy = {[2] = true},
  MonkeyKing = {[2] = true},
  Qiyana = {[2] = true},
  Yasuo = {[2] = true},
  Warwick = {[0] = true},
  Galio = {[2] = function(startpos, endpos, k)
    if startpos:distSqr(player.pos) < 650*650 then
      local pos = startpos:lerp(endpos, 650/endpos:dist(startpos))
      if pos:distSqr(player.pos) < k then
        return true
      end
    end
  end},
  Ornn = {[2] = function(startpos, endpos, k)
    local pos = startpos:lerp(endpos, 900/endpos:dist(startpos))
    if pos:distSqr(player.pos) < k then
      return true
    end
  end},
  Khazix = {[2] = function(startpos, endpos, k)
    local pos = startpos:lerp(endpos, 866/endpos:dist(startpos))
    if pos:distSqr(player.pos) < k then
      return true
    end
  end},
  Gragas = {[2] = function(startpos, endpos, k)
    local pos = startpos:lerp(endpos, 866/endpos:dist(startpos))
    if pos:distSqr(player.pos) < k then
      return true
    end
  end},
  Shen = {[2] = function(startpos, endpos, k)
    local pos = startpos:lerp(endpos, 626/endpos:dist(startpos))
    if pos:distSqr(player.pos) < k then
      return true
    end
  end},
  Tryndamere = {[2] = function(startpos, endpos, k)
    local pos = startpos:lerp(endpos, 656/endpos:dist(startpos))
    if pos:distSqr(player.pos) < k then
      return true
    end
  end},
}

return spells