hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)
hs.loadSpoon("SpeedMenu")

-- focus窗口的时候关注条的宽度
switchAppSettings = {
    ["Google Chrome"] = 9,
    ["微信"] = 14,
    ["酷狗音乐"] = 10,
    ["虾米音乐"] = 13,
    -- ["Finder"] = 24,
    ["App Store"] = 9,
    ["系统偏好设置"] = 7,
    ["Bear"] = 12,
    ["Safari"] = 8
}

-- 各种filter
winf_ALL = hs.window.filter.new(true)
winf_allWin = hs.window.filter.new():setDefaultFilter({}) -- 包括不可见窗口
winf_allWinNoAlfred = hs.window.filter.new():setDefaultFilter({}):rejectApp("Alfred 3") -- regular windows including hidden and minimized ones
winf_Inv = hs.window.filter.new():setDefaultFilter({visible = false}) -- 不可见窗口
winf_noInv = hs.window.filter.new() -- 可见窗口
winf_Irregular =
    hs.window.filter.new(false):setOverrideFilter():setFilters(
    {
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
    }
)
winf_IrregularNo =
    hs.window.filter.new():setOverrideFilter({allowScreens = "Color LCD"}):setFilters(
    {
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
    }
)
winf_DELL = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "DELL P2414H"})
winf_MX27AQ = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "MX27AQ"})
winf_COLOR = hs.window.filter.new():setOverrideFilter({["allowScreens"] = "Color LCD"})
winf_twoScreen = hs.window.filter.new():setOverrideFilter({allowScreens = {"DELL P2414H", "MX27AQ"}})

-- 最大化窗口
function maxInScreen()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        f.x = maxThis.x
        f.y = maxThis.y
        f.w = maxThis.w
        f.h = maxThis.h
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window1")
    end
end
-- 窗口放左边
function halfScreenLeft()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen()
        local f_current = screen:frame() -- 获得当前屏幕的 h w x y
        if (screen:name() == "DELL P2414H") then
            f.x = f_current.x
            f.y = f_current.y
            f.w = f_current.w
            f.h = f_current.h / 2
            outlineFocusedWindow(f)
            win:setFrame(f)
        else
            f.x = f_current.x
            f.y = f_current.y
            f.w = f_current.w / 2
            f.h = f_current.h
            outlineFocusedWindow(f)
            win:setFrame(f)
        end
    else
        hs.alert.show("没有focused的window2")
    end
end
-- 窗口放右边
function halfScreenRight()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen()
        local f_current = screen:frame() -- 获得当前屏幕的 h w x y
        if (screen:name() == "DELL P2414H") then
            f.x = f_current.x
            f.y = f_current.y + f_current.h / 2
            f.w = f_current.w
            f.h = f_current.h / 2
            outlineFocusedWindow(f)
            win:setFrame(f)
        else
            f.x = f_current.x + f_current.w / 2
            f.y = f_current.y
            f.w = f_current.w / 2
            f.h = f_current.h
            outlineFocusedWindow(f)
            win:setFrame(f)
        end
    else
        hs.alert.show("没有focused的window3")
    end
end

-- 窗口大小占1/4屏幕
function layoutU()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        if (f.x == maxThis.x + maxThis.w / 2) then
            f.y = maxThis.y
        else
            f.x = maxThis.x
            f.y = maxThis.y
        end

        if (screen:name() == "MX27AQ" or screen:name() == "Color LCD") then
            if (f.w == math.floor(maxThis.w / 2) and f.h == math.floor(maxThis.h / 2)) then
                f.h = maxThis.h
            elseif (f.w == math.floor(maxThis.w / 2) and f.h == maxThis.h) then
                f.x = maxThis.x
                f.w = maxThis.w
            else
                f.w = maxThis.w / 2
                f.h = maxThis.h / 2
            end
        elseif (screen:name() == "DELL P2414H") then
            f.x = maxThis.x
            if (f.w == math.floor(maxThis.w) and f.h == math.floor(maxThis.h / 2)) then
                f.h = maxThis.h
            else
                f.w = maxThis.w
                f.h = maxThis.h / 2
            end
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window4")
    end
