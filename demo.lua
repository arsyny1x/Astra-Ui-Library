local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local ACCENT = Color3.fromRGB(129, 130, 255)
local THAI_TEXT = {
    ["Astra Analytics"] = "Astra Analytics",
    ["Live experience dashboard"] = "แดชบอร์ดประสบการณ์แบบเรียลไทม์",
    ["Search"] = "ค้นหา",
    ["Overview"] = "ภาพรวม",
    ["Players"] = "ผู้เล่น",
    ["Controls"] = "การควบคุม",
    ["Components"] = "คอมโพเนนต์",
    ["Experience"] = "ประสบการณ์",
    ["Interface"] = "หน้าตา UI",
    ["Color theme"] = "ธีมสี",
    ["Dark"] = "มืด",
    ["Light"] = "สว่าง",
    ["Lilith"] = "Lilith",
    ["English"] = "อังกฤษ",
    ["None"] = "ไม่มี",
    ["PLAYERS ONLINE"] = "ผู้เล่นออนไลน์",
    ["Players in this server"] = "ผู้เล่นในเซิร์ฟเวอร์นี้",
    ["SERVER CAPACITY"] = "ความจุเซิร์ฟเวอร์",
    ["Current players and server limit"] = "จำนวนผู้เล่นปัจจุบันและขีดจำกัดเซิร์ฟเวอร์",
    ["YOUR PING"] = "ค่า Ping ของคุณ",
    ["Current network latency"] = "ความหน่วงของเครือข่ายปัจจุบัน",
    ["SESSION TIME"] = "เวลาเซสชัน",
    ["Since dashboard opened"] = "ตั้งแต่เปิดแดชบอร์ด",
    ["Live dashboard"] = "แดชบอร์ดสด",
    ["Capacity and recent activity"] = "ความจุและกิจกรรมล่าสุด",
    ["Server capacity"] = "ความจุเซิร์ฟเวอร์",
    ["Current players compared with the server limit."] = "จำนวนผู้เล่นปัจจุบันเทียบกับขีดจำกัดเซิร์ฟเวอร์",
    ["Available slots"] = "ช่องว่างที่เหลือ",
    ["Waiting for live server data..."] = "กำลังรอข้อมูลเซิร์ฟเวอร์...",
    ["Recent activity"] = "กิจกรรมล่าสุด",
    ["Dashboard connected"] = "เชื่อมต่อแดชบอร์ดแล้ว",
    ["Recent player activity"] = "กิจกรรมผู้เล่นล่าสุด",
    ["Collecting player count samples..."] = "กำลังรวบรวมข้อมูลจำนวนผู้เล่น...",
    ["Waiting for players..."] = "กำลังรอผู้เล่น...",
    ["This server"] = "เซิร์ฟเวอร์นี้",
    ["Server connection"] = "การเชื่อมต่อเซิร์ฟเวอร์",
    ["Connected to the current Roblox experience."] = "เชื่อมต่อกับประสบการณ์ Roblox นี้แล้ว",
    ["Choose player"] = "เลือกผู้เล่น",
    ["Select a player..."] = "เลือกผู้เล่น...",
    ["No players are currently available."] = "ขณะนี้ไม่มีผู้เล่น",
    ["Choose a player from this server."] = "เลือกผู้เล่นจากเซิร์ฟเวอร์นี้",
    ["YOU"] = "คุณ",
    ["Return to overview"] = "กลับไปภาพรวม",
    ["Go back to the live dashboard."] = "กลับไปยังแดชบอร์ดสด",
    ["Refresh dashboard"] = "รีเฟรชแดชบอร์ด",
    ["Refresh live player and server metrics."] = "รีเฟรชข้อมูลผู้เล่นและเซิร์ฟเวอร์",
    ["General preferences"] = "ค่ากำหนดทั่วไป",
    ["Enable notifications"] = "เปิดการแจ้งเตือน",
    ["Toggle state can be saved and restored."] = "สามารถบันทึกและเรียกคืนสถานะสวิตช์ได้",
    ["Refresh interval"] = "ช่วงเวลารีเฟรช",
    ["Adjust the sample interval used by this demo."] = "ปรับช่วงเวลาเก็บข้อมูลของเดโมนี้",
    ["Display density"] = "ความหนาแน่นการแสดงผล",
    ["Appearance and actions"] = "รูปลักษณ์และการทำงาน",
    ["Dashboard label"] = "ชื่อแดชบอร์ด",
    ["Enter a custom label"] = "ใส่ชื่อที่กำหนดเอง",
    ["Toggle dashboard"] = "ปุ่มสลับแดชบอร์ด",
    ["Accent color"] = "สีเน้น",
    ["Demo progress"] = "ความคืบหน้าเดโม",
    ["Connection status"] = "สถานะการเชื่อมต่อ",
    ["Connected to the current demo experience."] = "เชื่อมต่อกับประสบการณ์เดโมนี้แล้ว",
    ["Save settings"] = "บันทึกการตั้งค่า",
    ["Could not save settings"] = "บันทึกการตั้งค่าไม่สำเร็จ",
    ["Settings saved"] = "บันทึกการตั้งค่าแล้ว",
    ["Your settings were saved to a local file."] = "บันทึกการตั้งค่าลงไฟล์ในเครื่องแล้ว",
    ["Load settings"] = "โหลดการตั้งค่า",
    ["Could not load settings"] = "โหลดการตั้งค่าไม่สำเร็จ",
    ["No saved settings"] = "ไม่มีการตั้งค่าที่บันทึกไว้",
    ["Save settings once before loading them."] = "บันทึกการตั้งค่าก่อนจึงจะโหลดได้",
    ["Settings loaded"] = "โหลดการตั้งค่าแล้ว",
    ["Saved settings have been applied."] = "ใช้การตั้งค่าที่บันทึกไว้แล้ว",
    ["Interface components"] = "คอมโพเนนต์หน้าตา UI",
    ["Built with Astra UI"] = "สร้างด้วย Astra UI",
    ["This demo is composed from the library's Cards, Sections, controls, status messages, and notifications. It does not create custom Roblox UI elements."] = "เดโมนี้ประกอบด้วย Cards, Sections, controls, สถานะ และการแจ้งเตือนจากไลบรารี โดยไม่สร้าง UI ของ Roblox เอง",
    ["Live session"] = "เซสชันสด",
    ["Show notification"] = "แสดงการแจ้งเตือน",
    ["Preview the dashboard notification style."] = "ดูตัวอย่างรูปแบบการแจ้งเตือนของแดชบอร์ด",
    ["The notification system is working."] = "ระบบแจ้งเตือนทำงานแล้ว",
    ["Demo actions"] = "การทำงานเดโม",
    ["Update demo status"] = "อัปเดตสถานะเดโม",
    ["Dashboard ready"] = "แดชบอร์ดพร้อมใช้งาน",
    ["Live server metrics are now connected to this session."] = "เชื่อมต่อข้อมูลเซิร์ฟเวอร์สดกับเซสชันนี้แล้ว",
}

