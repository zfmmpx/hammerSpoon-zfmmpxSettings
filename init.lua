hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)
hs.loadSpoon("SpeedMenu")

hs.hotkey.bind({"alt"}, "R", function() hs.reload()  end)

function layoutU()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    local f = win:frame() -- 获得当前窗口的 h w x y
    local screen = win:screen() -- 获得当前窗口所在的屏幕
    print("jiba", screen:name())
    local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
    if (f.x == maxThis.x + maxThis.w / 2)
    then
        f.y = maxThis.y
    else
        f.x = maxThis.x
        f.y = maxThis.y
    end
    
    if (screen:name() == "MX27AQ" or screen:name() == "Color LCD")
    then
        if (f.w == math.floor(maxThis.w / 2) and f.h == math.floor(maxThis.h / 2))
        then
            f.h = maxThis.h
        elseif (f.w == math.floor(maxThis.w / 2) and f.h == maxThis.h)
        then
            f.x = maxThis.x
            f.w = maxThis.w
        else
            f.w = maxThis.w / 2
            f.h = maxThis.h / 2
        end
    elseif (screen:name() == "DELL P2414H")
    then
        f.x = maxThis.x        
        if (f.w == math.floor(maxThis.w) and f.h == math.floor(maxThis.h / 2))
        then
            f.h = maxThis.h
        else
            f.w = maxThis.w
            f.h = maxThis.h / 2
        end
    end

    outlineFocusedWindow(f)
    win:setFrame(f)
    print(f)

    return f
end

function layoutY()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    local f = win:frame() -- 获得当前窗口的 h w x y
    local screen = win:screen() -- 获得当前窗口所在的屏幕
    print("jiba", screen)
    local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
    if (f.x == maxThis.x + math.floor(maxThis.w / 3))
    then
        f.y = maxThis.y
    elseif (f.x == maxThis.x + math.ceil(maxThis.w / 3 * 2))
    then
        f.y = maxThis.y
    else
        f.x = maxThis.x
        f.y = maxThis.y
    end

    if (screen:name() == "MX27AQ" or screen:name() == "Color LCD")
    then
        if (f.w == math.floor(maxThis.w / 3) and f.h == math.floor(maxThis.h / 2))
        then
            f.h = maxThis.h
        elseif (f.w == math.floor(maxThis.w / 3) and f.h == math.floor(maxThis.h))
        then
            if (f.x == maxThis.x + math.floor(maxThis.w / 3))
            then
                f.w = f.w * 2
            elseif(f.x == maxThis.x + math.ceil(maxThis.w / 3 * 2))
            then
                f.x = maxThis.x
                f.w = f.w * 2
            else
                f.w = f.w * 2
            end
        elseif (f.w == math.floor(maxThis.w / 3 * 2) and f.h == math.floor(maxThis.h))
        then
            f.x = maxThis.x
            f.w = f.w * 2
        else
            f.w = math.floor(maxThis.w / 3)
            f.h = math.floor(maxThis.h / 2)
        end
    elseif (screen:name() == "DELL P2414H")
    then
        f.x = maxThis.x
        if (f.w == math.floor(maxThis.w / 2) and f.h == math.floor(maxThis.h / 3))
        then
            f.w = maxThis.w
        elseif (f.w == maxThis.w and f.h == math.floor(maxThis.h / 3))
        then
            f.h = f.h * 2
            print("jijibaba", f.h)
        elseif (f.w == maxThis.w and f.h == math.floor(maxThis.h / 3 * 2))
        then
            f.h = maxThis.h
        else
            f.w = maxThis.w / 2
            f.h = maxThis.h / 3
        end

    end

    print(f)
    outlineFocusedWindow(f)
    win:setFrame(f)
    print(f)

    return f
end

