# Components overview

Astra UI uses a hierarchy of **window → tab → section → component**. Cards are created directly on a tab. Use stable IDs for values you want to serialize with `GetState()`.

```lua
local window = AstraUI:CreateWindow({Title = "Example"})
local tab = window:Tab({Id = "home", Name = "Home"})
local section = tab:Section({Name = "Preferences"})

section:Toggle({
    Id = "sound",
    Name = "Sound",
    Description = "Enable interface sounds.",
    Default = true,
    Callback = function(enabled)
        print("Sound:", enabled)
    end,
})
```

## Common control fields

Most section controls accept:

| Field | Type | Meaning |
|---|---|---|
| `Name` | string | Visible control title; `Title` is accepted by the shared row builder as a fallback |
| `Description` | string? | Optional explanatory text below the title |
| `Id` | string? | Stable, unique ID for state serialization |
| `Enabled` | boolean? | Starts enabled unless explicitly `false` |
| `Callback` | function? | Called for user changes; state restoration and `SetValue()` do not call it |

Value controls expose `GetValue()` and `SetValue(value)`. `SetEnabled(boolean)` enables or disables supported interaction. Components can be removed with `Destroy()`.

## Controls

Detailed field lists and runnable examples are in [Buttons and values](controls.md). The available controls are:

- `Button`, `Toggle`, `Slider`
- `Dropdown`, `MultiDropdown`, `PlayerDropdown`
- `Input`, `Keybind`, `Colorpicker`

## Display components

See [Display components](display-components.md) for `Paragraph`, `Divider`, `Progress`, `State`, `EmptyState`, and `Badge`.

## Cards and composition

See [Cards, accordions, and custom UI](layout-components.md) for Bento cards, accordion sections, two-column sections, and custom components.

## Search and navigation

- `window:Search(config)` adds a single search field to the sidebar.
- `tab:Search(config)` is an alias for the window search.
- Tabs accept `Name`, optional `Id`, `Icon`, and `Category`.
- Sections accept `Name`, optional `Icon`, and optional `Side = "Left"` or `"Right"` for two-column layout.

Read [Window API](window-api.md) for the complete constructor and window methods.
