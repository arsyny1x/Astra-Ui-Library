# JPEG decoder

`jpeg.luau` decodes baseline sequential and progressive 8-bit JPEG images. It supports grayscale and three-component RGB or YCbCr images and returns an RGBA `buffer`. Astra UI also uses this decoder automatically for JPEG image URLs; `JpegDecoder` and `JpegDecoderUrl` can override it.

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

Coordinates passed to `readPixel` are 1-based. `pixels` stores four bytes per pixel in RGBA order. The optional `yieldIfNeeded` callback is called periodically during decoding.

Arithmetic-coded and CMYK/four-component JPEGs are not supported. Progressive decoding uses up to 64 MB of coefficient storage. The standalone decoder accepts images up to 8192 pixels on either side or 16,777,216 pixels total; Astra UI applies a lower 4096-pixel-side and 4-megapixel limit before decoding. The host must also support `EditableImage` to render decoded pixels.