local function formatDuration(seconds)
    seconds = math.max(0, math.floor(seconds))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainder = seconds % 60
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, remainder)
    end
    return string.format("%02d:%02d", minutes, remainder)
end

local window = AstraUI:CreateWindow({
    Title = "Astra Analytics",
    Subtitle = "Live experience dashboard",
    HeaderVersion = "v0.1.0",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    RestoreImageUrl = "https://i.ibb.co/tMv26Nr5/hi-guys-im-collecting-lilith-pictures-i-hope-you-guys-can-v0-jbwkdcepgjgf1.png",
    Responsive = true,
    Resizable = true,
    Draggable = true,
    Theme = {
        CornerRadius = 10,
    },
    Localization = {
        Locale = "en-US",
        Resolve = function(locale, key, fallback)
            if string.sub(locale, 1, 2) == "th" then
                return THAI_TEXT[key] or fallback
            end
            return fallback
        end,
    },
})

window:Search({
    Placeholder = "Search",
    Icon = "search",
})

local dashboard = window:Tab({
    Id = "overview",
    Name = "Overview",
    Category = "Experience",
    Icon = "house",
})

local playersTab = window:Tab({
    Id = "players",
    Name = "Players",
    Category = "Experience",
    Icon = "users",
})

local controlsTab = window:Tab({
    Id = "controls",
    Name = "Controls",
    Category = "Interface",
    Icon = "settings",
})

local componentsTab = window:Tab({
    Id = "components",
    Name = "Components",
    Category = "Interface",
    Icon = "layout-dashboard",
})

local sessionStarted = os.clock()
local activity = {}
local samples = {}
local sampleInterval = 10
local lastSample = 0

