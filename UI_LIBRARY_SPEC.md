# Astra UI — Roblox UI Library Design Spec

> Working name: **Astra UI**. An original, reusable Luau UI library with a premium dark-glass visual style. This document describes the design and public API; see [`main.lua`](./main.lua) for the initial implementation.

The initial implementation lives in [`main.lua`](./main.lua) as a Roblox `ModuleScript`. The intended host is a client `LocalScript` in an experience you own, creating windows under the local player's `PlayerGui`. The current icon bootstrap uses `game:HttpGet` and `loadstring`, so it must be adapted to use local, reviewed icon dependencies before it can run in a standard Roblox client.

## 1. Product direction

Astra UI is a responsive component library for Roblox experiences, built with Roblox-native `ScreenGui` and `GuiObject` components. It supports desktop and mobile layouts and input; desktop is the visual reference, not a requirement. React is a visual reference only; the library API and runtime use Luau. The API should be declarative enough to compose quickly, while leaving room for future controls and custom content.

### Design principles

- **Readable first:** translucent surfaces never compromise text contrast or hit targets.
- **Quiet premium:** deep navy surfaces, restrained purple/green highlights, and a soft aurora gradient only on large surfaces or active states.
- **Composable:** windows contain tabs; tabs contain sections; sections contain controls.
- **Predictable:** each control has a small config table, a stable value, and an optional callback.
- **Contained:** create and destroy only UI and input connections owned by this library; do not modify global lighting or experience settings.
- **Touch-ready:** use practical touch targets and avoid hover-only behavior or controls that require pixel-precise dragging.

## 2. Visual system

### Color tokens

| Token | Dark | Light | Use |
|---|---|---|---|
| `Background` | `#0B0E17` | `#E8EDF5` | Window canvas |
| `WindowBorder` | `#1E2436` | `#B3BFCF` | Outer window outline |
| `Surface` | `#111625` | `#F2F6FA` | Main content surfaces |
| `SurfaceRaised` | `#161D2D` | `#F7F9FC` | Raised panels and popovers |
| `SurfaceHover` | `#1E2246` | `#E4EBF4` | Navigation and general hover |
| `SecondarySurface` | `#1E2246` | `#E6EFF8` | Selected navigation surface |
| `ControlSurface` | `#141C2B` | `#ECF1F7` | Inputs, buttons, and search |
| `ControlInset` | `#0E1421` | `#E0E7F0` | Recessed dropdowns, player options, and selected-player badges |
| `ControlHover` | `#1D2739` | `#E2EAF3` | Interactive control hover |
| `ControlTrack` | `#263144` | `#CFDAE7` | Slider/progress tracks and off toggles |
| `ControlBorder` | `#313F54` | `#B1BFD1` | Control outlines and toggle/slider knobs |
| `ControlKnob` | `#DCE4EF` | `#FCFDFF` | Toggle and slider knobs |
| `StateSurface` | `#161D2D` | `#F7F9FC` | Shared background for sections, controls, dashboard, and status cards |
| `Border` | `#222B40` | `#BFCAD8` | Default outlines |
| `BorderActive` | `#10B981` | `#059669` | Selected and focused outlines |
| `TextPrimary` | `#EBF1FA` | `#182230` | Titles and primary values |
| `TextSecondary` | `#9CABC1` | `#4D5B6D` | Descriptions and metadata |
| `TextMuted` | `#677892` | `#707E91` | Hints and disabled labels |
| `Accent` | `#3B429F` | `#6366F1` | Brand accent |
| `AccentSecondary` | `#10B981` | `#059669` | Primary actions and active states |
| `AccentForeground` | `#061E19` | `#061E19` | Readable text and icons on primary green actions |
| `Success` | `#10B981` | `#059669` | Success status |
| `Warning` | `#D97706` | `#B46700` | Caution status |
| `Danger` | `#F56879` | `#D2374B` | Error/destructive status |

Use the typed `Theme` tokens and presets instead of assigning neutral colors separately in components or demos. Dark and Light use cool, softened surfaces; Light uses a brighter canvas, near-white cards, lightly tinted controls, and clearer border contrast without pure-white expanses. Lilith is a dedicated light palette inspired by its artwork: icy blue and cool white surfaces, deep navy text, crimson accents, and restrained blush hover states. It loads the selected artwork as a cropped background and makes major cards, sidebar, and header lightly translucent so the art is visible without sacrificing text contrast. Accent, semantic status, corner radius, and density tokens remain independently overridable.

### Typography, shape, and spacing

