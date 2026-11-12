# Installation and first window

## Load via loadstring (executor environments)

Use this bootstrap only in an executor or other runtime that provides both `game:HttpGet` and `loadstring`:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()
```

The current `main.lua` downloads and executes the Lucide and Solar icon libraries while loading, so this does not work in a standard Roblox client `LocalScript`. To use Astra UI in an experience you own, adapt the loader to use reviewed, locally included icon dependencies; see [Troubleshooting](troubleshooting.md).

## Create a window

After loading in a compatible runtime, create your first window:

```lua
local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()

local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Subtitle = "Welcome",
    HeaderVersion = "v1.0.0",
    Size = UDim2.fromOffset(920, 600),
    ToggleKey = Enum.KeyCode.RightShift,
    Responsive = true,
    Resizable = true,
    Draggable = true,
})

local home = window:Tab({
    Id = "home",
    Name = "Home",
    Icon = "house",
})

local section = home:Section({
    Name = "Settings",
})

section:Toggle({
    Id = "notifications",
    Name = "Enable notifications",
    Default = true,
    Callback = function(enabled)
        print("Notifications:", enabled)
    end,
})
```

## Requirements

- An executor or environment that supports `game:HttpGet` and `loadstring` (e.g. Potassium or another supported executor). A standard Roblox client `LocalScript` cannot use the current remote icon bootstrap as-is.
- PNG rendering requires Roblox `EditableImage` support and the required permissions.
- The demo's settings save/load features use `readfile` / `writefile` — these are executor-provided APIs, not standard Roblox APIs.

See [`demo.lua`](../demo.lua) for a complete dashboard example.
