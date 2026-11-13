# ส่วนประกอบแสดงผล

ส่วนประกอบแสดงผลจะอยู่ใน section ส่วนประกอบที่ใช้แถวควบคุมร่วมกันรองรับ `Name`, `Description` (ไม่บังคับ) และ `Id` (ไม่บังคับ) ฟิลด์เฉพาะของแต่ละรายการมีดังนี้

## Paragraph

แสดงข้อความหลายบรรทัดและเปลี่ยนข้อความภายหลังได้:

```lua
local status = section:Paragraph({
    Id = "status-text",
    Title = "Current status",
    Content = "Waiting for data...",
})

status:SetContent("Data received.")
```

ต้องกำหนด `Content` ส่วน `Title` เป็นตัวเลือก `SetContent(string)` ใช้แทนที่เนื้อหา

## Divider

```lua
section:Divider()
```

เพิ่มเส้นคั่นสีตามธีมหนา 1 พิกเซล ไม่รับการตั้งค่า

## Progress

```lua
local progress = section:Progress({
    Id = "download-progress",
    Name = "Download",
    Description = "Downloading assets.",
    Value = 0.4,
    ShowValue = true,
})

progress:SetValue(0.75)
```

`Value` ต้องอยู่ระหว่าง 0 ถึง 1 `ShowValue` จะแสดงเปอร์เซ็นต์แบบปัดเศษ กำหนด `Indeterminate = true` เพื่อแสดงตัวบอกงานที่กำลังดำเนินการ (การทำงานปัจจุบันแสดงแถบเติมคงที่บางส่วน) หาก `ShowValue` เป็น false จะแสดง `Label` แทน ใช้ `GetValue()` และ `SetValue(value)` ได้

## State

แสดงแผงสถานะพร้อมการกระทำเสริม:

```lua
local connection = section:State({
    Id = "connection",
    Type = "Success",
    Title = "Connected",
    Description = "The service is ready.",
    Icon = "circle-check",
    Action = {
        Name = "Reconnect",
        Callback = function()
            print("Retry connection")
        end,
    },
})

connection:SetState("Error", "Connection failed.")
```

`Type` เป็นป้ายสถานะเริ่มต้น `SetState(kind, message)` รองรับ `"Loading"`, `"Empty"`, `"Error"` และ `"Success"` `Action` เป็นตัวเลือกและต้องมี `Callback` หากไม่กำหนดชื่อปุ่ม จะใช้ `"Try again"`

## EmptyState

`EmptyState(config)` เป็นตัวช่วยสร้างที่ครอบ `State` โดยกำหนด `Type = "Empty"` และใช้ `Title` เริ่มต้นเป็น `"Nothing here yet"`

```lua
section:EmptyState({
    Title = "No saved presets",
    Description = "Create a preset to see it here.",
    Icon = "folder-open",
})
```

## Badge

```lua
local badge = section:Badge({
    Id = "server-status",
    Text = "Online",
    Type = "Success",
})

badge:SetText("Maintenance")
badge:SetType("Warning")
```

ชนิดที่รองรับคือ `"Neutral"`, `"Info"`, `"Success"`, `"Warning"` และ `"Error"` โดยชนิดจะกำหนดสีข้อความ จุด และเส้นขอบตามความหมาย