local onlineCard = dashboard:Card({
    Title = "PLAYERS ONLINE",
    Value = "0",
    Description = "Players in this server",
    Accent = "Green",
    Icon = "users",
})

local capacityCard = dashboard:Card({
    Title = "SERVER CAPACITY",
    Value = "0 / 0",
    Description = "Current players and server limit",
    Icon = "server",
})

local pingCard = dashboard:Card({
    Title = "YOUR PING",
    Value = "-- ms",
    Description = "Current network latency",
    Accent = "Green",
    Icon = "activity",
})

local sessionCard = dashboard:Card({
    Title = "SESSION TIME",
    Value = "00:00",
    Description = "Since dashboard opened",
    Accent = "None",
    Icon = "clock-3",
})

local liveControls = dashboard:Section({
    Name = "Live dashboard",
    Icon = "activity",
})

local activitySection = dashboard:Section({
    Name = "Capacity and recent activity",
    Side = "Left",
    Icon = "server",
})

local capacityProgress = activitySection:Progress({
    Name = "Server capacity",
    Description = "Current players compared with the server limit.",
    Value = 0,
    ShowValue = true,
})

local capacityDetails = activitySection:Paragraph({
    Title = "Available slots",
    Content = "Waiting for live server data...",
})

local activityLog = activitySection:Paragraph({
    Title = "Recent activity",
    Content = "Dashboard connected",
})

local trendsSection = dashboard:Section({
    Name = "Recent player activity",
    Side = "Right",
    Icon = "chart-no-axes-column-increasing",
})

local activityTrend = trendsSection:Paragraph({
    Content = "Collecting player count samples...",
})

local livePlayersSection = dashboard:Section({
    Name = "Players in this server",
    Side = "Right",
    Icon = "users",
})

local livePlayers = livePlayersSection:Paragraph({
    Content = "Waiting for players...",
})

local playersSection = playersTab:Section({
    Name = "This server",
    Icon = "server",
})

playersSection:PlayerDropdown({
    Name = "Choose player",
    Description = "Choose a player from this server.",
    Placeholder = "Select a player...",
    EmptyText = "No players are currently available.",
    ExcludeLocalPlayer = false,
})

playersSection:State({
    Title = "Server connection",
    Description = "Connected to the current Roblox experience.",
    Type = "Success",
    Icon = "circle-check",
})

playersSection:Button({
    Name = "Return to overview",
    Description = "Go back to the live dashboard.",
    Icon = "layout-dashboard",
    Callback = function()
        window:SetState({
            Version = 1,
            SelectedTab = "overview",
            Values = {},
        })
    end,
})

local function getSortedPlayers()
    local currentPlayers = Players:GetPlayers()
    table.sort(currentPlayers, function(first, second)
        return string.lower(first.DisplayName) < string.lower(second.DisplayName)
    end)
    return currentPlayers
end

local function updatePlayerLists()
    local currentPlayers = getSortedPlayers()
    local names = {}
    for index, player in ipairs(currentPlayers) do
        local role = player == LocalPlayer and "YOU" or "PLAYER"
        table.insert(names, string.format("%d. %s — %s", index, player.DisplayName, role))
    end
    local content = #names > 0 and table.concat(names, "\n") or "Waiting for players..."
    livePlayers:SetContent(content)
end

local function addActivity(message)
    table.insert(activity, 1, os.date("%H:%M") .. "  " .. message)
    while #activity > 5 do
        table.remove(activity)
    end
    activityLog:SetContent(table.concat(activity, "\n"))
end

local function updateMetrics(collectSample)
    local currentCount = #Players:GetPlayers()
    local maxCount = math.max(1, Players.MaxPlayers)
    local freeSlots = math.max(0, maxCount - currentCount)
    local ping = LocalPlayer and math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) or 0

    onlineCard:SetValue(tostring(currentCount))
    capacityCard:SetValue(string.format("%d / %d", currentCount, maxCount))
    pingCard:SetValue(tostring(ping) .. " ms")
    sessionCard:SetValue(formatDuration(os.clock() - sessionStarted))
    capacityProgress:SetValue(math.clamp(currentCount / maxCount, 0, 1))
    capacityDetails:SetContent(string.format(
        "%d of %d player slots are in use. %d slots available.",
        currentCount,
        maxCount,
        freeSlots
    ))

    if collectSample and os.clock() - lastSample >= sampleInterval then
        lastSample = os.clock()
        table.insert(samples, currentCount)
        while #samples > 8 do
            table.remove(samples, 1)
        end
        local counts = {}
        for _, count in ipairs(samples) do
            table.insert(counts, tostring(count))
        end
        activityTrend:SetContent("Players per sample (latest first): " .. table.concat(counts, "  →  "))
    end