-- 窗口水平移动
function layoutH(toRight)
    return function()
        local win = hs.window.focusedWindow() -- 获取当前窗口
        print(win:application())
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        local screenNext = screen:next() -- 获得下一个屏幕
        local screenPrevious = screen:previous() -- 获得上一个屏幕
        local maxNext = screenNext:frame() -- 获得下一个屏幕的 h w x y
        local maxPrevious = screenPrevious:frame() -- 获得上一个屏幕的 h w x y
        local bottomThis = maxThis.y + maxThis.h
        local rightThis = maxThis.x + maxThis.w
        local bottomNext = maxNext.y + maxNext.h
        local rightNext = maxNext.x + maxNext.w
        local bottomPrevious = maxPrevious.y + maxPrevious.h
        local rightPrevious = maxPrevious.x + maxPrevious.w
        -- 向右移动
        if (toRight == 1) 
        then
            -- 1.到了右边界就转到下个屏幕
            if (f.x + f.w) == rightThis
            then
                f.x = maxNext.x
                f.y = f.y - maxThis.y + maxNext.y
                -- 2.如果窗口宽大于下一个屏幕的宽, 那么适应下一个窗口
                if f.w > maxNext.w
                then
                    f.w = maxNext.w
                end
                -- 3.如果窗口下边突出了, 靠边停靠
                if f.h > maxNext.h
                then
                elseif (f.y + f.h) > bottomNext
                then
                    f.y = maxNext.y + maxNext.h - f.h
                    f.x = maxNext.x
                    print("hahaxi", maxNext)
                    print(bottomNext)
                end
            -- 4.移动之后会超越当前screen右边界, 就靠边停靠
            elseif (f.x + f.w + f.w) >= (rightThis - 2) -- 这里把elseif改为if 删掉上面的if就行
            then
                f.x = rightThis - f.w
            else
                f.x = f.x + f.w
            end
        -- 向左移动
        elseif (toRight == 0)
        then
            -- 1.到了左边界就转到上一个屏幕
            if f.x == maxThis.x
            then
                f.x = rightPrevious - f.w
                f.y = f.y - maxThis.y + maxPrevious.y
                -- 2. 如果窗口宽大于上一个屏幕的宽, 那么适应上一个窗口
                if (f.w > maxPrevious.w) 
                then
                    f.w = maxPrevious.w
                    f.x = maxPrevious.x
                end
                -- 3.如果窗口下边突出了, 靠边停靠
                if f.h > maxPrevious.h
                then
                elseif (f.y + f.h) > bottomNext
                then
                    f.y = bottomPrevious - f.h
                end
            -- 4. 移动之后会超越当前screen左边界, 就靠边停靠
            elseif (f.x - f.w) <= (maxThis.x + 2) -- 这里吧elseif改为if 删掉上面的if就行
            then
                f.x = maxThis.x
            else
                f.x = f.x - f.w
            end
        end

        outlineFocusedWindow(f)
        win:setFrame(f)
        print(f)
    end
end

-- 窗口垂直移动
function layoutV(down)
    return function()
        local win = hs.window.focusedWindow() -- 获取当前窗口
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        local screenNext = screen:next() -- 获得下一个屏幕
        local screenPrevious = screen:previous() -- 获得上一个屏幕
        local maxNext = screenNext:frame() -- 获得下一个屏幕的 h w x y
        local maxPrevious = screenPrevious:frame() -- 获得上一个屏幕的 h w x y
        local bottomThis = maxThis.y + maxThis.h
        local rightThis = maxThis.x + maxThis.w
        local bottomNext = maxNext.y + maxNext.h
        local rightNext = maxNext.x + maxNext.w
        local bottomPrevious = maxPrevious.y + maxPrevious.h
        local rightPrevious = maxPrevious.x + maxPrevious.w
        -- 向下移动
        if (down == 1)
        then
            -- 1.到了下边界就转下个屏幕
            if (f.y + f.h) == bottomThis
            then
                f.x = f.x - maxThis.x + maxNext.x
                f.y = maxNext.y
                -- 2.如果窗口宽大于下一个屏幕的宽, 那么适应下一个窗口
                if f.w > maxNext.w
                then
                    f.w = maxNext.w
                end
                -- 3.如果窗口右边突出了, 靠边停靠
                if (f.x + f.w) > rightNext
                then
                    f.x = rightNext - f.w
                end
            -- 4.如果移动之后会超越当前screen下边界, 就靠边停靠
            elseif (f.y + f.h + f.h) >= (bottomThis - 34)
            then
                f.y = bottomThis - f.h
            else
                f.y = f.y + f.h
            end
        -- 向上移动
        elseif (down == 0)
        then
            -- 1.到了上边界就转到上一个屏幕
            if f.y == maxThis.y
            then
                f.y = bottomPrevious - f.h
                f.x = f.x - maxThis.x + maxPrevious.x
                -- 2. 如果窗口宽大于上一个屏幕的宽, 那么适应上一个窗口
                if (f.w > maxPrevious.w) 
                then
                    f.w = maxPrevious.w
                    f.x = maxPrevious.x
                end
                -- 3.如果窗口右边突出了, 靠边停靠
                if (f.x + f.w) > rightPrevious
                then
                    f.x = rightPrevious - f.w
                end

            -- 4.如果移动之后会超越当前screen上边界, 就靠边停靠
            elseif (f.y - f.h) <= (maxThis.y + 34)
            then
                f.y = maxThis.y
            else
                f.y = f.y - f.h
            end
        end

        outlineFocusedWindow(f)
        win:setFrame(f)


        
        print(f)
    end
