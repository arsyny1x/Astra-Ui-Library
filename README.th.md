# Astra UI

**[English](README.md) | [ไทย](README.th.md)**

Astra UI คือไลบรารีส่วนติดต่อผู้ใช้ (UI) สำหรับ Roblox ที่เขียนด้วย Luau และสร้างจาก GUI object มาตรฐานของ Roblox มีหน้าต่างที่ปรับตามขนาดจอ แท็บ ส่วนประกอบย่อย การ์ด ตัวควบคุมแบบโต้ตอบ ธีม การแจ้งเตือน กล่องโต้ตอบ การเลือกผู้เล่น และการบันทึกสถานะ

## ความสามารถ

- เลย์เอาต์สำหรับเดสก์ท็อปและมือถือ พร้อมหน้าต่างที่ลากและปรับขนาดได้
- ธีม Dark, Light และ Lilith พร้อมปรับแต่งค่าสีและรูปแบบของธีมได้
- แท็บ เมนูแบบจัดหมวดหมู่ ส่วนประกอบ การ์ด และช่องค้นหา
- ปุ่ม สวิตช์ แถบเลื่อน เมนูแบบเลื่อนลง เมนูเลือกหลายรายการ และเมนูเลือกผู้เล่น
- ช่องกรอกข้อมูล ปุ่มลัด สี ตัวบอกความคืบหน้า แผงสถานะ และป้ายกำกับ
- การแจ้งเตือน กล่องโต้ตอบ จุดเชื่อมต่อสำหรับการแปลภาษา และการจัดเก็บสถานะของหน้าต่าง
- รองรับรูป PNG และ JPEG สำหรับปุ่มเปิดหน้าต่างแบบลอยและภาพพื้นหลังของธีม Lilith
- มีตัวถอดรหัส PNG และ JPEG ทั้ง baseline/progressive สำหรับ Luau พร้อมรองรับการ yield ระหว่างประมวลผล

## ไฟล์

| ไฟล์ | คำอธิบาย |
|---|---|
| `main.lua` | ไลบรารี Astra UI; การโหลดไอคอนจากระยะไกลในปัจจุบันต้องใช้ `game:HttpGet` และ `loadstring` |
| `demo.lua` | ตัวอย่างแดชบอร์ดที่ใช้ไลบรารี |
| `png.luau` | ตัวถอดรหัส PNG ที่รองรับการ yield |
| `jpeg.luau` | ตัวถอดรหัส JPEG baseline/progressive ที่รองรับการ yield |
| `UI_LIBRARY_SPEC.md` | ข้อกำหนดการออกแบบและ API |
| `LICENSE` | สัญญาอนุญาต MIT |

## ข้อกำหนด

- การโหลดไอคอนจากระยะไกลในปัจจุบันต้องใช้ executor หรือสภาพแวดล้อมที่รองรับ `game:HttpGet` และ `loadstring` (เช่น Potassium หรือ executor อื่นที่รองรับ) จึงยังใช้กับ `LocalScript` ใน Roblox client มาตรฐานโดยตรงไม่ได้
- การแสดงผล PNG และ JPEG ต้องใช้ Roblox ที่รองรับ `EditableImage` และได้รับสิทธิ์ที่จำเป็นใน experience/runtime
- ฟังก์ชันบันทึก โหลด และบันทึกอัตโนมัติใน demo ใช้ `readfile` / `writefile` ซึ่งเป็น API จาก executor และไม่มีใน Roblox client มาตรฐาน

## การติดตั้ง

### โหลดด้วย loadstring (สำหรับสภาพแวดล้อม executor)

หากใช้ executor หรือ runtime ที่รองรับ ไม่จำเป็นต้องตั้งค่าใน Studio:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

### รองรับ PNG และ JPEG

ไลบรารีตรวจข้อมูล PNG หรือ JPEG baseline/progressive และโหลดตัวถอดรหัสที่ตรงกันให้อัตโนมัติ เพียงระบุ URL ของรูป:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "แดชบอร์ดของฉัน",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

ไม่จำเป็นต้องตั้งค่าตัวถอดรหัสที่มาพร้อมไลบรารีเพิ่มเติม โดยทั้งสองตัวมีเมธอด `decode(buffer, options)` และพร็อพเพอร์ตี `supportsYieldIfNeeded = true`

### ตัวถอดรหัส JPEG

`jpeg.luau` ถอดรหัส JPEG baseline และ progressive 8-bit แบบ grayscale, RGB และ YCbCr และถูกใช้โดยระบบโหลดรูปภาพของ Astra UI ดูข้อจำกัดได้ที่[คู่มือตัวถอดรหัส JPEG](docs/th/jpeg-images.md)

## เริ่มต้นใช้งานอย่างรวดเร็ว

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "แดชบอร์ดของฉัน",
    Subtitle = "ยินดีต้อนรับ",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
        AccentSecondary = Color3.fromRGB(46, 211, 159),
    },
})

local home = window:Tab({
    Id = "home",
    Name = "หน้าหลัก",
    Icon = "house",
})

local settings = home:Section({
    Name = "การตั้งค่า",
})

settings:Toggle({
    Id = "notifications",
    Name = "เปิดการแจ้งเตือน",
    Default = true,
    Callback = function(enabled)
        print("การแจ้งเตือน:", enabled)
    end,
})

