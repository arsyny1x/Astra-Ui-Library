# Components overview

Astra UI uses a hierarchy of **window → tab → section → component**. Cards are created directly on a tab. Use stable IDs for values you want to serialize with `GetState()`.

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="components-overview examples">
    <button class="astra-code-tab" type="button" role="tab" id="components-overview-full-tab" aria-controls="components-overview-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="components-overview-short-tab" aria-controls="components-overview-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="components-overview-full-panel" role="tabpanel" aria-labelledby="components-overview-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({Title = "Example"})&#10;local tab = window:Tab({Id = "home", Name = "Home"})&#10;local section = tab:Section({Name = "Preferences"})&#10;&#10;section:Toggle({&#10;    Id = "sound",&#10;    Name = "Sound",&#10;    Description = "Enable interface sounds.",&#10;    Default = true,&#10;    Callback = function(enabled)&#10;        print("Sound:", enabled)&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="components-overview-short-panel" role="tabpanel" aria-labelledby="components-overview-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local section = window:Tab({Name = "Home"}):Section({Name = "Settings"})&#10;section:Toggle({Name = "Sound", Default = true})</code></pre>
  </div>
</div>

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

See [Display components](display-components.md) for `Paragraph`, `Console`, `Divider`, `Progress`, `State`, `EmptyState`, and `Badge`.

## Cards and composition

See [Cards, accordions, and custom UI](layout-components.md) for Bento cards, accordion sections, two-column sections, and custom components.

## Search and navigation

- `window:Search(config)` adds a single search field to the sidebar.
- `tab:Search(config)` is an alias for the window search.
- Tabs accept `Name`, optional `Id`, `Icon`, and `Category`.
- Sections accept `Name`, optional `Icon`, and optional `Side = "Left"` or `"Right"` for two-column layout.

Read [Window API](window-api.md) for the complete constructor and window methods.
