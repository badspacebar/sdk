local menu = menu('menu_example', 'Menu Example 1.0')

menu:header('header_test', 'This is a header')
menu:boolean('boolean_test', 'This is a boolean', true)
menu:keybind('keybind_test', 'This is a keybind', 'V', nil)
menu:header('header_test2', 'Another header')
menu:slider('slider_test', 'This is a slider', 300, 0, 500, 1)
menu:color('color_test', 'Choose a color', 255, 255, 0, 155)

return menu