end

hs.hotkey.bind({"shift"}, "f18", layoutY, nil, layoutY) -- fy
hs.hotkey.bind({"shift"}, "f19", layoutU, nil, layoutU) -- fu
hs.hotkey.bind({}, "F16", layoutH(0), nil, layoutH(0)) -- fh
hs.hotkey.bind({}, "F17", layoutV(1), nil, layoutV(1)) -- fj
hs.hotkey.bind({}, "F18", layoutV(0), nil, layoutV(0)) -- fk
hs.hotkey.bind({}, "F19", layoutH(1), nil, layoutH(1)) -- fl
-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
function tile(screenName, keepOrder, keepScale)
    return function()
        print(hs.window.allWindows())
        local screen = hs.screen.find(screenName)
        local frame = screen:frame()
        -- 后面两个boolean, 第一个关于次序:getWindows(),按照获得的的list进行排序,依次tile; 第二个关于是否尽量保持个窗口大小之间的比例(但是无关窗口形状,只比对面积的相对大小)
        winf_screen = hs.window.filter.new():setOverrideFilter({allowScreens = screenName})
        hs.window.tiling.tileWindows(winf_screen:getWindows(), frame, 1, keepOrder, keepScale)
        outlineFocusedWindowGetFrameFirst()
    end
end


winf_allWin = hs.window.filter.new():setDefaultFilter({}) -- 包括不可见窗口
winf_allWinNoAlfred = hs.window.filter.new():setDefaultFilter({}):rejectApp("Alfred 3") -- regular windows including hidden and minimized ones
winf_Inv = hs.window.filter.new():setDefaultFilter({visible = false}) -- 不可见窗口
winf_noInv = hs.window.filter.new() -- 可见窗口
winf_Irregular = hs.window.filter.new(false):setOverrideFilter():setFilters({["网易云音乐"] = {}, ["微信"] = {}, ["虾米音乐"] = {}, ["酷狗音乐"] = {}, ["QQ音乐"] = {}, ["Karabiner Preferences"] = {}, ["系统偏好设置"] = {}, ["计算器"] = {}, ["iTunes"] = {}})
winf_IrregularNo = hs.window.filter.new():setOverrideFilter({allowScreens = "Color LCD"}):setFilters({["网易云音乐"] = false, ["微信"] = false, ["虾米音乐"] = false, ["酷狗音乐"] = false, ["QQ音乐"] = false, ["Karabiner Preferences"] = false, ["系统偏好设置"] = false, ["计算器"] = false, ["iTunes"] = false})

winf_DELL = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "DELL P2414H"})
winf_MX27AQ = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "MX27AQ"})
winf_COLOR = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "Color LCD"})

function windowCreatedPrevious(screen)
    return function() 
        local lastWindow = screen:getWindows(hs.window.filter.sortByFocusedLast)[1]
        local length = #screen:getWindows()
        local tempNum = 1
        for i,v in ipairs(screen:getWindows(hs.window.filter.sortByCreated)) do
            if (hs.window.frontmostWindow() == v)
            then
                tempNum = i
            end
        end
        if (hs.window.focusedWindow() ~= lastWindow)
        then
            lastWindow:focus()
        elseif (tempNum > 1)
        then
            screen:getWindows(hs.window.filter.sortByCreated)[tempNum - 1]:focus() 
        else
            screen:getWindows(hs.window.filter.sortByCreated)[length]:focus() 
        end
    end
