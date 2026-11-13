# สถานะและการแปลภาษา

## บันทึกและคืนค่าสถานะ

กำหนด ID ที่คงที่ให้แท็บและตัวควบคุมค่าที่ต้องการคืนค่าหลังสร้าง UI ใหม่:

```lua
local tab = window:Tab({
    Id = "overview",
    Name = "Overview",
})

local section = tab:Section({
    Name = "Preferences",
})

section:Toggle({
    Id = "notifications",
    Name = "Notifications",
    Default = true,
})

local state = window:GetState()
window:SetState(state)
```

ตารางสถานะประกอบด้วยการตั้งค่าหน้าต่างที่รองรับและค่าของตัวควบคุมที่กำหนด ID ไว้ `SetState` ตรวจสอบค่าก่อนใช้และจะไม่เรียก callback ของผู้ใช้ หากพบ ID ที่ไม่รู้จัก ระบบจะข้ามพร้อมแสดงข้อความวินิจฉัย การเลือกผู้เล่นใน dropdown มีผลเฉพาะระหว่างรันไทม์และจะไม่ถูก serialize

ไลบรารีจะไม่เขียนสถานะลง data store หรือไฟล์ การจัดเก็บและย้ายรูปแบบข้อมูลเป็นหน้าที่ของ experience ที่นำไปใช้ ส่วน demo มีตัวอย่างบันทึกไฟล์ JSON เป็นตัวเลือก แต่ API ระบบไฟล์ที่ใช้ไม่ใช่ API มาตรฐานของ Roblox

## การแปลภาษา

กำหนด locale และ resolver (ไม่บังคับ) เมื่อสร้างหน้าต่าง:

```lua
local window = AstraUI:CreateWindow({
    Title = "Control Center",
    Localization = {
        Locale = "th-TH",
        Resolve = function(locale, key, fallback)
            if locale == "th-TH" then
                return translations[key] or fallback
            end
            return fallback
        end,
    },
})

window:SetLocale("en-US")
```

resolver จะได้รับ locale, text key และข้อความสำรอง `SetLocale` จะประมวลผลข้อความ UI ที่ลงทะเบียนไว้อีกครั้ง