- Use Roblox `Enum.Font.GothamMedium` for default body text and `GothamBold` for hierarchy; components may opt into lighter text where appropriate.
- Window title: 18–20 px; section title: 14–16 px; body: 13–14 px; hints: 11–12 px.
- Base spacing scale: 4, 8, 12, 16, 20, 24 px.
- Panel corner radius: 12–16 px; controls: 8–10 px; pills and status badges: fully rounded.
- Use a 1 px `UIStroke` with subtle transparency for panel boundaries and a soft shadow. Reserve brighter strokes for focus/selection.
- Keep core interactive targets at least 44 × 44 px in touch layouts and preferably 40 × 40 px or more on desktop; provide adequate spacing so neighboring controls are not accidentally activated.

### Motion and interaction

- Use short `TweenService` transitions (roughly 0.14–0.22 seconds) for hover, selection, expand/collapse, and toast entry/exit.
- Tab changes use a brief content transition, and toggles animate the thumb and track together while keeping the thumb inside the switch bounds.
- Window header and sidebar surfaces preserve the rounded shell corners instead of painting over them with square edges.
- Provide visible hover, pressed, disabled, selected, and keyboard/gamepad focus states. Respect reduced motion if the host experience exposes such a preference.
- Do not animate layout continuously. Avoid per-frame loops; update only on input or state changes.
- Keep all text and icons legible in both focused and unfocused states; color is not the only signal for a state.
- Do not make essential affordances hover-only. Touch users should get equivalent feedback on press and release.

## 3. Window and dashboard layout

### Default desktop composition

- Centered floating window, default size `920 × 600` px, with a recommended minimum of `680 × 440` px.
- Rounded charcoal shell with subtle outer shadow and a thin frosted border.
- Header height: about 56 px. It contains the library/app mark and title on the left, optional search or status content in the middle, and window actions on the right.
- Expanded sidebar width: about 216 px; collapsed width: about 72 px. Each tab row has a clear selected indicator and optional icon.
- Main content uses consistent 20–24 px padding. The landing/dashboard tab may use a responsive Bento grid of cards; ordinary tabs use sections and controls.
- Toasts stack at the lower-right of the window, with a maximum of four visible at once.

### Responsive desktop and mobile layouts

- Detect usable viewport size and touch capability at runtime; do not assume that a Roblox experience is desktop-only based on screen size alone.
- On desktop, use the centered floating window, header and collapsible sidebar described above.
- On phones, use a near-full-screen window with safe-area-aware top/bottom padding. Replace the persistent sidebar with a compact navigation drawer or bottom navigation; close the drawer after selecting a tab.
- On tablets and narrow windows, allow a compact icon rail or collapsible drawer. Keep navigation state visible and provide an obvious way to reopen it.
- Recalculate layout from the actual window/content width whenever the viewport or window size changes. Do not rely only on a device-type flag or fixed desktop coordinates.
- Use width-based layout modes as starting points, then measure the actual content area: `Wide` at 900 px and above, `Compact` from 600–899 px, and `Narrow` below 600 px. In `Compact`, collapse the sidebar to an icon rail; in `Narrow`, use a drawer or bottom navigation. These are defaults, not substitutes for measuring card/control space.
- Bento cards use adaptive widths: fit as many cards as their minimum readable width allows, then reflow remaining cards into fewer columns and ultimately one column. Card content wraps or grows vertically; it must not be clipped or compressed until its value/contents are unreadable.
- Treat card `Size` as a preferred span, not a fixed pixel size. `Auto` is the default; `Small`, `Medium`, and `Wide` may guide the desktop grid but must gracefully reflow on narrow screens.
- Multi-column sections and control rows also reflow. On narrow content widths, place labels above inputs, let descriptions wrap, and move secondary actions to another row rather than squeezing hit targets.
- Never require horizontal scrolling for ordinary controls. Use vertical scrolling inside the content region, and update the canvas size after cards expand, collapse, or change content.
- Size the window relative to the available viewport with minimum bounds suitable for the current device. If the viewport is too small for those bounds, prioritize fitting the screen over enforcing a desktop minimum.
- Account for Roblox top-bar and device safe areas where supported. Content scrolls within the main region; headers and primary navigation remain reachable.
- Avoid clipping control labels. Let descriptions wrap, keep text at a readable size, and use scrolling or a full-screen layout instead of shrinking the entire UI until it is difficult to read.
- If the user resizes a desktop window below its usable minimum, clamp it to that minimum. If the viewport itself is smaller, switch to a fitted/full-screen layout; do not scale the controls below their touch or readability minimums.
- Support touch, keyboard, mouse, and gamepad without making any essential action exclusive to one input type.

## 4. Public API proposal

Ship as one Luau `ModuleScript` returning a library table. Consumers should `require` the module from a client script. The current implementation's icon bootstrap fetches remote libraries and executes them with `loadstring`; for standard Roblox clients, replace this with local, reviewed icon dependencies. Do not fetch or execute arbitrary user-provided code. Names below are proposed public contracts, not implementation details.

