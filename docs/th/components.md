# ภาพรวมส่วนประกอบ

Astra UI ใช้โครงสร้าง **window → tab → section → component** โดยสร้างการ์ดไว้บนแท็บโดยตรง กำหนด ID ที่คงที่ให้ค่าที่ต้องการบันทึกด้วย `GetState()`

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="components-overview-full-tab" aria-controls="components-overview-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="components-overview-short-tab" aria-controls="components-overview-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="components-overview-full-panel" role="tabpanel" aria-labelledby="components-overview-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({Title = "Example"})&#10;local tab = window:Tab({Id = "home", Name = "Home"})&#10;local section = tab:Section({Name = "Preferences"})&#10;&#10;section:Toggle({&#10;    Id = "sound",&#10;    Name = "Sound",&#10;    Description = "Enable interface sounds.",&#10;    Default = true,&#10;    Callback = function(enabled)&#10;        print("Sound:", enabled)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="components-overview-short-panel" role="tabpanel" aria-labelledby="components-overview-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local section = window:Tab({Name = "Home"}):Section({Name = "Settings"})&#10;section:Toggle({Name = "Sound", Default = true})</code></pre>
  </div>
</div>

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

ดู [ส่วนประกอบแสดงผล](display-components.md) สำหรับ `Paragraph`, `Console`, `Divider`, `Progress`, `State`, `EmptyState` และ `Badge`

## การ์ดและการจัดวาง

ดู [การ์ด แอคคอร์เดียน และ UI แบบกำหนดเอง](layout-components.md) สำหรับการ์ด Bento, section แบบแอคคอร์เดียน, section สองคอลัมน์ และส่วนประกอบที่กำหนดเอง

## การค้นหาและการนำทาง

- `window:Search(config)` เพิ่มช่องค้นหาเพียงช่องเดียวใน sidebar
- `tab:Search(config)` เป็น alias ของการค้นหาในหน้าต่าง
- แท็บรองรับ `Name`, `Id` (ไม่บังคับ), `Icon` และ `Category`
- Section รองรับ `Name`, `Icon` (ไม่บังคับ) และ `Side = "Left"` หรือ `"Right"` (ไม่บังคับ) เพื่อจัดวางสองคอลัมน์

อ่าน [Window API](window-api.md) สำหรับ constructor และเมธอดของหน้าต่างทั้งหมด
