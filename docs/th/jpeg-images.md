# ตัวถอดรหัส JPEG

`jpeg.luau` ถอดรหัสภาพ JPEG แบบ baseline sequential 8-bit รองรับภาพ grayscale และภาพสามองค์ประกอบแบบ RGB หรือ YCbCr โดยส่งผลลัพธ์เป็น `buffer` รูปแบบ RGBA ระบบโหลดรูปของ Astra UI จะเลือก decoder นี้อัตโนมัติเมื่อ URL เป็น JPEG และสามารถแทนที่ด้วย `JpegDecoder` หรือ `JpegDecoderUrl` ได้:

```lua
local JPEG = require(script.Parent.jpeg)
local encoded = buffer.fromstring(game:HttpGet("https://example.com/image.jpg"))

local image = JPEG.decode(encoded, {
    yieldIfNeeded = function()
        task.wait()
    end,
})

print(image.width, image.height)
local red, green, blue, alpha = image.readPixel(1, 1)
```

พิกัดที่ส่งให้ `readPixel` เริ่มจาก 1 ส่วน `pixels` เก็บข้อมูล 4 ไบต์ต่อพิกเซลตามลำดับ RGBA สามารถส่ง callback `yieldIfNeeded` ซึ่งจะถูกเรียกเป็นระยะระหว่างถอดรหัสได้

ยังไม่รองรับ JPEG แบบ arithmetic-coded และ CMYK/สี่องค์ประกอบ การถอดรหัส progressive ใช้ coefficient storage ได้สูงสุด 64 MB ตัว decoder แบบแยกรับภาพได้ไม่เกิน 8192 พิกเซลต่อด้าน หรือรวมไม่เกิน 16,777,216 พิกเซล ส่วนระบบโหลดรูปของ Astra UI จำกัดไว้ที่ 4096 พิกเซลต่อด้านและรวมไม่เกิน 4 ล้านพิกเซล นอกจากนี้ host ต้องรองรับ `EditableImage` เพื่อแสดงผลภาพ
