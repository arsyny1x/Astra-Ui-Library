# PNG images

PNG decoding is used for the optional floating toggle-button image and the Lilith background. The library decodes PNG data into Roblox `EditableImage` content.

## Built-in decoder

The included `png.luau` and `luau-png.lua` modules support cooperative yielding. The decoder must expose:

- `decode(buffer, options)`
- `supportsYieldIfNeeded = true`

The `options.yieldIfNeeded` callback should be called periodically during long decode operations so the UI remains responsive.

When an image needs decoding, the library first checks for a supplied `PngDecoder`, then a nearby compatible decoder `ModuleScript`, and finally downloads the built-in decoder URL:
`https://raw.githubusercontent.com/arsyny1x/luau-png/refs/heads/main/png.luau`.
You do not need to load or pass the decoder yourself. Set `RestoreImageUrl` and the library handles decoder loading automatically:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

`PngDecoder` and `PngDecoderUrl` are optional overrides for custom decoders. Using the built-in remote decoder requires an executor or runtime that provides `game:HttpGet` and `loadstring`; see [Getting started](getting-started.md).

### Override the decoder

Set this only to use a decoder source other than the built-in URL:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    PngDecoderUrl = "https://example.com/png.luau",
})
```

PNG display requires `EditableImage` API support and the relevant experience/runtime permissions. If decoding or image creation fails, the library emits a warning; the floating toggle falls back to its built-in icon.
