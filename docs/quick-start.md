# Quick start

## Requirements

This example requires an executor or runtime that provides `game:HttpGet` and `loadstring`. The current library downloads and executes its icon libraries during loading, so it cannot be used directly from a standard Roblox client `LocalScript`.

- Image URLs must point directly to a PNG or baseline JPEG under 8 MB and no larger than 4096 x 4096 pixels. Roblox also requires `EditableImage` support and the relevant permissions.
- The demo's built-in JSON persistence requires host-provided file APIs such as `readfile` / `writefile`.

## Build a window

Choose one tab and copy its entire code block. Both versions load Astra UI and create a window; the full example also includes a button to toggle the setting.

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="Window examples">
    <button class="astra-code-tab" type="button" role="tab" id="quickstart-window-full-tab" aria-controls="quickstart-window-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="quickstart-window-short-tab" aria-controls="quickstart-window-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="quickstart-window-full-panel" role="tabpanel" aria-labelledby="quickstart-window-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()&#10;&#10;local window = AstraUI:CreateWindow({&#10;    Title = "Game Dashboard",&#10;    Subtitle = "Local experience status",&#10;    Size = UDim2.fromOffset(800, 500),&#10;    ToggleKey = Enum.KeyCode.RightShift,&#10;    RestoreImageUrl = "https://i.ibb.co/tMv26Nr5/hi-guys-im-collecting-lilith-pictures-i-hope-you-guys-can-v0-jbwkdcepgjgf1.png",&#10;    Responsive = true,&#10;    Resizable = true,&#10;    Draggable = true,&#10;})&#10;&#10;local home = window:Tab({&#10;    Id = "home",&#10;    Name = "Home",&#10;    Category = "Game",&#10;    Icon = "house",&#10;})&#10;&#10;local status = home:Section({&#10;    Name = "Status",&#10;    Icon = "activity",&#10;})&#10;&#10;local enabled = status:Toggle({&#10;    Id = "feature-enabled",&#10;    Name = "Enable feature",&#10;    Default = false,&#10;    Callback = function(value)&#10;        print("Feature enabled:", value)&#10;    end,&#10;})&#10;&#10;status:Button({&#10;    Name = "Toggle feature",&#10;    Icon = "bell",&#10;    Callback = function()&#10;        local value = not enabled:GetValue()&#10;        enabled:SetValue(value)&#10;        window:Notify({&#10;            Type = "Success",&#10;            Title = "Feature updated",&#10;            Content = "Feature enabled: " .. tostring(value),&#10;        })&#10;    end,&#10;})</code></pre>
  </div>
  <div class="astra-code-panel" id="quickstart-window-short-panel" role="tabpanel" aria-labelledby="quickstart-window-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local AstraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/main.lua"))()&#10;local window = AstraUI:CreateWindow({Title = "Game Dashboard", RestoreImageUrl = "https://i.ibb.co/tMv26Nr5/hi-guys-im-collecting-lilith-pictures-i-hope-you-guys-can-v0-jbwkdcepgjgf1.png"})&#10;local home = window:Tab({Id = "home", Name = "Home"})&#10;local status = home:Section({Name = "Status"})&#10;local enabled = status:Toggle({Name = "Enable feature", Default = false})</code></pre>
  </div>
</div>

The examples set `RestoreImageUrl` to a direct PNG URL for the floating restore button. Baseline JPEG URLs are also supported and detected automatically. Replace the sample URL with one you control. If `EditableImage` support or permissions are unavailable, the button falls back to its built-in icon.

See [Buttons and values](controls.md), [Display components](display-components.md), and [Window API](window-api.md) for the full reference.
