# Display components

Display components belong to a section. Components that use the shared control row accept `Name`, optional `Description`, and optional `Id`; each component below lists its own fields.

## Paragraph

Display wrapped text and update it later:

```lua
local status = section:Paragraph({
    Id = "status-text",
    Title = "Current status",
    Content = "Waiting for data...",
})

status:SetContent("Data received.")
```

`Content` is required. `Title` is optional. `SetContent(string)` replaces the content.

## Divider

```lua
section:Divider()
```

Adds a one-pixel theme-colored separator. It accepts no configuration.

## Progress

```lua
local progress = section:Progress({
    Id = "download-progress",
    Name = "Download",
    Description = "Downloading assets.",
    Value = 0.4,
    ShowValue = true,
})

progress:SetValue(0.75)
```

`Value` must be between 0 and 1. `ShowValue` displays a rounded percentage. Set `Indeterminate = true` for a moving-work placeholder (the current implementation displays a fixed partial fill). If `ShowValue` is false, `Label` is shown instead. `GetValue()` and `SetValue(value)` are available.

## State

Display a status panel with an optional action:

```lua
local connection = section:State({
    Id = "connection",
    Type = "Success",
    Title = "Connected",
    Description = "The service is ready.",
    Icon = "circle-check",
    Action = {
        Name = "Reconnect",
        Callback = function()
            print("Retry connection")
        end,
    },
})

connection:SetState("Error", "Connection failed.")
```

`Type` is an initial display label. `SetState(kind, message)` accepts `"Loading"`, `"Empty"`, `"Error"`, or `"Success"`. `Action` is optional and requires a `Callback`; its button name defaults to `"Try again"`.

## EmptyState

`EmptyState(config)` is a convenience wrapper around `State`. It sets `Type = "Empty"` and defaults `Title` to `"Nothing here yet"`.

```lua
section:EmptyState({
    Title = "No saved presets",
    Description = "Create a preset to see it here.",
    Icon = "folder-open",
})
```

## Badge

```lua
local badge = section:Badge({
    Id = "server-status",
    Text = "Online",
    Type = "Success",
})

badge:SetText("Maintenance")
badge:SetType("Warning")
```

Supported types are `"Neutral"`, `"Info"`, `"Success"`, `"Warning"`, and `"Error"`. Type controls semantic text, dot, and outline colors.
