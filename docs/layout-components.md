# Cards, accordions, and custom UI

## Bento cards

Cards are added directly to a tab and reflow between one and two columns:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-bento-cards examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-bento-cards-full-tab" aria-controls="example-bento-cards-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-bento-cards-short-tab" aria-controls="example-bento-cards-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-bento-cards-full-panel" role="tabpanel" aria-labelledby="example-bento-cards-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local count = tab:Card({&#10;    Id = "online-count",&#10;    Title = "Players online",&#10;    Value = 12,&#10;    Description = "Players in this server.",&#10;    Icon = "users",&#10;    Size = "Small",&#10;    Accent = "Blue",&#10;})&#10;&#10;count:SetValue(14)&#10;print(count:GetValue())</code></pre>
  </div>
  <div class="astra-code-panel" id="example-bento-cards-short-panel" role="tabpanel" aria-labelledby="example-bento-cards-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">tab:Card({Title = "Players online", Value = 12})</code></pre>
  </div>
</div>

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

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-accordion examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-accordion-full-tab" aria-controls="example-accordion-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-accordion-short-tab" aria-controls="example-accordion-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-accordion-full-panel" role="tabpanel" aria-labelledby="example-accordion-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local advanced = section:Accordion({&#10;    Id = "advanced",&#10;    Name = "Advanced",&#10;    DefaultOpen = false,&#10;}, function(inner)&#10;    inner:Toggle({&#10;        Id = "debug-mode",&#10;        Name = "Debug mode",&#10;        Default = false,&#10;    })&#10;end)&#10;&#10;advanced:SetExpanded(true)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-accordion-short-panel" role="tabpanel" aria-labelledby="example-accordion-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Accordion({Name = "Advanced"}, function(inner) inner:Toggle({Name = "Debug mode"}) end)</code></pre>
  </div>
</div>

The `build` callback is required and receives an inner section, so its normal controls can be used. `DefaultOpen` controls the initial state. `SetExpanded(boolean)` changes it. Build errors are reported in Roblox Output.

## Custom component

Use `Custom` for UI that cannot be expressed with built-in controls:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-custom-component examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-custom-component-full-tab" aria-controls="example-custom-component-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-custom-component-short-tab" aria-controls="example-custom-component-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-custom-component-full-panel" role="tabpanel" aria-labelledby="example-custom-component-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local custom = section:Custom({&#10;    Id = "custom-meter",&#10;    Height = 48,&#10;    Build = function(host, context)&#10;        local label = Instance.new("TextLabel")&#10;        label.BackgroundTransparency = 1&#10;        label.Size = UDim2.fromScale(1, 1)&#10;        label.Text = "Custom content"&#10;        label.Parent = host&#10;&#10;        context:RegisterCleanup(function()&#10;            print("Clean up custom connections/resources here")&#10;        end)&#10;&#10;        return label&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="example-custom-component-short-panel" role="tabpanel" aria-labelledby="example-custom-component-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Custom({Height = 32, Build = function(host) local label = Instance.new("TextLabel"); label.Text = "Custom content"; label.Parent = host; return label end})</code></pre>
  </div>
</div>

`Height` must be a positive number and `Build` is required. `Build(host, context)` must return a `GuiObject`; only `Id`, `Height`, and `Build` are used by this component. The context exposes:

- `GetTheme()` — copy of the active theme tokens
- `GetLayoutMode()` — `"Wide"`, `"Compact"`, or `"Narrow"`
- `RegisterCleanup(function)` — register cleanup work for `Destroy()`

`Build` may also return a cleanup function as its second return value. Use ordinary local Luau functions; do not pass code strings or execute remote/user-supplied scripts.