end


-- 窗口大小占1/4屏幕
function layoutHalfOrFull()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local f_current = screen:frame() -- 获得当前屏幕的 h w x y

        f.x = f_current.x
        f.y = f_current.y

        if (screen:name() == "MX27AQ" or screen:name() == "Color LCD") then
            if (f.w == math.floor(f_current.w / 2) and f.h == math.floor(f_current.h)) then
                f.w = f_current.w
            else
                f.w = f_current.w / 2
                f.h = f_current.h
            end
        elseif (screen:name() == "DELL P2414H") then
            if (f.w == math.floor(f_current.w) and f.h == math.floor(f_current.h / 2)) then
                f.h = f_current.h
            else
                f.w = f_current.w
                f.h = f_current.h / 2
            end
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window4")
    end
end

-- 窗口大小占1/6屏幕
function layoutY()
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local screen = win:screen() -- 获得当前窗口所在的屏幕
        local maxThis = screen:frame() -- 获得当前屏幕的 h w x y
        if (f.x == maxThis.x + math.floor(maxThis.w / 3)) then
            f.y = maxThis.y
        elseif (f.x == maxThis.x + math.ceil(maxThis.w / 3 * 2)) then
            f.y = maxThis.y
        else
            f.x = maxThis.x
            f.y = maxThis.y
        end

        if (screen:name() == "MX27AQ" or screen:name() == "Color LCD") then
            if (f.w == math.floor(maxThis.w / 3) and f.h == math.floor(maxThis.h / 2)) then
                f.h = maxThis.h
            elseif (f.w == math.floor(maxThis.w / 3) and f.h == math.floor(maxThis.h)) then
                if (f.x == maxThis.x + math.floor(maxThis.w / 3)) then
                    f.w = f.w * 2
                elseif (f.x == maxThis.x + math.ceil(maxThis.w / 3 * 2)) then
                    f.x = maxThis.x
                    f.w = f.w * 2
                else
                    f.w = f.w * 2
                end
            elseif (f.w == math.floor(maxThis.w / 3 * 2) and f.h == math.floor(maxThis.h)) then
                f.x = maxThis.x
                f.w = f.w * 2
            else
                f.w = math.floor(maxThis.w / 3)
                f.h = math.floor(maxThis.h / 2)
            end
        elseif (screen:name() == "DELL P2414H") then
            f.x = maxThis.x
            if (f.w == math.floor(maxThis.w / 2) and f.h == math.floor(maxThis.h / 3)) then
                f.w = maxThis.w
            elseif (f.w == maxThis.w and f.h == math.floor(maxThis.h / 3)) then
                f.h = f.h * 2
            elseif (f.w == maxThis.w and f.h == math.floor(maxThis.h / 3 * 2)) then
                f.h = maxThis.h
            else
                f.w = maxThis.w / 2
                f.h = maxThis.h / 3
            end
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window5")
    end
end