settings:Button({
    Name = "แสดงการแจ้งเตือน",
    Callback = function()
        window:Notify({
            Title = "Astra UI",
            Content = "แดชบอร์ดพร้อมใช้งานแล้ว",
            Type = "Success",
        })
    end,
})
```

## ส่วนประกอบ

สร้างแท็บด้วย `window:Tab(config)` สร้างส่วนย่อยด้วย `tab:Section(config)` และสร้างการ์ดด้วย `tab:Card(config)` ส่วนย่อยรองรับ:

- `Button`
- `Toggle`
- `Slider`
- `Dropdown`
- `MultiDropdown`
- `PlayerDropdown`
- `Input`
- `Keybind`
- `Colorpicker`
- `Paragraph`
- `Divider`
- `Progress`
- `State` และ `EmptyState`
- `Badge`
- `Accordion`
- `Custom`

ดู [ภาพรวมส่วนประกอบ](docs/th/components.md) และ [Window API](docs/th/window-api.md) สำหรับพารามิเตอร์ ค่าที่ส่งกลับ และตัวอย่างโดยละเอียด

ตัวควบคุมส่วนใหญ่รองรับ `Id` สำหรับระบุชื่อที่คงที่ และ `Callback` สำหรับจัดการเหตุการณ์ ดูตัวอย่างเพิ่มเติมได้ใน `demo.lua` และ `UI_LIBRARY_SPEC.md` การเลือกผู้เล่นจะมีผลเฉพาะระหว่างรันไทม์และจะไม่ถูกบันทึกเป็นสถานะของหน้าต่าง

## ธีม

เลือกธีมที่มีให้:

```lua
window:SetThemePreset("Dark")
window:SetThemePreset("Light")
window:SetThemePreset("Lilith")
```

ธีม Lilith ใช้ภาพประกอบเป็นพื้นหลังแบบครอบตัด พร้อมพื้นผิวโทนน้ำเงินและสีเน้นโทนแดง ระบบจะโหลด PNG เมื่อเลือกธีม Lilith

ปรับค่าสีและรูปแบบบางส่วนได้โดยไม่ต้องแทนที่ชุดสีทั้งหมด:

```lua
window:SetTheme({
    Accent = Color3.fromRGB(129, 130, 255),
    AccentSecondary = Color3.fromRGB(46, 211, 159),
    CornerRadius = 10,
})
```

ค่าสีเน้นที่กำหนดผ่าน `CreateWindow.Theme` หรือ `SetTheme` จะยังคงอยู่เมื่อเปลี่ยนจาก Lilith กลับไปใช้ Dark หรือ Light

## รูปภาพ: รองรับ PNG และ JPEG

`RestoreImageUrl` ใช้ระบุรูปภาพที่จะแสดงในปุ่มเปิดหน้าต่างแบบลอย ส่วนธีม Lilith มี URL ภาพพื้นหลังของตัวเอง

กำหนด `RestoreImageUrl` เป็น URL ตรงของ PNG หรือ JPEG ไลบรารีจะตรวจชนิดไฟล์และโหลดตัวถอดรหัสที่ตรงกันให้อัตโนมัติ:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "แดชบอร์ดของฉัน",
    RestoreImageUrl = "https://example.com/icon.jpg",
})
```

ตัวถอดรหัสที่มาพร้อมไลบรารีมี `decode(buffer, options)` และ `supportsYieldIfNeeded = true` สามารถกำหนด `PngDecoder` / `PngDecoderUrl` และ `JpegDecoder` / `JpegDecoderUrl` เพื่อใช้ตัวถอดรหัสอื่นได้ JPEG รองรับ baseline และ progressive 8-bit แบบ grayscale, RGB และ YCbCr แต่ไม่รองรับ arithmetic-coded หรือ CMYK การถอดรหัส progressive ใช้ coefficient storage ได้สูงสุด 64 MB การโหลดตัวถอดรหัสจากระยะไกลต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` การแสดงภาพต้องใช้ `EditableImage` และสิทธิ์ที่จำเป็น หากโหลดหรือถอดรหัสรูปไม่สำเร็จ ไลบรารีจะแสดงคำเตือนและคงไอคอนเริ่มต้นไว้

## เมธอดของหน้าต่าง

ออบเจ็กต์หน้าต่างรองรับเมธอดต่อไปนี้:

- `SetVisible(boolean)`, `SetSize(UDim2)`, `SetTheme(theme)`, `SetThemePreset(name)`
- `SetLocale(locale)`, `SetToggleKey(Enum.KeyCode)`, `SetResizable(boolean)`, `SetDraggable(boolean)`
- `Notify(config)`, `Dialog(config)`, `OpenSettings()`
- `SetHeaderVersion(stringOrNil)`, `SetDiscordLink(urlOrNil, copyCallback)`
- `GetState()`, `SetState(stateTable)` และ `Destroy()`

กำหนด `Id` ให้กับตัวควบคุมและแท็บที่ต้องการกู้คืนด้วย `GetState()` และ `SetState()` ไลบรารีไม่ได้บันทึกข้อมูลลง data store หรือระบบไฟล์ การจัดเก็บข้อมูลถาวรเป็นหน้าที่ของ experience ที่นำไปใช้งาน

## Demo

`demo.lua` สร้างแดชบอร์ดตัวอย่างที่มีข้อมูลผู้เล่น ตัวควบคุม ตัวอย่างการแปลภาษา การตั้งค่าธีม และการบันทึกการตั้งค่าเสริม ฟังก์ชันบันทึกการตั้งค่าต้องอาศัย API จากสภาพแวดล้อมที่รัน และไม่จำเป็นต่อการใช้งานไลบรารี

## สัญญาอนุญาต

โปรเจกต์นี้เผยแพร่ภายใต้สัญญาอนุญาต MIT ดูรายละเอียดได้ที่ [`LICENSE`](./LICENSE)
