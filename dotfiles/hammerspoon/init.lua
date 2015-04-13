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
end


-- PUT ALL WINDOWS WHERE THEY BELONG WHEN AN APPLICATION LAUNCHES
function applicationWatcherFun(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
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