-- 新的函数moveRight
function moveRight()
    local win = hs.window.focusedWindow() -- 获取当前有焦点的窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local f_current = win:screen():frame() -- 当前屏幕的 h w x y

        -- 1.1先判断是否到了当前screen的【右】边界，如果到了【右】边界就转到下面的屏幕
        if (f.x + f.w) == (f_current.x + f_current.w) then
            if (win:screen():toEast(nil, true)) then
                local f_east = win:screen():toEast(nil, true):frame()
                -- 1.2如果窗口【宽度】或【高度】大于后面窗口的，等于后面窗口的
                if (f.w > f_east.w) then f.w = f_east.w end
                if (f.h > f_east.h) then f.h = f_east.h end
                -- 1.3保持窗口【y】坐标与之前screen【上】侧的距离
                f.y = f_east.y + (f.y - f_current.y)
                -- 1.4【x】变为【东边】screen的【左边】（贴近[左]边）
                f.x = f_east.x
                -- 1.5如果移动后的窗口[y+h]大于后面屏幕的[y+h]，那么贴近后面屏幕[底边]进行适应（超出后修正贴近[底]边）
                if (f.y + f.h) > (f_east.y + f_east.h) then
                    f.y = f_east.y + f_east.h - f.h
                end
            end
        -- 2.1如果窗口还没贴近边界，但是在新移动的位置会超出currentScreen的【右】边界，靠边【右】停靠
        elseif (f.x + f.w + f.w) >= (f_current.x + f_current.w) then
            f.x = (f_current.x + f_current.w) - f.w
        else
        -- 3.1如果窗口没有贴近边界，移动后也不会超出，那么向【右】移动一个【f.w】宽
            f.x = f.x + f.w
        end
        outlineFocusedWindow(f)
        win:setFrame(f)        
    else
        hs.alert.show("没有focused的window6")
    end
end

-- 新的函数moveLeft
-- 改变后的窗口h如果超过下面的屏幕的h，那么mac会自动执行  f.x=f_后面.x  f.h=f_后面.h
-- 所以不用考虑(f.h > f_后面.h)的情况，只需要考虑(f.y + f.h) > (f_west.y + f_west.h)的情况
function moveLeft()
    local win = hs.window.focusedWindow() -- 获取当前有焦点的窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local f_current = win:screen():frame() -- 当前屏幕的 h w x y
        -- 1.1先判断是否到了当前screen的【左】边界，如果到了【左】边界就转到下面的屏幕
        if (f.x) == (f_current.x) then
            if (win:screen():toWest(nil, true)) then
                local f_west = win:screen():toWest(nil, true):frame()
                -- 1.2如果窗口【宽度】或【高度】大于后面窗口的，等于后面窗口的
                if (f.w > f_west.w) then f.w = f_west.w end
                if (f.h > f_west.h) then f.h = f_west.h end
                -- 1.3保持窗口【y】坐标与之前screen【上】侧的距离
                f.y = f_west.y + (f.y - f_current.y)
                -- 1.4【x】变为【西边】screen的【右边-f.w】（贴近[右]边）
                f.x = (f_west.x + f_west.w) - f.w
                -- 1.5如果移动后的窗口[y+h]大于后面屏幕的[y+h]，那么贴近后面屏幕[底边]进行适应（超出后修正贴近[底]边）
                if (f.y + f.h) > (f_west.y + f_west.h) then
                    f.y = f_west.y + f_west.h - f.h
                end
            end
        -- 2.1如果窗口还没贴近边界，但是在新移动的位置会超出currentScreen的【左】边界，靠【左】边停靠
        elseif (f.x - f.w) <= (f_current.x) then
            f.x = f_current.x
        else
        -- 3.1如果窗口没有贴近边界，移动后也不会超出，那么向【左】移动一个【f.w】距离
            f.x = f.x - f.w
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window7")
    end
end