end
function windowCreatedNext(screen)                                                                                                        -- F11 在MX27AQ上选择窗口
    return function ()
        local lastWindowId = screen:getWindows(hs.window.filter.sortByFocusedLast)[1]:id()
        print("李李", lastWindowId)
        local length = #screen:getWindows()    
        local tempNum = 1
        for i,v in ipairs(screen:getWindows(hs.window.filter.sortByCreated)) do
            if (hs.window.frontmostWindow() == v)
            then
                tempNum = i
            end
        end
        if (hs.window.focusedWindow() ~= hs.window.get(lastWindowId))
        then
            hs.window.get(lastWindowId):focus()
            hs.window.get(lastWindowId):focus()
        elseif (tempNum < length)
        then
            screen:getWindows(hs.window.filter.sortByCreated)[tempNum + 1]:focus() 
        else
            screen:getWindows(hs.window.filter.sortByCreated)[1]:focus() 
        end
    end
end

hs.hotkey.bind({}, "F1", windowCreatedPrevious(winf_MX27AQ))                                                                                -- F1 在MX27AQ上选择窗口(倒着数)
hs.hotkey.bind({}, "F2", windowCreatedNext(winf_MX27AQ))                                                                                    -- F2 在MX27AQ上选择窗口
hs.hotkey.bind({}, "F3", windowCreatedNext(winf_DELL))                                                                                      -- F3 在DELL上选择窗口
hs.hotkey.bind({}, "F4", windowCreatedNext(winf_COLOR))                                                                                     -- F4 在Color LCD上选择窗口
hs.hotkey.bind({}, "F5", function()                                                                                                         -- F5 恢复当前app的所有窗口(最小化用cmd+h)
    local win = hs.window.focusedWindow()
    local app = win:application() 
    for _, window in ipairs(app:allWindows()) do
        window:unminimize()
    end
end)
hs.hotkey.bind({}, "F6",  function()                                                                                                        -- F6 恢复显示所有最小化窗口(最小化没必要)
    -- hammerspoon这个app比较特殊, 在default里面已经设置过, 现在将他设置为Hammerspoon = {},
    for _, window in ipairs(hs.window.filter.new():setDefaultFilter({visible = false}):setAppFilter("Hammerspoon", {}):getWindows()) do
    window:unminimize()
    end
end)
hs.hotkey.bind({}, "F14", function() end)                                                                                                   -- F7
hs.hotkey.bind({}, "F15", function()                                                                                                        -- F8 关于Color LCD
    for i,win in ipairs(winf_IrregularNo:getWindows()) do
        win:moveOneScreenNorth(true)
    end
    local screen = hs.screen.find("Color LCD")
    local frame = screen:frame()
    hs.window.tiling.tileWindows(winf_Irregular:getWindows(), frame, 1, false, false)
end)
hs.hotkey.bind({"alt"}, "F9", tile("Color LCD"))                                                                                                 -- F9 tile Color LCD
hs.hotkey.bind({"alt"}, "F10", tile("DELL p2414h"))                                                                                              -- F10 tile DELL
hs.hotkey.bind({"alt"}, "F11", tile("MX27AQ"))                                                                                                   -- F11 tile MX27AQ
hs.hotkey.bind({"alt"}, "F12", tile("MX27AQ", true, true))                                                                                       -- F11 tile MX27AQ





