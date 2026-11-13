# Troubleshooting

## The image does not appear

1. Check Roblox Output for an `[AstraUI] Unable to load ... PNG` warning.
2. Confirm a compatible decoder is supplied as `PngDecoder` or found as a nearby ModuleScript named `png` or `luau-png`.
3. Confirm the decoder exports `supportsYieldIfNeeded = true` and accepts the `yieldIfNeeded` option.
4. Confirm the target runtime supports `EditableImage` and has the required permissions.
5. Confirm the URL returns PNG data or a supported baseline JPEG. The loader detects the image format from its signature and rejects unsupported formats or images above its size/dimension limits.

## The library fails while loading icons

The current icon loader fetches icon libraries with `game:HttpGet` and executes them with `loadstring`. A standard Roblox client `LocalScript` cannot use this bootstrap. For an experience you own, adapt `main.lua` to use locally included, reviewed icon modules/assets. Do not solve this by running an executor or by listening for arbitrary code to execute.

## Settings do not persist

State serialization is available through `GetState()` and `SetState()`. The library also provides `SaveStateToFile()` and `LoadStateFromFile()` convenience methods, but they require host filesystem functions such as `readfile`, `writefile`, `isfile`, `isfolder`, and `makefolder`, which Roblox does not provide as standard APIs. Alternatively, use host-owned callbacks or storage.

## A player selection disappears

`PlayerDropdown` only lists players currently in the server. It automatically removes a player's selection when that player leaves, and the selection is intentionally not persisted.
