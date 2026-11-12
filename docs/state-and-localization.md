# State and localization

## Save and restore state

Give tabs and value controls stable IDs when they should be restored across UI rebuilds:

```lua
local tab = window:Tab({
    Id = "overview",
    Name = "Overview",
})

local section = tab:Section({
    Name = "Preferences",
})

section:Toggle({
    Id = "notifications",
    Name = "Notifications",
    Default = true,
})

local state = window:GetState()
window:SetState(state)
```

The state table contains supported window settings and values for controls with explicit IDs. `SetState` validates values and does not fire user callbacks. Unknown IDs are ignored with a diagnostic. Player dropdown selections are runtime-only and are not serialized.

The library does not write state to a data store or file. The host experience is responsible for persistence and migrations. The demo includes optional JSON file persistence, but its filesystem APIs are not standard Roblox APIs.

## Localization

Provide a locale and optional resolver when creating the window:

```lua
local window = AstraUI:CreateWindow({
    Title = "Control Center",
    Localization = {
        Locale = "th-TH",
        Resolve = function(locale, key, fallback)
            if locale == "th-TH" then
                return translations[key] or fallback
            end
            return fallback
        end,
    },
})

window:SetLocale("en-US")
```

The resolver receives the locale, the text key, and the fallback string. `SetLocale` re-resolves registered UI text.