### Library and window

```lua
local AstraUI = require(path.To.AstraUI)

local window = AstraUI:CreateWindow({
    Title = "Control Center",
    Subtitle = "Welcome back",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(1000, 640),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
    },
    Localization = {
        Locale = "th-TH",
        Resolve = function(locale, key, fallback)
            return fallback
        end,
    },
})
```

`CreateWindow(config)` returns a window handle with:

- `Tab(config) -> tab`
- `Search(config) -> searchHandle` (optional search above the tab navigation)
- `Notify(config) -> toastHandle`
- `Dialog(config) -> dialogHandle`
- `SetVisible(boolean)`
- `SetSize(UDim2)`
- `SetTheme(theme)`
- `SetThemePreset("Dark" | "Light" | "Lilith")`
- `SetLocale(locale)`
- `SetToggleKey(Enum.KeyCode)`
- `SetResizable(boolean)`
- `SetDraggable(boolean)`
- `OpenSettings()`
- `SetHeaderVersion(stringOrNil)`
- `SetDiscordLink(urlOrNil, copyCallback)`
- `GetState() -> stateTable`
- `SetState(stateTable)`
- `Destroy()`

Suggested config fields: `Title`, `Subtitle`, `HeaderVersion`, `RestoreImageUrl`, `PngDecoder`, `PngDecoderUrl`, `Discord = {Url, Copy}`, `Size`, `ToggleKey`, `Responsive`, `Resizable`, `Draggable`, `Theme`, `Localization`, and optional `Parent`. A floating toggle button remains visible above the window at all times, is inset from the upper-left corner, and supports mouse/touch dragging; clicking it toggles window visibility. Its optional PNG is placed inside the button, and its position stays within the screen. `RestoreImageUrl` optionally supplies a PNG URL for that button. Loading it uses a cooperative-yielding PNG decoder and Roblox `EditableImage` support; if those APIs are unavailable or the image fails to decode, the built-in icon remains visible and a warning is emitted. The bundled `luau-png.lua` and `png.luau` decoders support cooperative yielding; provide either as a sibling ModuleScript named `png` or `luau-png`, or pass it as `PngDecoder`. The loader skips matching modules that do not expose `supportsYieldIfNeeded = true`, so older non-yielding PNG modules will not be used. A custom source URL can be given with `PngDecoderUrl`, but its returned decoder must expose the same marker; this option fetches and executes source at runtime and is not suitable for standard Roblox client scripts. Prefer reviewed local ModuleScripts and never execute arbitrary user-provided code. `Discord.Copy(url)` is supplied by the experience because standard Roblox Luau has no clipboard API; the header button reports when the URL or copy callback is not configured. `SetDiscordLink(url, copyCallback)` can set or replace those values later. `Responsive` defaults to `true`; setting it to `false` keeps the requested window size where the viewport allows, but the window still clamps to the viewport and content still reflows to remain usable. `Resizable` and `Draggable` default to `true` on desktop; neither is required for mobile interaction. `Theme` is a partial token override and unspecified tokens retain their defaults. `Localization` accepts a locale and optional resolver. `Parent` defaults to the local player's `PlayerGui`; an explicitly provided parent should be honored. Validate values and report invalid config through a clear error or warning rather than silently substituting an unrelated value.

```lua
local window = AstraUI:CreateWindow({
    HeaderVersion = "v1.0.0",
    Discord = {
        Url = inviteUrl,
        Copy = clipboardCallback,
    },
})

window:SetHeaderVersion("v1.1.0")
window:SetDiscordLink(nextInviteUrl, copyCallback)
window:SetThemePreset("Lilith")
```

Value controls and tabs accept an optional stable `Id`. If omitted, the library may generate a runtime-only ID, but that value is not guaranteed to match after rebuilding the UI. `GetState()` returns a plain serializable table containing controls with explicit stable IDs, the selected tab ID, theme preset, locale, UI toggle key, and window resize/drag settings. `SetState(stateTable)` validates and restores those settings and matching control values without firing user callbacks; unknown IDs are ignored with a diagnostic, while invalid values are reported. The state table includes a library schema version, for example `{Version = 1, ThemePreset = "Light", Locale = "th-TH", ToggleKey = "RightShift", Resizable = true, Draggable = true, SelectedTab = "overview", Values = {notifications = true}}`. `SetLocale(locale)` re-resolves library text and relayouts affected content. The library does not use `DataStoreService` or perform network calls. The experience owns persistence, version migration, and any profile/cloud policy. The demo persists changed settings as JSON and loads them on startup using host-provided `writefile`, `readfile`, `makefolder`, `isfolder`, and `isfile` functions; manual Save/Load buttons are also available. Autosave writes only when serialized state changes and stops with a warning if a write fails. These filesystem functions are not standard Roblox APIs and must be provided by the runtime.