-- 新的函数moveUp
function moveUp()
    local win = hs.window.focusedWindow() -- 获取当前有焦点的窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local f_current = win:screen():frame() -- 当前屏幕的 h w x y
        -- 1.1先判断是否到了当前screen的【上】边界，如果到了【上】边界就转到下面的屏幕
        if (f.y) == (f_current.y) then
            if (win:screen():toNorth(nil, true)) then
                local f_north = win:screen():toNorth(nil, true):frame()
                -- 1.2如果窗口【宽度】或【高度】大于后面窗口的，等于后面窗口的
                if (f.h > f_north.h) then f.h = f_north.h end
                if (f.w > f_north.w) then f.w = f_north.w end
                -- 1.3保持窗口【x】坐标与之前screen【左】侧的距离
                f.x = f_north.x + (f.x - f_current.x)
                -- 1.4【y】变为【北边】screen的【下边-f.h】（贴近[底]边）
                f.y = (f_north.y + f_north.h) - f.h
                -- 1.5如果移动后的窗口[x+w]大于后面屏幕的[x+w]，那么贴近后面屏幕[右边]进行适应（超出后修正贴近[右]边）
                if (f.x + f.w) > (f_north.x + f_north.w) then
                    f.x = (f_north.x + f_north.w) - f.w
                end
            end
        -- 2.1如果窗口还没贴近边界，但是在新移动的位置会超出currentScreen的【上】边界，那么靠【上】边停靠
        elseif (f.y - f.h) <= (f_current.y) then
            f.y = f_current.y
        else
        -- 3.1如果窗口没有贴近边界，移动后也不会超出，那么向【上】移动一个【f.h】距离
            f.y = f.y - f.h
        end
        outlineFocusedWindow(f)
        win:setFrame(f)        
    else
        hs.alert.show("没有focused的window8")
    end
end


-- 新的函数moveDown
function moveDown()
    local win = hs.window.focusedWindow() -- 获取当前有焦点的窗口
    if (win) then
        local f = win:frame() -- 获得当前窗口的 h w x y
        local f_current = win:screen():frame() -- 当前屏幕的 h w x y
        -- 1.1先判断是否到了当前screen的【下】边界，如果到了【下】边界就转到下面的屏幕
        if (f.y + f.h) == (f_current.y + f_current.h) then
            if (win:screen():toSouth(nil, true)) then
                local f_south = win:screen():toSouth(nil, true):frame()
                -- 1.2如果窗口【宽度】或【高度】大于后面窗口的，等于后面窗口的
                if (f.h > f_south.h) then f.h = f_south.h end
                if (f.w > f_south.w) then f.w = f_south.w end
                -- 1.3保持窗口x坐标与之前screen【左】侧的距离
                f.x = f_south.x + (f.x - f_current.x)
                -- 1.4【y】变为【北边】screen的【下边-f.h】（贴近[顶]边）
                f.y = f_south.y
                -- 1.5如果移动后的窗口[x+w]大于后面屏幕的[x+w]，那么贴近后面屏幕[右边]进行适应（超出后修正贴近[右]边）
                if (f.x + f.w) > (f_south.x + f_south.w) then
                    f.x = (f_south.x + f_south.w) - f.w
                end
            end
        -- 2.1如果窗口还没贴近边界，但是如果移动的话会超出currentScreen的【下】边界，那么靠【下】边停靠
        elseif (f.y + f.h + f.h) >= (f_current.y + f_current.h) then
            f.y = f_current.y + f_current.h - f.h
        else
        -- 3.1如果窗口没有贴近边界，移动后也不会超出，那么向【下】移动一个【f.h】距离
            f.y = f.y + f.h
        end
        outlineFocusedWindow(f)
        win:setFrame(f)        
    else
        hs.alert.show("没有focused的window9")
    end
end