end

local function refreshDashboard()
    updatePlayerLists()
    updateMetrics(true)
end

liveControls:Button({
    Name = "Refresh dashboard",
    Description = "Refresh live player and server metrics.",
    Icon = "refresh-cw",
    Callback = function()
        refreshDashboard()
        addActivity("Dashboard refreshed")
    end,
})

updatePlayerLists()
updateMetrics(true)
addActivity("Dashboard connected")

window:_connect(Players.PlayerAdded, function(player)
    addActivity(player.DisplayName .. " joined the server")
    refreshDashboard()
end)

window:_connect(Players.PlayerRemoving, function(player)
    addActivity(player.DisplayName .. " left the server")
    task.defer(function()
        if not window._destroyed then
            refreshDashboard()
        end
    end)
end)

task.defer(function()
    if not window._destroyed then
        refreshDashboard()
    end
end)

task.spawn(function()
    while not window._destroyed do
        task.wait(1)
        if not window._destroyed then
            updateMetrics(true)
        end
    end
end)

local settings = controlsTab:Section({
    Name = "General preferences",
    Side = "Left",
    Icon = "sliders-horizontal",
})

local notificationsToggle = settings:Toggle({
    Id = "notifications",
    Name = "Enable notifications",
    Description = "Toggle state can be saved and restored.",
    Default = true,
    Callback = function(enabled)
        print("Notifications enabled:", enabled)
    end,
})

local refreshIntervalControl = settings:Slider({
    Id = "refresh-interval",
    Name = "Refresh interval",
    Description = "Adjust the sample interval used by this demo.",
    Min = 5,
    Max = 60,
    Step = 5,
    Default = 10,
    Callback = function(value)
        sampleInterval = value
        print("Refresh interval:", value)
    end,
})

settings:Dropdown({
    Id = "display-density",
    Name = "Display density",
    Options = {"Comfortable", "Compact"},
    Default = "Comfortable",
    Callback = function(value)
        print("Display density:", value)
    end,
})

local appearance = controlsTab:Section({
    Name = "Appearance and actions",
    Side = "Right",
    Icon = "palette",
})

appearance:Input({
    Id = "display-name",
    Name = "Dashboard label",
    Placeholder = "Enter a custom label",
    Default = "",
    MaxLength = 24,
    Callback = function(value)
        print("Dashboard label:", value)
    end,
})

appearance:Keybind({
    Id = "dashboard-key",
    Name = "Toggle dashboard",
    Default = Enum.KeyCode.RightShift,
    Callback = function(keyCode)
        print("Dashboard key:", keyCode.Name)
    end,
})

local accentColorControl = appearance:Colorpicker({
    Id = "accent-color",
    Name = "Accent color",
    Default = ACCENT,
    Callback = function(color)
        window:SetTheme({Accent = color})
    end,
})

local progress = appearance:Progress({
    Name = "Demo progress",
    Value = 0.65,
    ShowValue = true,
})

local stateCard = appearance:State({
    Title = "Connection status",
    Description = "Connected to the current demo experience.",
    Type = "Success",
    Icon = "circle-check",
})

local SETTINGS_FOLDER = "AstraUI"
local SETTINGS_FILE = SETTINGS_FOLDER .. "/AstraAnalytics_" .. tostring(game.PlaceId) .. ".json"
local lastSavedSettings

local function checkFileApi()
    if type(writefile) ~= "function"
        or type(readfile) ~= "function"
        or type(makefolder) ~= "function"
        or type(isfolder) ~= "function"
        or type(isfile) ~= "function" then
        return false, "Required file APIs are unavailable in this environment."
    end
    return true
end

local function encodeSettings()
    return HttpService:JSONEncode(window:GetState())
end

local function saveSettings()
    local available, apiError = checkFileApi()
    if not available then
        return false, apiError
    end
    local ok, encodedOrError = pcall(encodeSettings)
    if not ok then
        return false, tostring(encodedOrError)
    end
    local encoded = encodedOrError
    local writeOk, writeError = pcall(function()
        if not isfolder(SETTINGS_FOLDER) then
            makefolder(SETTINGS_FOLDER)
        end
        writefile(SETTINGS_FILE, encoded)
    end)
    if not writeOk then
        return false, tostring(writeError)
    end
    lastSavedSettings = encoded
    return true
