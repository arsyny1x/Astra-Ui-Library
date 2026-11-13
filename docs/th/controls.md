# ปุ่มและตัวควบคุมค่า

เพิ่มตัวควบคุมลงใน section:

```lua
local settings = tab:Section({Name = "Settings"})
settings:Toggle({Name = "Example", Default = true})
```

## Button

ใช้เรียกการทำงาน ปุ่ม Button ไม่มีค่า:

```lua
local refresh = settings:Button({
    Id = "refresh",
    Name = "Refresh data",
    Description = "Reload the dashboard values.",
    Icon = "refresh-cw",
    Callback = function()
        print("Refreshing")
    end,
})

refresh:SetLoading(true)
task.wait(1)
refresh:SetLoading(false)
```

ต้องกำหนด `Callback` ส่วน `Icon` เป็นตัวเลือก `SetLoading(boolean)` จะปิดใช้งานปุ่มระหว่างโหลด

## Toggle

```lua
local music = settings:Toggle({
    Id = "music",
    Name = "Music",
    Description = "Play background music.",
    Default = false,
    Callback = function(enabled)
        print("Music enabled:", enabled)
    end,
})

music:SetValue(true)
print(music:GetValue())
```

หากกำหนด `Default` ค่านั้นต้องเป็น boolean

## Slider

```lua
local volume = settings:Slider({
    Id = "volume",
    Name = "Volume",
    Min = 0,
    Max = 100,
    Step = 5,
    Default = 35,
    Callback = function(value)
        print("Volume:", value)
    end,
})
```

| ฟิลด์ | จำเป็น | รายละเอียด |
|---|---:|---|
| `Min` | ใช่ | ค่าต่ำสุด ซึ่งต้องเป็นตัวเลข |
| `Max` | ใช่ | ค่าสูงสุด ซึ่งต้องมากกว่า `Min` |
| `Step` | ไม่ | ระยะเพิ่มค่าที่ต้องเป็นบวก หากไม่กำหนด การลากตัวชี้จะเปลี่ยนค่าได้ต่อเนื่อง และแป้นพิมพ์จะเพิ่มทีละ 1% ของช่วง |
| `Default` | ไม่ | ค่าเริ่มต้น หากไม่กำหนดจะใช้ `Min` และจำกัดให้อยู่ในช่วง |

Slider รองรับเมาส์ การสัมผัส และการปรับค่าด้วยแป้นซ้าย/ขวาหรือ gamepad เมื่อได้รับโฟกัส

## Dropdown

ใช้เลือก string หนึ่งค่า:

```lua
local quality = settings:Dropdown({
    Id = "quality",
    Name = "Quality",
    Options = {"Low", "Medium", "High"},
    Default = "Medium",
    Callback = function(value)
        print("Quality:", value)
    end,
})
```

`Options` ต้องเป็น array ที่มี string อย่างน้อยหนึ่งค่า หากไม่กำหนด `Default` จะเลือกตัวเลือกแรก `SetValue()` ต้องได้รับค่าที่มีอยู่ใน `Options`

## MultiDropdown

ใช้เลือก string ได้หลายค่าตามต้องการ:

```lua
local effects = settings:MultiDropdown({
    Id = "effects",
    Name = "Effects",
    Options = {"Bloom", "Blur", "Color correction"},
    Default = {"Bloom"},
    Callback = function(values)
        for _, name in ipairs(values) do
            print("Enabled effect:", name)
        end
    end,
})
```

`Options` ต้องเป็น array ที่มี string อย่างน้อยหนึ่งค่า `Default` เป็น array ของค่าที่เลือก (ค่าเริ่มต้นเป็น array ว่าง) `GetValue()` จะคืนสำเนาของ array ที่เลือก

## PlayerDropdown

ใช้เลือกผู้เล่นที่อยู่ในเซิร์ฟเวอร์ปัจจุบัน:

```lua
local players = settings:PlayerDropdown({
    Name = "Players",
    Description = "Choose players currently in this server.",
    Placeholder = "Select players...",
    EmptyText = "No players are online.",
    ExcludeLocalPlayer = true,
    Callback = function(selectedPlayers)
        for _, player in ipairs(selectedPlayers) do
            print(player.Name)
        end
    end,
})
```

Dropdown จะติดตามเหตุการณ์ผู้เล่นเข้า/ออก อัปเดตตัวเลือก และนำผู้เล่นที่ออกจากเซิร์ฟเวอร์ออกจากรายการที่เลือก รองรับการเลือกหลายคน โดยตั้งใจไม่รองรับ `Id` และ `Default` เพราะการเลือกมีผลเฉพาะระหว่างรันไทม์และจะไม่ถูก serialize

## Input

```lua
local username = settings:Input({
    Id = "nickname",
    Name = "Display name",
    Description = "Enter a short label.",
    Placeholder = "Guest",
    Default = "",
    MaxLength = 24,
    Live = false,
    Numeric = false,
    Callback = function(value)
        print("Committed text:", value)
    end,
})

username:SetError("This name is unavailable.")
username:SetError(nil)
```

เมื่อ `Live = true` จะเรียก callback ขณะข้อความเปลี่ยน หากเป็นค่าอื่น callback จะทำงานเมื่อเสียโฟกัส สำหรับ `Live = false` และ `Numeric = true` จะตรวจสอบเมื่อเสียโฟกัส แสดงข้อผิดพลาด และไม่เรียก callback หากข้อความที่ไม่ว่างไม่ใช่ตัวเลข แต่เมื่อ `Live = true` จะส่งค่าตามที่พิมพ์และข้ามการตรวจสอบตอนยืนยัน `MaxLength` จะตัดข้อความให้ไม่เกินความยาวบวกที่กำหนด ใช้ `SetError(messageOrNil)` เพื่อแสดงหรือล้างข้อผิดพลาด

## Keybind

```lua
local action = settings:Keybind({
    Id = "quick-action",
    Name = "Quick action",
    Default = Enum.KeyCode.G,
    Callback = function(keyCode)
        print("Pressed:", keyCode.Name)
    end,
})
```

ค่าเริ่มต้นคือ `Enum.KeyCode.Unknown` คลิก **Change key** แล้วกดปุ่มที่ต้องการ กด Escape ระหว่างรอปุ่มเพื่อยกเลิก callback จะทำงานเมื่อกดปุ่มที่ผูกไว้ และจะไม่ทำงานขณะกล่องข้อความมีโฟกัส

## Colorpicker

```lua
local tint = settings:Colorpicker({
    Id = "tint",
    Name = "Interface tint",
    Default = Color3.fromRGB(129, 130, 255),
    Callback = function(color)
        print(color)
    end,
})
```

หน้าต่างป๊อปอัปให้เลือกเฉดสี ความอิ่มสี/ความสว่าง และกรอกค่าสี hex 6 หลัก หากกำหนด `Default` ค่านั้นต้องเป็น `Color3`