hs.hotkey.bind({"alt"}, "F16", function() 
    local windows = winf_noInv:windowsToEast(hs.window.focusedWindow(), nil, true)
    if (not hs.window.focusedWindow():focusWindowWest(winf_noInv:getWindows(), nil, true))
    then
        windows[#windows]:focus()
    end
end)
hs.hotkey.bind({"alt"}, "F17", function()
    local windows = winf_noInv:windowsToNorth(hs.window.focusedWindow(), nil, true)
    if (not hs.window.focusedWindow():focusWindowSouth(winf_noInv:getWindows(), nil, true))
    then
        windows[#windows]:focus()
    end
end)
hs.hotkey.bind({"alt"}, "F18", function() 
    local windows = winf_noInv:windowsToSouth(hs.window.focusedWindow(), nil, true)
    if (not hs.window.focusedWindow():focusWindowNorth(winf_noInv:getWindows(), nil, true))
    then
        windows[#windows]:focus()
    end
end)
hs.hotkey.bind({"alt"}, "F19", function()
    local windows = winf_noInv:windowsToWest(hs.window.focusedWindow(), nil, true)
    if (not hs.window.focusedWindow():focusWindowEast(winf_noInv:getWindows(), nil, true))
    then
        windows[#windows]:focus()
    end
end)











hs.hotkey.bind({"alt"}, "a", function()                                                                                                     -- 所有窗口
    for _, win in ipairs(winf_allWin:getWindows()) do
        print(win)
        local f = win:frame() -- 获得当前窗口的 h w x y  
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        f.x = maxThis.x
        f.y = maxThis.y
        f.w = maxThis.w / 2
        f.h = maxThis.h / 2
        win:setFrame(f)
        win:unminimize()
    end
end)
-- ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
function outlineFocusedWindow(f)
    -- Delete an existing highlight if it exists
    if WindowOutline then
        WindowOutline:delete()
        if WindowOutlineTimer then
            WindowOutlineTimer:stop()
        end
    end

    local win = hs.window.focusedWindow()
    local app = win:application()
    print("加吧" .. app:name())
    local height
    local strokeWidth
    
    local switch = {
        ["Google Chrome"] = 9,
        ["微信"] = 14,
        ["酷狗音乐"] = 10,
        ["虾米音乐"] = 13,
        ["Finder"] = 24,
        ["App Store"] = 9,
        ["系统偏好设置"] = 7,
        ["Bear"] = 12
    }
    
    local height = switch[app:name()]
    if (not height) then 
        height = 22 
    end
    if(app:name() == "Google Chrome") then height = 9 end
    if(app:name() == "微信") then height = 14 end
    
    WindowOutline = hs.drawing.rectangle(hs.geometry.point(f.x, f.y, f.w, height))

    -- WindowOutline:setFillColor({["hex"]="#d2ff00", ["alpha"]=0.5})
    WindowOutline:setFillColor({["hex"]="#28a56b", ["alpha"]=0.5})
    -- WindowOutline:setFillColor({["hex"]="#bb5656", ["alpha"]=0.5})
    WindowOutline:setStroke(false)
    WindowOutline:setFill(true)
    WindowOutline:show()

    -- Set a timer to delete the circle after 3 seconds
    -- WindowOutlineTimer = hs.timer.doAfter(0.3, function() WindowOutline:delete() end)

    -- -- reminder
    -- -- Delete an existing highlight if it exists
    -- if reminder then
    --     reminder:delete()
    --     if reminderTimer then
    --         reminderTimer:stop()
    --     end
    -- end

    -- -- Prepare a big red circle around the mouse pointer
    -- reminder = hs.drawing.rectangle(f)
    -- -- reminder:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    -- reminder:setStrokeColor({["hex"]="#ffd900", ["alpha"]=1})
    -- reminder:setFill(false)
    -- reminder:setStrokeWidth(40)
    -- reminder:show()

    -- -- Set a timer to delete the circle after 3 seconds
    -- reminderTimer = hs.timer.doAfter(0.38, function() reminder:delete() end)
end

function outlineFocusedWindowGetFrameFirst()
    local winGet = hs.window.focusedWindow() -- 获取当前窗口.
    local f = winGet:frame() -- 获得当前窗口的 h w x y
    outlineFocusedWindow(f)
end

winf_allWin:subscribe(hs.window.filter.windowFocused, outlineFocusedWindowGetFrameFirst, true)
winf_allWin:subscribe(hs.window.filter.windowMoved, outlineFocusedWindowGetFrameFirst, true)
winf_allWin:subscribe(hs.window.filter.windowMinimized, function(win, appName, event)
    -- 获得当前app的filter,不包括不可见窗口
    app_winf = hs.window.filter.new(false):setAppFilter(appName, {visible = true})

    if (#app_winf:getWindows() == 0)
    then
        winf_noInv:getWindows(hs.window.filter.sortByFocusedLast)[1]:focus()
    end
end, true)
winf_allWinNoAlfred:subscribe(hs.window.filter.windowDestroyed, function(win, appName, event)
    -- 获得当前app的filter,不包括不可见窗口
    app_winf = hs.window.filter.new(false):setAppFilter(appName, {visible = true})

    if #app_winf:getWindows() == 0 
    then
        winf_noInv:getWindows(hs.window.filter.sortByFocusedLast)[1]:focus()        
    end
end, true)

hs.alert.show("Config loaded")