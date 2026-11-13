# Window API

## สร้างหน้าต่าง

bootstrap แบบ `loadstring` ด้านล่างต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ไลบรารีปัจจุบันโหลด dependency ไอคอนจากระยะไกลระหว่างเริ่มทำงาน จึงใช้กับ `LocalScript` ใน Roblox client มาตรฐานไม่ได้ ดู [การเริ่มต้นใช้งาน](getting-started.md)

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
local window = AstraUI:CreateWindow(config)
```

`CreateWindow` คืนออบเจ็กต์หน้าต่าง โดยใช้ธีม Lilith เป็นค่าเริ่มต้น ขนาดเริ่มต้นคือ `UDim2.fromOffset(800, 500)` หน้าต่างจะปรับให้พอดีกับ viewport ที่ใช้ได้ รวมถึงหน้าจอขนาดเล็ก บน Android และ iOS หน้าต่าง เนื้อหา ป๊อปอัป และ toast ใช้ global scale ร่วมกันที่ 70-80% ระบบเลือกคอลัมน์ responsive จากความกว้างที่แสดงหลังปรับ scale ส่วนปุ่มเปิด/ซ่อนแบบลอยจะคงขนาดเดิม พื้นหลังและเส้นขอบของปุ่มจะค่อย ๆ จางเมื่อเปลี่ยนการแสดงผลผ่าน `SetVisible`, ปุ่ม restore หรือปุ่ม toggle

| ฟิลด์ | ชนิด | ค่าเริ่มต้น / หมายเหตุ |
|---|---|---|
| `Title` | string | `"Astra UI"` |
| `Subtitle` | string? | ข้อความรอง (ไม่บังคับ) |
| `HeaderVersion` | string? | ข้อความเวอร์ชันในส่วนหัว (ไม่บังคับ) |
| `Size` | `UDim2`? | ขนาดเริ่มต้น ค่าเริ่มต้น 800 × 500 พิกเซล |
| `ToggleKey` | `Enum.KeyCode`? | ปุ่มสำหรับสลับการแสดงผล (ไม่บังคับ) |
| `Responsive` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Resizable` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Draggable` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Theme` | table? | ค่า override บางส่วนของ token ธีม โดยค่าต้องตรงกับชนิดของ token |
| `Localization` | table? | การตั้งค่า locale และ resolver สำหรับการแปลภาษา |
| `Parent` | `Instance`? | GUI parent ค่าเริ่มต้นคือ `gethui()` (alias: `get_hidden_gui()`) หากระบุจะใช้ค่านี้แทน |
| `RestoreImageUrl` | string? | URL HTTP(S) ของรูป PNG สำหรับปุ่ม restore |
| `PngDecoder` | table? | ตัวถอดรหัสที่เปิดเผย `decode(buffer, options)` |
| `PngDecoderUrl` | string? | เปลี่ยน URL ของตัวถอดรหัสระยะไกล (ไม่บังคับ) ค่าเริ่มต้นเป็น URL `luau-png` ที่มาพร้อมกัน หากไม่พบโมดูลจะดาวน์โหลดและรันโค้ด |
| `Discord` | table? | `Url` และ callback `Copy` (ไม่บังคับ) |
| `IconLibrary` | table? | ไลบรารีที่เข้ากันได้กับ Lucide และเปิดเผย `GetAsset(name)` |
| `IconLibraries` | table? | ไลบรารีไอคอนที่ตั้งชื่อตามชนิด โดย Lucide เปิดเผย `GetAsset` และ Solar เป็นตารางไอคอน |

`IconLibrary` เป็น alias ที่เข้ากันได้กับ `IconLibraries.Lucide` ชื่อไอคอนมาจากไลบรารีที่รวมไว้ ดู [การติดตั้ง](getting-started.md) สำหรับข้อจำกัดของ bootstrap ไอคอนระยะไกลใน runtime ปัจจุบัน

## สร้างแท็บและ section

```lua
local tab = window:Tab({
    Id = "settings",
    Name = "Settings",
    Icon = "settings",
    Category = "Configuration",
})

local section = tab:Section({
    Name = "General",
    Icon = "sliders-horizontal",
})
```

- แท็บต้องมี `Name` ส่วน `Id`, `Icon` และ `Category` เป็นตัวเลือก
- `Name` ของ section ไม่จำเป็นต้องกำหนด `Icon` เป็นตัวเลือก ส่วน `Side` กำหนดเป็น `"Left"` หรือ `"Right"` เพื่อจัด section เคียงกันแบบ responsive ได้
- ID ควรไม่ซ้ำกันภายในหน้าต่างเดียว หากซ้ำ ระบบจะปฏิเสธ

## เมธอดของหน้าต่าง

