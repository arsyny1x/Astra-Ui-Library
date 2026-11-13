# Demo script

The full [`demo.lua` source](https://github.com/arsyny1x/Astra-Ui-Library/blob/main/demo.lua) is an interactive Astra UI dashboard demonstrating tabs, controls, themes, localization, and optional settings persistence.

To run it, use a compatible runtime that provides `game:HttpGet` and `loadstring`. The library's built-in JSON persistence helpers are used by the demo and require host-provided file APIs such as `readfile`, `writefile`, `isfile`, `isfolder`, and `makefolder`. PNG and baseline JPEG images use the matching built-in decoder; no separate decoder setup is needed.

This page is also available at the legacy Docsify URL `#/demo.lua`.
