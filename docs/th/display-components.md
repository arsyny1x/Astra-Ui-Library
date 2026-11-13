# ส่วนประกอบแสดงผล

ส่วนประกอบแสดงผลจะอยู่ใน section ส่วนประกอบที่ใช้แถวควบคุมร่วมกันรองรับ `Name`, `Description` (ไม่บังคับ) และ `Id` (ไม่บังคับ) ฟิลด์เฉพาะของแต่ละรายการมีดังนี้

## Paragraph

แสดงข้อความหลายบรรทัดและเปลี่ยนข้อความภายหลังได้:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-paragraph-full-tab" aria-controls="example-paragraph-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-paragraph-short-tab" aria-controls="example-paragraph-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-paragraph-full-panel" role="tabpanel" aria-labelledby="example-paragraph-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local status = section:Paragraph({&#10;    Id = "status-text",&#10;    Title = "Current status",&#10;    Content = "Waiting for data...",&#10;})&#10;&#10;status:SetContent("Data received.")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-paragraph-short-panel" role="tabpanel" aria-labelledby="example-paragraph-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Paragraph({Title = "Status", Content = "Waiting..."})</code></pre>
  </div>
</div>

ต้องกำหนด `Content` ส่วน `Title` เป็นตัวเลือก `SetContent(string)` ใช้แทนที่เนื้อหา โดยเนื้อหาจะแสดงในพื้นหลังตามธีมที่มี padding และเส้นขอบบาง ๆ

## Console

แสดง log ระหว่างรันในแผงข้อความแบบ monospace ที่เลื่อนได้:

```lua
local console = section:Console({
    Id = "runtime-log",
    Name = "Runtime log",
    Height = 180,
    MaxEntries = 100,
})

console:Log("Connected to the server")
console:Log("Retrying with fallback settings", "Warning")
console:Log("Could not load configuration", "Error")

console:Clear()
```

`Height` คือความสูงของแผงเป็นพิกเซล (ค่าเริ่มต้น `160`) ส่วน `MaxEntries` จำกัดจำนวนข้อความที่เก็บไว้ (ค่าเริ่มต้น `100`) เมื่อเต็ม ระบบจะลบข้อความเก่าก่อน `Log(message, level)` รองรับ `"Info"`, `"Success"`, `"Warning"` และ `"Error"` โดยค่าเริ่มต้นเป็น `"Info"` ใช้ `Clear()` เพื่อล้างข้อความทั้งหมด พื้นที่แสดงผลและข้อความใช้พื้นหลังกับสีตามธีม รายการใน Console ใช้แสดงผลเท่านั้นและไม่รันคำสั่งจากช่องกรอก

## Divider

```lua
section:Divider()
```

เพิ่มเส้นคั่นสีตามธีมหนา 1 พิกเซล ไม่รับการตั้งค่า

## Progress

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-progress-full-tab" aria-controls="example-progress-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-progress-short-tab" aria-controls="example-progress-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-progress-full-panel" role="tabpanel" aria-labelledby="example-progress-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local progress = section:Progress({&#10;    Id = "download-progress",&#10;    Name = "Download",&#10;    Description = "Downloading assets.",&#10;    Value = 0.4,&#10;    ShowValue = true,&#10;})&#10;&#10;progress:SetValue(0.75)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-progress-short-panel" role="tabpanel" aria-labelledby="example-progress-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Progress({Name = "Download", Value = 0})</code></pre>
  </div>
</div>

`Value` ต้องอยู่ระหว่าง 0 ถึง 1 `ShowValue` จะแสดงเปอร์เซ็นต์แบบปัดเศษ กำหนด `Indeterminate = true` เพื่อแสดงตัวบอกงานที่กำลังดำเนินการ (การทำงานปัจจุบันแสดงแถบเติมคงที่บางส่วน) หาก `ShowValue` เป็น false จะแสดง `Label` แทน ใช้ `GetValue()` และ `SetValue(value)` ได้

## State

แสดงแผงสถานะพร้อมการกระทำเสริม:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-state-full-tab" aria-controls="example-state-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-state-short-tab" aria-controls="example-state-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-state-full-panel" role="tabpanel" aria-labelledby="example-state-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local connection = section:State({&#10;    Id = "connection",&#10;    Type = "Success",&#10;    Title = "Connected",&#10;    Description = "The service is ready.",&#10;    Icon = "circle-check",&#10;    Action = {&#10;        Name = "Reconnect",&#10;        Callback = function()&#10;            print("Retry connection")&#10;        end,&#10;    },&#10;})&#10;&#10;connection:SetState("Error", "Connection failed.")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-state-short-panel" role="tabpanel" aria-labelledby="example-state-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:State({Type = "Success", Title = "Connected"})</code></pre>
  </div>
</div>

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

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="ตัวอย่างโค้ด">
    <button class="astra-code-tab" type="button" role="tab" id="example-badge-full-tab" aria-controls="example-badge-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">ตัวอย่างเต็ม</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-badge-short-tab" aria-controls="example-badge-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">ตัวอย่างย่อ</button>
  </div>
  <div class="astra-code-panel" id="example-badge-full-panel" role="tabpanel" aria-labelledby="example-badge-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local badge = section:Badge({&#10;    Id = "server-status",&#10;    Text = "Online",&#10;    Type = "Success",&#10;})&#10;&#10;badge:SetText("Maintenance")&#10;badge:SetType("Warning")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-badge-short-panel" role="tabpanel" aria-labelledby="example-badge-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Badge({Text = "Online"})</code></pre>
  </div>
</div>

ชนิดที่รองรับคือ `"Neutral"`, `"Info"`, `"Success"`, `"Warning"` และ `"Error"` โดยชนิดจะกำหนดสีข้อความ จุด และเส้นขอบตามความหมาย