-- 窗口水平移动
function moveH(toRight)
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
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
        if (toRight == 1) then
            -- 向左移动
            -- 1.到了右边界就转到下个屏幕
            if (f.x + f.w) == rightThis then
                -- 4.移动之后会超越当前screen右边界, 就靠边停靠
                f.x = maxNext.x
                f.y = f.y - maxThis.y + maxNext.y
                -- 2.如果窗口宽大于下一个屏幕的宽, 那么适应下一个窗口
                if f.w > maxNext.w then
                    f.w = maxNext.w
                end
                -- 3.如果窗口下边突出了, 靠边停靠
                if f.h > maxNext.h then
                elseif (f.y + f.h) > bottomNext then
                    f.y = maxNext.y + maxNext.h - f.h
                    f.x = maxNext.x
                end
            elseif (f.x + f.w + f.w) >= (rightThis - 2) then -- 这里把elseif改为if 删掉上面的if就行
                f.x = rightThis - f.w
            else
                f.x = f.x + f.w
            end
        elseif (toRight == 0) then
            -- 1.到了左边界就转到上一个屏幕
            if f.x == maxThis.x then
                -- 4. 移动之后会超越当前screen左边界, 就靠边停靠
                f.x = rightPrevious - f.w
                f.y = f.y - maxThis.y + maxPrevious.y
                -- 2. 如果窗口宽大于上一个屏幕的宽, 那么适应上一个窗口
                if (f.w > maxPrevious.w) then
                    f.w = maxPrevious.w
                    f.x = maxPrevious.x
                end
                -- 3.如果窗口下边突出了, 靠边停靠
                if f.h > maxPrevious.h then
                elseif (f.y + f.h) > bottomNext then
                    f.y = bottomPrevious - f.h
                end
            elseif (f.x - f.w) <= (maxThis.x + 2) then -- 这里吧elseif改为if 删掉上面的if就行
                f.x = maxThis.x
            else
                f.x = f.x - f.w
            end
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window10")
    end
end



-- 窗口垂直移动
function moveV(down)
    local win = hs.window.focusedWindow() -- 获取当前窗口
    if (win) then
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
        if (down == 1) then
            -- 向上移动


            -- 1.到了下边界就转下个屏幕
            if (f.y + f.h) == bottomThis then
                -- 4.如果移动之后会超越当前screen下边界, 就靠边停靠
                f.x = f.x - maxThis.x + maxNext.x
                f.y = maxNext.y
                -- 2.如果窗口宽大于下一个屏幕的宽, 那么适应下一个窗口
                if f.w > maxNext.w then
                    f.w = maxNext.w
                end
                -- 3.如果窗口右边突出了, 靠边停靠
                if (f.x + f.w) > rightNext then
                    f.x = rightNext - f.w
                end
            elseif (f.y + f.h + f.h) >= (bottomThis - 34) then
                f.y = bottomThis - f.h
            else
                f.y = f.y + f.h
            end


        elseif (down == 0) then
            -- 1.到了上边界就转到上一个屏幕
            if f.y == maxThis.y then
                -- 4.如果移动之后会超越当前screen上边界, 就靠边停靠
                f.x = f.x - maxThis.x + maxPrevious.x
                f.y = bottomPrevious - f.h
                -- 2. 如果窗口宽大于上一个屏幕的宽, 那么适应上一个窗口
                if (f.w > maxPrevious.w) then
                    f.w = maxPrevious.w
                    f.x = maxPrevious.x
                end
                -- 3.如果窗口右边突出了, 靠边停靠
                if (f.x + f.w) > rightPrevious then
                    f.x = rightPrevious - f.w
                end
            elseif (f.y - f.h) <= (maxThis.y + 34) then
                f.y = maxThis.y
            else
                f.y = f.y - f.h
            end
        end
        outlineFocusedWindow(f)
        win:setFrame(f)
    else
        hs.alert.show("没有focused的window11")
    end
end



