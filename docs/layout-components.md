# Cards, accordions, and custom UI

## Bento cards

Cards are added directly to a tab and reflow between one and two columns:

```lua
local count = tab:Card({
    Id = "online-count",
    Title = "Players online",
    Value = 12,
    Description = "Players in this server.",
    Icon = "users",
    Size = "Small",
    Accent = "Blue",
})

count:SetValue(14)
print(count:GetValue())
```

| Field | Meaning |
|---|---|
| `Title` | Required card heading |
| `Value` | Optional displayed value |
| `Description` | Optional supporting text |
| `Icon` | Optional icon name |
| `Size` | `"Auto"` (default), `"Small"`, `"Medium"`, or `"Wide"` |
| `Height` | Optional positive minimum height |
| `Accent` | `"Green"` or `"Cyan"` uses the secondary accent; `"None"` uses the border; other/omitted values use the primary accent |

`SetValue(value)` updates the displayed value and reflows the card. `GetValue()` returns the current value.

## Two-column sections

On a tab, assign sections to left and right columns:

```lua
tab:Section({Name = "Controls", Side = "Left"})
tab:Section({Name = "Status", Side = "Right"})
```

`Side` must be `"Left"` or `"Right"`. The columns stack when the displayed content is narrower than the 360px minimum width, adjusted by the global UI scale. On mobile, this lets the layout keep two columns whenever the scaled content can fit them.

## Accordion

An accordion builds a nested section through a callback:

```lua
local advanced = section:Accordion({
    Id = "advanced",
    Name = "Advanced",
    DefaultOpen = false,
}, function(inner)
    inner:Toggle({
        Id = "debug-mode",
        Name = "Debug mode",
        Default = false,
    })
end)

advanced:SetExpanded(true)
```

The `build` callback is required and receives an inner section, so its normal controls can be used. `DefaultOpen` controls the initial state. `SetExpanded(boolean)` changes it. Build errors are reported in Roblox Output.

## Custom component

Use `Custom` for UI that cannot be expressed with built-in controls:

```lua
local custom = section:Custom({
    Id = "custom-meter",
    Height = 48,
    Build = function(host, context)
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Text = "Custom content"
        label.Parent = host

        context:RegisterCleanup(function()
            print("Clean up custom connections/resources here")
        end)

        return label
    end,
})
```

`Height` must be a positive number and `Build` is required. `Build(host, context)` must return a `GuiObject`; only `Id`, `Height`, and `Build` are used by this component. The context exposes:

- `GetTheme()` — copy of the active theme tokens
- `GetLayoutMode()` — `"Wide"`, `"Compact"`, or `"Narrow"`
- `RegisterCleanup(function)` — register cleanup work for `Destroy()`

`Build` may also return a cleanup function as its second return value. Use ordinary local Luau functions; do not pass code strings or execute remote/user-supplied scripts.
