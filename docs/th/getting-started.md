# ติดตั้งและสร้างหน้าต่างแรก

## โหลดด้วย loadstring (สำหรับสภาพแวดล้อม executor)

ใช้ bootstrap นี้เฉพาะใน executor หรือ runtime อื่นที่รองรับทั้ง `game:HttpGet` และ `loadstring`:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

`main.lua` ในปัจจุบันดาวน์โหลดและรันไลบรารีไอคอน Lucide และ Solar ระหว่างเริ่มทำงาน จึงใช้กับ `LocalScript` ใน Roblox client มาตรฐานไม่ได้ หากใช้ใน experience ที่คุณเป็นเจ้าของ ให้ปรับ loader เพื่อใช้ dependency ไอคอนที่ตรวจสอบแล้วและรวมไว้ในโปรเจกต์ ดู [การแก้ไขปัญหา](troubleshooting.md)

## สร้างหน้าต่าง

หลังโหลดใน runtime ที่รองรับแล้ว ให้สร้างหน้าต่างแรก:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Subtitle = "Welcome",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
})

local home = window:Tab({
    Id = "home",
    Name = "Home",
    Icon = "house",
})

local section = home:Section({
    Name = "Settings",
})

section:Toggle({
    Id = "notifications",
    Name = "Enable notifications",
    Default = true,
    Callback = function(enabled)
        print("Notifications:", enabled)
    end,
})
```

## ข้อกำหนด

- ต้องใช้ executor หรือสภาพแวดล้อมที่รองรับ `game:HttpGet` และ `loadstring` (เช่น Potassium หรือ executor อื่นที่รองรับ) `LocalScript` ใน Roblox client มาตรฐานยังใช้ bootstrap ไอคอนจากระยะไกลนี้ไม่ได้
- การแสดง PNG ต้องใช้ Roblox ที่รองรับ `EditableImage` และได้รับสิทธิ์ที่จำเป็น
- ฟังก์ชันบันทึก/โหลดการตั้งค่าใน demo ใช้ `readfile` / `writefile` ซึ่งเป็น API จาก executor ไม่ใช่ API มาตรฐานของ Roblox

ดู [`demo.lua`](https://github.com/arsyny1x/Astra-Ui-Library/blob/main/demo.lua) สำหรับตัวอย่างแดชบอร์ดฉบับเต็ม
