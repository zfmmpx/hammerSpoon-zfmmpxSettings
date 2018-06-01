hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)
hs.loadSpoon("SpeedMenu")

-- focus窗口的时候关注条的宽度
switchAppSettings = {
    ["Google Chrome"] = 9,
    ["微信"] = 14,
    ["酷狗音乐"] = 10,
    ["虾米音乐"] = 13,
    ["Finder"] = 24,
    ["App Store"] = 9,
    ["系统偏好设置"] = 7,
    ["Bear"] = 12,
    ["Safari"] = 8
}

-- 各种filter
winf_allWin = hs.window.filter.new():setDefaultFilter({}) -- 包括不可见窗口
winf_allWinNoAlfred = hs.window.filter.new():setDefaultFilter({}):rejectApp("Alfred 3") -- regular windows including hidden and minimized ones
winf_Inv = hs.window.filter.new():setDefaultFilter({visible = false}) -- 不可见窗口
winf_noInv = hs.window.filter.new() -- 可见窗口
winf_Irregular = hs.window.filter.new(false):setOverrideFilter():setFilters({
    ["网易云音乐"] = {},
    ["微信"] = {},
    ["虾米音乐"] = {},
    ["酷狗音乐"] = {},
    ["QQ音乐"] = {},
    ["Karabiner Preferences"] = {},
    ["Karabiner-Elements"] = {},
    ["Karabiner-EventViewer"] = {},
    ["系统偏好设置"] = {},
    ["计算器"] = {},
    ["iTunes"] = {},
    ["终端"] = {},
    ["Keyboard Maestro"] = {},
    ["Hammerspoon"] = {}
})
winf_IrregularNo = hs.window.filter.new():setOverrideFilter({allowScreens = "Color LCD"}):setFilters({
    ["网易云音乐"] = false,
    ["微信"] = false,
    ["虾米音乐"] = false,
    ["酷狗音乐"] = false,
    ["QQ音乐"] = false,
    ["Karabiner Preferences"] = false,
    ["Karabiner-Elements"] = false,
    ["Karabiner-EventViewer"] = false,
    ["系统偏好设置"] = false,
    ["计算器"] = false,
    ["iTunes"] = false,
    ["终端"] = false,
    ["Keyboard Maestro"] = false,
    ["Hammerspoon"] = false
})
winf_DELL = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "DELL P2414H"})
winf_MX27AQ = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "MX27AQ"})
winf_COLOR = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "Color LCD"})
winf_twoScreen = hs.window.filter.new():setOverrideFilter({allowScreens = {"DELL P2414H" ,"MX27AQ"}})

-- 最大化窗口
function maxInScreen()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    local f = win:frame() -- 获得当前窗口的 h w x y
    local screen = win:screen() -- 获得当前窗口所在的屏幕
    local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
    f.x = maxThis.x
    f.y = maxThis.y
    f.w = maxThis.w
    f.h = maxThis.h
    win:setFrame(f)
end

-- 窗口大小占1/4屏幕
function layoutU()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    local f = win:frame() -- 获得当前窗口的 h w x y
    local screen = win:screen() -- 获得当前窗口所在的屏幕
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
end

-- 窗口大小占1/6屏幕
function layoutY()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    local f = win:frame() -- 获得当前窗口的 h w x y
    local screen = win:screen() -- 获得当前窗口所在的屏幕
    print("当前屏幕:", screen)
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
    outlineFocusedWindow(f)
    win:setFrame(f)
    print("当前应用的frame:", f)
end

-- 窗口水平移动
function moveH(toRight)
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
function moveV(down)
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

-- 整齐窗口
function tile(screenName, myAspect, keepOrder, keepScale)
    local screen = hs.screen.find(screenName)
    local frame = screen:frame()
    -- 后面两个boolean, 第一个关于次序:getWindows(),按照获得的的list进行排序,依次tile; 第二个关于是否尽量保持个窗口大小之间的比例(但是无关窗口形状,只比对面积的相对大小)
    winf_screen = hs.window.filter.new():setOverrideFilter({allowScreens = screenName})
    local wins = winf_screen:getWindows()
    local desiredAspect = 1
    -- 判断win的数量, 再决定desiredAspect
    print(#wins)
    if (screenName == "DELL P2414H")
    then
        desiredAspect = 100
    else
        if (#wins == 3)
        then
            desiredAspect = 0.01
        end
    end
    if (myAspect) then desiredAspect = myAspect end
    hs.window.tiling.tileWindows(wins, frame, desiredAspect, keepOrder, keepScale)
    outlineFocusedWindowGetFrameFirst()
end

function tileOrderly()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    local screenName = screen:name()
    tile(screenName, desiredAspect, true, true)
end

-- 收集窗口
function collectAppToScreen(screenName)
    local win = hs.window.focusedWindow()
    local app = win:application()
    local appName = app:name()
    local app_winf = hs.window.filter.new(false):setAppFilter(appName, {visible = true})
    local wins = app_winf:getWindows()

    local screen = hs.screen.find(screenName)
    local frame = screen:frame()
    local desiredAspect = 1
    
    local winf_screen = hs.window.filter.new():setOverrideFilter({allowScreens = screenName}):setAppFilter(appName, false)
    for i,win in ipairs(winf_screen:getWindows()) do
        print("haha")
        if (not win:moveOneScreenSouth(true)) then win:moveOneScreenNorth(true) end
    end
    if (screenName == "DELL P2414H")
    then
        desiredAspect = 100
    else
        if (#wins == 3)
        then
            desiredAspect = 0.01
        end
    end
    hs.window.tiling.tileWindows(wins, frame, desiredAspect, false, false)
end
-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 当前app放到DELL P2414H,DELL P2414H的窗口都放到Color LCD
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "1", function() collectAppToScreen("DELL P2414H") end) -- hyper+1
-- 当前app放到MX27AQ,MX27AQ的窗口都放到Color LCD
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "2", function() collectAppToScreen("MX27AQ") end) -- hyper+2
-- 当前app放到Color LCD,Color LCD的窗口都放到华硕
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "3", function() collectAppToScreen("Color LCD") end) -- hyper+3
-- 整齐所有窗口
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "4", function() tile("MX27AQ") tile("DELL P2414H") tile("Color LCD") end) -- hyper+4
-- 所有无关紧要的app(或者不规则的app)全部都放到Color LCD
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "5", function() -- hyper+5
    for i,win in ipairs(winf_IrregularNo:getWindows()) do
        win:moveOneScreenNorth(true)
    end
    local screen = hs.screen.find("Color LCD")
    local frame = screen:frame()
    hs.window.tiling.tileWindows(winf_Irregular:getWindows(), frame, 1, false, false)
