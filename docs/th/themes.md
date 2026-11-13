# ธีมและการปรับแต่ง

เลือกใช้ธีมสำเร็จรูปหรือปรับชุดสีด้วยการ override token เฉพาะส่วนได้

## ธีมที่มีให้

หน้าต่างที่สร้างใหม่จะใช้ธีม Lilith เป็นค่าเริ่มต้น

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="preset-dark-tab" aria-controls="preset-dark-panel" aria-selected="true" tabindex="0" data-code-tab="dark">Dark</button>
    <button class="astra-code-tab" type="button" role="tab" id="preset-light-tab" aria-controls="preset-light-panel" aria-selected="false" tabindex="-1" data-code-tab="light">Light</button>
    <button class="astra-code-tab" type="button" role="tab" id="preset-lilith-tab" aria-controls="preset-lilith-panel" aria-selected="false" tabindex="-1" data-code-tab="lilith">Lilith</button>
  </div>
  <div class="astra-code-panel" id="preset-dark-panel" role="tabpanel" aria-labelledby="preset-dark-tab" data-code-panel="dark">
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Dark&quot;)</code></pre>
  </div>
  <div class="astra-code-panel" id="preset-light-panel" role="tabpanel" aria-labelledby="preset-light-tab" data-code-panel="light" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Light&quot;)</code></pre>
  </div>
  <div class="astra-code-panel" id="preset-lilith-panel" role="tabpanel" aria-labelledby="preset-lilith-tab" data-code-panel="lilith" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Lilith&quot;)</code></pre>
  </div>
</div>

- **Dark** ใช้พื้นผิวสีน้ำเงินเข้มและสีเน้นมาตรฐานของไลบรารี
- **Light** ใช้พื้นผิวโทนกลางที่สว่างกว่า
- **Lilith** ใช้ภาพประกอบแบบครอบตัด พื้นผิวสีน้ำเงินเย็น ข้อความสีน้ำเงินเข้ม สีเน้นแดงเข้ม และพื้นผิวหลักแบบโปร่งแสง

ภาพประกอบของ Lilith จะโหลดเป็นค่าเริ่มต้นและทุกครั้งที่เลือกธีมนี้ ความพร้อมใช้งานขึ้นอยู่กับตัวถอดรหัส PNG/JPEG ที่ตรงกับชนิดภาพและการรองรับ `EditableImage`

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

การ override บางส่วนจะคง token ที่ไม่ได้ระบุไว้ token สีที่รองรับครอบคลุมพื้นผิว ตัวควบคุม เส้นขอบ ข้อความ สีเน้น และสีตามความหมาย (`Success`, `Warning`, `Danger`) `CornerRadius` รับตัวเลขตั้งแต่ 0 ถึง 32 ส่วน `Density` รับ `"Compact"` หรือ `"Comfortable"` และ `SurfaceTransparency` รับค่าตั้งแต่ 0 (ค่าเริ่มต้นของ preset) ถึง 1 (โปร่งใสทั้งหมด) โดยปรับเฉพาะพื้นผิวหลักที่กำหนดไว้ให้เกิดเอฟเฟกต์กระจกแบบ Lilith ส่วนปุ่ม ช่องกรอก และข้อความจะไม่ถูกปรับความโปร่งใส

สีเน้นที่กำหนดใน `CreateWindow.Theme` หรือผ่าน `SetTheme` ภายหลังจะยังคงอยู่เมื่อเปลี่ยนจาก Lilith กลับไปใช้ Dark หรือ Light สถานะ hover และกดของปุ่มจะอัปเดตเมื่อเปลี่ยนธีม

### สร้างธีมใน Settings

เปิด **Settings** แล้วเลือก **Add theme** เพื่อสร้างธีม ตั้งชื่อ เลือก preset ที่ต้องการใช้เป็นต้นแบบ (เมื่อเลือก Lilith จะคัดลอกรูปพื้นหลังมาด้วย หากยังไม่ได้กรอกรูปเอง) ปรับสีจาก color map หรือกรอกค่า `#RRGGBB` และใส่ `rbxassetid://` หรือ HTTP(S) URL โดยตรงของภาพพื้นหลัง PNG หรือ JPEG baseline/progressive ที่รองรับได้ (ไม่บังคับ) ระบบจะใช้ตัวถอดรหัสตามชนิดภาพเพื่อแปลงเป็น `EditableImage` (กำหนด `PngDecoder` หรือ `JpegDecoder` เองได้) โดย host ต้องรองรับ `EditableImage` เมื่อบันทึก ธีมใหม่จะถูกเลือกทันทีและแสดงร่วมกับ preset ที่มีอยู่ ธีมจะแชร์ระหว่างหน้าต่างที่ใช้ `ProfileKey` เดียวกัน และ host สามารถบันทึกผ่าน callback `Settings.Save` ได้

ธีมที่สร้างเองมีปุ่มแก้ไข ลบ และส่งออก preset ปุ่ม **Export preset** จะคัดลอก JSON ของธีมที่กำลังแก้ไขไปยัง clipboard ผ่าน `Settings.Copy` หรือ `setclipboard` การแก้ธีมจะไม่เปลี่ยนธีมที่กำลังใช้อยู่ เว้นแต่จะแก้ธีมที่เลือกอยู่ เมื่อลบธีมที่กำลังใช้งาน ระบบจะกลับไปใช้ preset ปัจจุบัน หรือ Lilith หากไม่ได้ใช้ preset ส่วน Dark, Light และ Lilith เป็นธีมเริ่มต้นที่แก้ไขหรือลบไม่ได้

ดู [ข้อกำหนดการออกแบบ](../../UI_LIBRARY_SPEC.md) สำหรับรายการ token ทั้งหมด
