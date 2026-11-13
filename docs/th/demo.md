# สคริปต์ Demo

ดูซอร์สโค้ด [`demo.lua`](https://github.com/arsyny1x/Astra-Ui-Library/blob/main/demo.lua) ซึ่งเป็นแดชบอร์ด Astra UI แบบโต้ตอบ แสดงตัวอย่างแท็บ ตัวควบคุม ธีม การแปลภาษา และการบันทึกการตั้งค่าเสริม

การรันต้องใช้ executor หรือ runtime ที่รองรับ `game:HttpGet` และ `loadstring` ฟังก์ชันบันทึกการตั้งค่าเสริมยังใช้ API `readfile` และ `writefile` จาก executor ด้วย รูป PNG ใช้ตัวถอดรหัสที่มาพร้อมไลบรารี จึงไม่ต้องตั้งค่าตัวถอดรหัสแยก

หน้านี้ยังรองรับ URL Docsify แบบเดิม `#/demo.lua`
