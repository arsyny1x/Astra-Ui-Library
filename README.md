# Astra UI

**[English](README.md) | [ไทย](README.th.md)**

Astra UI is a reusable Roblox Luau UI library built with native Roblox GUI objects. It provides responsive windows, tabs, sections, cards, interactive controls, theme presets, notifications, dialogs, player selection, and state serialization.

## Features

- Responsive desktop and mobile layouts with draggable, resizable windows
- Dark, Light, and Lilith theme presets, plus per-token theme overrides
- Tabs, categorized navigation, sections, cards, and search
- Buttons, toggles, sliders, dropdowns, multi-select dropdowns, and player dropdowns
- Inputs, keybinds, color pickers, progress indicators, status panels, and badges
- Notifications, dialogs, localization hooks, and serializable window state
- Optional PNG and JPEG images for the floating window-toggle button and Lilith background
- Bundled Luau PNG and baseline/progressive JPEG decoders with cooperative yielding

## Files

| File | Description |
|---|---|
| `main.lua` | Astra UI library; its current remote icon bootstrap requires `game:HttpGet` and `loadstring` |
| `demo.lua` | Example dashboard using the library |
| `png.luau` | PNG decoder with cooperative-yield support |
| `jpeg.luau` | Baseline JPEG decoder with cooperative-yield support |
| `UI_LIBRARY_SPEC.md` | Design and API specification |
| `LICENSE` | MIT License |

## Requirements

- The current remote icon bootstrap requires an executor or environment that supports `game:HttpGet` and `loadstring` (e.g. Potassium or another supported executor); a standard Roblox client `LocalScript` cannot load it as-is.
- PNG and JPEG rendering requires Roblox `EditableImage` support and the required experience/runtime permissions.
- The demo's settings save/load and autosave features use `readfile` / `writefile` — executor-provided APIs not available in a standard Roblox client.

## Installation

### Load via loadstring (executor environments)

In a compatible executor or runtime, no Studio setup is needed:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

### PNG and JPEG support

The library detects PNG and baseline or progressive JPEG image data and loads the matching decoder automatically. You only need to provide the image URL:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

No decoder configuration is needed for the bundled decoders. They expose `decode(buffer, options)` and `supportsYieldIfNeeded = true`.

### JPEG decoder

`jpeg.luau` decodes baseline and progressive 8-bit grayscale, RGB, and YCbCr JPEGs and is used by Astra UI's image loading. See the [JPEG decoder guide](docs/jpeg-images.md) for format limitations.

## Quick start

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Subtitle = "Welcome",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(800, 500),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
        AccentSecondary = Color3.fromRGB(46, 211, 159),
    },
})

local home = window:Tab({
    Id = "home",
    Name = "Home",
    Icon = "house",
})

local settings = home:Section({
    Name = "Settings",
})

settings:Toggle({
    Id = "notifications",
    Name = "Enable notifications",
    Default = true,
    Callback = function(enabled)
        print("Notifications enabled:", enabled)
    end,
})

settings:Button({
    Name = "Show notification",
    Callback = function()
        window:Notify({
            Title = "Astra UI",
            Content = "Your dashboard is ready.",
            Type = "Success",
        })
    end,
})
```

## Components

Create tabs with `window:Tab(config)`, sections with `tab:Section(config)`, and cards with `tab:Card(config)`. Sections support:

- `Button`
- `Toggle`
- `Slider`
- `Dropdown`
- `MultiDropdown`
- `PlayerDropdown`
- `Input`
- `Keybind`
- `Colorpicker`
- `Paragraph`
- `Console`
- `Divider`
- `Progress`
- `State` and `EmptyState`
- `Badge`
- `Accordion`
- `Custom`

See the [component reference](docs/components.md) and [Window API](docs/window-api.md) for detailed parameters, return values, and examples.

Most controls accept an optional stable `Id` and a `Callback`. See `demo.lua` and `UI_LIBRARY_SPEC.md` for additional examples and configuration details. Player dropdown selections are runtime-only and are not saved to window state.

## Themes

Choose a built-in preset:

```lua
window:SetThemePreset("Dark")
window:SetThemePreset("Light")
window:SetThemePreset("Lilith")
```

Lilith uses its artwork as a cropped background with coordinated cool-blue surfaces and crimson accents. The PNG is loaded when Lilith is selected.

Apply token overrides without replacing the whole palette:

```lua
window:SetTheme({
    Accent = Color3.fromRGB(129, 130, 255),
    AccentSecondary = Color3.fromRGB(46, 211, 159),
    CornerRadius = 10,
})
```

Explicit accent overrides supplied in `CreateWindow.Theme` or later through `SetTheme` are retained when switching back from Lilith to Dark or Light.

## Images: PNG and JPEG support

`RestoreImageUrl` optionally supplies the image shown inside the floating window-toggle button. The Lilith theme has its own background artwork URL.

Set `RestoreImageUrl` to a direct PNG or JPEG URL; the library detects the file format and loads the matching decoder:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.jpg",
})
```

The bundled decoders expose `decode(buffer, options)` and `supportsYieldIfNeeded = true`. `PngDecoder` / `PngDecoderUrl` and `JpegDecoder` / `JpegDecoderUrl` optionally override their respective decoders. JPEG support covers baseline and progressive 8-bit grayscale, RGB, and YCbCr images; arithmetic-coded and CMYK JPEGs are not supported. Progressive decoding uses up to 64 MB for coefficient storage. Remote decoder loading requires an executor or runtime that provides `game:HttpGet` and `loadstring`. Image rendering requires `EditableImage` support and permissions in the target environment. If an image cannot be loaded or decoded, the library warns and keeps the built-in toggle icon visible.

## Window methods

The window handle includes:

- `SetVisible(boolean)`, `SetSize(UDim2)`, `SetTheme(theme)`, `SetThemePreset(name)`
- `SetLocale(locale)`, `SetToggleKey(Enum.KeyCode)`, `SetResizable(boolean)`, `SetDraggable(boolean)`
- `Notify(config)`, `Dialog(config)`, `OpenSettings()`
- `SetHeaderVersion(stringOrNil)`, `SetDiscordLink(urlOrNil, copyCallback)`
- `GetState()`, `SetState(stateTable)`, `SaveStateToFile()`, `LoadStateFromFile()`, `StartStateAutoSave()`, and `Destroy()`

Use explicit IDs on controls and tabs that should be restored through the state methods. File persistence helpers require host-provided filesystem functions and do not write to a Roblox data store.

## Demo

`demo.lua` creates an analytics dashboard with player information, controls, localization examples, theme settings, and optional settings persistence. The persistence controls require host-provided filesystem functions and are not required to use the UI library.

## License

This project is licensed under the MIT License. See [`LICENSE`](./LICENSE).
