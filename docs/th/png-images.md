# รูปภาพ PNG

การถอดรหัส PNG ใช้กับรูปภาพเสริมบนปุ่มเปิดหน้าต่างแบบลอยและภาพพื้นหลังของ Lilith ไลบรารีจะแปลงข้อมูล PNG เป็นเนื้อหา `EditableImage` ของ Roblox

## ตัวถอดรหัสที่มาพร้อมไลบรารี

โมดูล `png.luau` และ `luau-png.lua` รองรับการ yield แบบร่วมมือกัน ตัวถอดรหัสต้องเปิดเผย:

- `decode(buffer, options)`
- `supportsYieldIfNeeded = true`

ควรเรียก callback `options.yieldIfNeeded` เป็นระยะระหว่างการถอดรหัสที่ใช้เวลานาน เพื่อให้ UI ยังคงตอบสนองได้

เมื่อจำเป็นต้องถอดรหัสรูป ไลบรารีจะตรวจสอบ `PngDecoder` ที่ส่งมา จากนั้นหา `ModuleScript` ที่เข้ากันได้ในบริเวณใกล้เคียง และสุดท้ายจึงดาวน์โหลดตัวถอดรหัสจาก URL:
`https://raw.githubusercontent.com/arsyny1x/luau-png/refs/heads/main/png.luau`
ไม่ต้องโหลดหรือส่งตัวถอดรหัสด้วยตนเอง เพียงกำหนด `RestoreImageUrl` แล้วไลบรารีจะจัดการโหลดตัวถอดรหัสให้อัตโนมัติ:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

`PngDecoder` และ `PngDecoderUrl` เป็นตัวเลือกสำหรับใช้ตัวถอดรหัสที่กำหนดเอง การใช้ตัวถอดรหัสจากระยะไกลที่มาพร้อมไลบรารีต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ดู [การเริ่มต้นใช้งาน](getting-started.md)

### เปลี่ยนตัวถอดรหัส

กำหนดค่านี้เฉพาะเมื่อต้องการใช้แหล่งตัวถอดรหัสอื่นแทน URL เริ่มต้น:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    PngDecoderUrl = "https://example.com/png.luau",
})
```

การแสดง PNG ต้องรองรับ API `EditableImage` และได้รับสิทธิ์ที่จำเป็นใน experience/runtime หากถอดรหัสหรือสร้างรูปไม่สำเร็จ ไลบรารีจะแสดงคำเตือนและใช้ไอคอนเริ่มต้นบนปุ่มเปิดหน้าต่างแทน