### Theming and customization

```lua
window:SetTheme({
    ControlSurface = Color3.fromRGB(218, 226, 235),
    ControlHover = Color3.fromRGB(206, 216, 228),
    Accent = Color3.fromRGB(103, 232, 249),
    CornerRadius = 12,
    Density = "Comfortable",
})
```

- Components use theme tokens for neutral surfaces, borders, text, and semantic states; interactive state changes must update their token binding as well as their displayed color. This includes control hover states, selected navigation surfaces, open popovers, and dialogs. The header Settings panel provides Dark and Light palettes plus the Lilith light palette inspired by *NOexistenceN of you AND me*, which asynchronously loads the configured artwork as a cropped window background with coordinated crimson, icy blue, and navy colors. Switching presets restores explicit accent overrides from `CreateWindow.Theme` or a later `SetTheme` call rather than carrying Lilith's accents into another preset; button hover and pressed colors are refreshed from the active theme.
- Settings selection is indicated by a square `BorderSizePixel` outline around the whole selected option; selected text stays the normal theme text color and is never outlined or recolored.
- `OpenSettings()` opens the same settings popover as the header gear button without dimming the entire window. It lets users choose Dark, Light, or Lilith, change locale, rebind the UI visibility key, and toggle window resizing and dragging. Locale changes re-resolve text through the configured `Localization.Resolve` callback.
- Accept only known tokens and values of the documented type; partial overrides inherit all other defaults. Do not accept arbitrary instance properties or execute theme callbacks.
- Offer `Compact` and `Comfortable` density presets, but never let density override minimum touch target sizes.
- Theme changes must preserve readable contrast and visible focus/disabled states. The library may warn when a custom palette falls below its documented contrast target.

### Window behavior and overlay layers

- Desktop windows may be draggable by the header, but dragging starts only from the header's non-interactive area, not from search, buttons, or text inputs. Constrain the window so its title and close/navigation affordances remain reachable.
- `Draggable` and `Resizable` default to `true` on desktop and can be disabled in window config. Resizing has a visible grip and clamps to the usable minimum or viewport bounds; minimize hides the panel and exposes a restore button.
- Provide explicit minimize, close, and restore controls when enabled. `Close` hides or destroys only according to a documented config choice; do not make a decorative close icon silently destroy user state.
- Touch layouts use large explicit header actions; dragging is optional and never the only way to move or dismiss the window.
- Use a single per-window overlay/layer manager for dropdowns, color pickers, dialogs, and toasts. Define deterministic ordering (content < popover < toast < modal dialog), dismiss transient popovers on outside tap or Escape, and ensure an open overlay cannot be clipped by a card or scrolling container.
- Modal dialogs may block interaction with the owning window while open; toasts and non-modal popovers must not unexpectedly block unrelated controls.
- Restore focus/selection to a sensible control after an overlay closes. Destroying a parent window also destroys its overlays and disconnects their listeners.

### UI states and async work

Every interactive component should define its normal, hover/pressed, focused, disabled, and error states where relevant. Loading states must be explicit and must not be indicated only by color.

- Controls inside sections use individually padded, subtly outlined cards so adjacent settings remain visually distinct. Inputs and action surfaces use a contrasting inset surface rather than merging into the card.
- Related controls may be grouped into left and right sections using `Section.Side`, yielding a two-column settings layout that stacks on narrow windows.
- Search sits above the tab list (including in the narrow navigation drawer) in a rounded outlined container that wraps the icon and input; focus strengthens the container outline without highlighting the text or icon. Search results and dropdown options are aligned popovers with subtle selected and hover states, not full-screen dialogs.
- Dropdowns open beside their trigger when space allows and flip or clamp inside the window when they would otherwise be clipped.
- Control cards flow vertically from their title through any wrapped description to the interactive surface; long localized descriptions must not overlap or push controls outside the card.
- Toggles use a compact switch with a visible state and thumb; the switch must not stretch across the entire content column.

```lua
local refresh = general:Button({
    Name = "Refresh",
    Icon = "refresh-cw",
    Callback = refreshData,
})

refresh:SetLoading(true)
-- When the consumer's operation completes:
refresh:SetLoading(false)
```

