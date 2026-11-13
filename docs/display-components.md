# Display components

Display components belong to a section. Components that use the shared control row accept `Name`, optional `Description`, and optional `Id`; each component below lists its own fields.

## Paragraph

Display wrapped text and update it later:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-paragraph examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-paragraph-full-tab" aria-controls="example-paragraph-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-paragraph-short-tab" aria-controls="example-paragraph-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-paragraph-full-panel" role="tabpanel" aria-labelledby="example-paragraph-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local status = section:Paragraph({&#10;    Id = "status-text",&#10;    Title = "Current status",&#10;    Content = "Waiting for data...",&#10;})&#10;&#10;status:SetContent("Data received.")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-paragraph-short-panel" role="tabpanel" aria-labelledby="example-paragraph-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Paragraph({Title = "Status", Content = "Waiting..."})</code></pre>
  </div>
</div>

`Content` is required. `Title` is optional. `SetContent(string)` replaces the content. The content is displayed in a padded, theme-aware surface with a subtle border.

## Console

Show runtime log messages in a scrollable, monospace panel:

```lua
local console = section:Console({
    Id = "runtime-log",
    Name = "Runtime log",
    Height = 180,
    MaxEntries = 100,
})

console:Log("Connected to the server")
console:Log("Retrying with fallback settings", "Warning")
console:Log("Could not load configuration", "Error")

console:Clear()
```

`Height` is the panel height in pixels (default `160`). `MaxEntries` limits retained messages (default `100`); older messages are removed when the limit is reached. `Log(message, level)` supports `"Info"`, `"Success"`, `"Warning"`, and `"Error"`; the default level is `"Info"`. `Clear()` removes all messages. The output area and entries use theme-aware backgrounds and text colors. Console entries are display-only and do not execute input.

## Divider

```lua
section:Divider()
```

Adds a one-pixel theme-colored separator. It accepts no configuration.

## Progress

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-progress examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-progress-full-tab" aria-controls="example-progress-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-progress-short-tab" aria-controls="example-progress-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-progress-full-panel" role="tabpanel" aria-labelledby="example-progress-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local progress = section:Progress({&#10;    Id = "download-progress",&#10;    Name = "Download",&#10;    Description = "Downloading assets.",&#10;    Value = 0.4,&#10;    ShowValue = true,&#10;})&#10;&#10;progress:SetValue(0.75)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-progress-short-panel" role="tabpanel" aria-labelledby="example-progress-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Progress({Name = "Download", Value = 0})</code></pre>
  </div>
</div>

`Value` must be between 0 and 1. `ShowValue` displays a rounded percentage. Set `Indeterminate = true` for a moving-work placeholder (the current implementation displays a fixed partial fill). If `ShowValue` is false, `Label` is shown instead. `GetValue()` and `SetValue(value)` are available.

## State

Display a status panel with an optional action:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-state examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-state-full-tab" aria-controls="example-state-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-state-short-tab" aria-controls="example-state-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-state-full-panel" role="tabpanel" aria-labelledby="example-state-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local connection = section:State({&#10;    Id = "connection",&#10;    Type = "Success",&#10;    Title = "Connected",&#10;    Description = "The service is ready.",&#10;    Icon = "circle-check",&#10;    Action = {&#10;        Name = "Reconnect",&#10;        Callback = function()&#10;            print("Retry connection")&#10;        end,&#10;    },&#10;})&#10;&#10;connection:SetState("Error", "Connection failed.")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-state-short-panel" role="tabpanel" aria-labelledby="example-state-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:State({Type = "Success", Title = "Connected"})</code></pre>
  </div>
</div>

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

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-badge examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-badge-full-tab" aria-controls="example-badge-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-badge-short-tab" aria-controls="example-badge-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-badge-full-panel" role="tabpanel" aria-labelledby="example-badge-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local badge = section:Badge({&#10;    Id = "server-status",&#10;    Text = "Online",&#10;    Type = "Success",&#10;})&#10;&#10;badge:SetText("Maintenance")&#10;badge:SetType("Warning")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-badge-short-panel" role="tabpanel" aria-labelledby="example-badge-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">section:Badge({Text = "Online"})</code></pre>
  </div>
</div>

Supported types are `"Neutral"`, `"Info"`, `"Success"`, `"Warning"`, and `"Error"`. Type controls semantic text, dot, and outline colors.
