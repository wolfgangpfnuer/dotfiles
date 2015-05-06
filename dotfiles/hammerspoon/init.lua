-- constants
local applications = {"Google Chrome", "Mail", "Calendar", "Skype", "iTerm"}
local laptopScreen = "Color LCD"
local windowLayout = {
    {"Google Chrome",  nil,          laptopScreen, hs.layout.left50,    nil, nil},
    {"Mail",  nil,          laptopScreen, hs.layout.left50,    nil, nil},
    {"Calendar",  nil,          laptopScreen, hs.layout.left50,    nil, nil},
    {"Skype",    nil,          laptopScreen, hs.layout.right50,   nil, nil},
    {"iTerm",   nil,          laptopScreen, hs.layout.maximized, nil, nil},
}


switchableHotkeys = {}

-----------------------------------------------
-- {"ctrl"} i to show window hints
-----------------------------------------------
hs.hints.style = 'vimperator'
table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, "i", function()
    hs.hints.windowHints()
end))

-----------------------------------------------
-- {"ctrl"} hjkl to switch window focus
-----------------------------------------------

table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'k', function()
    hs.window.focusedWindow():focusWindowNorth()
end))

table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'j', function()
    hs.window.focusedWindow():focusWindowSouth()
end))

table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'l', function()
    hs.window.focusedWindow():focusWindowEast()
end))

table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'h', function()
    hs.window.focusedWindow():focusWindowWest()
end))

if (hs.window.focusedWindow() and hs.window.focusedWindow():isFullScreen()) then
    hs.fnutils.each(switchableHotkeys, function(hotkey)
        hotkey:disable()
    end)
end


-- PUT ALL WINDOWS WHERE THEY BELONG
function applyLayout()
    hs.layout.apply(windowLayout)
    for _, window in pairs(hs.window.allWindows()) do
        if (window:application():title() == "iTerm") then
            if not window:isFullScreen() then
                window:toggleFullScreen()
            end
        end
    end

    -- restart nexTab
    for _, application in pairs(hs.application.runningApplications()) do
        if (application:title() == 'nexTab') then
            application:kill()
            hs.application.launchOrFocus('nexTab')
        end
    end
end



-- PUT ALL WINDOWS WHERE THEY BELONG WHEN AN APPLICATION LAUNCHES
function applicationWatcherFun(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
        if (appObject and appObject:focusedWindow() and appObject:focusedWindow():isFullScreen()) then
            hs.fnutils.each(switchableHotkeys, function(hotkey)
                hotkey:disable()
            end)
        else
            hs.fnutils.each(switchableHotkeys, function(hotkey)
                hotkey:enable()
            end)
        end
    end
    if (eventType == hs.application.watcher.launching) then
        for _, application in pairs(applications) do
            if (appName == application) then
                applyLayout()
            end
        end
    end
end
local appWatcher = hs.application.watcher.new(applicationWatcherFun)
appWatcher:start()





-- PUT ALL WINDOWS WHERE THEY BELONG WHEN SCREENS CHANGE
function screenWatcherFun()
    applyLayout()
end

local screenWatcher = hs.screen.watcher.new(screenWatcherFun)
screenWatcher:start()




-- AUTOTEST BINGO ON CHANGES
for _, service in pairs({"bingo", "tumbler", "corsa", "kino", "stoker", "chemist", "polis", "lib34", "minitel"}) do
    hs.pathwatcher.new(os.getenv("HOME") .. "/bingo/" .. service, function(files)
        for _, file in pairs(files) do
            if string.find(file, '.py') and not string.find(file, '.pyc') then
                io.popen(os.getenv("SHELL") .. " -l -i -c 'tmux send -Rt 2 \"make test-" .. service .. "\" enter'", 'r')
                return
            end
        end
    end):start()
end



-- AUTORELOAD CONFIG
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()


-- HOTKEY REPOSITION WINDOWS
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  applyLayout()
end)





hs.alert.show("Config loaded")
