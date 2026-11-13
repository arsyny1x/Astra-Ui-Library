# ธีมและการปรับแต่ง

## ธีมที่มีให้

หน้าต่างที่สร้างใหม่จะใช้ธีม Lilith เป็นค่าเริ่มต้น

```lua
window:SetThemePreset("Dark")
window:SetThemePreset("Light")
window:SetThemePreset("Lilith")
```

- **Dark** ใช้พื้นผิวสีน้ำเงินเข้มและสีเน้นมาตรฐานของไลบรารี
- **Light** ใช้พื้นผิวโทนกลางที่สว่างกว่า
- **Lilith** ใช้ภาพประกอบแบบครอบตัด พื้นผิวสีน้ำเงินเย็น ข้อความสีน้ำเงินเข้ม สีเน้นแดงเข้ม และพื้นผิวหลักแบบโปร่งแสง

ภาพประกอบของ Lilith จะโหลดเป็นค่าเริ่มต้นและทุกครั้งที่เลือกธีมนี้ ความพร้อมใช้งานขึ้นอยู่กับตัวถอดรหัส PNG ที่ตั้งค่าไว้และการรองรับ `EditableImage`

## ปรับ token ของธีม

ส่งค่า override บางส่วนเมื่อสร้างหน้าต่าง:

```lua
local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
        AccentSecondary = Color3.fromRGB(46, 211, 159),
        CornerRadius = 10,
        Density = "Comfortable",
    },
})
```

หรือปรับชุดสีภายหลัง:

```lua
window:SetTheme({
    ControlSurface = Color3.fromRGB(218, 226, 235),
    ControlHover = Color3.fromRGB(206, 216, 228),
})
```

การ override บางส่วนจะคง token ที่ไม่ได้ระบุไว้ token สีที่รองรับครอบคลุมพื้นผิว ตัวควบคุม เส้นขอบ ข้อความ สีเน้น และสีตามความหมาย (`Success`, `Warning`, `Danger`) `CornerRadius` รับตัวเลขตั้งแต่ 0 ถึง 32 ส่วน `Density` รับ `"Compact"` หรือ `"Comfortable"`

สีเน้นที่กำหนดใน `CreateWindow.Theme` หรือผ่าน `SetTheme` ภายหลังจะยังคงอยู่เมื่อเปลี่ยนจาก Lilith กลับไปใช้ Dark หรือ Light สถานะ hover และกดของปุ่มจะอัปเดตเมื่อเปลี่ยนธีม

ดู [ข้อกำหนดการออกแบบ](../../UI_LIBRARY_SPEC.md) สำหรับรายการ token ทั้งหมด