end

local function loadSettings()
    local available, apiError = checkFileApi()
    if not available then
        return false, apiError
    end
    local ok, stateOrError = pcall(function()
        if not isfolder(SETTINGS_FOLDER) or not isfile(SETTINGS_FILE) then
            return nil
        end
        return HttpService:JSONDecode(readfile(SETTINGS_FILE))
    end)
    if not ok then
        return false, tostring(stateOrError)
    end
    local savedState = stateOrError
    if savedState == nil then
        return false, nil
    end
    if type(savedState) ~= "table" or type(savedState.Values) ~= "table" then
        return false, "Saved settings file has an invalid format."
    end
    window:SetState(savedState)
    sampleInterval = refreshIntervalControl:GetValue()
    window:SetTheme({Accent = accentColorControl:GetValue()})
    lastSavedSettings = encodeSettings()
    return true
end

local _, loadError = loadSettings()
if loadError then
    warn("[AstraUI] Could not load saved settings: " .. loadError)
end
if not lastSavedSettings then
    local encoded, stateOrError = pcall(encodeSettings)
    if encoded then
        lastSavedSettings = stateOrError
    else
        warn("[AstraUI] Could not prepare autosave: " .. tostring(stateOrError))
    end
end

local autosaveAvailable, autosaveApiError = checkFileApi()
if autosaveAvailable then
    task.spawn(function()
        while not window._destroyed do
            task.wait(1)
            if window._destroyed then
                break
            end
            local encoded, currentSettings = pcall(encodeSettings)
            if not encoded then
                warn("[AstraUI] Autosave could not encode settings: " .. tostring(currentSettings))
                break
            end
            if currentSettings ~= lastSavedSettings then
                local saved, err = saveSettings()
                if not saved then
                    warn("[AstraUI] Autosave stopped: " .. tostring(err))
                    break
                end
            end
        end
    end)
else
    warn("[AstraUI] Autosave unavailable: " .. tostring(autosaveApiError))
end

appearance:Button({
    Name = "Save settings",
    Icon = "save",
    Callback = function()
        local saved, err = saveSettings()
        if not saved then
            window:Notify({
                Type = "Error",
                Title = "Could not save settings",
                Content = err or "No saved settings file was found.",
            })
            return
        end
        window:Notify({
            Type = "Success",
            Title = "Settings saved",
            Content = "Your settings were saved to a local file.",
        })
    end,
})

appearance:Button({
    Name = "Load settings",
    Icon = "rotate-ccw",
    Callback = function()
        local loaded, err = loadSettings()
        if not loaded then
            if err then
                window:Notify({
                    Type = "Error",
                    Title = "Could not load settings",
                    Content = err,
                })
                return
            end
            window:Notify({
                Type = "Warning",
                Title = "No saved settings",
                Content = "Save settings once before loading them.",
            })
            return
        end
        window:Notify({
            Type = "Success",
            Title = "Settings loaded",
            Content = "Saved settings have been applied.",
        })
    end,
})

local components = componentsTab:Section({
    Name = "Interface components",
    Icon = "blocks",
})

components:Paragraph({
    Title = "Built with Astra UI",
    Content = "This demo is composed from the library's Cards, Sections, controls, status messages, and notifications. It does not create custom Roblox UI elements.",
})

components:Badge({
    Text = "Live session",
    Type = "Success",
})

components:Divider()

components:Button({
    Name = "Show notification",
    Description = "Preview the dashboard notification style.",
    Icon = "bell",
    Callback = function()
        window:Notify({
            Type = "Info",
            Title = "Astra Analytics",
            Content = "The notification system is working.",
            Duration = 4,
        })
    end,
})

components:Accordion({
    Name = "Demo actions",
    DefaultOpen = false,
}, function(actions)
    actions:Button({
        Name = "Update demo status",
        Icon = "refresh-cw",
        Callback = function()
            notificationsToggle:SetValue(not notificationsToggle:GetValue())
            progress:SetValue(math.random(0, 100) / 100)
            stateCard:SetState("Success", "Demo status updated just now.")
        end,
    })
end)

window:Notify({
    Type = "Success",
    Title = "Dashboard ready",
    Content = "Live server metrics are now connected to this session.",
    Duration = 4,
})
