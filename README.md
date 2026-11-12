# Astra UI

Astra UI is a reusable Roblox Luau UI library built with native Roblox GUI objects. It provides responsive windows, tabs, sections, cards, interactive controls, theme presets, notifications, dialogs, player selection, and state serialization.

**Documentation:** [Publish the documentation site with GitHub Pages](docs/deployment.md). Once enabled, use the URL shown in the repository's Pages settings.

## Features

- Responsive desktop and mobile layouts with draggable, resizable windows
- Dark, Light, and Lilith theme presets, plus per-token theme overrides
- Tabs, categorized navigation, sections, cards, and search
- Buttons, toggles, sliders, dropdowns, multi-select dropdowns, and player dropdowns
- Inputs, keybinds, color pickers, progress indicators, status panels, and badges
- Notifications, dialogs, localization hooks, and serializable window state
- Optional PNG images for the floating window-toggle button and Lilith background
- Bundled Luau PNG decoders with cooperative yielding

## Files

| File | Description |
|---|---|
| `main.lua` | Astra UI library; its current remote icon bootstrap requires `game:HttpGet` and `loadstring` |
| `demo.lua` | Example dashboard using the library |
| `png.luau` | PNG decoder with cooperative-yield support |
| `luau-png.lua` | Alternate PNG decoder implementation |
| `UI_LIBRARY_SPEC.md` | Design and API specification |
| `LICENSE` | MIT License |

## Requirements

- The current remote icon bootstrap requires an executor or environment that supports `game:HttpGet` and `loadstring` (e.g. Potassium or another supported executor); a standard Roblox client `LocalScript` cannot load it as-is.
- PNG rendering requires Roblox `EditableImage` support and the required experience/runtime permissions.
- The demo's settings save/load and autosave features use `readfile` / `writefile` — executor-provided APIs not available in a standard Roblox client.

## Installation

### Load via loadstring (executor environments)

In a compatible executor or runtime, no Studio setup is needed:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

### PNG support

The library loads its built-in PNG decoder automatically when an image is used. You only need to provide the image URL:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

No separate `PngDecoder` or `PngDecoderUrl` configuration is needed. The built-in decoder exposes `decode(buffer, options)` and `supportsYieldIfNeeded = true`.

## Quick start

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Subtitle = "Welcome",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(1000, 640),
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

## Images and PNG support

`RestoreImageUrl` optionally supplies the image shown inside the floating window-toggle button. The Lilith theme has its own background artwork URL.

To use a PNG image, set `RestoreImageUrl`; the library automatically loads its built-in decoder:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    RestoreImageUrl = "https://example.com/icon.png",
})
```

The built-in decoder exposes `decode(buffer, options)` and `supportsYieldIfNeeded = true`. `PngDecoder` and `PngDecoderUrl` are optional overrides for custom decoders. Remote decoder loading requires an executor or runtime that provides `game:HttpGet` and `loadstring`, and is not suitable for a standard Roblox client. If an image cannot be loaded or decoded, the library warns and keeps the built-in toggle icon visible. PNG support depends on `EditableImage` availability and permissions in the target environment.

## Window methods

The window handle includes:

- `SetVisible(boolean)`, `SetSize(UDim2)`, `SetTheme(theme)`, `SetThemePreset(name)`
- `SetLocale(locale)`, `SetToggleKey(Enum.KeyCode)`, `SetResizable(boolean)`, `SetDraggable(boolean)`
- `Notify(config)`, `Dialog(config)`, `OpenSettings()`
- `SetHeaderVersion(stringOrNil)`, `SetDiscordLink(urlOrNil, copyCallback)`
- `GetState()`, `SetState(stateTable)`, and `Destroy()`

Use explicit IDs on controls and tabs that should be restored through `GetState()` and `SetState()`. The library does not write to a data store or filesystem; persistence belongs to the host experience.

## Demo

`demo.lua` creates an analytics dashboard with player information, controls, localization examples, theme settings, and optional settings persistence. The persistence controls require host-provided filesystem functions and are not required to use the UI library.

## License

This project is licensed under the MIT License. See [`LICENSE`](./LICENSE).
