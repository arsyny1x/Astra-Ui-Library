# State and localization

## Save and restore state

Give tabs and value controls stable IDs when they should be restored across UI rebuilds:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-save-restore-state examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-save-restore-state-full-tab" aria-controls="example-save-restore-state-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-save-restore-state-short-tab" aria-controls="example-save-restore-state-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-save-restore-state-full-panel" role="tabpanel" aria-labelledby="example-save-restore-state-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local tab = window:Tab({&#10;    Id = "overview",&#10;    Name = "Overview",&#10;})&#10;&#10;local section = tab:Section({&#10;    Name = "Preferences",&#10;})&#10;&#10;section:Toggle({&#10;    Id = "notifications",&#10;    Name = "Notifications",&#10;    Default = true,&#10;})&#10;&#10;local state = window:GetState()&#10;window:SetState(state)</code></pre>
  </div>
  <div class="astra-code-panel" id="example-save-restore-state-short-panel" role="tabpanel" aria-labelledby="example-save-restore-state-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local state = window:GetState()&#10;window:SetState(state)</code></pre>
  </div>
</div>

The state table contains supported window settings and values for controls with explicit IDs. `SetState` validates values and does not fire user callbacks. Unknown IDs are ignored with a diagnostic. Player dropdown selections are runtime-only and are not serialized.

`GetState` and `SetState` do not write component values to a data store or file. Use the `Settings` adapter below for shared window preferences; the host remains responsible for persistence and migrations.

## Localization

Provide a locale and optional resolver when creating the window:

<div class="astra-code-tabs" data-code-tabs>
  <div class="astra-code-tabs-bar" role="tablist" aria-label="example-localization examples">
    <button class="astra-code-tab" type="button" role="tab" id="example-localization-full-tab" aria-controls="example-localization-full-panel" aria-selected="true" tabindex="0" data-code-tab="full">Full example</button>
    <button class="astra-code-tab" type="button" role="tab" id="example-localization-short-tab" aria-controls="example-localization-short-panel" aria-selected="false" tabindex="-1" data-code-tab="short">Short example</button>
  </div>
  <div class="astra-code-panel" id="example-localization-full-panel" role="tabpanel" aria-labelledby="example-localization-full-tab" data-code-panel="full">
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({&#10;    Title = "Control Center",&#10;    Localization = {&#10;        Locale = "th-TH",&#10;        Resolve = function(locale, key, fallback)&#10;            if locale == "th-TH" then&#10;                return translations[key] or fallback&#10;            end&#10;            return fallback&#10;        end,&#10;    },&#10;})&#10;&#10;window:SetLocale("en-US")</code></pre>
  </div>
  <div class="astra-code-panel" id="example-localization-short-panel" role="tabpanel" aria-labelledby="example-localization-short-tab" data-code-panel="short" hidden>
    <pre data-lang="lua"><code class="language-lua">local window = AstraUI:CreateWindow({Localization = {Locale = "th-TH"}})&#10;window:SetLocale("en-US")</code></pre>
  </div>
</div>

The resolver receives the locale, the text key, and the fallback string. `SetLocale` re-resolves registered UI text.

### Add and edit locales with JSON

The Settings panel lists locales from `Localization.Locales` and any locales added in Settings. Choose **Add language**, copy the JSON template, translate its `Translations` values, paste the finished JSON, and choose **Add language**. Translation keys are the original English UI text (or the key passed to `Resolve`); leave keys unchanged and translate their values. Custom locales can also be edited or deleted from the language list. Editing a locale does not switch the active language unless it is currently selected; deleting the active locale falls back to `en-US`. The built-in `en-US` and `th-TH` locales cannot be edited or deleted.

```lua
local window = AstraUI:CreateWindow({
    Localization = {
        Locale = "en-US",
        Locales = {
            ["en-US"] = {Name = "English", Translations = {}},
            ["th-TH"] = {
                Name = "ไทย",
                Translations = {
                    ["Color theme"] = "ธีมสี",
                    ["Language"] = "ภาษา",
                },
            },
        },
    },
})
```

The language editor accepts one locale in this shape:

```json
{
  "Locale": "th-TH",
  "Name": "ไทย",
  "Translations": {
    "Settings": "ตั้งค่า",
    "Color theme": "ธีมสี",
    "Language": "ภาษา"
  }
}
```

The locale editor can copy its JSON template through `Settings.Copy` or the host's `setclipboard` function. Paste JSON directly into the editor using the platform's normal text input shortcut (for example, Ctrl+V). Adding a locale makes it available to all windows using the same profile key during the current library runtime.

### Share and persist Settings

Windows with the same `ProfileKey` share locale, theme, toggle key, resize, and drag settings during the current library runtime. `Settings.FilePath` enables built-in JSON file persistence for that profile:

```lua
local window = AstraUI:CreateWindow({
    Settings = {
        ProfileKey = "my-ui",
        FilePath = "AstraUI/my-ui-profile.json",
    },
})
```

The host must provide `readfile`, `isfile`, `writefile`, `makefolder`, and `isfolder` for file persistence; without `FilePath` or custom `Load`/`Save` callbacks, sharing lasts only until the library runtime ends. Custom callbacks remain available when the host uses another storage backend. Clipboard and file APIs are host-specific, not standard Roblox APIs.

Component state can also be saved separately from the shared settings profile:

```lua
local window = AstraUI:CreateWindow({
    StatePersistence = {
        Path = "AstraUI/my-ui-state.json",
        AutoSaveInterval = 2,
    },
})

-- After creating tabs and components with stable IDs:
local loaded, loadError = window:LoadStateFromFile()
local autoSaveStarted, autoSaveError = window:StartStateAutoSave()
```

`SaveStateToFile(path?)` and `LoadStateFromFile(path?)` accept an optional path; otherwise they use `StatePersistence.Path`. `LoadStateFromFile` returns `false, nil` when the file does not exist and `false, error` when reading or applying it fails. `StartStateAutoSave(interval?)` only writes when serialized state changes and stops with a warning if a save fails.
