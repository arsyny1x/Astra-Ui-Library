# Window API

## สร้างหน้าต่าง

bootstrap แบบ `loadstring` ด้านล่างต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ไลบรารีปัจจุบันโหลด dependency ไอคอนจากระยะไกลระหว่างเริ่มทำงาน จึงใช้กับ `LocalScript` ใน Roblox client มาตรฐานไม่ได้ ดู[เริ่มต้นอย่างรวดเร็ว](quick-start.md)

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
local window = AstraUI:CreateWindow(config)
```

`CreateWindow` คืนออบเจ็กต์หน้าต่าง โดยใช้ธีม Lilith เป็นค่าเริ่มต้น ขนาดเริ่มต้นคือ `UDim2.fromOffset(800, 500)` หน้าต่างจะปรับให้พอดีกับ viewport ที่ใช้ได้ รวมถึงหน้าจอขนาดเล็ก บน Android และ iOS หน้าต่าง เนื้อหา ป๊อปอัป และ toast ใช้ global scale ร่วมกันที่ 70-80% ระบบเลือกคอลัมน์ responsive จากความกว้างที่แสดงหลังปรับ scale ส่วนปุ่มเปิด/ซ่อนแบบลอยจะคงขนาดเดิม เมื่อซ่อนหน้าต่างจะหดลง และเมื่อแสดงจะขยายกลับพร้อมเส้นขอบที่ค่อย ๆ จาง ผ่าน `SetVisible`, ปุ่ม restore หรือปุ่ม toggle

| ฟิลด์ | ชนิด | ค่าเริ่มต้น / หมายเหตุ |
|---|---|---|
| `Title` | string | `"Astra UI"` |
| `Subtitle` | string? | ข้อความรอง (ไม่บังคับ) |
| `HeaderVersion` | string? | ข้อความเวอร์ชันในส่วนหัว (ไม่บังคับ) |
| `Size` | `UDim2`? | ขนาดเริ่มต้น ค่าเริ่มต้น 800 × 500 พิกเซล |
| `ToggleKey` | `Enum.KeyCode`? | ปุ่มสำหรับสลับการแสดงผล (ไม่บังคับ) |
| `Responsive` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Resizable` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Draggable` | boolean? | ค่าเริ่มต้นเป็น `true` เว้นแต่กำหนดเป็น `false` |
| `Theme` | table? | ค่า override บางส่วนของ token ธีม โดยค่าต้องตรงกับชนิดของ token |
| `Localization` | table? | locale, resolver และตารางคำแปล `Locales` (ไม่บังคับ) |
| `Settings` | table? | คีย์ profile, `FilePath` สำหรับบันทึก JSON ในตัว หรือ callback จาก host (ไม่บังคับ) |
| `StatePersistence` | table? | `Path` สำหรับ `SaveStateToFile`/`LoadStateFromFile` และ `AutoSaveInterval` (ไม่บังคับ) |
| `Parent` | `Instance`? | GUI parent ค่าเริ่มต้นคือ `gethui()` (alias: `get_hidden_gui()`) หากระบุจะใช้ค่านี้แทน |
| `RestoreImageUrl` | string? | URL HTTP(S) ของรูป PNG หรือ JPEG baseline สำหรับปุ่ม restore |
| `PngDecoder` | table? | ตัวถอดรหัสที่เปิดเผย `decode(buffer, options)` |
| `PngDecoderUrl` | string? | เปลี่ยน URL ของตัวถอดรหัสระยะไกล (ไม่บังคับ) ค่าเริ่มต้นเป็น URL `luau-png` ที่มาพร้อมกัน หากไม่พบโมดูลจะดาวน์โหลดและรันโค้ด |
| `JpegDecoder` | table? | ตัวถอดรหัส JPEG baseline ที่เปิดเผย `decode(buffer, options)` (ไม่บังคับ) |
| `JpegDecoderUrl` | string? | เปลี่ยน URL ของตัวถอดรหัส JPEG ระยะไกล (ไม่บังคับ) ค่าเริ่มต้นเป็น URL `jpeg.luau` ที่มาพร้อมกัน หากไม่พบโมดูลจะดาวน์โหลดและรันโค้ด |
| `Discord` | table? | URL เชิญและ callback `Copy(url)` ที่ host จัดเตรียม (ไม่บังคับ) |
| `IconLibrary` | table? | ไลบรารีที่เข้ากันได้กับ Lucide และเปิดเผย `GetAsset(name)` |
| `IconLibraries` | table? | ไลบรารีไอคอนที่ตั้งชื่อตามชนิด โดย Lucide เปิดเผย `GetAsset` และ Solar เป็นตารางไอคอน |

`IconLibrary` เป็น alias ที่เข้ากันได้กับ `IconLibraries.Lucide` ชื่อไอคอนมาจากไลบรารีที่รวมไว้ ดู[เริ่มต้นอย่างรวดเร็ว](quick-start.md)สำหรับข้อจำกัดของ bootstrap ไอคอนระยะไกลใน runtime ปัจจุบัน

หน้า Settings แยกขั้นตอนสร้างธีมและเพิ่ม locale ออกจากกัน การเพิ่ม locale มีปุ่ม **Copy JSON template** ส่วนการวางให้ใช้คีย์ลัดมาตรฐานของช่องข้อความ (เช่น Ctrl+V) การตั้งค่าจะถูกบันทึกเป็น shared profile ผ่าน `Settings.Save` ดู JSON สำหรับ locale และ adapter การบันทึกที่[สถานะและการแปลภาษา](state-and-localization.md)

## สร้างแท็บและ section

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-tabs-sections-full-tab" aria-controls="example-tabs-sections-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-tabs-sections-short-tab" aria-controls="example-tabs-sections-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-tabs-sections-full-panel" role="tabpanel" aria-labelledby="example-tabs-sections-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({&#10;    Id = "settings",&#10;    Name = "Settings",&#10;    Icon = "settings",&#10;    Category = "Configuration",&#10;})&#10;&#10;local section = tab:Section({&#10;    Name = "General",&#10;    Icon = "sliders-horizontal",&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-tabs-sections-short-panel" role="tabpanel" aria-labelledby="example-tabs-sections-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({Name = "Settings"})&#10;tab:Section({Name = "General"})</code></pre>
  </div>
</div>

- แท็บต้องมี `Name` ส่วน `Id`, `Icon` และ `Category` เป็นตัวเลือก
- `Name` ของ section ไม่จำเป็นต้องกำหนด `Icon` เป็นตัวเลือก ส่วน `Side` กำหนดเป็น `"Left"` หรือ `"Right"` เพื่อจัด section เคียงกันแบบ responsive ได้
- ID ควรไม่ซ้ำกันภายในหน้าต่างเดียว หากซ้ำ ระบบจะปฏิเสธ

## เมธอดของหน้าต่าง

| เมธอด | การทำงาน |
|---|---|
| `Tab(config)` | สร้างและคืนค่าแท็บ |
| `Search(config)` | เพิ่มช่องค้นหาใน sidebar การเรียกซ้ำจะคืนช่องค้นหาเดิม |
| `Notify(config)` | แสดง toast และคืนค่า toast (`toast:Dismiss()` ใช้ปิด) |
| `Dialog(config)` | แสดงกล่องโต้ตอบแบบ modal และคืน `{Close, Destroy}` |
| `SetVisible(boolean)` | แสดงหรือซ่อนหน้าต่าง |
| `SetSize(UDim2)` | กำหนดขนาดที่ต้องการ |
| `SetTheme(theme)` | ใช้ค่า override บางส่วนของ token ธีม |
| `SetThemePreset(name)` | เลือก `"Dark"`, `"Light"` หรือ `"Lilith"` |
| `SetLocale(locale)` | เปลี่ยน locale และประมวลผลข้อความที่ลงทะเบียนไว้อีกครั้ง |
| `SetToggleKey(Enum.KeyCode or nil)` | เปลี่ยนหรือล้างปุ่ม toggle สำหรับแสดง/ซ่อน |
| `SetResizable(boolean)` | เปิดหรือปิดการปรับขนาด |
| `SetDraggable(boolean)` | เปิดหรือปิดการลาก |
| `OpenSettings()` | เปิดแผงการตั้งค่าของไลบรารี |
| `SetHeaderVersion(stringOrNil)` | เปลี่ยนหรือล้างเวอร์ชันในส่วนหัว |
| `SetDiscordLink(urlOrNil, copyCallback)` | กำหนดหรือแทนที่การทำงานของลิงก์ Discord |
| `GetState()` | คืนค่าตารางสถานะที่ serialize ได้ |
| `SetState(stateTable)` | ตรวจสอบและคืนค่าสถานะหน้าต่าง/ส่วนประกอบที่รองรับ |
| `SaveStateToFile(path?)` | บันทึก `GetState()` เป็น JSON ผ่าน file API ของ host |
| `LoadStateFromFile(path?)` | โหลดและใช้สถานะ JSON ที่บันทึกไว้ |
| `StartStateAutoSave(interval?)` | บันทึกเมื่อสถานะเปลี่ยนตามช่วงเวลาที่กำหนดใน `StatePersistence` |
| `Destroy()` | ทำลายหน้าต่างและ connection ที่เป็นของหน้าต่าง |

## ค้นหาใน sidebar

```lua
local search = window:Search({
    Placeholder = "Find a tab",
    Icon = "search",
})
```

ค่าเริ่มต้นของ `Placeholder` คือ `"Search"` และของ `Icon` คือ `"search"` ส่วน `tab:Search(config)` เป็น alias ของ `window:Search(config)`

## การแจ้งเตือน

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-notifications-full-tab" aria-controls="example-notifications-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-notifications-short-tab" aria-controls="example-notifications-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-notifications-full-panel" role="tabpanel" aria-labelledby="example-notifications-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local toast = window:Notify({&#10;    Type = "Success",&#10;    Title = "Saved",&#10;    Content = "Your preferences were updated.",&#10;    Duration = 4,&#10;})&#10;&#10;toast:Dismiss()</code></pre>
  </div>
  <div class="astra-code-panel" id="example-notifications-short-panel" role="tabpanel" aria-labelledby="example-notifications-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:Notify({Title = "Saved", Content = "Preferences updated."})</code></pre>
  </div>
</div>

`Type` รองรับ `"Success"`, `"Info"` (ค่าเริ่มต้น), `"Warning"` หรือ `"Error"` `Title` จะใช้ชนิดเป็นค่าเริ่มต้น `Content` เริ่มต้นเป็นข้อความว่าง และ `Duration` เริ่มต้น 3 วินาที หากกำหนดระยะเวลาเป็น `0` จะไม่ปิดอัตโนมัติ เก็บ toast ได้สูงสุดสี่รายการ เมื่อเพิ่มรายการใหม่จะปิดรายการที่เก่าที่สุด

## กล่องโต้ตอบ

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-dialogs-full-tab" aria-controls="example-dialogs-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-dialogs-short-tab" aria-controls="example-dialogs-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-dialogs-full-panel" role="tabpanel" aria-labelledby="example-dialogs-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local dialog = window:Dialog({&#10;    Title = "Reset settings?",&#10;    Content = "This action cannot be undone.",&#10;    Actions = {&#10;        {&#10;            Name = "Cancel",&#10;            Style = "Secondary",&#10;        },&#10;        {&#10;            Name = "Reset",&#10;            Style = "Danger",&#10;            Callback = function()&#10;                print("Reset confirmed")&#10;            end,&#10;        },&#10;    },&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-dialogs-short-panel" role="tabpanel" aria-labelledby="example-dialogs-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:Dialog({Title = "Reset settings?", Content = "This cannot be undone.", Actions = {{Name = "Reset"}}})</code></pre>
  </div>
</div>

`Actions` ต้องเป็น array ที่มีอย่างน้อยหนึ่งรายการ แต่ละ action ต้องมี `Name` ส่วน `Style` รองรับ `"Primary"` (ค่าเริ่มต้น), `"Secondary"` หรือ `"Danger"` `Callback` เป็นตัวเลือก action จะปิดกล่องโต้ตอบหลังคลิกเป็นค่าเริ่มต้น หากต้องการเปิดค้างไว้ให้กำหนด `Close = false` ออบเจ็กต์ที่คืนมามีเมธอด `Close()` และ `Destroy()`

## ธีมและการตั้งค่า

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-themes-settings-full-tab" aria-controls="example-themes-settings-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-themes-settings-short-tab" aria-controls="example-themes-settings-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-themes-settings-full-panel" role="tabpanel" aria-labelledby="example-themes-settings-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset("Light")&#10;window:SetTheme({&#10;    Accent = Color3.fromRGB(120, 110, 255),&#10;})&#10;window:SetToggleKey(Enum.KeyCode.RightControl)&#10;window:SetVisible(false)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-themes-settings-short-panel" role="tabpanel" aria-labelledby="example-themes-settings-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset("Light")&#10;window:SetVisible(false)</code></pre>
  </div>
</div>

ธีมที่มีคือ `"Dark"`, `"Light"` และ `"Lilith"` `SetTheme` จะผสานค่า override บางส่วน ชื่อ token และพฤติกรรมของ preset อธิบายไว้ใน [ธีม](themes.md)

## การ serialize สถานะ

```lua
local state = window:GetState()
-- เก็บสถานะด้วยวิธีจัดเก็บข้อมูลที่เหมาะกับ experience ของคุณเอง
window:SetState(state)
```

`GetState()` คืน `Version = 1`, ID แท็บที่เลือก, preset ธีม, locale, ชื่อปุ่ม toggle, การตั้งค่าปรับขนาด/ลาก และค่าของส่วนประกอบที่มี ID และ `GetValue()` ค่าสีแทนด้วย `{R, G, B}` ส่วนปุ่มลัดแทนด้วยชื่อปุ่ม `SetState()` ใช้การตั้งค่าที่รองรับและค่าของส่วนประกอบที่ตรงกัน ส่วน ID ที่ไม่รู้จักและค่าที่ไม่ถูกต้องจะแสดงคำเตือนแล้วข้าม การเลือก `PlayerDropdown` และส่วนประกอบที่ใช้แสดงผลเท่านั้นจะไม่ถูก serialize

ไลบรารี UI ไม่ได้บันทึกข้อมูลให้เอง ให้ใช้ระบบจัดเก็บของ Roblox ที่เหมาะกับ experience และอย่าเชื่อถือสถานะจาก client สำหรับการกระทำในเกมที่เซิร์ฟเวอร์เป็นผู้มีอำนาจ

## ปุ่มลิงก์ Discord

ปุ่มรูปข้อความในส่วนหัวของหน้าต่างจะคัดลอก URL เชิญผ่าน callback ที่ host กำหนด:

```lua
local window = AstraUI:CreateWindow({
    Discord = {
        Url = "https://discord.gg/your-invite",
        Copy = function(url)
            setclipboard(url)
        end,
    },
    Localization = {
        Locale = "th-TH",
    },
})
```

`setclipboard` เป็นตัวอย่างฟังก์ชันจาก host/executor; ไลบรารีและ Roblox API มาตรฐานไม่มีความสามารถเข้าถึง clipboard โดย callback จะได้รับ URL ที่ตั้งไว้ ใช้ `SetDiscordLink(urlOrNil, copyCallback)` เพื่อเปลี่ยนการตั้งค่าขณะรันไทม์

ข้อความ `AstraLabel` ของปุ่มและการแจ้งเตือนจะแปลเป็นไทยในตัวเมื่อ locale ขึ้นต้นด้วย `th` (เช่น `th-TH`) และใช้ภาษาอังกฤษในกรณีอื่น สามารถใช้ `Localization.Resolve` เพื่อกำหนดคำแปลเองผ่าน key `discord.button`, `discord.url_missing.title`, `discord.url_missing.content`, `discord.copy_missing.title`, `discord.copy_missing.content`, `discord.copy_failed.title`, `discord.copy_failed.content`, `discord.copied.title` และ `discord.copied.content`
