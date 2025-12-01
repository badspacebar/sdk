local table = module.load("DivineLib", "table")
local bounds = {
    w = 200,
    h = 50,
    p = 10,
    fs = 24,
}
bounds.sx = graphics.width - bounds.w - bounds.p
bounds.sy = 0.25 * graphics.height - bounds.h
bounds.my = graphics.height * 0.75 + bounds.h
--[[
    notify
        .add(text, time, color, done)
            Adds a new notification
            Input:
                - text to display
                - total time of display
                - base color, optional
                - callback, optional

]]
local notify;notify = {
    __c = 0xff1f1f1f,
    __n = 0,
    __t = {},
    __bounds = bounds,
    __init = function()
        if not notify.__addedCb then
            for i, f in pairs(notify.__cb) do
                cb.add(cb[i], f)
            end
        end
    end,
    __cb = {
        draw = function()
            for i = 1, notify.__n do
                local n = notify.__t[i]
                local offsetT
                if n.__timeDiv < 0.75 then
                    offsetT = math.cos(n.__timeDiv * math.pi)
                elseif n.__timeDiv > 1.25 then
                    offsetT = math.cos((2 - n.__timeDiv) * math.pi)
                else
                    offsetT = math.cos(.75 * math.pi)
                end
                local x = bounds.sx + (bounds.w + bounds.p) * offsetT
                local y = bounds.sy + bounds.h * 0.5 + (bounds.h + bounds.p) * i
                graphics.draw_line_2D(x, y, x + bounds.w, y, bounds.h, n.__c)
                local area = graphics.text_area(n.__text, bounds.fs)
                graphics.draw_text_2D(
                        n.__text,
                        bounds.fs,
                        x + bounds.w * .5 - area * .5,
                        y,
                        0xffffffff)
            end
        end,
        tick = function()
            local time, remove, removed = game.time, {}, 0
            for i = 1, notify.__n do
                local n = notify.__t[i]
                if game.time - n.__startTime > n.__totalTime then
                    remove[#remove + 1] = i
                    if n.__done then
                        n.__done()
                    end
                else
                    n.__timeDiv = 2 * (time - n.__startTime) / n.__totalTime
                end
            end
            for i = 1, #remove do
                table.remove(notify.__t, remove[i] - removed)
                removed = removed + 1
            end
            notify.__n = #notify.__t
        end
    },
    add = function(text, time, color, done)
        notify.__init()
        notify.__n = notify.__n + 1
        notify.__t[notify.__n] = {
            __text = text,
            __timeDiv = 0,
            __startTime = game.time,
            __totalTime = time or 3,
            __done = done,
            __c = color or notify.__c
        }
    end
}return notify