- `Button` supports `SetLoading(boolean)` and `SetEnabled(boolean)`. While loading, show a loading label, prevent duplicate activation, and preserve the label or an accessible equivalent.
- `Input` supports invalid/helper text and exposes `SetError(messageOrNil)`; do not clear user-entered text when reporting validation errors.
- Collections and content areas can show explicit `Loading`, `Empty`, and `Error` presentations. Provide `EmptyState(config)` and `State(config)` display elements with an optional title, description, icon, and action callback.
- `Section:State(config)` creates a status card. `State:SetState("Loading" | "Empty" | "Error" | "Success", message)` updates its status and message. `Section:EmptyState(config)` creates a ready-to-use empty presentation.
- Loading is indeterminate unless the consumer supplies a real progress value. Empty and error states provide an actionable recovery route when one exists.
- The library does not own consumer async operations or invent success on timeout. Consumers set/clear loading and report the resulting state.
- For any callback executed by the library, surface errors with component context and keep unrelated UI operational.

```lua
local status = general:State({
    Type = "Loading",
    Title = "Loading records",
    Description = "Please wait while the data is fetched.",
    Icon = "loader-circle",
})

-- After the consumer's request finishes:
status:SetState("Empty", "No records were found.")
```

### Custom components

```lua
general:Custom({
    Name = "Preview",
    Height = 180,
    Build = function(parent, context)
        local preview = Instance.new("Frame")
        preview.Size = UDim2.fromScale(1, 1)
        preview.Parent = parent

        return preview, function()
            -- Disconnect custom connections owned by this component.
        end
    end,
})
```

- `Custom(config)` creates a library-owned host area and invokes `Build(parent, context)`. `context` exposes read-only theme/layout information and a cleanup-registration method, not internal window objects.
- `Build` must return the root `GuiObject` it created and may return a cleanup function. The library parents/destroys the returned root and invokes cleanup exactly once on component/window destruction.
- Require a declared preferred/minimum height (or a documented size policy) so custom content participates in scrolling and responsive reflow. Custom content must not escape its host bounds or overlap sibling controls.
- Custom components are responsible for their own internal input and accessibility behavior. Do not accept arbitrary code strings or remote code; a normal local Luau function is the extension point.
- Theme/layout changes are communicated through documented context signals; custom UI should not need access to private library tables.

### Localization and accessibility

- Allow UI text fields to be either literal strings or text descriptors such as `{Key = "settings.title", Default = "Settings"}`. The optional window `Localization` config supplies the locale and a resolver; descriptors pass their `Key` and `Default`, while literal strings pass the string as both key and fallback. When no translation exists, use the fallback. `SetLocale(locale)` changes the locale at runtime and re-resolves existing text.
- Re-resolve text on locale changes and recompute layout because translated text may be longer. Support right-to-left layout direction for navigation, alignment, and popover placement; do not reverse numbers, key names, or user-provided content incorrectly.
- Expose accessible names/labels for icon-only buttons and current values/state for toggles, sliders, dropdowns, and keybinds. Decorative icons and dividers must not take focus.
- Preserve visible keyboard/gamepad focus, logical navigation order, and a way to dismiss every modal/popover. Do not rely on color, emoji, or icon shape as the sole meaning of a state.
- Support text scaling within a documented range without clipping; when space runs short, wrap or scroll before truncating important labels.
- Keep strings outside layout logic. Consumers can localize their own content; the library handles only strings it owns or text descriptors passed through its resolver.

### Tabs and sections

```lua
local home = window:Tab({
    Id = "overview",
    Name = "Overview",
    Icon = "home",
    Category = "Experience",
})

local players = window:Tab({
    Name = "Players",
    Icon = "users",
    Category = "Experience",
})

local general = home:Section({
    Id = "general",
    Name = "General",
    Side = "Left",
})
```

Tabs in a named `Category` are grouped under a collapsible heading in the sidebar and mobile drawer. The selected tab label uses a bold font; tabs without a category retain the flat navigation layout.

Icon support is available by default: the library loads Lucide and Solar from their configured raw GitHub URLs. This requires `loadstring` and `game:HttpGet` to be available, and executes the downloaded icon-library code. Only use sources you trust; production projects should prefer reviewed, pinned dependencies. You can override either library through `IconLibraries`: Lucide must expose `GetAsset(name)` and return an asset with a `Url` and optional `ImageRectSize`/`ImageRectOffset`; Solar is an icon map where each key maps directly to an asset URL. The legacy `IconLibrary` option remains supported for Lucide. Prefix Solar names with `solar:`, such as `Icon = "solar:home-2-linear"`; Solar keys include a style suffix (for example `-linear`), and a missing unsuffixed name automatically tries its `-linear` variant. This applies to `Tab`, `Section`, `Card`, `Button`, and `State` icons, and the window `Search` icon. Missing icons fall back to text for backwards compatibility.