| เมธอด | การทำงาน |
|---|---|
| `Tab(config)` | สร้างและคืนค่าแท็บ |
| `Search(config)` | เพิ่มช่องค้นหาใน sidebar การเรียกซ้ำจะคืนช่องค้นหาเดิม |
| `Notify(config)` | แสดง toast และคืนค่า toast (`toast:Dismiss()` ใช้ปิด) |
| `Dialog(config)` | แสดงกล่องโต้ตอบแบบ modal และคืน `{Close, Destroy}` |
| `SetVisible(boolean)` | แสดงหรือซ่อนหน้าต่าง |
| `SetSize(UDim2)` | กำหนดขนาดที่ต้องการ |
| `SetTheme(theme)` | ใช้ค่า override บางส่วนของ token ธีม |
| `SetThemePreset(name)` | เลือก `"Dark"`, `"Light"` หรือ `"Lilith"` |
| `SetLocale(locale)` | เปลี่ยน locale และประมวลผลข้อความที่ลงทะเบียนไว้อีกครั้ง |
| `SetToggleKey(Enum.KeyCode)` | เปลี่ยนปุ่ม toggle สำหรับแสดง/ซ่อน |
| `SetResizable(boolean)` | เปิดหรือปิดการปรับขนาด |
| `SetDraggable(boolean)` | เปิดหรือปิดการลาก |
| `OpenSettings()` | เปิดแผงการตั้งค่าของไลบรารี |
| `SetHeaderVersion(stringOrNil)` | เปลี่ยนหรือล้างเวอร์ชันในส่วนหัว |
| `SetDiscordLink(urlOrNil, copyCallback)` | กำหนดหรือแทนที่การทำงานของลิงก์ Discord |
| `GetState()` | คืนค่าตารางสถานะที่ serialize ได้ |
| `SetState(stateTable)` | ตรวจสอบและคืนค่าสถานะหน้าต่าง/ส่วนประกอบที่รองรับ |
| `Destroy()` | ทำลายหน้าต่างและ connection ที่เป็นของหน้าต่าง |

## ค้นหาใน sidebar

```lua
local search = window:Search({
    Placeholder = "Find a tab",
    Icon = "search",
})
```

ค่าเริ่มต้นของ `Placeholder` คือ `"Search"` และของ `Icon` คือ `"search"` ส่วน `tab:Search(config)` เป็น alias ของ `window:Search(config)`

## การแจ้งเตือน

```lua
local toast = window:Notify({
    Type = "Success",
    Title = "Saved",
    Content = "Your preferences were updated.",
    Duration = 4,
})

toast:Dismiss()
```

`Type` รองรับ `"Success"`, `"Info"` (ค่าเริ่มต้น), `"Warning"` หรือ `"Error"` `Title` จะใช้ชนิดเป็นค่าเริ่มต้น `Content` เริ่มต้นเป็นข้อความว่าง และ `Duration` เริ่มต้น 3 วินาที หากกำหนดระยะเวลาเป็น `0` จะไม่ปิดอัตโนมัติ เก็บ toast ได้สูงสุดสี่รายการ เมื่อเพิ่มรายการใหม่จะปิดรายการที่เก่าที่สุด

## กล่องโต้ตอบ

```lua
local dialog = window:Dialog({
    Title = "Reset settings?",
    Content = "This action cannot be undone.",
    Actions = {
        {
            Name = "Cancel",
            Style = "Secondary",
        },
        {
            Name = "Reset",
            Style = "Danger",
            Callback = function()
                print("Reset confirmed")
            end,
        },
    },
})
```

`Actions` ต้องเป็น array ที่มีอย่างน้อยหนึ่งรายการ แต่ละ action ต้องมี `Name` ส่วน `Style` รองรับ `"Primary"` (ค่าเริ่มต้น), `"Secondary"` หรือ `"Danger"` `Callback` เป็นตัวเลือก action จะปิดกล่องโต้ตอบหลังคลิกเป็นค่าเริ่มต้น หากต้องการเปิดค้างไว้ให้กำหนด `Close = false` ออบเจ็กต์ที่คืนมามีเมธอด `Close()` และ `Destroy()`

## ธีมและการตั้งค่า

```lua
window:SetThemePreset("Light")
window:SetTheme({
    Accent = Color3.fromRGB(120, 110, 255),
})
window:SetToggleKey(Enum.KeyCode.RightControl)
window:SetVisible(false)
```

ธีมที่มีคือ `"Dark"`, `"Light"` และ `"Lilith"` `SetTheme` จะผสานค่า override บางส่วน ชื่อ token และพฤติกรรมของ preset อธิบายไว้ใน [ธีม](themes.md)

## การ serialize สถานะ

```lua
local state = window:GetState()
-- เก็บสถานะด้วยวิธีจัดเก็บข้อมูลที่เหมาะกับ experience ของคุณเอง
window:SetState(state)
```

`GetState()` คืน `Version = 1`, ID แท็บที่เลือก, preset ธีม, locale, ชื่อปุ่ม toggle, การตั้งค่าปรับขนาด/ลาก และค่าของส่วนประกอบที่มี ID และ `GetValue()` ค่าสีแทนด้วย `{R, G, B}` ส่วนปุ่มลัดแทนด้วยชื่อปุ่ม `SetState()` ใช้การตั้งค่าที่รองรับและค่าของส่วนประกอบที่ตรงกัน ส่วน ID ที่ไม่รู้จักและค่าที่ไม่ถูกต้องจะแสดงคำเตือนแล้วข้าม การเลือก `PlayerDropdown` และส่วนประกอบที่ใช้แสดงผลเท่านั้นจะไม่ถูก serialize

ไลบรารี UI ไม่ได้บันทึกข้อมูลให้เอง ให้ใช้ระบบจัดเก็บของ Roblox ที่เหมาะกับ experience และอย่าเชื่อถือสถานะจาก client สำหรับการกระทำในเกมที่เซิร์ฟเวอร์เป็นผู้มีอำนาจ

## Callback ของลิงก์ Discord

`Discord = {Url = "...", Copy = function(url) ... end}` ใช้กำหนดลิงก์และ callback คัดลอกที่ host จัดการเอง ไลบรารีไม่มีความสามารถเข้าถึง clipboard ส่วน `SetDiscordLink(urlOrNil, copyCallback)` ใช้แทนการตั้งค่านี้ขณะรันไทม์
