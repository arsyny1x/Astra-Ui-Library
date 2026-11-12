# Themes and customization

## Built-in presets

```lua
window:SetThemePreset("Dark")
window:SetThemePreset("Light")
window:SetThemePreset("Lilith")
```

- **Dark** uses dark navy surfaces and the library's standard accent colors.
- **Light** uses brighter neutral surfaces.
- **Lilith** uses a cropped artwork background with cool blue surfaces, navy text, crimson accents, and translucent major surfaces.

The Lilith artwork is loaded when that preset is selected. Its availability depends on the configured PNG decoder and `EditableImage` support.

## Override theme tokens

Pass partial overrides at window creation:

```lua
local window = AstraUI:CreateWindow({
    Title = "My Dashboard",
    Theme = {
        Accent = Color3.fromRGB(129, 130, 255),
        AccentSecondary = Color3.fromRGB(46, 211, 159),
        CornerRadius = 10,
        Density = "Comfortable",
    },
})
```

Or update the palette later:

```lua
window:SetTheme({
    ControlSurface = Color3.fromRGB(218, 226, 235),
    ControlHover = Color3.fromRGB(206, 216, 228),
})
```

Partial overrides preserve unspecified tokens. Supported color tokens include surfaces, controls, borders, text, accents, and semantic colors (`Success`, `Warning`, `Danger`). `CornerRadius` accepts a number from 0 to 32. `Density` accepts `"Compact"` or `"Comfortable"`.

Explicit accent overrides in `CreateWindow.Theme` or a later `SetTheme` call are retained when switching back from Lilith to Dark or Light. Hover and pressed button states are refreshed when the active theme changes.

See [the specification](../UI_LIBRARY_SPEC.md) for the full token palette.