```lua
window:Tab({
    Name = "Home",
    Icon = "house",
})

window:Search({
    Placeholder = "Search",
    Icon = "search",
})
```

Only load remote code you trust; production projects should prefer a reviewed, pinned dependency. `Tab(config)` returns a tab handle with `Section(config)`. `Section(config)` returns a section handle that owns its controls. `Side` may select a column in a wide Bento layout; on narrow windows, sections flow into one column. Icons should use a library-provided icon set or Roblox-supported image assets selected by the consumer, not undocumented glyph assumptions.

On touch layouts, the tab navigation should open as a drawer or compact navigation panel rather than keeping the desktop sidebar width reserved. The selected tab name remains visible in the header when the navigation is closed.

Dashboard tabs may also compose responsive summary cards:

```lua
home:Card({
    Title = "Active users",
    Value = "1,284",
    Description = "Compared with the previous session",
    Size = "Auto",
    Accent = "Green",
    Icon = "users",
})
```

`Card(config)` returns a card handle with `SetValue(value)` and `Destroy()`. `Size` is a preferred grid span: `Auto` (default), `Small`, `Medium`, or `Wide`. The layout engine chooses the actual card width from available content space and the card's minimum readable width; when there is not enough space, it reflows the card to the next row or a single-column layout. Cards grow vertically to fit wrapped content, and `SetValue` must trigger layout/canvas-size updates if the new value changes the card's measured content. `Accent` is a restrained token such as `Purple`, `Green`, or `None`, not an arbitrary high-saturation fill. A later custom-card API may expose a consumer-owned content container without changing the standard card contract.

### Controls

All controls accept a config table with a required `Name` or `Title` and optional `Description`. Callbacks run only after user-initiated changes, except where a control explicitly documents initialization behavior.

Controls cover common settings and customization needs while keeping the API compact and consistent.

```lua
general:Button({
    Name = "Refresh",
    Description = "Reload the displayed data",
    Icon = "refresh-cw",
    Callback = function()
        -- Consumer action
    end,
})

general:Toggle({
    Id = "notifications",
    Name = "Show notifications",
    Default = true,
    Callback = function(value)
        print(value)
    end,
})

general:Slider({
    Name = "Opacity",
    Min = 0,
    Max = 100,
    Step = 5,
    Default = 80,
    Callback = function(value)
        print(value)
    end,
})

general:Dropdown({
    Name = "Theme",
    Options = {"Violet", "Cyan", "System"},
    Default = "Violet",
    Callback = function(value)
        print(value)
    end,
})

general:Keybind({
    Name = "Toggle panel",
    Default = Enum.KeyCode.RightShift,
    Callback = function(keyCode)
        print(keyCode)
    end,
})

general:Input({
    Name = "Display name",
    Placeholder = "Enter a name",
    Default = "",
    MaxLength = 32,
    Callback = function(value)
        print(value)
    end,
})

general:MultiDropdown({
    Name = "Visible categories",
    Options = {"Players", "Items", "Locations"},
    Default = {"Players"},
    Callback = function(values)
        print(table.concat(values, ", "))
    end,
})

general:Colorpicker({
    Name = "Accent color",
    Default = Color3.fromRGB(167, 139, 250),
    Callback = function(color)
        print(color)
    end,
})
```

```lua
local playerPicker = players:PlayerDropdown({
    Name = "Select player",
    Placeholder = "Choose a player...",
    ExcludeLocalPlayer = true,
    Callback = function(selectedPlayers)
        for _, player in ipairs(selectedPlayers) do
            print(player.DisplayName, player.Name)
        end
    end,
})
```

Control contracts:

| Method | Required config | Value/callback contract |
|---|---|---|
| `Button` | `Name`, `Callback` | Invokes callback on activation; does not retain a value |
| `Toggle` | `Name` | Boolean `Default`; callback receives the new boolean |
| `Slider` | `Name`, `Min`, `Max` | Numeric bounds, optional `Step` and `Default`; callback receives a clamped, step-aligned number |
| `Dropdown` | `Name`, `Options` | Single selection in the initial version; `Default` must be one of the options; selected menu options use a green outline only, without selected-fill or selected-text coloring; callback receives the selected option |
| `PlayerDropdown` | `Name` | Loads current players on creation/open, multi-selects in a responsive multi-column menu with headshot, display name, and username; marks the local player as `YOU` unless `ExcludeLocalPlayer = true`; selected players appear as removable badges, joins/leaves update choices, and it is intentionally excluded from saved state |
| `MultiDropdown` | `Name`, `Options` | Multi-selection; selected menu options use a green outline only, without selected-fill or selected-text coloring; callback receives a copy of the selected values |
| `Keybind` | `Name` | `Default` is an `Enum.KeyCode`; callback fires when that key is pressed and receives the bound key; rebinding has a cancel path |
| `Input` | `Name` | Text input with optional `Placeholder`, `Default`, `MaxLength`, and `Numeric`; callback receives submitted text, not every keystroke, unless `Live = true` |
| `Colorpicker` | `Name` | `Color3` `Default`; callback receives the selected `Color3`; supports a draggable hue/saturation/value map and hex input |

