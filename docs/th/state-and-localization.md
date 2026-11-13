# สถานะและการแปลภาษา

## บันทึกและคืนค่าสถานะ

กำหนด ID ที่คงที่ให้แท็บและตัวควบคุมค่าที่ต้องการคืนค่าหลังสร้าง UI ใหม่:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-save-restore-state-full-tab" aria-controls="example-save-restore-state-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-save-restore-state-short-tab" aria-controls="example-save-restore-state-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-save-restore-state-full-panel" role="tabpanel" aria-labelledby="example-save-restore-state-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({&#10;    Id = "overview",&#10;    Name = "Overview",&#10;})&#10;&#10;local section = tab:Section({&#10;    Name = "Preferences",&#10;})&#10;&#10;section:Toggle({&#10;    Id = "notifications",&#10;    Name = "Notifications",&#10;    Default = true,&#10;})&#10;&#10;local state = window:GetState()&#10;window:SetState(state)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-save-restore-state-short-panel" role="tabpanel" aria-labelledby="example-save-restore-state-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local state = window:GetState()&#10;window:SetState(state)</code></pre>
  </div>
</div>

ตารางสถานะประกอบด้วยการตั้งค่าหน้าต่างที่รองรับและค่าของตัวควบคุมที่กำหนด ID ไว้ `SetState` ตรวจสอบค่าก่อนใช้และจะไม่เรียก callback ของผู้ใช้ หากพบ ID ที่ไม่รู้จัก ระบบจะข้ามพร้อมแสดงข้อความวินิจฉัย การเลือกผู้เล่นใน dropdown มีผลเฉพาะระหว่างรันไทม์และจะไม่ถูก serialize

`GetState` และ `SetState` จะไม่บันทึกค่าคอมโพเนนต์ลง data store หรือไฟล์ ใช้ adapter `Settings` ด้านล่างเพื่อแชร์ค่ากำหนดของหน้าต่าง ส่วนการจัดเก็บและย้ายรูปแบบข้อมูลยังเป็นหน้าที่ของ host

## การแปลภาษา

กำหนด locale และ resolver (ไม่บังคับ) เมื่อสร้างหน้าต่าง:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-localization-full-tab" aria-controls="example-localization-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-localization-short-tab" aria-controls="example-localization-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-localization-full-panel" role="tabpanel" aria-labelledby="example-localization-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({&#10;    Title = "Control Center",&#10;    Localization = {&#10;        Locale = "th-TH",&#10;        Resolve = function(locale, key, fallback)&#10;            if locale == "th-TH" then&#10;                return translations[key] or fallback&#10;            end&#10;            return fallback&#10;        end,&#10;    },&#10;})&#10;&#10;window:SetLocale("en-US")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-localization-short-panel" role="tabpanel" aria-labelledby="example-localization-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({Localization = {Locale = "th-TH"}})&#10;window:SetLocale("en-US")</code></pre>
  </div>
</div>

resolver จะได้รับ locale, text key และข้อความสำรอง `SetLocale` จะประมวลผลข้อความ UI ที่ลงทะเบียนไว้อีกครั้ง

### เพิ่มและแก้ locale ด้วย JSON

หน้า Settings จะแสดง locale จาก `Localization.Locales` และ locale ที่เพิ่มจากหน้า Settings เลือก **Add language** แล้วคัดลอก JSON ต้นแบบ แปลค่าใน `Translations` วาง JSON ที่แปลแล้ว และกด **Add language** ใช้ข้อความภาษาอังกฤษดั้งเดิมของ UI (หรือ key ที่ส่งให้ `Resolve`) เป็น key โดยคง key เดิมไว้และแปลเฉพาะค่า locale ที่สร้างเองแก้ไขหรือลบได้จากรายการภาษา การแก้ locale จะไม่เปลี่ยนภาษาที่กำลังใช้อยู่ เว้นแต่จะแก้ภาษาที่เลือกอยู่ หากลบภาษาที่กำลังใช้ ระบบจะกลับไปใช้ `en-US` ส่วน `en-US` และ `th-TH` เป็นภาษาเริ่มต้นที่แก้ไขหรือลบไม่ได้

```lua
local window = AstraUI:CreateWindow({
    Localization = {
        Locale = "en-US",
        Locales = {
            ["en-US"] = {Name = "English", Translations = {}},
            ["th-TH"] = {
                Name = "ไทย",
                Translations = {
                    ["Color theme"] = "ธีมสี",
                    ["Language"] = "ภาษา",
                },
            },
        },
    },
})
```

ตัวแก้ไขภาษารับข้อมูล locale หนึ่งรายการในรูปแบบนี้:

```json
{
  "Locale": "th-TH",
  "Name": "ไทย",
  "Translations": {
    "Settings": "ตั้งค่า",
    "Color theme": "ธีมสี",
    "Language": "ภาษา"
  }
}
```

ช่อง locale สามารถคัดลอก JSON ต้นแบบผ่าน `Settings.Copy` หรือฟังก์ชัน `setclipboard` ของ host ส่วนการวาง JSON ให้ใช้คีย์ลัดมาตรฐานของช่องข้อความ (เช่น Ctrl+V) เมื่อเพิ่ม locale แล้ว หน้าต่างที่ใช้ profile key เดียวกันจะเลือกภาษานั้นได้ระหว่างที่ library runtime ยังทำงาน

### แชร์และบันทึก Settings

หน้าต่างที่ใช้ `ProfileKey` เดียวกันจะแชร์ locale, ธีม, ปุ่ม toggle และค่าการปรับขนาด/ลากระหว่างที่ library runtime ยังทำงาน กำหนด `Settings.FilePath` เพื่อใช้ระบบโหลดและบันทึก JSON ในตัวได้:

```lua
local window = AstraUI:CreateWindow({
    Settings = {
        ProfileKey = "my-ui",
        FilePath = "AstraUI/my-ui-profile.json",
    },
})
```

ต้องใช้ file API ของ host ได้แก่ `readfile`, `isfile`, `writefile`, `makefolder` และ `isfolder` หากไม่กำหนด `FilePath` หรือ callback `Load`/`Save` การแชร์จะอยู่ได้จนกว่า library runtime จะจบ ยังสามารถใช้ callback ของ host แทนได้

บันทึก state ของคอมโพเนนต์แยกจาก profile การตั้งค่าที่แชร์กันได้:

```lua
local window = AstraUI:CreateWindow({
    StatePersistence = {
        Path = "AstraUI/my-ui-state.json",
        AutoSaveInterval = 2,
    },
})

-- เรียกหลังจากสร้างแท็บและคอมโพเนนต์ที่มี ID แล้ว
local loaded, loadError = window:LoadStateFromFile()
local autoSaveStarted, autoSaveError = window:StartStateAutoSave()
```

`SaveStateToFile(path?)` และ `LoadStateFromFile(path?)` รับ path เสริมได้ หากไม่ระบุจะใช้ `StatePersistence.Path` `LoadStateFromFile` คืน `false, nil` เมื่อยังไม่มีไฟล์ และคืน `false, error` เมื่ออ่านหรือใช้ state ไม่สำเร็จ `StartStateAutoSave(interval?)` จะเขียนเมื่อ state เปลี่ยน และหยุดพร้อมแสดง warning หากบันทึกไม่สำเร็จ API ไฟล์ขึ้นอยู่กับ host ไม่ใช่ API มาตรฐานของ Roblox