-- 整齐窗口
function tile(screenName, myAspect, keepOrder, keepScale)
    local screen = hs.screen.find(screenName)
    if (not screen) then
        return
    end
    local frame = screen:frame()
    -- 后面两个boolean, 第一个关于次序:getWindows(),按照获得的的list进行排序,依次tile; 第二个关于是否尽量保持个窗口大小之间的比例(但是无关窗口形状,只比对面积的相对大小)
    winf_screen = hs.window.filter.new():setOverrideFilter({allowScreens = screenName})
    local wins = winf_screen:getWindows()
    local desiredAspect = 1
    -- 判断win的数量, 再决定desiredAspect
    if (screenName == "DELL P2414H") then
        desiredAspect = 100
    else
        if (#wins == 3) then
            desiredAspect = 0.01
        end
    end
    if (myAspect) then
        desiredAspect = myAspect
    end
    hs.window.tiling.tileWindows(wins, frame, desiredAspect, keepOrder, keepScale)
    outlineFocusedWindow(f)
end

function tileOrderly()
    local win = hs.window.focusedWindow()
    if (win) then
        local screen = win:screen()
        local screenName = screen:name()
        tile(screenName, desiredAspect, true, true)
    else
        hs.alert.show("没有focused的window12")
    end
end

-- 收集窗口
function collectAppToScreen(screenName)
    local win = hs.window.focusedWindow()
    if (win) then
        local app = win:application()
        local appName = app:name()
        local app_winf = hs.window.filter.new(false):setAppFilter(appName, {visible = true})
        local wins = app_winf:getWindows()

        local screen = hs.screen.find(screenName)
        local frame = screen:frame()
        local desiredAspect = 1

        local winf_screen = hs.window.filter.new():setOverrideFilter({allowScreens = screenName}):setAppFilter(appName, false)
        for i, win in ipairs(winf_screen:getWindows()) do
            if (not win:moveOneScreenSouth(true)) then
                win:moveOneScreenNorth(true)
            end
        end
        if (screenName == "DELL P2414H") then
            desiredAspect = 100
        else
            if (#wins == 3) then
                desiredAspect = 0.01
            end
        end
        hs.window.tiling.tileWindows(wins, frame, desiredAspect, false, false)
    else
        hs.alert.show("没有focused的window13")
    end
end

-- 向右循环选择窗口
function switchWindowHorizontalRight()
    if (hs.window.focusedWindow():focusWindowEast(winf_noInv:getWindows(), nil, true)) then
    else
        local windowsToWest = hs.window.focusedWindow():windowsToWest(winf_noInv:getWindows(), nil, true)
        windowsToWest[#windowsToWest]:focus()
    end
end

-- 向左循环选择窗口
function switchWindowHorizontalLeft()
    if (hs.window.focusedWindow():focusWindowWest(winf_noInv:getWindows(), nil, true)) then
    else
        local windowsToEast = hs.window.focusedWindow():windowsToEast(winf_noInv:getWindows(), nil, true)
        windowsToEast[#windowsToEast]:focus()
    end
end

-- 垂直循环选择窗口
function switchWindowVertical()
    if (hs.window.focusedWindow():focusWindowSouth(winf_noInv:getWindows(), nil, true)) then
    else
        local windowsToNorth = hs.window.focusedWindow():windowsToNorth(winf_noInv:getWindows(), nil, true)
        windowsToNorth[#windowsToNorth]:focus()
    end
end


-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 当前app放到DELL P2414H,DELL P2414H的窗口都放到Color LCD
hs.hotkey.bind({"ctrl", "alt"}, "f16", function() collectAppToScreen("DELL P2414H") end) -- f7
-- 当前app放到MX27AQ,MX27AQ的窗口都放到Color LCD
hs.hotkey.bind({"ctrl", "alt"}, "f17", function() collectAppToScreen("MX27AQ") end) -- f8
-- 当前app放到Color LCD,Color LCD的窗口都放到华硕
hs.hotkey.bind({"ctrl", "alt"}, "f18", function() collectAppToScreen("Color LCD") end) -- f9

hs.hotkey.bind({"ctrl", "alt"}, "f19", layoutHalfOrFull) -- right_shift

hs.hotkey.bind({"ctrl", "cmd"}, "f16", maxInScreen) -- f4

-- 整齐所有窗口
-- hs.hotkey.bind({"alt"}, "f19", function() tile("MX27AQ") tile("DELL P2414H") tile("Color LCD") end) -- f7
-- 所有无关紧要的app(或者不规则的app)全部都放到Color LCD
-- hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "5", function() -- hyper+5
    -- for i,win in ipairs(winf_IrregularNo:getWindows()) do
    --     win:moveOneScreenNorth(true)
    -- end
    -- local screen = hs.screen.find("Color LCD")
    -- local frame = screen:frame()
    -- hs.window.tiling.tileWindows(winf_Irregular:getWindows(), frame, 1, false, false)
-- end)


-- 移动窗口
hs.hotkey.bind({}, "F16", moveLeft, nil, moveLeft) -- 左
hs.hotkey.bind({}, "F17", moveDown, nil, moveDown) -- 下
hs.hotkey.bind({}, "F18", moveUp, nil, moveUp) -- 上
hs.hotkey.bind({}, "F19", moveRight, nil, moveRight) -- 右


-- 两个大屏幕切换窗口
-- hs.hotkey.bind({"alt"}, "F16", function() hs.window.focusedWindow():focusWindowWest(winf_twoScreen:getWindows(), nil, true) end) -- f1
-- hs.hotkey.bind({"alt"}, "F19", function() hs.window.focusedWindow():focusWindowEast(winf_twoScreen:getWindows(), nil, true) end) -- f2

hs.hotkey.bind({"ctrl"}, "F16", function() tile("MX27AQ", 0.01, nil) tile("DELL P2414H", 100, nil) tile("Color LCD", 0.01, nil) end) -- escape
hs.hotkey.bind({"ctrl"}, "F17", switchWindowHorizontalLeft) -- f1
hs.hotkey.bind({"ctrl"}, "F18", switchWindowHorizontalRight) -- f2
hs.hotkey.bind({"ctrl"}, "F19", switchWindowVertical) -- f3
-- 竖直排列所有窗口



-- 顺序排列当前屏幕窗口(调用hyper3用到的tile函数,不过只是tile当前的屏幕)
-- hs.hotkey.bind({"ctrl"}, "F17", tileOrderly) -- f5


-- 放在左边
-- hs.hotkey.bind({"shift"}, "F16", halfScreenLeft) -- f1
-- 放在右边
-- hs.hotkey.bind({"shift"}, "F19", halfScreenRight) -- f2
-- 最大化窗口
-- hs.hotkey.bind({"shift"}, "f18", maxInScreen) -- escape



-- 切换窗口
hs.hotkey.bind({"cmd"}, "F16", function() -- 左
    hs.window.focusedWindow():focusWindowWest(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({"cmd"}, "F17", function() -- 下
    hs.window.focusedWindow():focusWindowSouth(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({"cmd"}, "F18", function() -- 上
    hs.window.focusedWindow():focusWindowNorth(winf_noInv:getWindows(), nil, true)
end)
hs.hotkey.bind({"cmd"}, "F19", function() -- 右
    hs.window.focusedWindow():focusWindowEast(winf_noInv:getWindows(), nil, true)
end)


-- 改变窗口占据屏幕大小
-- hs.hotkey.bind({"alt"}, "f17", layoutU, nil, layoutU) -- f8


-- -- 移动窗口
-- hs.hotkey.bind({}, "F16", function() moveH(1) end, nil, function() moveH(1) end) -- shift+左 或 f7
-- hs.hotkey.bind({}, "F17", function() moveV(0) end, nil,function() moveV(0) end) -- shift+下
-- hs.hotkey.bind({}, "F18", function() moveV(1) end, nil, function() moveV(1) end) -- shift+上
-- hs.hotkey.bind({}, "F19", function() moveH(0) end, nil, function() moveH(0) end) -- shift+右 或 f9

-- 窗口都最小
hs.hotkey.bind({"alt"}, "F16", function() -- cmd+右
    for _, wins in ipairs(winf_noInv:getWindows()) do
        wins:minimize()
    end
end)
-- 当前app的所有窗口最小化
hs.hotkey.bind({"alt"}, "F17", function() -- cmd+下
    local win = hs.window.focusedWindow()
    local app = win:application() 
    for _, window in ipairs(app:allWindows()) do
        window:minimize()
    end
end)
-- 当前app的所有窗口都恢复
hs.hotkey.bind({"alt"}, "F18", function() -- cmd+上
    local win = hs.window.focusedWindow()
    local app = win:application() 
    for _, window in ipairs(app:allWindows()) do
        window:unminimize()
    end
end)
-- 窗口都恢复
hs.hotkey.bind({"alt"}, "F19",  function() -- cmd 左
    -- hammerspoon这个app比较特殊, 在default里面已经设置过, 现在将他设置为Hammerspoon = {},
    for _, window in ipairs(hs.window.filter.new():setDefaultFilter({visible = false}):setAppFilter("Hammerspoon", {}):getWindows()) do
    window:unminimize()
    end
end)
-- ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff



-- ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
function outlineFocusedWindow(desiredFrame)
    -- Delete an existing highlight if it exists
    if WindowOutline then
        WindowOutline:delete()
        if WindowOutlineTimer then
            WindowOutlineTimer:stop()
        end
    end

    local f
    local win = hs.window.focusedWindow()
    if (win) then
        local app = win:application()
        local height = switchAppSettings[app:name()]
        if (not height) then
            height = 22
        end

        if (desiredFrame) then
            f = desiredFrame
        else
            f = win:frame()
        end
        print("前面的是", app:name(), f)
        WindowOutline = hs.drawing.rectangle(hs.geometry.rect(f.x, f.y, f.w, height))
        WindowOutline:setFillColor({["hex"] = "#28a56b", ["alpha"] = 0.5})
        WindowOutline:setStroke(false)
        WindowOutline:setFill(true)
        WindowOutline:show()
    else
        -- hs.alert.show("没有focused的window14")
    end
end


winf_ALL:subscribe(hs.window.filter.windowFocused, function() outlineFocusedWindow() end, true)
winf_ALL:subscribe(hs.window.filter.windowUnfocused, function() outlineFocusedWindow() end, true)
winf_ALL:subscribe(hs.window.filter.windowMoved, function() outlineFocusedWindow() end, true)

winf_noInv:subscribe(hs.window.filter.windowMinimized, function(win, appName, event)
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


hs.hotkey.bind({"alt"}, "C", function() hs.application.open("/Applications/Google Chrome.app") end)
hs.hotkey.bind({"alt"}, "E", function() hs.application.open("/Applications/Eudic.app") end)
hs.hotkey.bind({"alt"}, "F", function()
    hs.applescript(
        [[ tell application "Finder" 
        reopen 
        activate
        if (count windows) is 0 then
            open ("/Users/Jimmy" as POSIX file)
        end if
        end tell ]]
    )
end)
hs.hotkey.bind({"alt"}, "H", function() hs.application.open("/Applications/HammerSpoon.app") end)
hs.hotkey.bind({"alt"}, "J", function() hs.application.open("/Users/Jimmy/eclipse/jee-oxygen/Eclipse.app") end)
hs.hotkey.bind({"alt"}, "L", function() hs.application.open("/Applications/Karabiner-Elements.app") end)
hs.hotkey.bind({"alt"}, "M", function() hs.application.open("/Applications/虾米音乐.app") end)
hs.hotkey.bind({"alt"}, "N", function() hs.application.open("/Applications/NeteaseMusic.app") end)
hs.hotkey.bind({"alt"}, "P", function() hs.application.open("/Applications/System preferences.app") end)
hs.hotkey.bind({"alt"}, "R", function() hs.application.open("/Applications/Utilities/Terminal.app") end)
hs.hotkey.bind({"alt"}, "S", function() hs.application.open("/Applications/Beyond Compare.app") end)
hs.hotkey.bind({"alt"}, "V", function() hs.application.open("/Applications/Visual Studio Code.app") end)
hs.hotkey.bind({"alt"}, "W", function() hs.application.open("/Applications/WeChat.app") end)


hs.hotkey.bind({"ctrl", "alt", "cmd"}, "R", function() hs.reload()  end)
hs.alert.show("Config loaded")