Every control handle should expose `SetValue(value)` and `GetValue()` where applicable, plus `Destroy()`. Programmatic `SetValue` should update visuals without firing the user-change callback by default; if a future API adds notification behavior, make it an explicit option. Disabled controls remain visible, indicate their state, and do not accept input.

`PlayerDropdown` is backed by the local `Players` service rather than a fixed options array. Its trigger, menu options, and selected-player badges use the recessed `ControlInset` token. The menu flows into up to four columns based on available width and remains scrollable when the player list exceeds the popup height. Its selected value is an array of live `Player` instances; leaving players are removed from the selection and the optional callback receives the updated array. The local player is labeled `YOU`; set `ExcludeLocalPlayer = true` at creation to omit them from the choices and reject programmatic selection. The control renders each selected player as a separate badge with an explicit remove button. Badges also flow into up to four columns based on available width, and their container height follows the resulting row count. It does not accept an `Id`, so it is never included in `GetState()` or persisted by the demo.

Controls must retain usable hit-target dimensions as the window changes size. The layout may wrap a control into multiple rows or allow its content region to scroll, but must not shrink a button, slider track, dropdown trigger, or input field below its minimum usable size. Popovers and dropdown menus should reposition or scroll to remain inside the visible window/safe area.

Keybind capture should ignore input while the player is typing into a text field, allow Escape to cancel, and avoid consuming unrelated gameplay input unless the consumer opts in.

### Content and status elements

These are non-interactive display elements, so they do not have a change callback. They should use the same typography, spacing, and surface tokens as controls.

```lua
general:Paragraph({
    Title = "About",
    Content = "Short supporting text that can wrap onto multiple lines.",
})

general:Divider()

general:Progress({
    Name = "Download",
    Value = 0.65,
    ShowValue = true,
})

general:Badge({
    Text = "Connected",
    Type = "Success",
})
```

| Method | Contract |
|---|---|
| `Paragraph` | Displays optional `Title` and required `Content`; wraps text and supports `SetContent(text)` |
| `Divider` | Adds a quiet separator with optional `Spacing`; decorative and excluded from keyboard focus |
| `Progress` | `Value` is normalized from 0 to 1; optional `Indeterminate`, `ShowValue`, and `Label`; exposes `SetValue(value)` and `Destroy()` |
| `Badge` | Rounded outlined status label with a semantic color dot, `Text`, and `Type` (`Neutral`, `Info`, `Success`, `Warning`, `Error`); exposes `SetText(text)` and `SetType(type)` |

Progress must not imply a known completion percentage when `Indeterminate = true`; animate only while visible and stop on destruction.

### Composition and navigation

```lua
general:Accordion({
    Name = "Advanced",
    DefaultOpen = false,
}, function(content)
    content:Toggle({
        Name = "Use compact layout",
        Default = false,
    })
end)

window:Search({
    Placeholder = "Search settings",
    Scope = "Controls",
})
```

- `Accordion(config, build)` creates a collapsible group with a rounded, full-width title row, a Lucide chevron, a subtle divider, and inset controls using the normal Section/control APIs. It returns an owner handle with `SetExpanded(boolean)` and `Destroy()`.
- `Search(config)` adds optional header search. Search tabs and controls by their display names/descriptions, show a clear empty state, and allow keyboard navigation to results. It should be opt-in and not intercept gameplay typing.
- `MultiDropdown` handles modest lists. For long lists, search/filter options inside the popup rather than expanding an oversized menu. Keep the selected summary concise.

### Dialogs

Use dialogs for decisions or focused tasks, not routine status messages (use `Notify` for those).

```lua
window:Dialog({
    Title = "Reset settings?",
    Content = "This will restore the default values.",
    Actions = {
        {Name = "Cancel", Style = "Secondary"},
        {Name = "Reset", Style = "Danger", Callback = function()
            print("confirmed")
        end},
    },
})
```

`Dialog(config)` returns a handle with `Close()` and `Destroy()`. It should have a clear close/cancel route, sensible focus order, and trap focus only while open. Destructive actions use an explicit danger style and must not be the default focused action.

### Toast notifications

```lua
window:Notify({
    Title = "Settings saved",
    Content = "Your changes are ready.",
    Type = "Success",
    Duration = 3,
})
```

