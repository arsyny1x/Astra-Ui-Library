# การ์ด แอคคอร์เดียน และ UI แบบกำหนดเอง

## การ์ด Bento

เพิ่มการ์ดลงบนแท็บโดยตรง การ์ดจะจัดเรียงใหม่ได้ตั้งแต่หนึ่งถึงสองคอลัมน์:

```lua
local count = tab:Card({
    Id = "online-count",
    Title = "Players online",
    Value = 12,
    Description = "Players in this server.",
    Icon = "users",
    Size = "Small",
    Accent = "Blue",
})

count:SetValue(14)
print(count:GetValue())
```

| ฟิลด์ | ความหมาย |
|---|---|
| `Title` | ชื่อการ์ด (จำเป็น) |
| `Value` | ค่าที่จะแสดง (ไม่บังคับ) |
| `Description` | ข้อความอธิบายเพิ่มเติม (ไม่บังคับ) |
| `Icon` | ชื่อไอคอน (ไม่บังคับ) |
| `Size` | `"Auto"` (ค่าเริ่มต้น), `"Small"`, `"Medium"` หรือ `"Wide"` |
| `Height` | ความสูงขั้นต่ำที่เป็นบวก (ไม่บังคับ) |
| `Accent` | `"Green"` หรือ `"Cyan"` ใช้สีเน้นรอง, `"None"` ใช้สีเส้นขอบ และค่าอื่นหรือไม่กำหนดจะใช้สีเน้นหลัก |

`SetValue(value)` อัปเดตค่าที่แสดงและจัดวางการ์ดใหม่ ส่วน `GetValue()` คืนค่าปัจจุบัน

## Section สองคอลัมน์

กำหนดให้ section อยู่คอลัมน์ซ้ายหรือขวาบนแท็บ:

```lua
tab:Section({Name = "Controls", Side = "Left"})
tab:Section({Name = "Status", Side = "Right"})
```

`Side` ต้องเป็น `"Left"` หรือ `"Right"` คอลัมน์จะซ้อนกันเมื่อพื้นที่เนื้อหาที่แสดงแคบกว่าความกว้างขั้นต่ำ 360 พิกเซล ซึ่งปรับตาม UI scale กลาง บนมือถือจะยังจัดสองคอลัมน์เมื่อพื้นที่หลังปรับ scale มีขนาดพอ

## Accordion

Accordion สร้าง section ซ้อนอยู่ภายในผ่าน callback:

```lua
local advanced = section:Accordion({
    Id = "advanced",
    Name = "Advanced",
    DefaultOpen = false,
}, function(inner)
    inner:Toggle({
        Id = "debug-mode",
        Name = "Debug mode",
        Default = false,
    })
end)

advanced:SetExpanded(true)
```

ต้องกำหนด callback `build` ซึ่งจะได้รับ section ภายในและสามารถใช้ตัวควบคุมทั่วไปได้ `DefaultOpen` กำหนดสถานะเริ่มต้น และ `SetExpanded(boolean)` ใช้เปลี่ยนสถานะ หากสร้างไม่สำเร็จจะแสดงข้อผิดพลาดใน Roblox Output

## ส่วนประกอบแบบกำหนดเอง

ใช้ `Custom` สำหรับ UI ที่สร้างด้วยตัวควบคุมมาตรฐานไม่ได้:

```lua
local custom = section:Custom({
    Id = "custom-meter",
    Height = 48,
    Build = function(host, context)
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Text = "Custom content"
        label.Parent = host

        context:RegisterCleanup(function()
            print("Clean up custom connections/resources here")
        end)

        return label
    end,
})
```

`Height` ต้องเป็นตัวเลขบวกและต้องกำหนด `Build` โดย `Build(host, context)` ต้องคืนค่าเป็น `GuiObject` ส่วนประกอบนี้ใช้เฉพาะ `Id`, `Height` และ `Build` เท่านั้น context มีเมธอด:

- `GetTheme()` — สำเนาของ token ธีมที่ใช้งานอยู่
- `GetLayoutMode()` — `"Wide"`, `"Compact"` หรือ `"Narrow"`
- `RegisterCleanup(function)` — ลงทะเบียนการล้างทรัพยากรเมื่อเรียก `Destroy()`

`Build` สามารถคืน cleanup function เป็นค่าที่สองได้ ใช้ฟังก์ชัน Luau ปกติในเครื่อง ห้ามส่งสตริงโค้ดหรือรันสคริปต์จากระยะไกล/ผู้ใช้