end)

-- 切换窗口
hs.hotkey.bind({}, "F16", function() -- 左
    hs.window.focusedWindow():focusWindowWest(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({}, "F17", function() -- 下
    hs.window.focusedWindow():focusWindowSouth(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({}, "F18", function() -- 上
    hs.window.focusedWindow():focusWindowNorth(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({}, "F19", function() -- 右
    hs.window.focusedWindow():focusWindowEast(winf_noInv:getWindows(), nil, true)
end)

-- 两个大屏幕切换窗口
hs.hotkey.bind({"alt"}, "F16", function() hs.window.focusedWindow():focusWindowWest(winf_twoScreen:getWindows(), nil, true) end) -- f1
hs.hotkey.bind({"alt"}, "F19", function() hs.window.focusedWindow():focusWindowEast(winf_twoScreen:getWindows(), nil, true) end) -- f2

-- 顺序排列当前屏幕窗口(调用hyper3用到的tile函数,不过只是tile当前的屏幕)
hs.hotkey.bind({"ctrl"}, "F16", tileOrderly) -- f3
-- 竖直排列所有窗口
hs.hotkey.bind({"ctrl"}, "F17", function() tile("MX27AQ", 0.01) tile("DELL P2414H", 0.01) tile("Color LCD", 0.01) end) -- f4

-- 改变窗口占据屏幕大小
hs.hotkey.bind({"alt"}, "f17", layoutU, nil, layoutU) -- f8
-- 最大化窗口
hs.hotkey.bind({"alt"}, "f18", maxInScreen) -- escape

-- 移动窗口
hs.hotkey.bind({"shift"}, "F16", moveH(0), nil, moveH(0)) -- shift+左 或 f7
hs.hotkey.bind({"shift"}, "F17", moveV(1), nil, moveV(1)) -- shift+下
hs.hotkey.bind({"shift"}, "F18", moveV(0), nil, moveV(0)) -- shift+上
hs.hotkey.bind({"shift"}, "F19", moveH(1), nil, moveH(1)) -- shift+右 或 f9

-- 窗口都恢复
hs.hotkey.bind({"cmd"}, "F16",  function() -- cmd 左
    -- hammerspoon这个app比较特殊, 在default里面已经设置过, 现在将他设置为Hammerspoon = {},
    for _, window in ipairs(hs.window.filter.new():setDefaultFilter({visible = false}):setAppFilter("Hammerspoon", {}):getWindows()) do
    window:unminimize()
    end
end)
-- 当前app的所有窗口最小化
hs.hotkey.bind({"cmd"}, "F17", function() -- cmd+下
    local win = hs.window.focusedWindow()
    local app = win:application() 
    for _, window in ipairs(app:allWindows()) do
        window:minimize()
    end
end)
-- 当前app的所有窗口最大化
hs.hotkey.bind({"cmd"}, "F18", function() -- cmd+上
    local win = hs.window.focusedWindow()
    local app = win:application() 
    for _, window in ipairs(app:allWindows()) do
        window:unminimize()
    end
end)
-- 窗口都最小
hs.hotkey.bind({"cmd"}, "F19", function() -- cmd+右
    for _, wins in ipairs(winf_noInv:getWindows()) do
        wins:minimize()
    end
end)
-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff



-- ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
function outlineFocusedWindow(f)
    -- Delete an existing highlight if it exists
    if WindowOutline then
        WindowOutline:delete()
        if WindowOutlineTimer then
            WindowOutlineTimer:stop()
        end
    end

    local win = hs.window.frontmostWindow()
    local app = win:application()
    print("应用:" .. app:name())
    local height
    
    local height = switchAppSettings[app:name()]
    if (not height) then 
        height = 22 
    end    
    WindowOutline = hs.drawing.rectangle(hs.geometry.point(f.x, f.y, f.w, height))
    WindowOutline:setFillColor({["hex"]="#28a56b", ["alpha"]=0.5})
    WindowOutline:setStroke(false)
    WindowOutline:setFill(true)
    WindowOutline:show()
    

    -- -- reminder
    -- -- Delete an existing highlight if it exists
    -- if reminder then
    --     reminder:delete()
    --     if reminderTimer then
    --         reminderTimer:stop()
    --     end
    -- end
    
    -- local strokeWidth
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
    local f = hs.geometry.rect(0,0,0,0)
    if (winGet) then
        f = winGet:frame()
        print(f)
    end
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
-- ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss







hs.hotkey.bind({"alt"}, "R", function() hs.reload()  end)
hs.alert.show("Config loaded")