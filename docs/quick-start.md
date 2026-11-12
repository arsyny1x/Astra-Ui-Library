# Quick start

## Load Astra UI

This example requires an executor or runtime that provides `game:HttpGet` and `loadstring`. The current library downloads and executes its icon libraries during loading, so it cannot be used directly from a standard Roblox client `LocalScript`; see [Getting started](getting-started.md).

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

## Build a window

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "Game Dashboard",
    Subtitle = "Local experience status",
    Size = UDim2.fromOffset(920, 600),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
})

local home = window:Tab({
    Id = "home",
    Name = "Home",
    Category = "Game",
    Icon = "house",
})

local status = home:Section({
    Name = "Status",
    Icon = "activity",
})

local enabled = status:Toggle({
    Id = "feature-enabled",
    Name = "Enable feature",
    Default = false,
    Callback = function(value)
        print("Feature enabled:", value)
    end,
})

status:Button({
    Name = "Show toast",
    Icon = "bell",
    Callback = function()
        window:Notify({
            Type = "Success",
            Title = "Ready",
            Content = "The local UI action ran.",
        })
    end,
})
```

## Get and set values

```lua
enabled:SetValue(true)
print("Current value:", enabled:GetValue())
```

See [Buttons and values](controls.md), [Display components](display-components.md), and [Window API](window-api.md) for the full reference.
