local KEY_DOWN = 0
local KEY_UP = 1
local MOUSE_HOLD = 2 

local simulate_event_example = function()
  local next_event = 0
  cb.add(cb.tick, function()
    if os.clock() > next_event then
      local input = event.input(cursorPos.x, cursorPos.y, KEY_DOWN)
      event.simulate('evtPlayerMoveClick_MouseTriggered', input)
      next_event = os.clock() + 0.2
    end
  end)
end

local hook_event_example = function()
  event.set_hook('evtCastSpell2', function(input)
    print(os.clock(), 'evtCastSpell2', input.x, input.y, input.state)
  end)
end

local block_event_example = function()
  event.set_hook('evtCastSpell2', function(input)
    input.state = KEY_UP
    print('block evtCastSpell2')
  end)
end

local redirect_event_example = function()
  event.set_hook('evtPlayerMoveClick_MouseTriggered', function(input)
    input.x = 0
    input.y = 0
    print('redirect evtPlayerMoveClick_MouseTriggered')
  end)
end

--not recommended in release versions
local hook_all_events_example = function()
  for name, _ in pairs(event.list) do
    if name ~= 'evtGameMouseMove' then --filter spam
      event.set_hook(name, function(input)
        print(os.clock(), name, input.x, input.y, input.state, input.key)
      end)
    end
  end
end

local print_events = function()
  local str = ''
  for name, _ in pairs(event.list) do
    if #str + #name > 1000 then
      print(str)
      str = ''
    end
    str = str .. name ..'\n'
  end
  print(str)
end

print_events()
simulate_event_example()
--hook_event_example()
--block_event_example()
--redirect_event_example()
--hook_all_events_example()