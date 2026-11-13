# Window API

## Create a window

The `loadstring` bootstrap below requires an executor or runtime that provides `game:HttpGet` and `loadstring`. The current library loads its remote icon dependencies during startup, so a standard Roblox client `LocalScript` cannot use it as-is; see [Quick start](quick-start.md).

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
local window = AstraUI:CreateWindow(config)
```

`CreateWindow` returns the window object with the Lilith theme by default. The initial size defaults to `UDim2.fromOffset(800, 500)`. The window automatically fits within the available viewport, including on smaller screens; on Android and iOS, the window, content, popups, and toasts share a single 70-80% global scale. Responsive columns are selected from the displayed width after scaling, while the floating visibility button retains its size. The window scales down when hidden and expands when shown through `SetVisible`, the restore button, or the toggle key, while its border fades.

| Field | Type | Default / notes |
|---|---|---|
| `Title` | string | `"Astra UI"` |
| `Subtitle` | string? | Optional subtitle |
| `HeaderVersion` | string? | Optional version text in the header |
| `Size` | `UDim2`? | Initial size; default 800 × 500 pixels |
| `ToggleKey` | `Enum.KeyCode`? | Optional visibility toggle key |
| `Responsive` | boolean? | `true` unless explicitly `false` |
| `Resizable` | boolean? | `true` unless explicitly `false` |
| `Draggable` | boolean? | `true` unless explicitly `false` |
| `Theme` | table? | Partial theme-token overrides; values must match token types |
| `Localization` | table? | Locale, resolver, and optional `Locales` translation map |
| `Settings` | table? | Optional shared profile key, `FilePath` for built-in JSON persistence, or host callbacks |
| `StatePersistence` | table? | Optional `Path` for `SaveStateToFile`/`LoadStateFromFile` and `AutoSaveInterval` |
| `Parent` | `Instance`? | Parent GUI; defaults to `gethui()` (alias: `get_hidden_gui()`). An explicit parent overrides this. |
| `RestoreImageUrl` | string? | HTTP(S) PNG or supported baseline/progressive JPEG for the restore button |
| `PngDecoder` | table? | Decoder exposing `decode(buffer, options)` |
| `PngDecoderUrl` | string? | Optional remote decoder source override; defaults to this repository's `png.luau` and downloads/executes code if no decoder module is found |
| `JpegDecoder` | table? | Optional baseline/progressive JPEG decoder exposing `decode(buffer, options)` |
| `JpegDecoderUrl` | string? | Optional remote JPEG decoder source override; defaults to the bundled `jpeg.luau` URL and downloads/executes code if no decoder module is found |
| `Discord` | table? | Optional invite `Url` and host-provided `Copy(url)` callback |
| `IconLibrary` | table? | Lucide-compatible library exposing `GetAsset(name)` |
| `IconLibraries` | table? | Named icon libraries; Lucide exposes `GetAsset`, Solar is an icon map |

`IconLibrary` is a compatibility alias for `IconLibraries.Lucide`. Icons are library-provided asset names; see [Quick start](quick-start.md) for the current runtime limitation around the default remote icon bootstrap.

The Settings panel lets you create themes and add locales through separate workflows. Locale creation provides **Copy JSON template**; paste into its editor using the platform's normal text input shortcut (for example, Ctrl+V). Settings are persisted as a shared profile through `Settings.Save`. See [State and localization](state-and-localization.md) for locale JSON and the persistence adapter.

## Create tabs and sections

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-tabs-sections examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-tabs-sections-full-tab" aria-controls="example-tabs-sections-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-tabs-sections-short-tab" aria-controls="example-tabs-sections-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-tabs-sections-full-panel" role="tabpanel" aria-labelledby="example-tabs-sections-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({&#10;    Id = "settings",&#10;    Name = "Settings",&#10;    Icon = "settings",&#10;    Category = "Configuration",&#10;})&#10;&#10;local section = tab:Section({&#10;    Name = "General",&#10;    Icon = "sliders-horizontal",&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-tabs-sections-short-panel" role="tabpanel" aria-labelledby="example-tabs-sections-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({Name = "Settings"})&#10;tab:Section({Name = "General"})</code></pre>
  </div>
</div>

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
| `SetToggleKey(Enum.KeyCode or nil)` | Rebind or clear the visibility toggle key |
| `SetResizable(boolean)` | Enable or disable resizing |
| `SetDraggable(boolean)` | Enable or disable dragging |
| `OpenSettings()` | Open the library settings panel |
| `SetHeaderVersion(stringOrNil)` | Change or clear the header version |
| `SetDiscordLink(urlOrNil, copyCallback)` | Set or replace Discord link behavior |
| `GetState()` | Return a serializable state table |
| `SetState(stateTable)` | Validate and restore supported window/component state |
| `SaveStateToFile(path?)` | Save `GetState()` as JSON using host file APIs |
| `LoadStateFromFile(path?)` | Load and apply saved JSON state |
| `StartStateAutoSave(interval?)` | Save state changes periodically using `StatePersistence` |
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

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-notifications examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-notifications-full-tab" aria-controls="example-notifications-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-notifications-short-tab" aria-controls="example-notifications-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-notifications-full-panel" role="tabpanel" aria-labelledby="example-notifications-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local toast = window:Notify({&#10;    Type = "Success",&#10;    Title = "Saved",&#10;    Content = "Your preferences were updated.",&#10;    Duration = 4,&#10;})&#10;&#10;toast:Dismiss()</code></pre>
  </div>
  <div class="astra-code-panel" id="example-notifications-short-panel" role="tabpanel" aria-labelledby="example-notifications-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:Notify({Title = "Saved", Content = "Preferences updated."})</code></pre>
  </div>
</div>

`Type` accepts `"Success"`, `"Info"` (default), `"Warning"`, or `"Error"`. `Title` defaults to the type, `Content` defaults to an empty string, and `Duration` defaults to 3 seconds. A duration of `0` disables automatic dismissal. At most four toasts are retained; the oldest is dismissed when another is added.

## Dialogs

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-dialogs examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-dialogs-full-tab" aria-controls="example-dialogs-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-dialogs-short-tab" aria-controls="example-dialogs-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-dialogs-full-panel" role="tabpanel" aria-labelledby="example-dialogs-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local dialog = window:Dialog({&#10;    Title = "Reset settings?",&#10;    Content = "This action cannot be undone.",&#10;    Actions = {&#10;        {&#10;            Name = "Cancel",&#10;            Style = "Secondary",&#10;        },&#10;        {&#10;            Name = "Reset",&#10;            Style = "Danger",&#10;            Callback = function()&#10;                print("Reset confirmed")&#10;            end,&#10;        },&#10;    },&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-dialogs-short-panel" role="tabpanel" aria-labelledby="example-dialogs-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:Dialog({Title = "Reset settings?", Content = "This cannot be undone.", Actions = {{Name = "Reset"}}})</code></pre>
  </div>
</div>

`Actions` is a non-empty array. Each action requires `Name`; `Style` accepts `"Primary"` (default), `"Secondary"`, or `"Danger"`. `Callback` is optional. Actions close the dialog by default; set `Close = false` to keep it open after clicking. The returned object has `Close()` and `Destroy()` methods.

## Themes and settings

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-themes-settings examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-themes-settings-full-tab" aria-controls="example-themes-settings-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-themes-settings-short-tab" aria-controls="example-themes-settings-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-themes-settings-full-panel" role="tabpanel" aria-labelledby="example-themes-settings-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset("Light")&#10;window:SetTheme({&#10;    Accent = Color3.fromRGB(120, 110, 255),&#10;})&#10;window:SetToggleKey(Enum.KeyCode.RightControl)&#10;window:SetVisible(false)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-themes-settings-short-panel" role="tabpanel" aria-labelledby="example-themes-settings-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset("Light")&#10;window:SetVisible(false)</code></pre>
  </div>
</div>

Theme presets are `"Dark"`, `"Light"`, and `"Lilith"`. `SetTheme` merges partial overrides. Supported token names and preset behavior are documented in [Themes](themes.md).

## State serialization

```lua
local state = window:GetState()
-- Store state with a persistence mechanism appropriate for your own experience.
window:SetState(state)
```

`GetState()` returns `Version = 1`, selected tab ID, theme preset, locale, toggle key name, resize/drag settings, and values of components with IDs and `GetValue()`. Color values are represented as `{R, G, B}` and keybinds as key names. `SetState()` applies supported settings and matching component values; unknown IDs and invalid values are warned about and ignored. PlayerDropdown selections and display-only components are not serialized.

The UI library does not persist data by itself. Use Roblox storage appropriate to your experience and never trust client state for server-authoritative game actions.

## Discord link button

The message-circle button in the window header copies the invite URL through a callback supplied by the host:

```lua
local window = AstraUI:CreateWindow({
    Discord = {
        Url = "https://discord.gg/your-invite",
        Copy = function(url)
            setclipboard(url)
        end,
    },
    Localization = {
        Locale = "th-TH",
    },
})
```

`setclipboard` is an example of a host/executor-provided function; clipboard access is not provided by the library or standard Roblox APIs. The callback receives the configured URL. `SetDiscordLink(urlOrNil, copyCallback)` can replace the settings at runtime.

The button's `AstraLabel` and notifications use built-in Thai when the locale starts with `th` (for example, `th-TH`) and English otherwise. `Localization.Resolve` can override these strings using the keys `discord.button`, `discord.url_missing.title`, `discord.url_missing.content`, `discord.copy_missing.title`, `discord.copy_missing.content`, `discord.copy_failed.title`, `discord.copy_failed.content`, `discord.copied.title`, and `discord.copied.content`.
