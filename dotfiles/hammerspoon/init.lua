-- constants
local applications = {"Google Chrome", "Mail", "Calendar", "Slack", "iTerm2"}
local laptopScreen = "Color LCD"
local monitor = "C27F591"
local windowLayout = {
    {"Google Chrome",  nil,          laptopScreen, hs.layout.maximized,    nil, nil},
    {"Mail",  nil,          laptopScreen, hs.layout.maximized,    nil, nil},
    {"Calendar",  nil,          laptopScreen, hs.layout.maximized,    nil, nil},
    {"Slack",    nil,          laptopScreen, hs.layout.maximized,   nil, nil},
    {"iTerm2",   nil,          monitor, hs.layout.maximized, nil, nil},
}


switchableHotkeys = {}

-----------------------------------------------
-- {"ctrl"} i to show window hints
-----------------------------------------------
hs.hints.style = 'vimperator'
table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, "i", function()
    hs.hints.windowHints()
end))

-------------------------------------------------
---- {"ctrl"} hjkl to switch window focus
-------------------------------------------------

--table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'k', function()
--    hs.window.focusedWindow():focusWindowNorth()
--end))

--table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'j', function()
--    hs.window.focusedWindow():focusWindowSouth()
--end))

--table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'l', function()
--    hs.window.focusedWindow():focusWindowEast()
--end))

--table.insert(switchableHotkeys, hs.hotkey.bind({"ctrl"}, 'h', function()
--    hs.window.focusedWindow():focusWindowWest()
--end))

--if (hs.window.focusedWindow() and hs.window.focusedWindow():isFullScreen()) then
--    hs.fnutils.each(switchableHotkeys, function(hotkey)
--        hotkey:disable()
--    end)
--end


-- PUT ALL WINDOWS WHERE THEY BELONG
function applyLayout()
    for _, window in pairs(hs.window.allWindows()) do
        if (window:application():title() == "iTerm2") then
            if window:isFullScreen() then
                window:toggleFullScreen()
            end
        end
    end
    os.execute("sleep 1")
    hs.layout.apply(windowLayout)
    os.execute("sleep 1")
    for _, window in pairs(hs.window.allWindows()) do
        if (window:application():title() == "iTerm2") then
            if not window:isFullScreen() then
                window:toggleFullScreen()
            end
        end
    end

    -- -- stop powerline-daemon regularly
    -- os.execute('pgrep -f powerline-daemon | xargs kill')
end



-- PUT ALL WINDOWS WHERE THEY BELONG WHEN AN APPLICATION LAUNCHES
-- function applicationWatcherFun(appName, eventType, appObject)
--     if (eventType == hs.application.watcher.activated) then
--         if (appName == "Finder") then
--             -- Bring all Finder windows forward when one gets activated
--             appObject:selectMenuItem({"Window", "Bring All to Front"})
--         end
--         if (appObject and appObject:focusedWindow() and appObject:focusedWindow():isFullScreen()) then
--             hs.fnutils.each(switchableHotkeys, function(hotkey)
--                 hotkey:disable()
--             end)
--         else
--             hs.fnutils.each(switchableHotkeys, function(hotkey)
--                 hotkey:enable()
--             end)
--         end
--     end
--     if (eventType == hs.application.watcher.launching) then
--         for _, application in pairs(applications) do
--             if (appName == application) then
--                 applyLayout()
--             end
--         end
--     end
-- end
-- local appWatcher = hs.application.watcher.new(applicationWatcherFun)
-- appWatcher:start()





-- PUT ALL WINDOWS WHERE THEY BELONG WHEN SCREENS CHANGE
function screenWatcherFun()
    applyLayout()
end

local screenWatcher = hs.screen.watcher.new(screenWatcherFun)
screenWatcher:start()




-- -- AUTOTEST BINGO ON CHANGES
-- for _, service in pairs({"recommender", "librarian", "academy", "common"}) do
--     hs.pathwatcher.new(os.getenv("HOME") .. "/tron/tron/" .. service, function(files)
--         for _, file in pairs(files) do
--             if string.find(file, '.py') and not string.find(file, '.pyc') then
--                 io.popen(os.getenv("SHELL") .. " -l -i -c 'tmux send -t 2 \"C-c\" && tmux send -Rt 2 \".venv/bin/pytest --cov-fail-under=0 -n auto tron -k " .. service .. "\" enter'", 'r')
--                 return
--             end
--         end
--     end):start()
--     hs.pathwatcher.new(os.getenv("HOME") .. "/tron/tron/test/" .. service, function(files)
--         for _, file in pairs(files) do
--             if string.find(file, '.py') and not string.find(file, '.pyc') then
--                 io.popen(os.getenv("SHELL") .. " -l -i -c 'tmux send -t 2 \"C-c\" && tmux send -Rt 2 \".venv/bin/pytest --cov-fail-under=0 -n auto tron -k " .. service .. "\" enter'", 'r')
--                 return
--             end
--         end
--     end):start()
-- end


hs.pathwatcher.new(os.getenv("HOME") .. "dotfiles/dotfiles/hammerspoon/", hs.reload):start()


-- HOTKEY REPOSITION WINDOWS
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
  applyLayout()
end)



hs.alert.show("Config loaded")
