# การ์ด แอคคอร์เดียน และ UI แบบกำหนดเอง

## การ์ด Bento

เพิ่มการ์ดลงบนแท็บโดยตรง การ์ดจะจัดเรียงใหม่ได้ตั้งแต่หนึ่งถึงสองคอลัมน์:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-card-full-tab" aria-controls="example-card-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-card-short-tab" aria-controls="example-card-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-card-full-panel" role="tabpanel" aria-labelledby="example-card-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local count = tab:Card({&#10;    Id = "online-count",&#10;    Title = "Players online",&#10;    Value = 12,&#10;    Description = "Players in this server.",&#10;    Icon = "users",&#10;    Size = "Small",&#10;    Accent = "Blue",&#10;})&#10;&#10;count:SetValue(14)&#10;print(count:GetValue())</code></pre>
  </div>
  <div class="astra-code-panel" id="example-card-short-panel" role="tabpanel" aria-labelledby="example-card-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">tab:Card({Title = "Players online", Value = 12})</code></pre>
  </div>
</div>

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

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-accordion-full-tab" aria-controls="example-accordion-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-accordion-short-tab" aria-controls="example-accordion-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-accordion-full-panel" role="tabpanel" aria-labelledby="example-accordion-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local advanced = section:Accordion({&#10;    Id = "advanced",&#10;    Name = "Advanced",&#10;    DefaultOpen = false,&#10;}, function(inner)&#10;    inner:Toggle({&#10;        Id = "debug-mode",&#10;        Name = "Debug mode",&#10;        Default = false,&#10;    })&#10;end)&#10;&#10;advanced:SetExpanded(true)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-accordion-short-panel" role="tabpanel" aria-labelledby="example-accordion-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Accordion({Name = "Advanced"}, function(inner) inner:Toggle({Name = "Debug mode"}) end)</code></pre>
  </div>
</div>

ต้องกำหนด callback `build` ซึ่งจะได้รับ section ภายในและสามารถใช้ตัวควบคุมทั่วไปได้ `DefaultOpen` กำหนดสถานะเริ่มต้น และ `SetExpanded(boolean)` ใช้เปลี่ยนสถานะ หากสร้างไม่สำเร็จจะแสดงข้อผิดพลาดใน Roblox Output

## ส่วนประกอบแบบกำหนดเอง

ใช้ `Custom` สำหรับ UI ที่สร้างด้วยตัวควบคุมมาตรฐานไม่ได้:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-custom-component-full-tab" aria-controls="example-custom-component-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-custom-component-short-tab" aria-controls="example-custom-component-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-custom-component-full-panel" role="tabpanel" aria-labelledby="example-custom-component-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local custom = section:Custom({&#10;    Id = "custom-meter",&#10;    Height = 48,&#10;    Build = function(host, context)&#10;        local label = Instance.new("TextLabel")&#10;        label.BackgroundTransparency = 1&#10;        label.Size = UDim2.fromScale(1, 1)&#10;        label.Text = "Custom content"&#10;        label.Parent = host&#10;&#10;        context:RegisterCleanup(function()&#10;            print("Clean up custom connections/resources here")&#10;        end)&#10;&#10;        return label&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-custom-component-short-panel" role="tabpanel" aria-labelledby="example-custom-component-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Custom({Height = 32, Build = function(host) local label = Instance.new("TextLabel"); label.Text = "Custom content"; label.Parent = host; return label end})</code></pre>
  </div>
</div>

`Height` ต้องเป็นตัวเลขบวกและต้องกำหนด `Build` โดย `Build(host, context)` ต้องคืนค่าเป็น `GuiObject` ส่วนประกอบนี้ใช้เฉพาะ `Id`, `Height` และ `Build` เท่านั้น context มีเมธอด:

- `GetTheme()` — สำเนาของ token ธีมที่ใช้งานอยู่
- `GetLayoutMode()` — `"Wide"`, `"Compact"` หรือ `"Narrow"`
- `RegisterCleanup(function)` — ลงทะเบียนการล้างทรัพยากรเมื่อเรียก `Destroy()`

`Build` สามารถคืน cleanup function เป็นค่าที่สองได้ ใช้ฟังก์ชัน Luau ปกติในเครื่อง ห้ามส่งสตริงโค้ดหรือรันสคริปต์จากระยะไกล/ผู้ใช้
