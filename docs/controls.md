# Buttons and value controls

Controls are added to a section:

```lua
local settings = tab:Section({Name = "Settings"})
settings:Toggle({Name = "Example", Default = true})
```

## Button

Run an action; a Button has no value.

```lua
local refresh = settings:Button({
    Id = "refresh",
    Name = "Refresh data",
    Description = "Reload the dashboard values.",
    Icon = "refresh-cw",
    Callback = function()
        print("Refreshing")
    end,
})

refresh:SetLoading(true)
task.wait(1)
refresh:SetLoading(false)
```

`Callback` is required. `Icon` is optional. `SetLoading(boolean)` disables the button while loading.

## Toggle

```lua
local music = settings:Toggle({
    Id = "music",
    Name = "Music",
    Description = "Play background music.",
    Default = false,
    Callback = function(enabled)
        print("Music enabled:", enabled)
    end,
})

music:SetValue(true)
print(music:GetValue())
```

`Default` must be a boolean when supplied.

## Slider

```lua
local volume = settings:Slider({
    Id = "volume",
    Name = "Volume",
    Min = 0,
    Max = 100,
    Step = 5,
    Default = 35,
    Callback = function(value)
        print("Volume:", value)
    end,
})
```

| Field | Required | Notes |
|---|---:|---|
| `Min` | Yes | Number lower bound |
| `Max` | Yes | Number strictly greater than `Min` |
| `Step` | No | Positive increment; omitted means continuous pointer input and keyboard increments of 1% of the range |
| `Default` | No | Initial number; defaults to `Min` and is clamped to range |

The slider supports mouse, touch, and left/right keyboard or gamepad adjustments when focused.

## Dropdown

Select one string:

```lua
local quality = settings:Dropdown({
    Id = "quality",
    Name = "Quality",
    Options = {"Low", "Medium", "High"},
    Default = "Medium",
    Callback = function(value)
        print("Quality:", value)
    end,
})
```

`Options` is a non-empty array of strings. If `Default` is omitted, the first option is selected. `SetValue()` must receive a value present in `Options`.

## MultiDropdown

Select any number of string options:

```lua
local effects = settings:MultiDropdown({
    Id = "effects",
    Name = "Effects",
    Options = {"Bloom", "Blur", "Color correction"},
    Default = {"Bloom"},
    Callback = function(values)
        for _, name in ipairs(values) do
            print("Enabled effect:", name)
        end
    end,
})
```

`Options` is a non-empty array of strings. `Default` is an array of selected values (defaults to empty). `GetValue()` returns a copy of the selected array.

## PlayerDropdown

Select current players from the server:

```lua
local players = settings:PlayerDropdown({
    Name = "Players",
    Description = "Choose players currently in this server.",
    Placeholder = "Select players...",
    EmptyText = "No players are online.",
    ExcludeLocalPlayer = true,
    Callback = function(selectedPlayers)
        for _, player in ipairs(selectedPlayers) do
            print(player.Name)
        end
    end,
})
```

The dropdown tracks player join/leave events, refreshes the choices, and removes departed players from the selection. It supports multiple selected players. `Id` and `Default` are intentionally unsupported: the selection is runtime-only and is never serialized.

## Input

```lua
local username = settings:Input({
    Id = "nickname",
    Name = "Display name",
    Description = "Enter a short label.",
    Placeholder = "Guest",
    Default = "",
    MaxLength = 24,
    Live = false,
    Numeric = false,
    Callback = function(value)
        print("Committed text:", value)
    end,
})

username:SetError("This name is unavailable.")
username:SetError(nil)
```

`Live = true` calls the callback while text changes; otherwise it commits when focus is lost. With `Live = false`, `Numeric = true` validates on focus loss, displays an error, and skips the callback if non-empty text is not a number. With `Live = true`, values are reported as typed and that commit validation is skipped. `MaxLength` truncates input to the specified positive length. Errors are displayed with `SetError(messageOrNil)`.

## Keybind

```lua
local action = settings:Keybind({
    Id = "quick-action",
    Name = "Quick action",
    Default = Enum.KeyCode.G,
    Callback = function(keyCode)
        print("Pressed:", keyCode.Name)
    end,
})
```

The default is `Enum.KeyCode.Unknown`. Click **Change key**, then press a key. Press Escape while capturing to cancel. The callback runs when the bound key is pressed; focused text boxes are ignored.

## Colorpicker

```lua
local tint = settings:Colorpicker({
    Id = "tint",
    Name = "Interface tint",
    Default = Color3.fromRGB(129, 130, 255),
    Callback = function(color)
        print(color)
    end,
})
```

The popup supports hue and saturation/brightness selection and a six-digit hex field. `Default` must be a `Color3` when supplied.
