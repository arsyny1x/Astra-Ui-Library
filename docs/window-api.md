# Window API

## Create a window

The `loadstring` bootstrap below requires an executor or runtime that provides `game:HttpGet` and `loadstring`. The current library loads its remote icon dependencies during startup, so a standard Roblox client `LocalScript` cannot use it as-is; see [Getting started](getting-started.md).

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
local window = AstraUI:CreateWindow(config)
```

`CreateWindow` returns the window object. The initial size defaults to `UDim2.fromOffset(1000, 640)`. The window automatically fits within the available viewport, including on smaller screens. Its background and border fade when visibility changes through `SetVisible`, the restore button, or the toggle key.

| Field | Type | Default / notes |
|---|---|---|
| `Title` | string | `"Astra UI"` |
| `Subtitle` | string? | Optional subtitle |
| `HeaderVersion` | string? | Optional version text in the header |
| `Size` | `UDim2`? | Initial size; default 1000 × 640 pixels |
| `ToggleKey` | `Enum.KeyCode`? | Optional visibility toggle key |
| `Responsive` | boolean? | `true` unless explicitly `false` |
| `Resizable` | boolean? | `true` unless explicitly `false` |
| `Draggable` | boolean? | `true` unless explicitly `false` |
| `Theme` | table? | Partial theme-token overrides; values must match token types |
| `Localization` | table? | Localization locale and resolver configuration |
| `Parent` | `Instance`? | Parent GUI; defaults to the local player's `PlayerGui` |
| `RestoreImageUrl` | string? | HTTP(S) PNG for the restore button |
| `PngDecoder` | table? | Decoder exposing `decode(buffer, options)` |
| `PngDecoderUrl` | string? | Optional remote decoder source override; defaults to the bundled `luau-png` URL and downloads/executes code if no decoder module is found |
| `Discord` | table? | Optional `Url` and `Copy` callback |
| `IconLibrary` | table? | Lucide-compatible library exposing `GetAsset(name)` |
| `IconLibraries` | table? | Named icon libraries; Lucide exposes `GetAsset`, Solar is an icon map |

`IconLibrary` is a compatibility alias for `IconLibraries.Lucide`. Icons are library-provided asset names; see [Installation](getting-started.md) for the current runtime limitation around the default remote icon bootstrap.

## Create tabs and sections

```lua
local tab = window:Tab({
    Id = "settings",
    Name = "Settings",
    Icon = "settings",
    Category = "Configuration",
})

local section = tab:Section({
    Name = "General",
    Icon = "sliders-horizontal",
})
```

- Tab `Name` is required. `Id`, `Icon`, and `Category` are optional.
- Section `Name` is optional. `Icon` is optional. `Side` may be `"Left"` or `"Right"` to use responsive side-by-side section layout.
- IDs should be unique within the window. Duplicate IDs are rejected.

## Window methods

| Method | Behavior |
|---|---|
| `Tab(config)` | Create and return a tab |
| `Search(config)` | Add sidebar search; repeated calls return the existing search |
| `Notify(config)` | Show a toast and return it (`toast:Dismiss()` closes it) |
| `Dialog(config)` | Show a modal dialog and return `{Close, Destroy}` |
| `SetVisible(boolean)` | Show or hide the window |
| `SetSize(UDim2)` | Set requested size |
| `SetTheme(theme)` | Apply partial theme-token overrides |
| `SetThemePreset(name)` | Select `"Dark"`, `"Light"`, or `"Lilith"` |
| `SetLocale(locale)` | Change locale and re-resolve registered text |
| `SetToggleKey(Enum.KeyCode)` | Rebind the visibility toggle key |
| `SetResizable(boolean)` | Enable or disable resizing |
| `SetDraggable(boolean)` | Enable or disable dragging |
| `OpenSettings()` | Open the library settings panel |
| `SetHeaderVersion(stringOrNil)` | Change or clear the header version |
| `SetDiscordLink(urlOrNil, copyCallback)` | Set or replace Discord link behavior |
| `GetState()` | Return a serializable state table |
| `SetState(stateTable)` | Validate and restore supported window/component state |
| `Destroy()` | Destroy the window and owned connections |

## Sidebar search

```lua
local search = window:Search({
    Placeholder = "Find a tab",
    Icon = "search",
})
```

`Placeholder` defaults to `"Search"` and `Icon` defaults to `"search"`. `tab:Search(config)` is an alias for `window:Search(config)`.

## Notifications

```lua
local toast = window:Notify({
    Type = "Success",
    Title = "Saved",
    Content = "Your preferences were updated.",
    Duration = 4,
})

toast:Dismiss()
```

`Type` accepts `"Success"`, `"Info"` (default), `"Warning"`, or `"Error"`. `Title` defaults to the type, `Content` defaults to an empty string, and `Duration` defaults to 3 seconds. A duration of `0` disables automatic dismissal. At most four toasts are retained; the oldest is dismissed when another is added.

## Dialogs

```lua
local dialog = window:Dialog({
    Title = "Reset settings?",
    Content = "This action cannot be undone.",
    Actions = {
        {
            Name = "Cancel",
            Style = "Secondary",
        },
        {
            Name = "Reset",
            Style = "Danger",
            Callback = function()
                print("Reset confirmed")
            end,
        },
    },
})
```

`Actions` is a non-empty array. Each action requires `Name`; `Style` accepts `"Primary"` (default), `"Secondary"`, or `"Danger"`. `Callback` is optional. Actions close the dialog by default; set `Close = false` to keep it open after clicking. The returned object has `Close()` and `Destroy()` methods.

## Themes and settings

```lua
window:SetThemePreset("Light")
window:SetTheme({
    Accent = Color3.fromRGB(120, 110, 255),
})
window:SetToggleKey(Enum.KeyCode.RightControl)
window:SetVisible(false)
```

Theme presets are `"Dark"`, `"Light"`, and `"Lilith"`. `SetTheme` merges partial overrides. Supported token names and preset behavior are documented in [Themes](themes.md).

## State serialization

```lua
local state = window:GetState()
-- Store state with a persistence mechanism appropriate for your own experience.
window:SetState(state)
```

`GetState()` returns `Version = 1`, selected tab ID, theme preset, locale, toggle key name, resize/drag settings, and values of components with IDs and `GetValue()`. Color values are represented as `{R, G, B}` and keybinds as key names. `SetState()` applies supported settings and matching component values; unknown IDs and invalid values are warned about and ignored. PlayerDropdown selections and display-only components are not serialized.

The UI library does not persist data by itself. Use Roblox storage appropriate to your experience and never trust client state for server-authoritative game actions.

## Discord link callback

`Discord = {Url = "...", Copy = function(url) ... end}` supplies an optional link and a host-owned copy callback. The library does not provide clipboard access. `SetDiscordLink(urlOrNil, copyCallback)` replaces this configuration at runtime.
