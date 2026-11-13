# ภาพรวมส่วนประกอบ

Astra UI ใช้โครงสร้าง **window → tab → section → component** โดยสร้างการ์ดไว้บนแท็บโดยตรง กำหนด ID ที่คงที่ให้ค่าที่ต้องการบันทึกด้วย `GetState()`

```lua
local window = AstraUI:CreateWindow({Title = "Example"})
local tab = window:Tab({Id = "home", Name = "Home"})
local section = tab:Section({Name = "Preferences"})

section:Toggle({
    Id = "sound",
    Name = "Sound",
    Description = "Enable interface sounds.",
    Default = true,
    Callback = function(enabled)
        print("Sound:", enabled)
    end,
})
```

## ฟิลด์ทั่วไปของตัวควบคุม

ตัวควบคุมส่วนใหญ่ใน section รองรับฟิลด์ต่อไปนี้:

| ฟิลด์ | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อที่แสดงบนตัวควบคุม หากไม่มี `Name` ตัวสร้างแถวกลางจะใช้ `Title` แทน |
| `Description` | string? | ข้อความอธิบายเพิ่มเติมที่แสดงใต้ชื่อ |
| `Id` | string? | ID ที่ไม่ซ้ำและคงที่สำหรับบันทึกสถานะ |
| `Enabled` | boolean? | เริ่มต้นเป็นเปิด เว้นแต่กำหนดเป็น `false` |
| `Callback` | function? | เรียกเมื่อผู้ใช้เปลี่ยนค่า การคืนค่าสถานะและ `SetValue()` จะไม่เรียก callback นี้ |

ตัวควบคุมที่มีค่ารองรับ `GetValue()` และ `SetValue(value)` ส่วน `SetEnabled(boolean)` ใช้เปิดหรือปิดการโต้ตอบที่รองรับ และลบส่วนประกอบได้ด้วย `Destroy()`

## ตัวควบคุม

ดูรายการฟิลด์และตัวอย่างที่ใช้งานได้ใน [ปุ่มและตัวควบคุมค่า](controls.md) ตัวควบคุมที่มีได้แก่:

- `Button`, `Toggle`, `Slider`
- `Dropdown`, `MultiDropdown`, `PlayerDropdown`
- `Input`, `Keybind`, `Colorpicker`

## ส่วนประกอบแสดงผล

ดู [ส่วนประกอบแสดงผล](display-components.md) สำหรับ `Paragraph`, `Divider`, `Progress`, `State`, `EmptyState` และ `Badge`

## การ์ดและการจัดวาง

ดู [การ์ด แอคคอร์เดียน และ UI แบบกำหนดเอง](layout-components.md) สำหรับการ์ด Bento, section แบบแอคคอร์เดียน, section สองคอลัมน์ และส่วนประกอบที่กำหนดเอง

## การค้นหาและการนำทาง

- `window:Search(config)` เพิ่มช่องค้นหาเพียงช่องเดียวใน sidebar
- `tab:Search(config)` เป็น alias ของการค้นหาในหน้าต่าง
- แท็บรองรับ `Name`, `Id` (ไม่บังคับ), `Icon` และ `Category`
- Section รองรับ `Name`, `Icon` (ไม่บังคับ) และ `Side = "Left"` หรือ `"Right"` (ไม่บังคับ) เพื่อจัดวางสองคอลัมน์

อ่าน [Window API](window-api.md) สำหรับ constructor และเมธอดของหน้าต่างทั้งหมด