Support `Success`, `Info`, `Warning`, and `Error` types. A toast handle may expose `Dismiss()`. Duration is in seconds; allow a persistent toast only through an explicit documented value such as `Duration = 0`. Keep toast text concise, include an icon and text label for the type, and expose an accessible dismiss button. Notifications are rendered at the screen's bottom-right edge, outside the window, stack vertically, and animate out when dismissed or timed out.

On phones, toasts should fit the safe content width and remain large enough to dismiss by touch.

## 5. Roblox implementation boundaries

- Use `ScreenGui`, `Frame`, `TextLabel`, `TextButton`, `ImageLabel`/`ImageButton`, `UICorner`, `UIStroke`, `UIGradient`, `UIListLayout`, `UIPadding`, `UISizeConstraint`, and `UIScale` as appropriate. Use safe-area-aware layout support where available.
- Use `TweenService` for finite transitions and `UserInputService`/`ContextActionService` for input with cleanup on destruction. Prefer input events that support both touch and mouse (such as `GuiButton.Activated`) for button actions.
- Use touch gestures only where they are discoverable and nonessential to understand the interface. Provide visible buttons for opening/closing navigation, dialogs, and popovers; do not rely on swipes alone.
- Ensure sliders and color pickers support touch with sufficiently large draggable regions, clear current-value feedback, and a way to make adjustments without precise pointer movement.
- Avoid relying on hover events for mobile feedback. Use press states, selection states, and explicit open/close affordances instead.
- Do not change global `Lighting`, camera, player controls, or unrelated GUI state to create the glass effect. Use transparent layered panels and borders instead of a global blur.
- Parent the root GUI to the local `PlayerGui`; set reset behavior deliberately and document it. Do not remove or rewrite other ScreenGuis.
- Store event connections, active tweens, and instances under their owning handle. `Destroy()` must disconnect and destroy only resources owned by that handle, and should be safe to call more than once.
- Handle respawn/player GUI lifecycle without leaving duplicate windows or input listeners.
- Keep callbacks isolated from the render/update path. If a callback errors, report it with a useful warning and keep the library UI alive; do not swallow the error silently.
- Validate slider bounds, dropdown defaults/options, `Color3` values, enum types, progress ranges, text limits, dialog actions, and durations. Prefer explicit errors/warnings with the offending field name.
- Do not fetch or execute remote scripts, and do not provide executor-only APIs. The library should work in a normal Roblox Studio experience with the appropriate client context.

## 6. Accessibility and quality checklist

- All actions are reachable by keyboard/gamepad and have a visible focus treatment.
- All essential actions are reachable by touch, with comfortable hit targets and no hover-only behavior.
- Toggle state, selected tab, slider/progress value, keybind capture, badge state, and notification type are conveyed by more than color alone.
- Text contrast remains readable against both the base surface and aurora accents.
- The window respects safe areas and content scrolls or reflows rather than clipping across phone, tablet, and desktop sizes.
- Resizing the window or rotating/changing the viewport recomputes card and control layout; cards wrap/grow and interactive targets remain fully visible and tappable.
- At the narrowest supported viewport, no control is covered by navigation, clipped by a card, or reduced below its documented minimum hit target.
- Input, dropdown, colorpicker, accordion, and dialog interactions have clear keyboard/gamepad focus and dismissal behavior.
- Search results and empty states are understandable, and search never steals input from active text entry or gameplay unexpectedly.
- Destroying the window removes owned input listeners and UI instances.
- Repeatedly creating/destroying windows does not accumulate connections, duplicate toasts, or background loops.
- User callbacks receive documented values and are not called unexpectedly during construction.

### Verification scenarios

Before calling an implementation production-ready, manually or automatically verify at least:

- Viewports: 320 × 568 phone, 390 × 844 phone, 768 × 1024 tablet, and 1366 × 768 desktop, plus viewport rotation/resize.
- Reflow: one-column controls and cards fit without horizontal scrolling; long card values/descriptions wrap or grow; scrolling reaches the final control.
- Interaction: every touch target remains at least 44 × 44 px; desktop controls remain at least 40 × 40 px; no modal, toast, popover, or navigation layer makes a visible control unexpectedly untappable.
- Content: long translated strings, empty/loading/error states, keyboard focus, touch input, and gamepad navigation.
- Lifecycle: open/dismiss overlays, change theme/locale, export/import state, then destroy/recreate the window without duplicate instances or connections.

These are verification targets, not a claim that the current design spec has been implemented or runtime-tested.

The first implementation establishes the single-file API and responsive interaction foundation. Roblox Studio testing is still required; advanced RTL layout, full HSV/alpha color selection, contrast warnings for arbitrary themes, and detailed assistive-technology behavior remain follow-up work.
