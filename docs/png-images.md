# PNG images

PNG decoding is used for the optional floating toggle-button image and the Lilith background. The library decodes PNG data into Roblox `EditableImage` content.

## Provide a decoder

The included `png.luau` and `luau-png.lua` modules support cooperative yielding. The decoder must expose:

- `decode(buffer, options)`
- `supportsYieldIfNeeded = true`

The `options.yieldIfNeeded` callback should be called periodically during long decode operations so the UI remains responsive.

When an image needs decoding, the library first checks for a supplied `PngDecoder`, then a nearby compatible decoder `ModuleScript`, and finally downloads the built-in decoder URL:
`https://raw.githubusercontent.com/arsyny1x/luau-png/refs/heads/main/png.luau`.
Override this URL with `PngDecoderUrl` only when you need a different source. Remote source loading requires an executor or runtime that provides `game:HttpGet` and `loadstring`.

### Load decoder via loadstring

You can load and pass a decoder yourself in an executor or runtime that provides `game:HttpGet` and `loadstring`:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
local pngDecoder = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/png.luau"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    PngDecoder = pngDecoder,
})
```

### Override PngDecoderUrl

Set this only to use a decoder source other than the built-in URL:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    PngDecoderUrl = "https://example.com/png.luau",
})
```

PNG display requires `EditableImage` API support and the relevant experience/runtime permissions. If decoding or image creation fails, the library emits a warning; the floating toggle falls back to its built-in icon.
