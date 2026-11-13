# ปุ่มและตัวควบคุมค่า

เพิ่มตัวควบคุมลงใน section:

```lua
local settings = tab:Section({Name = "Settings"})
settings:Toggle({Name = "Example", Default = true})
```

## Button

ใช้เรียกการทำงาน ปุ่ม Button ไม่มีค่า:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-button-full-tab" aria-controls="control-button-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-button-short-tab" aria-controls="control-button-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-button-full-panel" role="tabpanel" aria-labelledby="control-button-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local refresh = settings:Button({&#10;    Id = "refresh",&#10;    Name = "Refresh data",&#10;    Description = "Reload the dashboard values.",&#10;    Icon = "refresh-cw",&#10;    Callback = function()&#10;        print("Refreshing")&#10;    end,&#10;})&#10;&#10;refresh:SetLoading(true)&#10;task.wait(1)&#10;refresh:SetLoading(false)</code></pre>
  </div>
  <div class="astra-code-panel" id="control-button-short-panel" role="tabpanel" aria-labelledby="control-button-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Button({&#10;    Name = "Refresh",&#10;    Callback = function()&#10;        print("Refreshing")&#10;    end,&#10;})</code></pre>
  </div>
</div>

ต้องกำหนด `Callback` ส่วน `Icon` เป็นตัวเลือก `SetLoading(boolean)` จะปิดใช้งานปุ่มระหว่างโหลด

## Toggle

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-toggle-full-tab" aria-controls="control-toggle-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-toggle-short-tab" aria-controls="control-toggle-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-toggle-full-panel" role="tabpanel" aria-labelledby="control-toggle-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local music = settings:Toggle({&#10;    Id = "music",&#10;    Name = "Music",&#10;    Description = "Play background music.",&#10;    Default = false,&#10;    Callback = function(enabled)&#10;        print("Music enabled:", enabled)&#10;    end,&#10;})&#10;&#10;music:SetValue(true)&#10;print(music:GetValue())</code></pre>
  </div>
  <div class="astra-code-panel" id="control-toggle-short-panel" role="tabpanel" aria-labelledby="control-toggle-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Toggle({Name = "Music", Default = false})</code></pre>
  </div>
</div>

หากกำหนด `Default` ค่านั้นต้องเป็น boolean

## Slider

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-slider-full-tab" aria-controls="control-slider-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-slider-short-tab" aria-controls="control-slider-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-slider-full-panel" role="tabpanel" aria-labelledby="control-slider-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local volume = settings:Slider({&#10;    Id = "volume",&#10;    Name = "Volume",&#10;    Min = 0,&#10;    Max = 100,&#10;    Step = 5,&#10;    Default = 35,&#10;    Callback = function(value)&#10;        print("Volume:", value)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-slider-short-panel" role="tabpanel" aria-labelledby="control-slider-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Slider({Name = "Volume", Min = 0, Max = 100, Default = 35})</code></pre>
  </div>
</div>

| ฟิลด์ | จำเป็น | รายละเอียด |
|---|---:|---|
| `Min` | ใช่ | ค่าต่ำสุด ซึ่งต้องเป็นตัวเลข |
| `Max` | ใช่ | ค่าสูงสุด ซึ่งต้องมากกว่า `Min` |
| `Step` | ไม่ | ระยะเพิ่มค่าที่ต้องเป็นบวก หากไม่กำหนด การลากตัวชี้จะเปลี่ยนค่าได้ต่อเนื่อง และแป้นพิมพ์จะเพิ่มทีละ 1% ของช่วง |
| `Default` | ไม่ | ค่าเริ่มต้น หากไม่กำหนดจะใช้ `Min` และจำกัดให้อยู่ในช่วง |

Slider รองรับเมาส์ การสัมผัส และการปรับค่าด้วยแป้นซ้าย/ขวาหรือ gamepad เมื่อได้รับโฟกัส

## Dropdown

ใช้เลือก string หนึ่งค่า:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-dropdown-full-tab" aria-controls="control-dropdown-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-dropdown-short-tab" aria-controls="control-dropdown-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-dropdown-full-panel" role="tabpanel" aria-labelledby="control-dropdown-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local quality = settings:Dropdown({&#10;    Id = "quality",&#10;    Name = "Quality",&#10;    Options = {"Low", "Medium", "High"},&#10;    Default = "Medium",&#10;    Callback = function(value)&#10;        print("Quality:", value)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-dropdown-short-panel" role="tabpanel" aria-labelledby="control-dropdown-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Dropdown({Name = "Quality", Options = {"Low", "Medium", "High"}})</code></pre>
  </div>
</div>

`Options` ต้องเป็น array ที่มี string อย่างน้อยหนึ่งค่า หากไม่กำหนด `Default` จะเลือกตัวเลือกแรก `SetValue()` ต้องได้รับค่าที่มีอยู่ใน `Options`

## MultiDropdown

ใช้เลือก string ได้หลายค่าตามต้องการ:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-multidropdown-full-tab" aria-controls="control-multidropdown-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-multidropdown-short-tab" aria-controls="control-multidropdown-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-multidropdown-full-panel" role="tabpanel" aria-labelledby="control-multidropdown-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local effects = settings:MultiDropdown({&#10;    Id = "effects",&#10;    Name = "Effects",&#10;    Options = {"Bloom", "Blur", "Color correction"},&#10;    Default = {"Bloom"},&#10;    Callback = function(values)&#10;        for _, name in ipairs(values) do&#10;            print("Enabled effect:", name)&#10;        end&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-multidropdown-short-panel" role="tabpanel" aria-labelledby="control-multidropdown-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:MultiDropdown({Name = "Effects", Options = {"Bloom", "Blur"}})</code></pre>
  </div>
</div>

`Options` ต้องเป็น array ที่มี string อย่างน้อยหนึ่งค่า `Default` เป็น array ของค่าที่เลือก (ค่าเริ่มต้นเป็น array ว่าง) `GetValue()` จะคืนสำเนาของ array ที่เลือก

## PlayerDropdown

ใช้เลือกผู้เล่นที่อยู่ในเซิร์ฟเวอร์ปัจจุบัน:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-playerdropdown-full-tab" aria-controls="control-playerdropdown-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-playerdropdown-short-tab" aria-controls="control-playerdropdown-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-playerdropdown-full-panel" role="tabpanel" aria-labelledby="control-playerdropdown-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local players = settings:PlayerDropdown({&#10;    Name = "Players",&#10;    Description = "Choose players currently in this server.",&#10;    Placeholder = "Select players...",&#10;    EmptyText = "No players are online.",&#10;    ExcludeLocalPlayer = true,&#10;    Callback = function(selectedPlayers)&#10;        for _, player in ipairs(selectedPlayers) do&#10;            print(player.Name)&#10;        end&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-playerdropdown-short-panel" role="tabpanel" aria-labelledby="control-playerdropdown-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:PlayerDropdown({Name = "Players"})</code></pre>
  </div>
</div>

Dropdown จะติดตามเหตุการณ์ผู้เล่นเข้า/ออก อัปเดตตัวเลือก และนำผู้เล่นที่ออกจากเซิร์ฟเวอร์ออกจากรายการที่เลือก รองรับการเลือกหลายคน โดยตั้งใจไม่รองรับ `Id` และ `Default` เพราะการเลือกมีผลเฉพาะระหว่างรันไทม์และจะไม่ถูก serialize

## Input

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-input-full-tab" aria-controls="control-input-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-input-short-tab" aria-controls="control-input-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-input-full-panel" role="tabpanel" aria-labelledby="control-input-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local username = settings:Input({&#10;    Id = "nickname",&#10;    Name = "Display name",&#10;    Description = "Enter a short label.",&#10;    Placeholder = "Guest",&#10;    Default = "",&#10;    MaxLength = 24,&#10;    Live = false,&#10;    Numeric = false,&#10;    Callback = function(value)&#10;        print("Committed text:", value)&#10;    end,&#10;})&#10;&#10;username:SetError("This name is unavailable.")&#10;username:SetError(nil)</code></pre>
  </div>
  <div class="astra-code-panel" id="control-input-short-panel" role="tabpanel" aria-labelledby="control-input-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Input({Name = "Display name", Placeholder = "Guest"})</code></pre>
  </div>
</div>

เมื่อ `Live = true` จะเรียก callback ขณะข้อความเปลี่ยน หากเป็นค่าอื่น callback จะทำงานเมื่อเสียโฟกัส สำหรับ `Live = false` และ `Numeric = true` จะตรวจสอบเมื่อเสียโฟกัส แสดงข้อผิดพลาด และไม่เรียก callback หากข้อความที่ไม่ว่างไม่ใช่ตัวเลข แต่เมื่อ `Live = true` จะส่งค่าตามที่พิมพ์และข้ามการตรวจสอบตอนยืนยัน `MaxLength` จะตัดข้อความให้ไม่เกินความยาวบวกที่กำหนด ใช้ `SetError(messageOrNil)` เพื่อแสดงหรือล้างข้อผิดพลาด

## Keybind

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-keybind-full-tab" aria-controls="control-keybind-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-keybind-short-tab" aria-controls="control-keybind-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-keybind-full-panel" role="tabpanel" aria-labelledby="control-keybind-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local action = settings:Keybind({&#10;    Id = "quick-action",&#10;    Name = "Quick action",&#10;    Default = Enum.KeyCode.G,&#10;    Callback = function(keyCode)&#10;        print("Pressed:", keyCode.Name)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-keybind-short-panel" role="tabpanel" aria-labelledby="control-keybind-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Keybind({Name = "Quick action", Default = Enum.KeyCode.G})</code></pre>
  </div>
</div>

ค่าเริ่มต้นคือ `Enum.KeyCode.Unknown` คลิก **Change key** แล้วกดปุ่มที่ต้องการ กด Escape ระหว่างรอปุ่มเพื่อยกเลิก callback จะทำงานเมื่อกดปุ่มที่ผูกไว้ และจะไม่ทำงานขณะกล่องข้อความมีโฟกัส

## Colorpicker

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="control-colorpicker-full-tab" aria-controls="control-colorpicker-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="control-colorpicker-short-tab" aria-controls="control-colorpicker-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="control-colorpicker-full-panel" role="tabpanel" aria-labelledby="control-colorpicker-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local tint = settings:Colorpicker({&#10;    Id = "tint",&#10;    Name = "Interface tint",&#10;    Default = Color3.fromRGB(129, 130, 255),&#10;    Callback = function(color)&#10;        print(color)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="control-colorpicker-short-panel" role="tabpanel" aria-labelledby="control-colorpicker-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">settings:Colorpicker({Name = "Interface tint"})</code></pre>
  </div>
</div>

หน้าต่างป๊อปอัปให้เลือกเฉดสี ความอิ่มสี/ความสว่าง และกรอกค่าสี hex 6 หลัก หากกำหนด `Default` ค่านั้นต้องเป็น `Color3`
