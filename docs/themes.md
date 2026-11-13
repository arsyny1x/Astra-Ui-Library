# Themes and customization

Choose a built-in preset or customize the palette with partial theme-token overrides.

## Built-in presets

Lilith is the default theme for newly created windows.

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="Theme preset examples">
    <button class="astra-code-tab" type="button" role="tab" id="preset-dark-tab" aria-controls="preset-dark-panel" aria-selected="true" tabindex="0" data-code-tab="dark">Dark</button>
    <button class="astra-code-tab" type="button" role="tab" id="preset-light-tab" aria-controls="preset-light-panel" aria-selected="false" tabindex="-1" data-code-tab="light">Light</button>
    <button class="astra-code-tab" type="button" role="tab" id="preset-lilith-tab" aria-controls="preset-lilith-panel" aria-selected="false" tabindex="-1" data-code-tab="lilith">Lilith</button>
  </div>
  <div class="astra-code-panel" id="preset-dark-panel" role="tabpanel" aria-labelledby="preset-dark-tab" data-code-panel="dark">
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Dark&quot;)</code></pre>
  </div>
  <div class="astra-code-panel" id="preset-light-panel" role="tabpanel" aria-labelledby="preset-light-tab" data-code-panel="light" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Light&quot;)</code></pre>
  </div>
  <div class="astra-code-panel" id="preset-lilith-panel" role="tabpanel" aria-labelledby="preset-lilith-tab" data-code-panel="lilith" hidden>
    <pre data-lang="lua"><code class="language-lua">window:SetThemePreset(&quot;Lilith&quot;)</code></pre>
  </div>
</div>

- **Dark** uses dark navy surfaces and the library's standard accent colors.
- **Light** uses brighter neutral surfaces.
- **Lilith** uses a cropped artwork background with cool blue surfaces, navy text, crimson accents, and translucent major surfaces.

The Lilith artwork loads by default and whenever that preset is selected. Its availability depends on the matching PNG/JPEG decoder and `EditableImage` support.

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

Partial overrides preserve unspecified tokens. Supported color tokens include surfaces, controls, borders, text, accents, and semantic colors (`Success`, `Warning`, `Danger`). `CornerRadius` accepts a number from 0 to 32. `Density` accepts `"Compact"` or `"Comfortable"`. `SurfaceTransparency` accepts a number from 0 (preset default) to 1 (fully transparent) and adjusts only the designated main panel surfaces, matching the Lilith glass effect; controls and text retain their opacity.

Explicit accent overrides in `CreateWindow.Theme` or a later `SetTheme` call are retained when switching back from Lilith to Dark or Light. Hover and pressed button states are refreshed when the active theme changes.

### Create themes in Settings

Open **Settings** and choose **Add theme** to create a named theme. Choose a built-in preset to copy; choosing Lilith also copies its background unless you already entered a custom image. Adjust the colors in the color map or enter a `#RRGGBB` value, optionally enter an `rbxassetid://` image ID or a direct HTTP(S) URL to a PNG or baseline JPEG background, and save. Images are decoded with the matching bundled decoder (or configured `PngDecoder` / `JpegDecoder`) to `EditableImage`; the host must support `EditableImage`. The new theme is selected immediately and appears with the built-in presets. Theme settings are shared between windows with the same `ProfileKey` and can be persisted by the host's `Settings.Save` callback.

Custom themes have edit, delete, and export controls. **Export preset** copies JSON for the current draft to the configured clipboard adapter (`Settings.Copy`) or `setclipboard`. Editing a theme does not change the active theme unless that theme is currently selected. Deleting the active theme returns to the current preset, or Lilith if no preset is active. The built-in Dark, Light, and Lilith presets cannot be edited or deleted.

See [the specification](../UI_LIBRARY_SPEC.md) for the full token palette.
