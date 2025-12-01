local names = {
  Aatrox = 'Beasty Aatrox ®',
  Cassiopeia = 'Beasty Cassiopeia ®',
  Ezreal = 'Beasty Ezreal ®',
  Irelia = 'Beasty Irelia ®',
  Jinx = 'Beasty Jinx ®',
  Lillia = 'Beasty Lillia ®',
  KogMaw = 'Beasty KogMaw ®',
  Samira = 'Beasty Samira ®',
  Swain = 'Beasty Swain ®',
  Syndra = 'Beasty Syndra ®',
  Vayne = 'Beasty Vayne ®',
  Velkoz = 'Beasty Velkoz ®',
  Veigar = 'Beasty Veigar ®',
  Yasuo = 'Beasty Yasuo ®',
  Yone = 'Beasty Yone ®',
}

console.set_color(14)
print('Loading..')

module.load(header.id, player.charName..'/main')

print('Loading3 successful!')
console.set_color(11)
print(names[player.charName])

chat.clear()
chat.add('[HanBOT]', {color = '#fff600', bold = false, italic = false})
chat.add(' Loading..', {color = '#fff600', bold = true})
chat.print()
chat.add('[HanBOT]', {color = '#fff600', bold = false, italic = false})
chat.add(' Loading successfull!', {color = '#fff600', bold = true})
chat.print()
chat.add('[HanBOT]', {color = '#fff600', bold = false, italic = false})
chat.add(' '..names[player.charName], {color = '#c317fa', bold = true})
chat.print()