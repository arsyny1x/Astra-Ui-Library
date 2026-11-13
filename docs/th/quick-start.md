# เริ่มต้นอย่างรวดเร็ว

## ข้อกำหนด

ตัวอย่างนี้ต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ไลบรารีปัจจุบันดาวน์โหลดและรันไลบรารีไอคอนระหว่างโหลด จึงใช้กับ `LocalScript` ใน Roblox client มาตรฐานโดยตรงไม่ได้

- URL รูปภาพต้องชี้ไปยังไฟล์ PNG หรือ JPEG baseline/progressive ที่รองรับโดยตรง ขนาดไม่เกิน 8 MB และแต่ละด้านไม่เกิน 4096 พิกเซล Roblox ต้องรองรับ `EditableImage` และได้รับสิทธิ์ที่จำเป็น
- การบันทึกการตั้งค่าใน demo ใช้ API จาก executor ได้แก่ `readfile` / `writefile`

## สร้างหน้าต่าง

เลือกแท็บแล้วคัดลอกโค้ดทั้งบล็อกได้เลย ทั้งสองแบบโหลด Astra UI และสร้างหน้าต่างให้ครบ ส่วนตัวอย่างเต็มมีปุ่มสำหรับสลับสถานะของ toggle

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="quickstart-window-full-tab" aria-controls="quickstart-window-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="quickstart-window-short-tab" aria-controls="quickstart-window-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="quickstart-window-full-panel" role="tabpanel" aria-labelledby="quickstart-window-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()&#10;&#10;local window = AstraUI:CreateWindow({&#10;    Title = "แดชบอร์ดเกม",&#10;    Subtitle = "สถานะเกม",&#10;    Size = UDim2.fromOffset(800, 500),&#10;    ToggleKey = Enum.KeyCode.RightShift,&#10;    RestoreImageUrl = "https://i.ibb.co/tMv26Nr5/hi-guys-im-collecting-lilith-pictures-i-hope-you-guys-can-v0-jbwkdcepgjgf1.png",&#10;    Responsive = true,&#10;    Resizable = true,&#10;    Draggable = true,&#10;})&#10;&#10;local home = window:Tab({&#10;    Id = "home",&#10;    Name = "หน้าหลัก",&#10;    Category = "เกม",&#10;    Icon = "house",&#10;})&#10;&#10;local status = home:Section({&#10;    Name = "สถานะ",&#10;    Icon = "activity",&#10;})&#10;&#10;local enabled = status:Toggle({&#10;    Id = "feature-enabled",&#10;    Name = "เปิดใช้งาน",&#10;    Default = false,&#10;    Callback = function(value)&#10;        print("เปิดใช้งาน:", value)&#10;    end,&#10;})&#10;&#10;status:Button({&#10;    Name = "สลับฟีเจอร์",&#10;    Icon = "bell",&#10;    Callback = function()&#10;        local value = not enabled:GetValue()&#10;        enabled:SetValue(value)&#10;        window:Notify({&#10;            Type = "Success",&#10;            Title = "อัปเดตแล้ว",&#10;            Content = "สถานะฟีเจอร์: " .. tostring(value),&#10;        })&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="quickstart-window-short-panel" role="tabpanel" aria-labelledby="quickstart-window-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()&#10;local window = AstraUI:CreateWindow({Title = "แดชบอร์ดเกม", RestoreImageUrl = "https://i.ibb.co/tMv26Nr5/hi-guys-im-collecting-lilith-pictures-i-hope-you-guys-can-v0-jbwkdcepgjgf1.png"})&#10;local home = window:Tab({Id = "home", Name = "หน้าหลัก"})&#10;local status = home:Section({Name = "สถานะ"})&#10;local enabled = status:Toggle({Name = "เปิดใช้งาน", Default = false})</code></pre>
  </div>
</div>

ตัวอย่างกำหนด `RestoreImageUrl` เป็น URL ของ PNG โดยตรงเพื่อแสดงรูปบนปุ่มเปิดหน้าต่างแบบลอย และรองรับ URL JPEG baseline/progressive โดยตรวจชนิดไฟล์ให้อัตโนมัติ เปลี่ยน URL ตัวอย่างเป็นรูปที่คุณใช้ได้ หากไม่รองรับ `EditableImage` หรือไม่มีสิทธิ์ที่จำเป็น ปุ่มจะกลับไปใช้ไอคอนเริ่มต้น

ดูข้อมูลอ้างอิงทั้งหมดใน [ปุ่มและตัวควบคุมค่า](controls.md), [ส่วนประกอบแสดงผล](display-components.md) และ [Window API](window-api.md)
