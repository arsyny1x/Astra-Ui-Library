# เริ่มต้นอย่างรวดเร็ว

## โหลด Astra UI

ตัวอย่างนี้ต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ไลบรารีปัจจุบันดาวน์โหลดและรันไลบรารีไอคอนระหว่างโหลด จึงใช้กับ `LocalScript` ใน Roblox client มาตรฐานโดยตรงไม่ได้ ดู [การเริ่มต้นใช้งาน](getting-started.md)

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

## สร้างหน้าต่าง

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "Game Dashboard",
    Subtitle = "Local experience status",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
})

local home = window:Tab({
    Id = "home",
    Name = "Home",
    Category = "Game",
    Icon = "house",
})

local status = home:Section({
    Name = "Status",
    Icon = "activity",
})

local enabled = status:Toggle({
    Id = "feature-enabled",
    Name = "Enable feature",
    Default = false,
    Callback = function(value)
        print("Feature enabled:", value)
    end,
})

status:Button({
    Name = "Show toast",
    Icon = "bell",
    Callback = function()
        window:Notify({
            Type = "Success",
            Title = "Ready",
            Content = "The local UI action ran.",
        })
    end,
})
```

## อ่านและกำหนดค่า

```lua
enabled:SetValue(true)
print("Current value:", enabled:GetValue())
```

ดูข้อมูลอ้างอิงทั้งหมดใน [ปุ่มและตัวควบคุมค่า](controls.md), [ส่วนประกอบแสดงผล](display-components.md) และ [Window API](window-api.md)
