local menu = menu('gagong_riven', 'Gagong Riven')

menu:header('header_push', 'Panic clear')
menu:boolean('push_w', 'Use W', true)
menu:boolean('push_e', 'Use E', true)
menu:keybind('push', 'Panic clear key', 'V', nil)

--menu:header('header_harass', 'Harass')
--menu:dropdown('harass_mode', 'Retreat Spell', 1, {'Q', 'E'})
--menu:keybind('harass', 'Harass Key', 'T', nil)

--menu:header('header_misc', 'Misc')
--menu:boolean('cancel_q', 'Cancel Qs issued by yourself', true)

menu:header('header_flash', 'Flash combo')
menu:boolean('flash', 'Use flash combo on selected target', true)
menu:boolean('reset_ts', 'Reset selected target after flash', true)
menu:boolean('flash_only_r', 'Use flash only for r1/r2 combos', false)
menu:slider('r2_flash', 'Flash after r2 missiles weight', 100, 0, 100, 1)

menu:header('header_gap', 'Closing the first gap')
menu:boolean('gap_e_w', 'E[+?]->[?[+W]]', true)
menu:boolean('gap_e_q', 'E[+?]->[?[+Q]]', true)
menu:boolean('gap_e_aa', 'E[+?]->[AA]', true)
menu:boolean('gap_q', 'Q->[?]', true)
menu:header('header_combat', 'Combat')
--menu:boolean('auto_cancel', 'Silently cancel manual Q', true)
--menu:menu('e_gapclose', 'Initial Gapclose')
--menu.e_gapclose:boolean('e_w', 'Use E->W[+Q]', true)
--menu.e_gapclose:boolean('e_q', 'Use E->Q', true)
--menu.e_gapclose:boolean('e_aa', 'Use E->AA', true)
--menu.e_gapclose:boolean('q_aa', 'Use Q->AA', true)
menu:slider('e_double_cast_weight', 'Close combat double cast weight', 100, 0, 100, 1)
menu:keybind('e_aa', 'Consider E[+?]->[AA->[?]]', nil, 'T')
menu:keybind('r1', 'Use R1 in next combo', nil, 'C')
menu:keybind('combat', 'Combat key', 'Space', nil)

return menu