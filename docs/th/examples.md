# ตัวอย่างฉบับเต็ม

ตัวอย่างนี้แสดงรูปแบบการประกอบ UI ของไลบรารี ตั้งแต่โหลดด้วย `loadstring` ต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` เนื่องจาก bootstrap ไอคอนปัจจุบันไม่รองรับ `LocalScript` ใน Roblox client มาตรฐาน ดู [การเริ่มต้นใช้งาน](getting-started.md)

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "Session Dashboard",
    Subtitle = "My experience",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
        AccentSecondary = Color3.fromRGB(46, 211, 159),
    },
})

local overview = window:Tab({
    Id = "overview",
    Name = "Overview",
    Category = "Dashboard",
    Icon = "house",
})

local online = overview:Card({
    Id = "online",
    Title = "Players online",
    Value = #game:GetService("Players"):GetPlayers(),
    Description = "Players in the current server.",
    Icon = "users",
})

local settings = overview:Section({
    Name = "Preferences",
    Side = "Left",
})

local notifications = settings:Toggle({
    Id = "notifications",
    Name = "Notifications",
    Default = true,
    Callback = function(enabled)
        print("Notifications:", enabled)
    end,
})

settings:Slider({
    Id = "volume",
    Name = "Volume",
    Min = 0,
    Max = 1,
    Step = 0.05,
    Default = 0.5,
    Callback = function(value)
        print("Volume:", value)
    end,
})

settings:Dropdown({
    Id = "quality",
    Name = "Quality",
    Options = {"Low", "Medium", "High"},
    Default = "Medium",
})

local status = overview:Section({
    Name = "Session",
    Side = "Right",
})

local connection = status:State({
    Id = "connection-status",
    Type = "Success",
    Title = "Connected",
    Description = "The session is ready.",
    Icon = "circle-check",
})

status:Button({
    Name = "Refresh",
    Callback = function()
        online:SetValue(#game:GetService("Players"):GetPlayers())
        connection:SetState("Success", "Updated just now.")
        if notifications:GetValue() then
            window:Notify({
                Type = "Info",
                Title = "Updated",
                Content = "Dashboard values refreshed.",
            })
        end
    end,
})

window:Search({Placeholder = "Search tabs", Icon = "search"})
```

ไลบรารี UI มีหน้าที่สร้างส่วนติดต่อเท่านั้น ให้เชื่อม callback เข้ากับตรรกะเกมที่คุณเป็นเจ้าของ และตรวจสอบการกระทำของเกมที่เซิร์ฟเวอร์เป็นผู้มีอำนาจบนเซิร์ฟเวอร์เสมอ
