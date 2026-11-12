# Troubleshooting

## The image does not appear

1. Check Roblox Output for an `[AstraUI] Unable to load ... PNG` warning.
2. Confirm a compatible decoder is supplied as `PngDecoder` or found as a nearby ModuleScript named `png` or `luau-png`.
3. Confirm the decoder exports `supportsYieldIfNeeded = true` and accepts the `yieldIfNeeded` option.
4. Confirm the target runtime supports `EditableImage` and has the required permissions.
5. Confirm the image URL returns PNG data. The loader rejects non-PNG responses and images above its supported size/dimension limits.

## The library fails while loading icons

The current icon loader fetches icon libraries with `game:HttpGet` and executes them with `loadstring`. A standard Roblox client `LocalScript` cannot use this bootstrap. For an experience you own, adapt `main.lua` to use locally included, reviewed icon modules/assets. Do not solve this by running an executor or by listening for arbitrary code to execute.

## Settings do not persist

State serialization is available through `GetState()` and `SetState()`, but persistence is owned by the host. The demo's JSON file persistence requires filesystem functions such as `readfile` and `writefile`, which Roblox does not provide as standard APIs.

## A player selection disappears

`PlayerDropdown` only lists players currently in the server. It automatically removes a player's selection when that player leaves, and the selection is intentionally not persisted.
