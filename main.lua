local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local SHARED_SETTINGS = {}
local platform = UserInputService:GetPlatform()
local IS_MOBILE_PLATFORM = platform == Enum.Platform.Android or platform == Enum.Platform.IOS
local ICON_LIBRARY_URLS = {
    Lucide = "https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/main/source.lua",
    Solar = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua",
}
local DEFAULT_PNG_DECODER_URL = "https://raw.githubusercontent.com/arsyny1x/luau-png/refs/heads/main/png.luau"
local DEFAULT_JPEG_DECODER_URL = "https://raw.githubusercontent.com/arsyny1x/Astra-Ui-Library/main/jpeg.luau"
local LILITH_BACKGROUND_URL = "https://i.ibb.co/sk4YSdj/0074aa3e1434937e307545db8881065878c16ecc.png"
local loadRestoreImage

local function loadIconLibrary(url, name)
    assert(type(loadstring) == "function", "[AstraUI] loadstring is required to load the " .. name .. " icon library")
    local source = game:HttpGet(url)
    local chunk, compileError = loadstring(source)
    assert(type(chunk) == "function", "[AstraUI] Unable to compile the " .. name .. " icon library: " .. tostring(compileError))
    local library = chunk()
    assert(type(library) == "table", "[AstraUI] The " .. name .. " icon library must return a table")
    if name == "Lucide" then
        assert(type(library.GetAsset) == "function", "[AstraUI] The Lucide icon library must expose GetAsset(name)")
    end

    return library
end

local DEFAULT_ICON_LIBRARIES = {
    lucide = loadIconLibrary(ICON_LIBRARY_URLS.Lucide, "Lucide"),
    solar = loadIconLibrary(ICON_LIBRARY_URLS.Solar, "Solar"),
}

local DEFAULT_THEME = {
    Background = Color3.fromRGB(11, 14, 23),
    WindowBorder = Color3.fromRGB(30, 36, 54),
    Surface = Color3.fromRGB(17, 22, 37),
    SurfaceRaised = Color3.fromRGB(22, 29, 45),
    SurfaceHover = Color3.fromRGB(30, 34, 70),
    SecondarySurface = Color3.fromRGB(30, 34, 70),
    ControlSurface = Color3.fromRGB(20, 28, 43),
    ControlInset = Color3.fromRGB(14, 20, 33),
    ControlHover = Color3.fromRGB(29, 39, 57),
    ControlTrack = Color3.fromRGB(38, 49, 68),
    ControlBorder = Color3.fromRGB(49, 63, 84),
    ControlKnob = Color3.fromRGB(220, 228, 239),
    StateSurface = Color3.fromRGB(22, 29, 45),
    Border = Color3.fromRGB(34, 43, 64),
    BorderActive = Color3.fromRGB(16, 185, 129),
    TextPrimary = Color3.fromRGB(235, 241, 250),
    TextSecondary = Color3.fromRGB(156, 171, 193),
    TextMuted = Color3.fromRGB(103, 120, 146),
    Accent = Color3.fromRGB(59, 66, 159),
    AccentSecondary = Color3.fromRGB(16, 185, 129),
    AccentForeground = Color3.fromRGB(6, 30, 25),
    Success = Color3.fromRGB(16, 185, 129),
    Warning = Color3.fromRGB(217, 119, 6),
    Danger = Color3.fromRGB(245, 104, 121),
    CornerRadius = 8,
    Density = "Compact",
    SurfaceTransparency = 0,
}

local LIGHT_THEME = {
    Background = Color3.fromRGB(232, 237, 245),
    WindowBorder = Color3.fromRGB(179, 191, 207),
    Surface = Color3.fromRGB(242, 246, 250),
    SurfaceRaised = Color3.fromRGB(247, 249, 252),
    SurfaceHover = Color3.fromRGB(228, 235, 244),
    SecondarySurface = Color3.fromRGB(230, 239, 248),
    ControlSurface = Color3.fromRGB(236, 241, 247),
    ControlInset = Color3.fromRGB(224, 231, 240),
    ControlHover = Color3.fromRGB(226, 234, 243),
    ControlTrack = Color3.fromRGB(207, 218, 231),
    ControlBorder = Color3.fromRGB(177, 191, 209),
    ControlKnob = Color3.fromRGB(252, 253, 255),
    StateSurface = Color3.fromRGB(247, 249, 252),
    Border = Color3.fromRGB(191, 202, 216),
    BorderActive = Color3.fromRGB(5, 150, 105),
    TextPrimary = Color3.fromRGB(24, 34, 48),
    TextSecondary = Color3.fromRGB(103, 115, 132),
    TextMuted = Color3.fromRGB(112, 126, 145),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentSecondary = Color3.fromRGB(5, 150, 105),
    AccentForeground = Color3.fromRGB(6, 30, 25),
    Success = Color3.fromRGB(5, 150, 105),
    Warning = Color3.fromRGB(180, 103, 0),
    Danger = Color3.fromRGB(210, 55, 75),
    CornerRadius = 8,
    Density = "Compact",
    SurfaceTransparency = 0,
}

local LILITH_THEME = {
    Background = Color3.fromRGB(225, 233, 246),
    WindowBorder = Color3.fromRGB(93, 112, 151),
    Surface = Color3.fromRGB(231, 239, 250),
    SurfaceRaised = Color3.fromRGB(246, 248, 253),
    SurfaceHover = Color3.fromRGB(247, 222, 230),
    SecondarySurface = Color3.fromRGB(214, 228, 246),
    ControlSurface = Color3.fromRGB(239, 244, 252),
    ControlInset = Color3.fromRGB(213, 226, 244),
    ControlHover = Color3.fromRGB(247, 222, 230),
    ControlTrack = Color3.fromRGB(180, 199, 224),
    ControlBorder = Color3.fromRGB(159, 180, 210),
    ControlKnob = Color3.fromRGB(255, 252, 253),
    StateSurface = Color3.fromRGB(241, 238, 248),
    Border = Color3.fromRGB(172, 189, 216),
    BorderActive = Color3.fromRGB(199, 49, 76),
    TextPrimary = Color3.fromRGB(21, 22, 43),
    TextSecondary = Color3.fromRGB(88, 99, 123),
    TextMuted = Color3.fromRGB(101, 111, 138),
    Accent = Color3.fromRGB(205, 48, 76),
    AccentSecondary = Color3.fromRGB(91, 139, 197),
    AccentForeground = Color3.fromRGB(255, 250, 251),
    Success = Color3.fromRGB(61, 132, 111),
    Warning = Color3.fromRGB(171, 106, 39),
    Danger = Color3.fromRGB(190, 39, 67),
    CornerRadius = 8,
    Density = "Compact",
    SurfaceTransparency = 0,
}
local LILITH_SURFACE_BASE_TRANSPARENCY = 0.12

local THEME_KEYS = {}
for key in pairs(DEFAULT_THEME) do
    THEME_KEYS[key] = true
end
local THEME_COLOR_ROLE_ORDER = {
    "Background",
    "WindowBorder",
    "Surface",
    "SurfaceRaised",
    "SurfaceHover",
    "SecondarySurface",
    "ControlSurface",
    "ControlInset",
    "ControlHover",
    "ControlTrack",
    "ControlBorder",
    "ControlKnob",
    "StateSurface",
    "Border",
    "BorderActive",
    "TextPrimary",
    "TextSecondary",
    "TextMuted",
    "Accent",
    "AccentSecondary",
    "AccentForeground",
    "Success",
    "Warning",
    "Danger",
}
local THEME_ACCENT_ROLES = {"Accent", "AccentSecondary", "BorderActive", "Success"}

local function matchesThemePreset(theme, preset)
    for _, role in ipairs(THEME_COLOR_ROLE_ORDER) do
        if not table.find(THEME_ACCENT_ROLES, role) and theme[role] ~= preset[role] then
            return false
        end
    end
    return true
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function addCorner(object, radius, parentWindow, preserveRadius)
    if parentWindow and not preserveRadius then
        radius = parentWindow.Theme.CornerRadius
    end
    local corner = make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10),
    }, object)
    if parentWindow and not preserveRadius then
        parentWindow:_trackTheme(corner, "CornerRadius")
    end
    return corner
end

local function addStroke(object, color, transparency, parentWindow, themeRole)
    if parentWindow and themeRole == nil then
        themeRole = "Border"
    end
    color = parentWindow and parentWindow.Theme[themeRole] or color
    local stroke = make("UIStroke", {
        Color = color or DEFAULT_THEME.Border,
        Transparency = transparency or 0.45,
        Thickness = 1,
    }, object)
    if parentWindow then
        parentWindow:_trackTheme(stroke, themeRole, "Color")
    end
    return stroke
end

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function isKeyCode(value)
    if typeof(value) ~= "EnumItem" then
        return false
    end
    local enumType = tostring(value.EnumType)
    return enumType == "Enum.KeyCode" or enumType == "KeyCode"
end

local function shallowCopy(source)
    local copy = {}
    for key, value in pairs(source or {}) do
        copy[key] = value
    end
    return copy
end

local function deepCopy(source)
    if type(source) ~= "table" then
        return source
    end
    local copy = {}
    for key, value in pairs(source) do
        copy[key] = deepCopy(value)
    end
    return copy
end

local function readTextFile(path)
    assert(type(path) == "string" and path ~= "", "File path must be a non-empty string")
    assert(type(readfile) == "function" and type(isfile) == "function",
        "File read APIs are unavailable in this environment")
    if not isfile(path) then
        return nil
    end
    return readfile(path)
end

local function writeTextFile(path, contents)
    assert(type(path) == "string" and path ~= "", "File path must be a non-empty string")
    assert(type(contents) == "string", "File contents must be a string")
    assert(type(writefile) == "function" and type(makefolder) == "function"
        and type(isfolder) == "function",
        "File write APIs are unavailable in this environment")
    local normalizedPath = string.gsub(path, "\\", "/")
    local directory = string.match(normalizedPath, "^(.*)/[^/]+$")
    if directory and directory ~= "" then
        local current = ""
        for segment in string.gmatch(directory, "[^/]+") do
            current = current == "" and segment or current .. "/" .. segment
            if not isfolder(current) then
                makefolder(current)
            end
        end
    end
    writefile(path, contents)
end

local function colorToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5))
end

local function colorFromHex(value, name)
    assert(type(value) == "string" and string.match(value, "^#?%x%x%x%x%x%x$"),
        name .. " must be a six-digit hex color")
    local hex = string.gsub(value, "^#", "")
    return Color3.fromRGB(
        tonumber(string.sub(hex, 1, 2), 16),
        tonumber(string.sub(hex, 3, 4), 16),
        tonumber(string.sub(hex, 5, 6), 16)
    )
end

local function normalizeImageAsset(value, name)
    assert(type(value) == "string", name .. " must be an asset ID or rbxassetid URL")
    if string.match(value, "^%d+$") then
        return "rbxassetid://" .. value
    end
    assert(string.match(value, "^rbxassetid://%d+$"),
        name .. " must be a numeric asset ID or rbxassetid:// URL")
    return value
end

local function normalizeImageUrl(value, name)
    assert(type(value) == "string" and string.match(value, "^https?://"),
        name .. " must be an HTTP(S) PNG or JPEG URL")
    return value
end

local function normalizeThemeImage(value, name)
    if type(value) == "string" and (
        string.match(value, "^%d+$") or string.match(value, "^rbxassetid://%d+$")
    ) then
        return normalizeImageAsset(value, name)
    end
    return normalizeImageUrl(value, name)
end

local function invalidatePngLoad(window, targetImage)
    window._pngLoadGenerations = window._pngLoadGenerations or {}
    local generation = (window._pngLoadGenerations[targetImage] or 0) + 1
    window._pngLoadGenerations[targetImage] = generation
    if (targetImage == window._customThemePngBackgroundImage
        or targetImage == window._lilithBackgroundImage) and window._setBackgroundLoading then
        window:_setBackgroundLoading(targetImage, false)
    end
    return generation
end

local function cacheThemeImage(window, imageUrl, editableImage)
    window._themeImageCache = window._themeImageCache or {}
    window._themeImageCacheOrder = window._themeImageCacheOrder or {}
    local cache = window._themeImageCache
    local order = window._themeImageCacheOrder
    local previous = cache[imageUrl]
    if previous and previous ~= editableImage then
        previous:Destroy()
    end
    cache[imageUrl] = editableImage
    for index = #order, 1, -1 do
        if order[index] == imageUrl then
            table.remove(order, index)
        end
    end
    table.insert(order, imageUrl)
    while #order > 3 do
        local expiredUrl = table.remove(order, 1)
        local expiredImage = cache[expiredUrl]
        cache[expiredUrl] = nil
        if expiredImage and expiredImage ~= window._customThemeEditableImage then
            expiredImage:Destroy()
        end
    end
end

local function encodeTheme(theme)
    local encoded = {}
    for key, value in pairs(theme) do
        if key == "CornerRadius" or key == "Density" or key == "SurfaceTransparency" then
            encoded[key] = value
        else
            encoded[key] = colorToHex(value)
        end
    end
    return encoded
end

local function decodeTheme(theme, name)
    assert(type(theme) == "table", name .. " must be a theme object")
    local decoded = {}
    for key, value in pairs(theme) do
        assert(THEME_KEYS[key], name .. " contains unknown theme token: " .. tostring(key))
        if key == "CornerRadius" then
            assert(type(value) == "number" and value >= 0 and value <= 32,
                name .. ".CornerRadius must be between 0 and 32")
            decoded[key] = value
        elseif key == "Density" then
            assert(value == "Compact" or value == "Comfortable",
                name .. ".Density must be Compact or Comfortable")
            decoded[key] = value
        elseif key == "SurfaceTransparency" then
            assert(type(value) == "number" and value >= 0 and value <= 1,
                name .. ".SurfaceTransparency must be between 0 and 1")
            decoded[key] = value
        else
            decoded[key] = colorFromHex(value, name .. "." .. key)
        end
    end
    return decoded
end

local function validateLocales(locales)
    assert(type(locales) == "table", "Locales must be an object")
    for locale, definition in pairs(locales) do
        assert(type(locale) == "string" and locale ~= "", "Locale keys must be non-empty strings")
        assert(type(definition) == "table", "Locales." .. locale .. " must be an object")
        assert(definition.Name == nil or type(definition.Name) == "string",
            "Locales." .. locale .. ".Name must be a string")
        assert(definition.Translations == nil or type(definition.Translations) == "table",
            "Locales." .. locale .. ".Translations must be an object")
        for key, value in pairs(definition.Translations or {}) do
            assert(type(key) == "string" and type(value) == "string",
                "Locales." .. locale .. ".Translations must contain string keys and values")
        end
    end
end

local function validateSettingsProfile(profile)
    assert(type(profile) == "table", "Settings JSON must be an object")
    assert(profile.Version == 1, "Settings JSON Version must be 1")
    assert(type(profile.Locale) == "string" and profile.Locale ~= "",
        "Settings JSON Locale must be a non-empty string")
    assert(type(profile.Theme) == "string" and profile.Theme ~= "",
        "Settings JSON Theme must be a non-empty string")
    assert(type(profile.Locales) == "table", "Settings JSON Locales must be an object")
    assert(type(profile.CustomThemes) == "table", "Settings JSON CustomThemes must be an object")
    assert(profile.RemovedLocales == nil or type(profile.RemovedLocales) == "table",
        "Settings JSON RemovedLocales must be an object")
    for locale, removed in pairs(profile.RemovedLocales or {}) do
        assert(type(locale) == "string" and locale ~= "", "RemovedLocales keys must be locale codes")
        assert(type(removed) == "boolean", "RemovedLocales values must be booleans")
    end
    validateLocales(profile.Locales)
    for name, theme in pairs(profile.CustomThemes) do
        assert(type(name) == "string" and name ~= "", "Custom theme names must be non-empty strings")
        assert(name ~= "Dark" and name ~= "Light" and name ~= "Lilith",
            "Custom theme names cannot replace built-in presets")
        decodeTheme(theme, "CustomThemes." .. name)
    end
    assert(profile.ThemeImages == nil or type(profile.ThemeImages) == "table",
        "Settings JSON ThemeImages must be an object")
    for name, image in pairs(profile.ThemeImages or {}) do
        assert(type(name) == "string" and name ~= "", "ThemeImages keys must be theme names")
        normalizeThemeImage(image, "ThemeImages." .. name)
    end
    assert(profile.ToggleKey == nil or type(profile.ToggleKey) == "string",
        "Settings JSON ToggleKey must be a string or null")
    if profile.ToggleKey ~= nil then
        assert(isKeyCode(Enum.KeyCode[profile.ToggleKey]),
            "Settings JSON ToggleKey is not a valid KeyCode")
    end
    assert(profile.Resizable == nil or type(profile.Resizable) == "boolean",
        "Settings JSON Resizable must be a boolean")
    assert(profile.Draggable == nil or type(profile.Draggable) == "boolean",
        "Settings JSON Draggable must be a boolean")
    local localeExists = profile.Locales[profile.Locale] ~= nil
        or string.sub(profile.Locale, 1, 2) == "en"
        or string.sub(profile.Locale, 1, 2) == "th"
    assert(localeExists, "Settings JSON Locale must exist in Locales")
    if profile.Theme ~= "Dark" and profile.Theme ~= "Light" and profile.Theme ~= "Lilith" then
        assert(profile.CustomThemes[profile.Theme] ~= nil,
            "Settings JSON Theme must be a built-in preset or a key in CustomThemes")
    end
end

local function settingsProfileDefaults(window)
    local themes = {}
    if window._customThemes then
        for name, theme in pairs(window._customThemes) do
            themes[name] = encodeTheme(theme)
        end
    end
    local locales = deepCopy(window.Localization.Locales or {})
    if locales[window.Localization.Locale] == nil then
        locales[window.Localization.Locale] = {
            Name = window.Localization.Locale,
            Translations = {},
        }
    end
    local themeImages = deepCopy(window._customThemeImages or {})
    return {
        Version = 1,
        Locale = window.Localization.Locale,
        Theme = window._settingsThemeName or window._themePreset or "Lilith",
        CustomThemes = themes,
        ThemeImages = themeImages,
        Locales = locales,
        RemovedLocales = {},
        ToggleKey = window._toggleKey and window._toggleKey.Name or nil,
        Resizable = window.Resizable,
        Draggable = window._draggable,
    }
end

local function prettyJson(json)
    local output = {}
    local containers = {}
    local depth = 0
    local inString = false
    local escaped = false
    local function addIndent()
        table.insert(output, "\n" .. string.rep("  ", depth))
    end
    for index = 1, #json do
        local character = string.sub(json, index, index)
        if inString then
            table.insert(output, character)
            if escaped then
                escaped = false
            elseif character == "\\" then
                escaped = true
            elseif character == '"' then
                inString = false
            end
        elseif character == '"' then
            inString = true
            table.insert(output, character)
        elseif character == "{" or character == "[" then
            table.insert(output, character)
            depth = depth + 1
            local closing = character == "{" and "}" or "]"
            local nextIndex = index + 1
            while nextIndex <= #json and string.match(string.sub(json, nextIndex, nextIndex), "%s") do
                nextIndex = nextIndex + 1
            end
            local hasItems = string.sub(json, nextIndex, nextIndex) ~= closing
            containers[#containers + 1] = hasItems
            if hasItems then
                addIndent()
            end
        elseif character == "}" or character == "]" then
            depth = depth - 1
            if table.remove(containers) then
                addIndent()
            end
            table.insert(output, character)
        elseif character == "," then
            table.insert(output, character)
            addIndent()
        elseif character == ":" then
            table.insert(output, ": ")
        elseif not string.match(character, "%s") then
            table.insert(output, character)
        end
    end
    return table.concat(output)
end

local function safeString(value)
    if value == nil then
        return ""
    end
    return tostring(value)
end

local function truncateText(value, maxLength)
    if not maxLength then
        return value
    end
    local offset = utf8 and utf8.offset and utf8.offset(value, math.floor(maxLength) + 1)
    if offset then
        return string.sub(value, 1, offset - 1)
    end
    return string.sub(value, 1, math.floor(maxLength))
end

local function textLength(value)
    if utf8 and utf8.len then
        local length = utf8.len(value)
        if length then
            return length
        end
    end
    return #value
end

local function setVisible(object, visible)
    if object and object.Parent then
        object.Visible = visible
    end
end

local function isTextFocused()
    return UserInputService:GetFocusedTextBox() ~= nil
end

local function validConfig(config, method)
    assert(type(config) == "table", method .. " expects a config table")
end

local WindowMethods = {}
WindowMethods.__index = WindowMethods
local TabMethods = {}
TabMethods.__index = TabMethods
local SectionMethods = {}
SectionMethods.__index = SectionMethods
local ControlMethods = {}
ControlMethods.__index = ControlMethods
local ConsoleMethods = {}
ConsoleMethods.__index = ConsoleMethods
setmetatable(ConsoleMethods, {__index = ControlMethods})
local SearchMethods = {}
SearchMethods.__index = SearchMethods

function WindowMethods:_connect(signal, callback, owner)
    local connection = signal:Connect(callback)
    local list = owner and owner._connections or self._connections
    table.insert(list, connection)
    return connection
end

function WindowMethods:_trackThemeSurface(object)
    self._surfaceTransparencyTargets = self._surfaceTransparencyTargets or {}
    for _, target in ipairs(self._surfaceTransparencyTargets) do
        if target.Object == object then
            return target
        end
    end
    local target = {
        Object = object,
        DefaultTransparency = object.BackgroundTransparency,
        LilithTransparency = nil,
    }
    table.insert(self._surfaceTransparencyTargets, target)
    local baseTransparency = self._themePreset == "Lilith" and target.LilithTransparency
        or target.DefaultTransparency
    local transparency = clamp(self.Theme.SurfaceTransparency or 0, 0, 1)
    object.BackgroundTransparency = baseTransparency + (1 - baseTransparency) * transparency
    return target
end

function WindowMethods:_setBackgroundLoading(targetImage, loading)
    self._backgroundLoadingSources = self._backgroundLoadingSources or {}
    if targetImage then
        self._backgroundLoadingSources[targetImage] = loading and true or nil
    end
    local isLoading = next(self._backgroundLoadingSources) ~= nil
    local indicator = self._backgroundLoadingIndicator
    if indicator then
        indicator.Visible = isLoading
    end
end

function WindowMethods:_trackTheme(object, propertyOrRole, property)
    if not object then
        return
    end

    for _, target in ipairs(self._themeTargets) do
        if target.Object == object and target.Property == property then
            target.Role = propertyOrRole
            local value = self.Theme[propertyOrRole]
            if value ~= nil then
                if property then
                    object[property] = value
                elseif propertyOrRole == "CornerRadius" then
                    object.CornerRadius = UDim.new(0, value)
                end
            end
            return
        end
    end
    table.insert(self._themeTargets, {
        Object = object,
        Role = propertyOrRole,
        Property = property,
    })
    local value = self.Theme[propertyOrRole]
    if value ~= nil then
        if property then
            object[property] = value
        elseif propertyOrRole == "CornerRadius" then
            object.CornerRadius = UDim.new(0, value)
        end
    end
end

function WindowMethods:_trackLilithSurface(object, transparency)
    if not object then
        return
    end
    local target = self:_trackThemeSurface(object)
    target.LilithTransparency = transparency
    self:_applyLilithSurfaceMode()
end

function WindowMethods:_applyLilithSurfaceMode()
    local active = self._themePreset == "Lilith"
    local imageReady = self._lilithImageLoadState == "loaded"
    local transparency = clamp(self.Theme.SurfaceTransparency or 0, 0, 1)
    if active and not imageReady then
        transparency = 0
    end
    for _, target in ipairs(self._surfaceTransparencyTargets or {}) do
        if target.Object and target.Object.Parent then
            local baseTransparency = target.DefaultTransparency
            if active then
                baseTransparency = imageReady and target.LilithTransparency or 0
            end
            target.Object.BackgroundTransparency = baseTransparency
                + (1 - baseTransparency) * transparency
        end
    end
end

function WindowMethods:_trackColor(object, color, property)
    if color == nil then
        return
    end
    local preferredRoles
    if property == "TextColor3" then
        preferredRoles = {"TextPrimary", "TextSecondary", "TextMuted", "AccentForeground", "Danger", "Warning", "Success"}
    elseif property == "BackgroundColor3" then
        preferredRoles = {"Background", "Surface", "SurfaceRaised", "SurfaceHover", "SecondarySurface", "Border", "BorderActive", "Accent", "AccentSecondary", "Success"}
    elseif property == "Color" then
        preferredRoles = {"Border", "WindowBorder", "BorderActive", "AccentSecondary", "Accent", "Success", "Warning", "Danger"}
    else
        preferredRoles = {"AccentSecondary", "Accent", "Success", "Warning", "Danger", "TextPrimary", "TextSecondary", "TextMuted"}
    end
    for _, role in ipairs(preferredRoles) do
        if self.Theme[role] == color then
            self:_trackTheme(object, role, property)
            return
        end
    end
    for _, role in ipairs(THEME_COLOR_ROLE_ORDER) do
        if self.Theme[role] == color then
            self:_trackTheme(object, role, property)
            return
        end
    end
end

function WindowMethods:_trackTextColor(object, color)
    self:_trackColor(object, color, "TextColor3")
end

local DISCORD_TEXT = {
    en = {
        button = "Copy Discord invite",
        ["url_missing.title"] = "Discord link not configured",
        ["url_missing.content"] = "Set Discord.Url in CreateWindow to configure this button.",
        ["copy_missing.title"] = "Clipboard not configured",
        ["copy_missing.content"] = "Provide Discord.Copy to copy the invite.",
        ["copy_failed.title"] = "Could not copy Discord link",
        ["copy_failed.content"] = "The configured copy callback failed.",
        ["copied.title"] = "Discord link copied",
        ["copied.content"] = "The invite link is ready to paste.",
    },
    th = {
        button = "คัดลอกลิงก์เชิญ Discord",
        ["url_missing.title"] = "ยังไม่ได้ตั้งค่าลิงก์ Discord",
        ["url_missing.content"] = "กำหนด Discord.Url ใน CreateWindow เพื่อใช้ปุ่มนี้",
        ["copy_missing.title"] = "ยังไม่ได้ตั้งค่าการคัดลอก",
        ["copy_missing.content"] = "กำหนด Discord.Copy เพื่อคัดลอกลิงก์เชิญ",
        ["copy_failed.title"] = "คัดลอกลิงก์ Discord ไม่สำเร็จ",
        ["copy_failed.content"] = "ฟังก์ชันคัดลอกที่กำหนดไว้ทำงานไม่สำเร็จ",
        ["copied.title"] = "คัดลอกลิงก์ Discord แล้ว",
        ["copied.content"] = "ลิงก์เชิญพร้อมวางแล้ว",
    },
}

function WindowMethods:_discordText(key)
    local locale = self.Localization.Locale
    local language = type(locale) == "string" and string.lower(string.sub(locale, 1, 2)) == "th"
        and "th" or "en"
    local fallback = DISCORD_TEXT[language][key]
    return self:_resolveText({Key = "discord." .. key, Default = fallback})
end

function WindowMethods:_resolveText(value)
    local key
    local fallback
    if type(value) == "table" and value.Key then
        key = safeString(value.Key)
        fallback = safeString(value.Default or value.Key)
    else
        fallback = safeString(value)
        key = fallback
    end
    local locale = self.Localization.Locales and self.Localization.Locales[self.Localization.Locale]
    local translation = locale and locale.Translations and locale.Translations[key]
    if type(translation) == "string" then
        fallback = translation
    end
    local resolver = self.Localization.Resolve
    if type(resolver) == "function" then
        local ok, result = pcall(resolver, self.Localization.Locale, key, fallback)
        if ok and result ~= nil then
            return tostring(result)
        elseif not ok then
            warn("[AstraUI] Localization resolver failed: " .. tostring(result))
        end
    end
    return fallback
end

function WindowMethods:_getSettingsProfile()
    local profile = settingsProfileDefaults(self)
    profile.RemovedLocales = deepCopy(self._settingsRemovedLocales or {})
    return profile
end

function WindowMethods:_normalizeSettingsProfile(profile)
    local normalized = deepCopy(profile)
    normalized.Locales = normalized.Locales or {}
    normalized.RemovedLocales = normalized.RemovedLocales or {}
    for locale, definition in pairs(self.Localization.Locales or {}) do
        if normalized.Locales[locale] == nil and not normalized.RemovedLocales[locale] then
            normalized.Locales[locale] = deepCopy(definition)
        end
    end
    if normalized.Locales[normalized.Locale] == nil then
        normalized.Locales[normalized.Locale] = {
            Name = normalized.Locale,
            Translations = {},
        }
    end
    normalized.ThemeImages = normalized.ThemeImages or {}
    return normalized
end

function WindowMethods:_applyThemeImage(imageAsset)
    local assetImage = self._customThemeBackgroundImage
    local pngImage = self._customThemePngBackgroundImage
    if not assetImage or not pngImage then
        return
    end
    if imageAsset and imageAsset ~= "" then
        local normalizedImage = normalizeThemeImage(imageAsset, "Theme image")
        self._lilithBackgroundImage.Visible = false
        self:_setBackgroundLoading(self._lilithBackgroundImage, false)
        if string.match(normalizedImage, "^https?://") then
            assetImage.Visible = false
            local cachedImage = self._themeImageCache and self._themeImageCache[normalizedImage]
            if cachedImage then
                invalidatePngLoad(self, pngImage)
                self._customThemeEditableImage = cachedImage
                pngImage.ImageContent = Content.fromObject(cachedImage)
                pngImage.Visible = true
                local order = self._themeImageCacheOrder or {}
                for index = #order, 1, -1 do
                    if order[index] == normalizedImage then
                        table.remove(order, index)
                    end
                end
                table.insert(order, normalizedImage)
                self._themeImageCacheOrder = order
            else
                self._customThemeEditableImage = nil
                pngImage.Visible = false
                loadRestoreImage(
                    self,
                    normalizedImage,
                    self._pngDecoder,
                    self._pngDecoderUrl,
                    pngImage,
                    self._jpegDecoder,
                    self._jpegDecoderUrl
                )
            end
        else
            invalidatePngLoad(self, pngImage)
            self._customThemeEditableImage = nil
            pngImage.Visible = false
            assetImage.Image = normalizedImage
            assetImage.Visible = true
        end
    else
        invalidatePngLoad(self, pngImage)
        self._customThemeEditableImage = nil
        assetImage.Visible = false
        pngImage.Visible = false
        self._lilithBackgroundImage.Visible = self._themePreset == "Lilith"
            and self._lilithImageLoadState == "loaded"
    end
end

function WindowMethods:_applySettingsProfile(profile)
    validateSettingsProfile(profile)
    profile = self:_normalizeSettingsProfile(profile)
    validateSettingsProfile(profile)
    self._settingsRemovedLocales = deepCopy(profile.RemovedLocales)
    local customThemes = {}
    for name, theme in pairs(profile.CustomThemes) do
        customThemes[name] = decodeTheme(theme, "CustomThemes." .. name)
    end
    local toggleKey = profile.ToggleKey and Enum.KeyCode[profile.ToggleKey] or nil
    assert(profile.ToggleKey == nil or isKeyCode(toggleKey), "Settings JSON ToggleKey is not a valid KeyCode")
    self._applyingSharedSettings = true
    local ok, err = pcall(function()
        self.Localization.Locales = deepCopy(profile.Locales)
        self._customThemes = customThemes
        self._customThemeImages = deepCopy(profile.ThemeImages)
        if profile.Theme == "Dark" or profile.Theme == "Light" or profile.Theme == "Lilith" then
            self:SetThemePreset(profile.Theme)
        else
            self._themePreset = nil
            self:SetTheme(customThemes[profile.Theme])
        end
        self._settingsThemeName = profile.Theme
        self:_applyThemeImage(customThemes[profile.Theme] and self._customThemeImages[profile.Theme] or nil)
        self:SetLocale(profile.Locale)
        self:SetToggleKey(toggleKey)
        if profile.Resizable ~= nil then
            self:SetResizable(profile.Resizable)
        end
        if profile.Draggable ~= nil then
            self:SetDraggable(profile.Draggable)
        end
    end)
    self._applyingSharedSettings = false
    if not ok then
        error(err, 0)
    end
    if self._settingsRefreshTheme then
        self._settingsRefreshTheme()
    end
    if self._settingsRefreshLocale then
        self._settingsRefreshLocale()
    end
end

function WindowMethods:_setSharedSettingsProfile(profile, save)
    validateSettingsProfile(profile)
    profile = self:_normalizeSettingsProfile(profile)
    validateSettingsProfile(profile)
    local encoded = HttpService:JSONEncode(profile)
    local store = self._settingsStore
    if not store then
        self:_applySettingsProfile(profile)
        return
    end
    store.Json = encoded
    for window in pairs(store.Windows) do
        if window ~= self and not window._destroyed then
            local ok, err = pcall(window._applySettingsProfile, window, deepCopy(profile))
            if not ok then
                warn("[AstraUI] Failed to sync settings to another window: " .. tostring(err))
            end
        end
    end
    self:_applySettingsProfile(deepCopy(profile))
    if save and store.Save then
        local ok, result, reason = pcall(store.Save, encoded)
        if not ok or result == false then
            warn("[AstraUI] Failed to save shared settings: "
                .. tostring(ok and (reason or "Save callback returned false") or result))
        end
    end
end

function WindowMethods:_syncSharedSettings()
    if self._applyingSharedSettings or not self._settingsStore then
        return
    end
    local profile = self:_getSettingsProfile()
    validateSettingsProfile(profile)
    local encoded = HttpService:JSONEncode(profile)
    self._settingsStore.Json = encoded
    for window in pairs(self._settingsStore.Windows) do
        if window ~= self and not window._destroyed then
            local ok, err = pcall(window._applySettingsProfile, window, deepCopy(profile))
            if not ok then
                warn("[AstraUI] Failed to sync settings to another window: " .. tostring(err))
            end
        end
    end
    if self._settingsStore.Save then
        local ok, result, reason = pcall(self._settingsStore.Save, encoded)
        if not ok or result == false then
            warn("[AstraUI] Failed to save shared settings: "
                .. tostring(ok and (reason or "Save callback returned false") or result))
        end
    end
end

function WindowMethods:_text(parent, value, properties)
    local props = shallowCopy(properties)
    props.Text = self:_resolveText(value)
    props.BackgroundTransparency = props.BackgroundTransparency or 1
    props.Font = props.Font or Enum.Font.GothamMedium
    props.TextColor3 = props.TextColor3 or self.Theme.TextPrimary
    props.TextSize = props.TextSize or 14
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    local label = make("TextLabel", props, parent)
    self:_trackTextColor(label, props.TextColor3)
    if type(value) == "string" or (type(value) == "table" and value.Key) then
        table.insert(self._localized, {Object = label, Value = value, Property = "Text"})
    end
    return label
end

function WindowMethods:_icon(parent, name, properties, fallbackText)
    local props = shallowCopy(properties)
    local libraryName, iconName = string.match(name, "^([%a]+):(.+)$")
    libraryName = string.lower(libraryName or "lucide")
    iconName = iconName or name
    local assetUrl
    local imageRectSize
    local imageRectOffset
    local library = self.IconLibraries[libraryName]
    if libraryName == "solar" then
        iconName = string.lower(iconName)
        assetUrl = library and library[iconName]
        local hasStyle = false
        for _, suffix in ipairs({"-bold-duotone", "-line-duotone", "-bold", "-broken", "-linear", "-outline"}) do
            if string.sub(iconName, -#suffix) == suffix then
                hasStyle = true
                break
            end
        end
        if not assetUrl and library and not hasStyle then
            assetUrl = library[iconName .. "-linear"]
        end
    elseif libraryName == "lucide" and library then
        local ok, asset = pcall(library.GetAsset, iconName)
        if ok and type(asset) == "table" then
            assetUrl = asset.Url
            imageRectSize = asset.ImageRectSize
            imageRectOffset = asset.ImageRectOffset
        else
            warn("[AstraUI] Unable to load Lucide icon " .. tostring(iconName) .. ": " .. tostring(ok and "asset not found" or asset))
        end
    end
    if type(assetUrl) == "string" and assetUrl ~= "" then
        local imageProps = {
            Active = false,
            BackgroundTransparency = 1,
            Image = assetUrl,
            ImageColor3 = props.ImageColor3 or props.TextColor3 or self.Theme.TextSecondary,
            ImageTransparency = props.ImageTransparency or 0,
            Selectable = false,
            ScaleType = Enum.ScaleType.Fit,
        }
        for key, value in pairs(props) do
            if key ~= "TextColor3" and key ~= "TextSize" and key ~= "TextXAlignment" and key ~= "TextYAlignment" then
                imageProps[key] = value
            end
        end
        if imageRectSize then
            imageProps.ImageRectSize = imageRectSize
        end
        if imageRectOffset then
            imageProps.ImageRectOffset = imageRectOffset
        end
        local icon = make("ImageLabel", imageProps, parent)
        self:_trackColor(icon, imageProps.ImageColor3, "ImageColor3")
        return icon
    elseif libraryName == "solar" and library then
        warn("[AstraUI] Unable to load Solar icon " .. tostring(iconName) .. ": asset not found")
    elseif libraryName ~= "lucide" and libraryName ~= "solar" then
        warn("[AstraUI] Unknown icon library " .. tostring(libraryName))
    end
    return self:_text(parent, fallbackText or "◇", props)
end

function WindowMethods:_button(parent, text, callback, options)
    options = options or {}
    local backgroundRole = options.Role or "ControlSurface"
    local hoverRole = options.HoverRole or "ControlHover"
    local strokeRole = options.StrokeRole or "ControlBorder"
    local textRole = options.TextRole or (backgroundRole == "AccentSecondary" and "AccentForeground" or nil)
    local hovered = false
    local pressed = false
    local buttonObject = make("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = options.Background or self.Theme[backgroundRole],
        BackgroundTransparency = options.BackgroundTransparency or 0,
        BorderSizePixel = 0,
        Font = options.Font or Enum.Font.GothamMedium,
        Text = self:_resolveText(text),
        TextColor3 = options.TextColor or self.Theme[textRole or "TextPrimary"],
        TextSize = options.TextSize or 14,
        TextTruncate = options.TextTruncate or Enum.TextTruncate.None,
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Center,
        TextWrapped = options.TextWrapped ~= false,
        Selectable = true,
        Size = options.Size or UDim2.new(1, 0, 0, options.Height or 44),
        ZIndex = options.ZIndex or 10,
    }, parent)
    addCorner(buttonObject, options.Radius or 9, self, options.PreserveRadius)
    if options.PaddingLeft or options.PaddingRight then
        make("UIPadding", {
            PaddingLeft = UDim.new(0, options.PaddingLeft or 0),
            PaddingRight = UDim.new(0, options.PaddingRight or 0),
        }, buttonObject)
    end
    local stroke = addStroke(
        buttonObject,
        options.Stroke or self.Theme[strokeRole],
        options.StrokeTransparency or 0.65,
        self,
        strokeRole
    )
    self:_trackTheme(buttonObject, backgroundRole, "BackgroundColor3")
    if options.TextColor then
        self:_trackTextColor(buttonObject, options.TextColor)
    else
        self:_trackTheme(buttonObject, textRole or "TextPrimary", "TextColor3")
    end
    if type(text) == "string" or (type(text) == "table" and text.Key) then
        table.insert(self._localized, {Object = buttonObject, Value = text, Property = "Text"})
    end
    local function resolveColorRole(color, fallbackRole)
        if color == nil or color == self.Theme[fallbackRole] then
            return fallbackRole
        end
        for _, themeRole in ipairs(THEME_COLOR_ROLE_ORDER) do
            if color == self.Theme[themeRole] then
                return themeRole
            end
        end
        return nil
    end
    local backgroundColorRole = resolveColorRole(options.Background, backgroundRole)
    local hoverColorRole = resolveColorRole(options.HoverBackground, hoverRole)
    local pressedColor = options.PressedBackground or options.HoverBackground
    local pressedColorRole = resolveColorRole(pressedColor, hoverRole)
    local function resolveColor(color, role, colorRole)
        if colorRole then
            return self.Theme[colorRole]
        end
        return color or self.Theme[role]
    end
    local function applyBackgroundState()
        if pressed then
            buttonObject.BackgroundColor3 = resolveColor(pressedColor, hoverRole, pressedColorRole)
        elseif hovered then
            buttonObject.BackgroundColor3 = resolveColor(options.HoverBackground, hoverRole, hoverColorRole)
        else
            buttonObject.BackgroundColor3 = resolveColor(options.Background, backgroundRole, backgroundColorRole)
        end
    end
    self._buttonThemeTargets = self._buttonThemeTargets or {}
    table.insert(self._buttonThemeTargets, {
        Object = buttonObject,
        Apply = applyBackgroundState,
    })
    self:_connect(buttonObject.Activated, function()
        if callback and not self._destroyed then
            callback()
        end
    end, options.Owner)
    self:_connect(buttonObject.MouseEnter, function()
        if buttonObject.Active then
            hovered = true
            applyBackgroundState()
            if buttonObject:GetAttribute("AstraChoiceOption") ~= true then
                TweenService:Create(stroke, TweenInfo.new(0.14), {
                    Transparency = options.HoverStrokeTransparency or 0.3,
                }):Play()
            end
        end
    end, options.Owner)
    self:_connect(buttonObject.MouseLeave, function()
        if buttonObject.Active then
            hovered = false
            applyBackgroundState()
            local selected = buttonObject:GetAttribute("AstraChoiceSelected") == true
            local currentStrokeRole = selected and "BorderActive" or strokeRole
            self:_trackTheme(stroke, currentStrokeRole, "Color")
            if buttonObject:GetAttribute("AstraChoiceOption") == true then
                stroke.Transparency = 1
            else
                TweenService:Create(stroke, TweenInfo.new(0.14), {
                    Transparency = selected and 0 or (options.StrokeTransparency or 0.65),
                }):Play()
            end
        end
    end, options.Owner)
    self:_connect(buttonObject.InputBegan, function(input)
        if buttonObject.Active and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            pressed = true
            applyBackgroundState()
        end
    end, options.Owner)
    self:_connect(buttonObject.InputEnded, function(input)
        if buttonObject.Active and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            pressed = false
            applyBackgroundState()
        end
    end, options.Owner)
    self:_connect(buttonObject.SelectionGained, function()
        if buttonObject:GetAttribute("AstraChoiceOption") == true then
            return
        end
        self:_trackTheme(stroke, "BorderActive", "Color")
        stroke.Color = self.Theme.BorderActive
    end, options.Owner)
    self:_connect(buttonObject.SelectionLost, function()
        if buttonObject:GetAttribute("AstraChoiceOption") == true then
            stroke.Transparency = 1
            return
        end
        local selected = buttonObject:GetAttribute("AstraChoiceSelected") == true
        local role = selected and "BorderActive" or strokeRole
        self:_trackTheme(stroke, role, "Color")
        stroke.Color = self.Theme[role]
        stroke.Transparency = selected and 0 or (options.StrokeTransparency or 0.65)
    end, options.Owner)
    buttonObject:SetAttribute("AstraStroke", true)
    return buttonObject, stroke
end

function WindowMethods:_warnCallback(label, callback, ...)
    if type(callback) ~= "function" then
        return
    end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(function()
            callback(table.unpack(args, 1, args.n))
        end)
        if not ok then
            warn("[AstraUI] " .. label .. " callback failed: " .. tostring(err))
        end
    end)
end

function WindowMethods:_registerComponent(component)
    if component.Id then
        assert(type(component.Id) == "string" and component.Id ~= "", "Component Id must be a non-empty string")
        assert(not self._ids[component.Id], "Duplicate component Id: " .. tostring(component.Id))
        self._ids[component.Id] = component
    end
    local originalDestroy = component.Destroy
    if type(originalDestroy) == "function" then
        component.Destroy = function(target, ...)
            if target._destroyed then
                return
            end
            if self._openOverlayComponent == target then
                self:_closeOverlay()
            end
            local result = originalDestroy(target, ...)
            target._destroyed = true
            self:_unregisterComponent(target)
            return result
        end
    end
    table.insert(self._components, component)
    return component
end

function WindowMethods:_unregisterComponent(component)
    if component.Id and self._ids[component.Id] == component then
        self._ids[component.Id] = nil
    end
    for index, value in ipairs(self._components) do
        if value == component then
            table.remove(self._components, index)
            break
        end
    end
end

function WindowMethods:_updatePageCanvas(tab)
    if not tab or not tab._pageLayout or not tab._page then
        return
    end
    local scale = tab._window._contentScale and tab._window._contentScale.Scale or 1
    tab._page.CanvasSize = UDim2.new(0, 0, 0, tab._pageLayout.AbsoluteContentSize.Y / scale + 32)
end

function WindowMethods:_styleTabs(animate)
    local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, item in ipairs(self._tabs) do
        local selected = item == self._selectedTab
        local backgroundRole = selected and "SecondarySurface" or "Surface"
        local background = self.Theme[backgroundRole]
        self:_trackTheme(item._button, backgroundRole, "BackgroundColor3")
        local textColor = selected and self.Theme.TextPrimary or self.Theme.TextSecondary
        local iconColor = selected and self.Theme.AccentSecondary or self.Theme.TextSecondary
        local strokeColor = selected and self.Theme.AccentSecondary or self.Theme.Border
        local strokeTransparency = selected and 0.65 or 1
        if animate then
            TweenService:Create(item._button, tweenInfo, {BackgroundColor3 = background}):Play()
            TweenService:Create(item._nameLabel, tweenInfo, {TextColor3 = textColor}):Play()
            if item._iconLabel then
                local colorProperty = item._iconLabel:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
                TweenService:Create(item._iconLabel, tweenInfo, {[colorProperty] = iconColor}):Play()
            end
            TweenService:Create(item._stroke, tweenInfo, {
                Color = strokeColor,
                Transparency = strokeTransparency,
            }):Play()
        else
            item._button.BackgroundColor3 = background
            item._nameLabel.TextColor3 = textColor
            if item._iconLabel then
                local colorProperty = item._iconLabel:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
                item._iconLabel[colorProperty] = iconColor
            end
            item._stroke.Color = strokeColor
            item._stroke.Transparency = strokeTransparency
        end
        item._nameLabel.Font = selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
    end
end

function WindowMethods:_selectTab(tab)
    if self._destroyed or not tab then
        return
    end
    local previousTab = self._selectedTab
    self._selectedTab = tab
    self._selectedTabId = tab._explicitId and tab.Id or nil
    self:_styleTabs(true)
    for _, item in ipairs(self._tabs) do
        setVisible(item._page, item == tab)
        if item._pageTransition then
            item._pageTransition:Cancel()
            item._pageTransition = nil
        end
        if item ~= tab then
            item._page.Position = UDim2.new(0, 0, 0, 0)
        end
    end
    if previousTab ~= tab then
        tab._page.Position = UDim2.new(0, 0, 0, 8)
        tab._pageTransition = TweenService:Create(
            tab._page,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 0, 0, 0)}
        )
        tab._pageTransition:Play()
    end
    self._selectedTabLabel.Text = tab.Name
    if self._narrow then
        self._drawer.Visible = false
    end
    self._content.Position = UDim2.new(0, self._narrow and 0 or self._sidebarWidth, 0, 0)
    self._content.Size = UDim2.new(1, self._narrow and 0 or -self._sidebarWidth, 1, 0)
end

function WindowMethods:_setResponsiveLayout(animateSidebar)
    if self._destroyed or not self._panel then
        return
    end
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1024, 768)
    local insetTopLeft, insetBottomRight = GuiService:GetGuiInset()
    local safeWidth = math.max(1, viewport.X - insetTopLeft.X - insetBottomRight.X - 20)
    local safeHeight = math.max(1, viewport.Y - insetTopLeft.Y - insetBottomRight.Y - 20)
    local narrow = safeWidth < 600
    local contentScale = 1
    if IS_MOBILE_PLATFORM then
        contentScale = clamp(math.min(safeWidth / 460, safeHeight / 640), 0.7, 0.8)
    end
    self._contentScale.Scale = contentScale
    self._uiRoot.Size = UDim2.fromScale(1 / contentScale, 1 / contentScale)
    local layoutSafeWidth = safeWidth / contentScale
    local layoutSafeHeight = safeHeight / contentScale
    self._narrow = narrow
    self._compact = safeWidth >= 600 and safeWidth < 900
    local sidebarCollapsed = self._sidebarCollapsed
    if sidebarCollapsed == nil then
        sidebarCollapsed = self._compact
    end
    local requestedWidth = self._requestedSize.X.Offset + self._requestedSize.X.Scale * layoutSafeWidth
    local requestedHeight = self._requestedSize.Y.Offset + self._requestedSize.Y.Scale * layoutSafeHeight
    local width
    local height
    if self.Responsive then
        width = math.min(requestedWidth, layoutSafeWidth)
        height = math.min(requestedHeight, layoutSafeHeight)
        if narrow then
            width = layoutSafeWidth
            height = layoutSafeHeight
        end
    else
        width = math.min(requestedWidth, layoutSafeWidth)
        height = math.min(requestedHeight, layoutSafeHeight)
    end
    local minimumWidth = math.min(narrow and 320 or 680, layoutSafeWidth)
    local minimumHeight = math.min(narrow and 360 or 440, layoutSafeHeight)
    width = math.max(math.min(width, layoutSafeWidth), minimumWidth)
    height = math.max(math.min(height, layoutSafeHeight), minimumHeight)
    self._panel.Size = UDim2.fromOffset(width, height)
    if not self._layoutInitialized then
        self._panel.Position = UDim2.new(
            0.5,
            (insetTopLeft.X - insetBottomRight.X) / (2 * contentScale),
            0.5,
            (insetTopLeft.Y - insetBottomRight.Y) / (2 * contentScale)
        )
        self._layoutInitialized = true
    else
        local halfWidth = self._panel.AbsoluteSize.X / 2
        local halfHeight = self._panel.AbsoluteSize.Y / 2
        local positionScale = self._contentScale.Scale
        local x = clamp(
            self._panel.Position.X.Offset * positionScale,
            -viewport.X / 2 + halfWidth + insetTopLeft.X,
            viewport.X / 2 - halfWidth - insetBottomRight.X
        )
        local y = clamp(
            self._panel.Position.Y.Offset * positionScale,
            -viewport.Y / 2 + halfHeight + insetTopLeft.Y,
            viewport.Y / 2 - halfHeight - insetBottomRight.Y
        )
        self._panel.Position = UDim2.new(0.5, x / positionScale, 0.5, y / positionScale)
    end

    self._menuButton.Visible = true
    self._menuButton.Text = ""
    self._selectedTabLabel.Visible = false
    self._titleLabel.Visible = not narrow
    self._subtitleLabel.Visible = not narrow
    self._logo.Visible = false
    self._resizeHandle.Visible = self.Resizable and not narrow
    self._sidebarWidth = sidebarCollapsed and 68 or 210
    self._menuButton:SetAttribute("AstraLabel", narrow and "Open tab navigation" or (sidebarCollapsed and "Expand tab navigation" or "Collapse tab navigation"))
    if self._updateSidebarToggleIcon then
        self._updateSidebarToggleIcon()
    end
    self._toastContainer.Position = UDim2.new(1, -18, 1, -18)
    self._toastContainer.Size = UDim2.new(0, math.max(1, math.min(320, safeWidth - 24)), 0, 320)
    self._headerVersion.Visible = not narrow and self._headerVersion.Text ~= ""
    self._discordButton.Visible = not narrow
    self._settingsButton.Visible = true
    self._headerActionGroup.Position = UDim2.new(1, -8, 0, 6)
    self._headerActionGroup.Size = UDim2.fromOffset(narrow and 94 or 136, 44)
    self._settingsButton.Position = UDim2.fromOffset(4, 1)
    self._discordButton.Position = UDim2.fromOffset(47, 1)
    self._hideButton.Position = UDim2.fromOffset(narrow and 47 or 90, 1)
    self._headerActionDividerRight.Visible = not narrow
    if self._settingsPanel then
        self._settingsPanel.AnchorPoint = narrow and Vector2.new(0.5, 0.5) or Vector2.new(1, 0)
        self._settingsPanel.Position = narrow
            and UDim2.fromScale(0.5, 0.5)
            or UDim2.new(1, -12, 0, 58)
        self._settingsPanel.Size = UDim2.fromOffset(
            math.max(1, math.min(320, self._panel.AbsoluteSize.X / contentScale - 24)),
            math.max(1, math.min(350, self._panel.AbsoluteSize.Y / contentScale - 24))
        )
    end
    if self._search then
        local searchFrame = self._search._frame
        searchFrame.Parent = narrow and self._drawerList or self._tabList
        searchFrame.Visible = narrow or not sidebarCollapsed
        searchFrame.Size = UDim2.new(1, -12, 0, 34)
    end
    if narrow then
        self._sidebar.Visible = false
        self._drawer.Size = UDim2.new(0, math.min(250, width - 48), 1, 0)
        self._content.Position = UDim2.new(0, 0, 0, 0)
        self._content.Size = UDim2.new(1, 0, 1, 0)
    else
        self._drawer.Visible = false
        self._sidebar.Visible = true
        local sidebarSize = UDim2.new(0, self._sidebarWidth, 1, 0)
        local contentPosition = UDim2.new(0, self._sidebarWidth, 0, 0)
        local contentSize = UDim2.new(1, -self._sidebarWidth, 1, 0)
        if animateSidebar then
            local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(self._sidebar, tweenInfo, {Size = sidebarSize}):Play()
            TweenService:Create(self._content, tweenInfo, {
                Position = contentPosition,
                Size = contentSize,
            }):Play()
        else
            self._sidebar.Size = sidebarSize
            self._content.Position = contentPosition
            self._content.Size = contentSize
        end
    end
    for _, tab in ipairs(self._tabs) do
        local iconOnly = sidebarCollapsed and not narrow
        tab._nameLabel.Visible = not iconOnly
        tab._button.Visible = not (tab._category and tab._category.Collapsed and not iconOnly)
        local buttonSize = iconOnly and UDim2.new(1, -18, 0, 46) or UDim2.new(1, -24, 0, 46)
        if animateSidebar then
            TweenService:Create(tab._button, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = buttonSize,
            }):Play()
        else
            tab._button.Size = buttonSize
        end
        tab._button.Text = iconOnly and (tab._iconLabel and "" or string.sub(tab.Name, 1, 1)) or ""
        tab._button.Parent = narrow and self._drawerList or (self._compact and self._tabList or self._tabList)
        if tab._iconLabel then
            tab._iconLabel.Visible = true
            if iconOnly and not narrow then
                tab._iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                tab._iconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            else
                tab._iconLabel.AnchorPoint = Vector2.new(0, 0.5)
                tab._iconLabel.Position = UDim2.new(0, 12, 0.5, 0)
            end
        end
    end
    for _, category in pairs(self._tabCategories) do
        category.Header.Visible = not (sidebarCollapsed and not narrow)
        category.Header.Parent = narrow and self._drawerList or self._tabList
        category.Icon.Visible = not (sidebarCollapsed and not narrow)
    end
    for _, tab in ipairs(self._tabs) do
        self:_updatePageCanvas(tab)
        if tab._sideColumns then
            tab._sideColumns.Relayout()
        end
        for _, cardLayout in ipairs(tab._cardLayouts) do
            cardLayout()
        end
    end
end

function WindowMethods:_createOverlay()
    if self._overlay then
        self._overlay:Destroy()
    end
    local overlay = make("Frame", {
        Active = true,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 100,
    }, self._contentGroup)
    self._overlay = overlay
    self._overlayOwner = {_connections = {}}
    return overlay
end

function WindowMethods:_closeOverlay()
    if self._settingsModalClose then
        self._settingsModalClose()
    end
    if self._overlayOwner then
        for _, connection in ipairs(self._overlayOwner._connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        self._overlayOwner = nil
    end
    if self._overlay then
        self._overlay:Destroy()
        self._overlay = nil
    end
    self._openOverlayComponent = nil
    self._settingsPanel = nil
    self._capturingToggleKey = false
    self._settingsRefreshLocale = nil
    self._settingsRefreshKeybind = nil
    self._settingsRefreshTheme = nil
    self._settingsModal = nil
    self._settingsModalClose = nil
    self._settingsModalCleanup = nil
end

function WindowMethods:_addToast(config)
    validConfig(config, "Notify")
    local allowed = {Success = true, Info = true, Warning = true, Error = true}
    local kind = config.Type or "Info"
    assert(allowed[kind], "Notify.Type must be Success, Info, Warning, or Error")
    local duration = config.Duration == nil and 3 or config.Duration
    assert(type(duration) == "number" and duration >= 0, "Notify.Duration must be a non-negative number")
    if #self._toasts >= 4 then
        self._toasts[1]:Dismiss()
    end
    local colors = {
        Success = self.Theme.Success,
        Info = self.Theme.AccentSecondary,
        Warning = self.Theme.Warning,
        Error = self.Theme.Danger,
    }
    local colorRoles = {
        Success = "Success",
        Info = "AccentSecondary",
        Warning = "Warning",
        Error = "Danger",
    }
    local toastFrame = make("Frame", {
        BackgroundColor3 = self.Theme.SurfaceRaised,
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 76),
        ZIndex = 201,
    }, self._toastContainer)
    self:_trackTheme(toastFrame, "SurfaceRaised", "BackgroundColor3")
    addCorner(toastFrame, 12, self)
    addStroke(toastFrame, colors[kind], 0.35, self, colorRoles[kind])
    local marker = make("Frame", {
        BackgroundColor3 = colors[kind],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(0, 3, 1, -20),
        ZIndex = 202,
    }, toastFrame)
    self:_trackTheme(marker, colorRoles[kind], "BackgroundColor3")
    addCorner(marker, 3)
    self:_text(toastFrame, config.Title or kind, {
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0, 14, 0, 8),
        Size = UDim2.new(1, -54, 0, 22),
        TextSize = 14,
        ZIndex = 202,
    })
    self:_text(toastFrame, config.Content or "", {
        Position = UDim2.new(0, 14, 0, 31),
        Size = UDim2.new(1, -24, 0, 36),
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 202,
    })
    local toast = {Frame = toastFrame, _window = self, _dismissed = false, _connections = {}}
    function toast:Dismiss()
        if self._dismissed then
            return
        end
        self._dismissed = true
        for _, connection in ipairs(self._connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        for index, value in ipairs(self._window._toasts) do
            if value == self then
                table.remove(self._window._toasts, index)
                break
            end
        end
        if self.Frame and self.Frame.Parent then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(self.Frame, tweenInfo, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
            }):Play()
            for _, descendant in ipairs(self.Frame:GetDescendants()) do
                local properties
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    properties = {TextTransparency = 1}
                elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                    properties = {ImageTransparency = 1}
                elseif descendant:IsA("UIStroke") then
                    properties = {Transparency = 1}
                elseif descendant:IsA("GuiObject") then
                    properties = {BackgroundTransparency = 1}
                end
                if properties then
                    TweenService:Create(descendant, tweenInfo, properties):Play()
                end
            end
            task.delay(tweenInfo.Time, function()
                if self.Frame and self.Frame.Parent then
                    self.Frame:Destroy()
                end
            end)
        end
    end
    local close = self:_button(toastFrame, "×", function()
        toast:Dismiss()
    end, {
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(1, -48, 0, 2),
        Height = 44,
        Background = self.Theme.SurfaceRaised,
        Role = "SurfaceRaised",
        ZIndex = 203,
        Owner = toast,
    })
    close.Position = UDim2.new(1, -48, 0, 2)
    table.insert(self._toasts, toast)
    if duration > 0 then
        task.delay(duration, function()
            toast:Dismiss()
        end)
    end
    return toast
end

function WindowMethods:Notify(config)
    assert(not self._destroyed, "Cannot notify on a destroyed window")
    return self:_addToast(config)
end

function WindowMethods:SetHeaderVersion(version)
    assert(version == nil or type(version) == "string", "SetHeaderVersion expects a string or nil")
    self._headerVersionText = version or ""
    self._headerVersion.Text = version or ""
    self._headerVersion.Visible = not self._narrow and version ~= nil and version ~= ""
end

function WindowMethods:SetDiscordLink(url, copyCallback)
    assert(url == nil or type(url) == "string", "SetDiscordLink expects a URL string or nil")
    assert(copyCallback == nil or type(copyCallback) == "function", "SetDiscordLink copy callback must be a function")
    self._discordUrl = url
    self._discordCopy = copyCallback
end

function WindowMethods:Dialog(config)
    validConfig(config, "Dialog")
    assert(type(config.Actions) == "table" and #config.Actions > 0, "Dialog.Actions must contain at least one action")
    self:_closeOverlay()
    local overlay = self:_createOverlay()
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.ZIndex = 150
    local card = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -32, 0, 220),
        ZIndex = 151,
    }, overlay)
    self:_trackTheme(card, "Surface", "BackgroundColor3")
    card.Size = UDim2.new(1, -32, 0, math.min(300, 160 + #config.Actions * 48))
    addCorner(card, 14, self)
    addStroke(card, self.Theme.Border, 0.3, self)
    self:_text(card, config.Title or "Notice", {
        Position = UDim2.new(0, 20, 0, 16),
        Size = UDim2.new(1, -40, 0, 28),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 152,
    })
    self:_text(card, config.Content or "", {
        Position = UDim2.new(0, 20, 0, 52),
        Size = UDim2.new(1, -40, 0, 60),
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 152,
    })
    local actionList = make("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 1, -56),
        Size = UDim2.new(1, -40, 0, 44),
        ZIndex = 152,
    }, card)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, actionList)
    local dialog = {Close = function(_dialog) self:_closeOverlay() end}
    dialog.Destroy = dialog.Close
    for _, action in ipairs(config.Actions) do
        local actionConfig = action
        assert(actionConfig.Name ~= nil, "Dialog action Name is required")
        assert(actionConfig.Style == nil or actionConfig.Style == "Danger" or actionConfig.Style == "Secondary" or actionConfig.Style == "Primary", "Invalid Dialog action Style")
        local role = actionConfig.Style == "Danger" and "Danger"
            or (actionConfig.Style == "Secondary" and "SecondarySurface" or "AccentSecondary")
        local strokeRole = actionConfig.Style == "Secondary" and "Accent" or role
        local strokeColor = self.Theme[strokeRole]
        local actionButton = self:_button(actionList, actionConfig.Name, function()
            if actionConfig.Callback then
                self:_warnCallback("Dialog action " .. safeString(actionConfig.Name), actionConfig.Callback)
            end
            if actionConfig.Close ~= false then
                dialog:Close()
            end
        end, {
            Owner = self._overlayOwner,
            Size = UDim2.new(1 / #config.Actions, -((#config.Actions - 1) * 8 / #config.Actions), 0, 44),
            Height = 44,
            Background = self.Theme[role],
            Stroke = strokeColor,
            StrokeTransparency = actionConfig.Style == "Secondary" and 0.15 or 0.25,
            TextColor = self.Theme[role == "AccentSecondary" and "AccentForeground" or "TextPrimary"],
            Role = role,
            StrokeRole = strokeRole,
            ZIndex = 153,
        })
        actionButton.LayoutOrder = #actionList:GetChildren()
    end
    return dialog
end

function WindowMethods:_applyComponentCorners()
    local radius = UDim.new(0, self.Theme.CornerRadius)
    local square = UDim.new(0, 0)
    if self._headerCorner then
        self._headerCorner.TopLeftRadius = radius
        self._headerCorner.TopRightRadius = radius
        self._headerCorner.BottomLeftRadius = square
        self._headerCorner.BottomRightRadius = square
    end
    if self._sidebarCorner then
        self._sidebarCorner.TopLeftRadius = square
        self._sidebarCorner.TopRightRadius = square
        self._sidebarCorner.BottomLeftRadius = radius
        self._sidebarCorner.BottomRightRadius = square
    end
end

function WindowMethods:SetTheme(theme)
    validConfig(theme, "SetTheme")
    local merged = shallowCopy(self.Theme)
    local retainsPreset = true
    for key, value in pairs(theme) do
        assert(THEME_KEYS[key], "Unknown theme token: " .. tostring(key))
        if key == "CornerRadius" then
            assert(type(value) == "number" and value >= 0 and value <= 32, "Theme.CornerRadius must be between 0 and 32")
        elseif key == "Density" then
            assert(value == "Compact" or value == "Comfortable", "Theme.Density must be Compact or Comfortable")
        elseif key == "SurfaceTransparency" then
            assert(type(value) == "number" and value >= 0 and value <= 1,
                "Theme.SurfaceTransparency must be between 0 and 1")
        else
            assert(typeof(value) == "Color3", "Theme." .. key .. " must be a Color3")
        end
        merged[key] = value
        if not self._applyingThemePreset and table.find(THEME_ACCENT_ROLES, key) then
            self._themeAccentOverrides[key] = value
        end
        if key ~= "Accent" and key ~= "AccentSecondary" and key ~= "BorderActive" and key ~= "Success" then
            retainsPreset = false
        end
    end
    if not retainsPreset then
        self._themePreset = nil
        if self._lilithBackgroundImage then
            self._lilithBackgroundImage.Visible = false
            self:_setBackgroundLoading(self._lilithBackgroundImage, false)
        end
    end
    self.Theme = merged
    self:_applyComponentCorners()
    self:_applyLilithSurfaceMode()
    for _, target in ipairs(self._themeTargets) do
        local object = target.Object
        if object and object.Parent then
            local value = self.Theme[target.Role]
            if value ~= nil then
                if target.Property then
                    object[target.Property] = value
                elseif target.Role == "CornerRadius" then
                    object.CornerRadius = UDim.new(0, value)
                end
            end
        end
    end
    for index = #self._buttonThemeTargets, 1, -1 do
        local target = self._buttonThemeTargets[index]
        if target.Object and target.Object.Parent then
            target.Apply()
        else
            table.remove(self._buttonThemeTargets, index)
        end
    end
    for _, tab in ipairs(self._tabs) do
        tab._page.ScrollBarImageColor3 = self.Theme.AccentSecondary
    end
    self:_styleTabs(false)
    if self._auroraGradient then
        self._auroraGradient.Color = ColorSequence.new(self.Theme.Accent, self.Theme.AccentSecondary)
        self._auroraGradient.Parent.BackgroundColor3 = self.Theme.Accent
    end
    for _, component in ipairs(shallowCopy(self._components)) do
        if component._kind ~= "Button" and component.SetValue and component._value ~= nil then
            local ok, err = pcall(function()
                component:SetValue(component._value)
            end)
            if not ok then
                warn("[AstraUI] Failed to refresh " .. tostring(component.Name or component._kind) .. " after theme update: " .. tostring(err))
            end
        end
        if component._kind == "Input" and component._errorLabel and component._errorLabel.Visible then
            component._inputStroke.Color = self.Theme.Danger
        end
        if component._kind == "Badge" and component.SetType then
            component:SetType(component._badgeType)
        end
    end
    if self._settingsRefreshTheme then
        self._settingsRefreshTheme()
    end
    if not self._applyingThemePreset and not self._applyingSharedSettings then
        self._settingsThemeName = "Custom"
        self._customThemes = self._customThemes or {}
        self._customThemes.Custom = shallowCopy(self.Theme)
        self:_applyThemeImage(self._customThemeImages and self._customThemeImages.Custom)
        if self._settingsRefreshTheme then
            self._settingsRefreshTheme()
        end
        self:_syncSharedSettings()
    end
end

function WindowMethods:SetThemePreset(name)
    assert(name == "Dark" or name == "Light" or name == "Lilith",
        "SetThemePreset expects Dark, Light, or Lilith")
    local preset = name == "Dark" and DEFAULT_THEME
        or (name == "Lilith" and LILITH_THEME or LIGHT_THEME)
    local palette = shallowCopy(preset)
    if name ~= "Lilith" then
        for _, token in ipairs(THEME_ACCENT_ROLES) do
            if self._themeAccentOverrides[token] then
                palette[token] = self._themeAccentOverrides[token]
            end
        end
    end
    self._applyingThemePreset = true
    local ok, err = pcall(self.SetTheme, self, palette)
    self._applyingThemePreset = false
    if not ok then
        error(err, 0)
    end
    self._themePreset = name
    self._settingsThemeName = name
    self:_applyThemeImage(nil)
    if name ~= "Lilith" then
        self:_setBackgroundLoading(self._lilithBackgroundImage, false)
    end
    if self._lilithBackgroundImage then
        self._lilithBackgroundImage.Visible = name == "Lilith" and self._lilithImageLoadState == "loaded"
        self:_applyLilithSurfaceMode()
        if name == "Lilith" and self._lilithImageLoadState ~= "loaded"
            and self._lilithImageLoadState ~= "loading" then
            self._lilithImageLoadState = "loading"
            loadRestoreImage(
                self,
                LILITH_BACKGROUND_URL,
                self._pngDecoder,
                self._pngDecoderUrl,
                self._lilithBackgroundImage,
                self._jpegDecoder,
                self._jpegDecoderUrl
            )
        end
    end
    if self._settingsRefreshTheme then
        self._settingsRefreshTheme()
    end
    if not self._applyingSharedSettings then
        self:_syncSharedSettings()
    end
end

function WindowMethods:SetLocale(locale)
    assert(type(locale) == "string", "SetLocale expects a locale string")
    self.Localization.Locales = self.Localization.Locales or {}
    if self.Localization.Locales[locale] == nil then
        self.Localization.Locales[locale] = {Name = locale, Translations = {}}
    end
    self.Localization.Locale = locale
    if self._discordButton then
        self._discordButton:SetAttribute("AstraLabel", self:_discordText("button"))
    end
    for _, item in ipairs(self._localized) do
        if item.Object and item.Object.Parent then
            item.Object[item.Property] = self:_resolveText(item.Value)
        end
    end
    for _, component in ipairs(self._components) do
        local config = component._config
        if config then
            local nameValue = config.Name or config.Title
            if nameValue ~= nil then
                component.Name = self:_resolveText(nameValue)
            end
            if config.Description ~= nil then
                component.Description = self:_resolveText(config.Description)
            end
        end
    end
    for _, tab in ipairs(self._tabs) do
        tab.Name = self:_resolveText(tab._nameValue)
        tab._nameLabel.Text = tab.Name
        local sidebarCollapsed = self._sidebarCollapsed
        if sidebarCollapsed == nil then
            sidebarCollapsed = self._compact
        end
        tab._button.Text = sidebarCollapsed and (tab._iconLabel and "" or string.sub(tab.Name, 1, 1)) or ""
        self:_updatePageCanvas(tab)
    end
    if self._selectedTab then
        self._selectedTabLabel.Text = self._selectedTab.Name
    end
    for _, tab in ipairs(self._tabs) do
        for _, cardLayout in ipairs(tab._cardLayouts) do
            cardLayout()
        end
    end
    if self._settingsRefreshLocale then
        self._settingsRefreshLocale()
    end
    if not self._applyingSharedSettings then
        self:_syncSharedSettings()
    end
end

function WindowMethods:SetVisible(visible)
    assert(type(visible) == "boolean", "SetVisible expects a boolean")
    if self._destroyed or visible == self._visibilityTarget then
        return
    end
    self._visibilityTarget = visible
    self._visibilityGeneration = self._visibilityGeneration + 1
    local generation = self._visibilityGeneration
    if not visible and self._overlay then
        self:_closeOverlay()
    end
    for _, tween in ipairs(self._visibilityTweens) do
        tween:Cancel()
    end
    table.clear(self._visibilityTweens)
    if visible and not self._panel.Visible then
        self._panelStroke.Transparency = 1
        self._panelMotionScale.Scale = 0.88
        self._panel.Visible = true
    end
    if self._restoreButton then
        self._restoreButton.Visible = true
    end
    local tweenInfo = TweenInfo.new(
        visible and 0.28 or 0.2,
        visible and Enum.EasingStyle.Quart or Enum.EasingStyle.Quad,
        visible and Enum.EasingDirection.Out or Enum.EasingDirection.In
    )
    table.insert(self._visibilityTweens, TweenService:Create(self._panelStroke, tweenInfo, {
        Transparency = visible and self._panelStrokeTargetTransparency or 1,
    }))
    table.insert(self._visibilityTweens, TweenService:Create(self._panelMotionScale, tweenInfo, {
        Scale = visible and 1 or 0.88,
    }))
    local remainingTweens = #self._visibilityTweens
    for _, tween in ipairs(self._visibilityTweens) do
        local completedConnection
        completedConnection = tween.Completed:Connect(function(playbackState)
            completedConnection:Disconnect()
            if self._visibilityGeneration ~= generation then
                return
            end
            remainingTweens = remainingTweens - 1
            if remainingTweens > 0 then
                return
            end
            if playbackState == Enum.PlaybackState.Completed and not visible and not self._destroyed then
                self._panel.Visible = false
            end
            table.clear(self._visibilityTweens)
        end)
        tween:Play()
    end
end

function WindowMethods:SetToggleKey(keyCode)
    assert(keyCode == nil or isKeyCode(keyCode), "SetToggleKey expects an Enum.KeyCode or nil")
    self._toggleKey = keyCode
    if self._settingsRefreshKeybind then
        self._settingsRefreshKeybind()
    end
    if not self._applyingSharedSettings then
        self:_syncSharedSettings()
    end
end

function WindowMethods:SetResizable(resizable)
    assert(type(resizable) == "boolean", "SetResizable expects a boolean")
    self.Resizable = resizable
    if self._resizeHandle then
        self._resizeHandle.Visible = resizable and not self._narrow
    end
    if self._settingsRefreshLocale then
        self._settingsRefreshLocale()
    end
    if not self._applyingSharedSettings then
        self:_syncSharedSettings()
    end
end

function WindowMethods:SetDraggable(draggable)
    assert(type(draggable) == "boolean", "SetDraggable expects a boolean")
    self._draggable = draggable
    if self._settingsRefreshLocale then
        self._settingsRefreshLocale()
    end
    if not self._applyingSharedSettings then
        self:_syncSharedSettings()
    end
end

function WindowMethods:OpenSettings()
    assert(not self._destroyed, "Cannot open settings on a destroyed window")
    if self._settingsPanel then
        self:_closeOverlay()
        return
    end
    self:_closeOverlay()
    local overlay = self:_createOverlay()
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 100
    local scale = self._contentScale.Scale

    local panel = make("Frame", {
        AnchorPoint = self._narrow and Vector2.new(0.5, 0.5) or Vector2.new(1, 0),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Position = self._narrow and UDim2.fromScale(0.5, 0.5) or UDim2.new(1, -12, 0, 58),
        Size = UDim2.fromOffset(
            math.max(1, math.min(420, self._panel.AbsoluteSize.X / scale - 24)),
            math.max(1, math.min(540, self._panel.AbsoluteSize.Y / scale - 70))
        ),
        ZIndex = 120,
    }, overlay)
    self._settingsPanel = panel
    self:_trackTheme(panel, "Surface", "BackgroundColor3")
    addCorner(panel, 10, self)
    addStroke(panel, self.Theme.WindowBorder, 0.15, self, "WindowBorder")

    local header = make("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 46),
        ZIndex = 121,
    }, panel)
    local title = self:_text(header, "Settings", {
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(1, -64, 1, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        ZIndex = 122,
    })
    local closeButton = self:_button(header, "", function()
        self:_closeOverlay()
    end, {
        Position = UDim2.new(1, -40, 0, 6),
        Size = UDim2.fromOffset(32, 32),
        Height = 32,
        Role = "SurfaceRaised",
        ZIndex = 122,
        Owner = self._overlayOwner,
    })
    closeButton.Position = UDim2.new(1, -40, 0, 6)
    self:_icon(closeButton, "x", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(15, 15),
        TextColor3 = self.Theme.TextSecondary,
        ZIndex = 123,
    }, "x")
    local headerDivider = make("Frame", {
        BackgroundColor3 = self.Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 14, 1, -1),
        Size = UDim2.new(1, -28, 0, 1),
        ZIndex = 122,
    }, header)
    self:_trackTheme(headerDivider, "Border", "BackgroundColor3")

    local content = make("ScrollingFrame", {
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 10, 0, 46),
        ScrollBarImageColor3 = self.Theme.AccentSecondary,
        ScrollBarThickness = 3,
        Size = UDim2.new(1, -20, 1, -56),
        ZIndex = 121,
    }, panel)
    self:_trackTheme(content, "AccentSecondary", "ScrollBarImageColor3")
    local contentPadding = make("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 2),
    }, content)
    local contentLayout = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    self:_connect(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if content.Parent then
            content.CanvasSize = UDim2.new(
                0,
                0,
                0,
                contentLayout.AbsoluteContentSize.Y / self._contentScale.Scale
                    + contentPadding.PaddingTop.Offset
                    + contentPadding.PaddingBottom.Offset
            )
        end
    end, self._overlayOwner)

    local order = 0
    local function addLabel(english, thai)
        order = order + 1
        local label = self:_text(content, english, {
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, 18),
            Font = Enum.Font.GothamMedium,
            TextColor3 = self.Theme.TextMuted,
            TextSize = 11,
            ZIndex = 122,
        })
        label:SetAttribute("EnglishText", english)
        label:SetAttribute("ThaiText", thai)
        return label
    end
    local function addRow(height)
        order = order + 1
        local row = make("Frame", {
            BackgroundTransparency = 1,
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, height),
            ZIndex = 122,
        }, content)
        return row
    end
    local function addChoice(row, text, callback, widthScale, layoutOrder, actions)
        local slot = make("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(widthScale, -4, 1, 0),
            ZIndex = 122,
        }, row)
        slot.LayoutOrder = layoutOrder
        local outline = make("Frame", {
            Active = false,
            BackgroundColor3 = self.Theme.AccentSecondary,
            BorderSizePixel = 0,
            Selectable = false,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            ZIndex = 122,
        }, slot)
        addCorner(outline, 7, self)
        local button, stroke = self:_button(slot, text, callback, {
            PaddingLeft = actions and 8 or nil,
            Size = UDim2.new(1, actions and -62 or -4, 1, -4),
            Height = 34,
            Role = "SurfaceRaised",
            Stroke = self.Theme.Border,
            StrokeRole = "Border",
            StrokeTransparency = 0.4,
            TextTruncate = actions and Enum.TextTruncate.AtEnd or nil,
            TextWrapped = not actions,
            TextXAlignment = actions and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
            TextSize = 11,
            ZIndex = 123,
            Owner = self._overlayOwner,
        })
        button.Position = UDim2.fromOffset(2, 2)
        button:SetAttribute("AstraChoiceOption", true)
        button:SetAttribute("AstraChoiceSelected", false)
        stroke.Transparency = 1
        if actions then
            local editButton = self:_button(slot, "", actions.Edit, {
                Height = 24,
                Owner = self._overlayOwner,
                Radius = 6,
                Role = "Surface",
                Size = UDim2.fromOffset(24, 24),
                StrokeTransparency = 0.8,
                TextColor = self.Theme.TextSecondary,
                TextSize = 10,
                ZIndex = 123,
            })
            editButton.Position = UDim2.new(1, -56, 0.5, -12)
            editButton:SetAttribute("AstraLabel", self:_resolveText("Edit " .. actions.Kind) .. ": " .. text)
            self:_icon(editButton, "pencil", {
                Active = false,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Selectable = false,
                Size = UDim2.fromOffset(14, 14),
                TextColor3 = self.Theme.TextSecondary,
                TextSize = 14,
                ZIndex = 124,
            }, "✎")
            local deleteButton = self:_button(slot, "", actions.Delete, {
                Height = 24,
                Owner = self._overlayOwner,
                Radius = 6,
                Role = "Surface",
                Size = UDim2.fromOffset(24, 24),
                StrokeTransparency = 0.8,
                TextColor = self.Theme.Danger,
                TextSize = 10,
                ZIndex = 123,
            })
            deleteButton.Position = UDim2.new(1, -28, 0.5, -12)
            deleteButton:SetAttribute("AstraLabel", self:_resolveText("Delete " .. actions.Kind) .. ": " .. text)
            self:_icon(deleteButton, "trash-2", {
                Active = false,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Selectable = false,
                Size = UDim2.fromOffset(14, 14),
                TextColor3 = self.Theme.Danger,
                TextSize = 14,
                ZIndex = 124,
            }, "×")
        end
        return button, stroke, outline, slot
    end
    local function setChoiceSelected(button, stroke, outline, selected)
        button:SetAttribute("AstraChoiceSelected", selected)
        outline.BackgroundColor3 = self.Theme.AccentSecondary
        outline.Visible = selected
        stroke.Transparency = 1
        button.TextColor3 = self.Theme.TextPrimary
    end
    local function layoutRow(row, padding)
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, padding or 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, row)
    end
    local function stateWord(enabled)
        return self:_resolveText(enabled and "On" or "Off")
    end

    local function disconnectOwner(owner)
        for _, connection in ipairs(owner._connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        table.clear(owner._connections)
    end
    local function createModal(modalTitle, requestedWidth, requestedHeight)
        if self._settingsModalClose then
            self._settingsModalClose()
        end
        local shade = make("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            ZIndex = 140,
        }, overlay)
        local modal = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.SurfaceRaised,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(
                math.max(1, math.min(requestedWidth, self._panel.AbsoluteSize.X / scale - 24)),
                math.max(1, math.min(requestedHeight, self._panel.AbsoluteSize.Y / scale - 24))
            ),
            ZIndex = 150,
        }, overlay)
        self:_trackTheme(modal, "SurfaceRaised", "BackgroundColor3")
        addCorner(modal, 12, self)
        addStroke(modal, self.Theme.Border, 0.2, self, "Border")
        local modalScale = make("UIScale", {
            Scale = 0.9,
        }, modal)
        local owner = {_connections = {}}
        local closed = false
        local closing = false
        local closeModal
        local function destroyModal()
            if closed then
                return
            end
            closed = true
            if shade.Parent then
                shade:Destroy()
            end
            if modal.Parent then
                modal:Destroy()
            end
            if self._settingsModal == modal then
                self._settingsModal = nil
            end
            if self._settingsModalClose == closeModal then
                self._settingsModalClose = nil
            end
        end
        closeModal = function()
            if closed or closing then
                return
            end
            closing = true
            if self._settingsModalCleanup then
                local cleanup = self._settingsModalCleanup
                self._settingsModalCleanup = nil
                cleanup()
            end
            disconnectOwner(owner)
            local shrinkTween = TweenService:Create(
                modalScale,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Scale = 0.9}
            )
            local fadeTween = TweenService:Create(
                shade,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            )
            local completedConnection
            completedConnection = shrinkTween.Completed:Connect(function()
                completedConnection:Disconnect()
                destroyModal()
            end)
            shrinkTween:Play()
            fadeTween:Play()
        end
        self._settingsModal = modal
        self._settingsModalClose = closeModal
        self:_connect(shade.Activated, closeModal, owner)
        local modalHeader = make("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 44),
            ZIndex = 151,
        }, modal)
        self:_text(modalHeader, modalTitle, {
            Position = UDim2.new(0, 16, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            ZIndex = 152,
        })
        local closeButton = self:_button(modalHeader, "×", closeModal, {
            Height = 30,
            Owner = owner,
            Position = UDim2.new(1, -38, 0, 7),
            Radius = 7,
            Role = "Surface",
            Size = UDim2.fromOffset(30, 30),
            TextSize = 16,
            ZIndex = 152,
        })
        closeButton.Position = UDim2.new(1, -38, 0, 7)
        TweenService:Create(
            modalScale,
            TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}
        ):Play()
        TweenService:Create(
            shade,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.42}
        ):Play()
        return modal, owner, closeModal
    end
    local settingsNotice
    local copySettingsText
    local function showThemeEditor(themeName)
        local modalTitle = themeName and "Edit theme" or "Create theme"
        local modal, owner, closeModal = createModal(modalTitle, 480, 520)
        local modalWidth = modal.Size.X.Offset
        local draftPalette = shallowCopy(themeName and self._customThemes[themeName] or self.Theme)
        local nameInput = make("TextBox", {
            BackgroundColor3 = self.Theme.ControlSurface,
            ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(112, 52),
            Size = UDim2.new(1, -128, 0, 32),
            Text = themeName or "",
            TextColor3 = self.Theme.TextPrimary,
            TextSize = 12,
            PlaceholderText = self:_resolveText("Theme name"),
            ZIndex = 152,
        }, modal)
        addCorner(nameInput, 6, self)
        addStroke(nameInput, self.Theme.Border, 0.3, self, "Border")
        self:_text(modal, "Name", {
            Position = UDim2.fromOffset(16, 52),
            Size = UDim2.fromOffset(88, 32),
            TextSize = 11,
            ZIndex = 152,
        })
        self:_text(modal, "Copy preset", {
            Position = UDim2.fromOffset(16, 91),
            Size = UDim2.new(1, -32, 0, 18),
            TextColor3 = self.Theme.TextMuted,
            TextSize = 10,
            ZIndex = 152,
        })
        local presetRow = make("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 110),
            Size = UDim2.new(1, -24, 0, 30),
            ZIndex = 152,
        }, modal)
        layoutRow(presetRow, 5)
        self:_text(modal, "Background image URL", {
            Position = UDim2.fromOffset(16, 148),
            Size = UDim2.new(1, -32, 0, 18),
            TextColor3 = self.Theme.TextMuted,
            TextSize = 10,
            ZIndex = 152,
        })
        local imageInput = make("TextBox", {
            BackgroundColor3 = self.Theme.ControlSurface,
            ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,
            PlaceholderText = self:_resolveText("Image URL or asset ID (optional)"),
            Position = UDim2.fromOffset(14, 167),
            Size = UDim2.new(1, -28, 0, 30),
            Text = themeName and (self._customThemeImages[themeName] or "") or "",
            TextColor3 = self.Theme.TextPrimary,
            TextSize = 11,
            ZIndex = 152,
        }, modal)
        addCorner(imageInput, 6, self)
        addStroke(imageInput, self.Theme.Border, 0.3, self, "Border")
        self:_text(modal, "Surface transparency", {
            Position = UDim2.fromOffset(16, 202),
            Size = UDim2.new(0, 122, 0, 26),
            TextColor3 = self.Theme.TextMuted,
            TextSize = 10,
            ZIndex = 152,
        })
        local transparencyTrack = make("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = self.Theme.ControlTrack,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 142, 0, 212),
            Size = UDim2.new(1, -230, 0, 8),
            Text = "",
            ZIndex = 153,
        }, modal)
        self:_trackTheme(transparencyTrack, "ControlTrack", "BackgroundColor3")
        addCorner(transparencyTrack, 4, self)
        local transparencyFill = make("Frame", {
            BackgroundColor3 = self.Theme.AccentSecondary,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            ZIndex = 154,
        }, transparencyTrack)
        self:_trackTheme(transparencyFill, "AccentSecondary", "BackgroundColor3")
        addCorner(transparencyFill, 4, self)
        local transparencyKnob = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.TextPrimary,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            ZIndex = 155,
        }, transparencyTrack)
        self:_trackTheme(transparencyKnob, "TextPrimary", "BackgroundColor3")
        addCorner(transparencyKnob, 7, self)
        local transparencyValue = self:_text(modal, "0%", {
            Position = UDim2.new(1, -72, 0, 202),
            Size = UDim2.fromOffset(52, 26),
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 152,
        })
        local function setSurfaceTransparency(value)
            local fraction = math.floor(clamp(value, 0, 1) * 100 + 0.5) / 100
            local knobOffset = 7 - fraction * 14
            draftPalette.SurfaceTransparency = fraction
            transparencyFill.Size = UDim2.new(fraction, knobOffset, 1, 0)
            transparencyKnob.Position = UDim2.new(fraction, knobOffset, 0.5, 0)
            transparencyValue.Text = string.format("%d%%", math.floor(fraction * 100 + 0.5))
        end
        local function updateSurfaceTransparencyFromX(x)
            local trackWidth = transparencyTrack.AbsoluteSize.X
            if trackWidth > 0 then
                setSurfaceTransparency((x - transparencyTrack.AbsolutePosition.X) / trackWidth)
            end
        end
        setSurfaceTransparency(draftPalette.SurfaceTransparency or 0)
        local transparencyDragging = false
        self:_connect(transparencyTrack.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                transparencyDragging = true
                updateSurfaceTransparencyFromX(input.Position.X)
            end
        end, owner)
        self:_connect(UserInputService.InputChanged, function(input)
            if transparencyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                updateSurfaceTransparencyFromX(input.Position.X)
            end
        end, owner)
        self:_connect(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                transparencyDragging = false
            end
        end, owner)
        self:_text(modal, "Color map", {
            Position = UDim2.fromOffset(16, 238),
            Size = UDim2.new(1, -32, 0, 18),
            TextColor3 = self.Theme.TextMuted,
            TextSize = 10,
            ZIndex = 152,
        })
        local paletteList = make("ScrollingFrame", {
            Active = true,
            BackgroundColor3 = self.Theme.ControlInset,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, #THEME_COLOR_ROLE_ORDER * 32),
            Position = UDim2.fromOffset(14, 258),
            ScrollBarImageColor3 = self.Theme.AccentSecondary,
            ScrollBarThickness = 3,
            Size = UDim2.new(1, -28, 1, -318),
            ZIndex = 152,
        }, modal)
        self:_trackTheme(paletteList, "ControlInset", "BackgroundColor3")
        self:_trackTheme(paletteList, "AccentSecondary", "ScrollBarImageColor3")
        addCorner(paletteList, 7, self)
        addStroke(paletteList, self.Theme.Border, 0.3, self, "Border")
        local palettePadding = make("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 5),
        }, paletteList)
        local paletteLayout = make("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, paletteList)
        local paletteRows = {}
        local palettePopup
        local paletteOwner
        local function closeColorMap()
            if paletteOwner then
                disconnectOwner(paletteOwner)
                paletteOwner = nil
            end
            if palettePopup and palettePopup.Parent then
                palettePopup:Destroy()
            end
            palettePopup = nil
        end
        self._settingsModalCleanup = closeColorMap
        local function updatePaletteRow(role)
            local row = paletteRows[role]
            row.Swatch.BackgroundColor3 = draftPalette[role]
            row.Hex.Text = colorToHex(draftPalette[role])
        end
        local function setDraftColor(role, color)
            draftPalette[role] = color
            updatePaletteRow(role)
        end
        local function openColorMap(role)
            closeColorMap()
            paletteOwner = {_connections = {}}
            palettePopup = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = self.Theme.SurfaceRaised,
                BorderSizePixel = 0,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(math.min(292, modalWidth - 24), 236),
                ZIndex = 170,
            }, modal)
            self:_trackTheme(palettePopup, "SurfaceRaised", "BackgroundColor3")
            addCorner(palettePopup, 10, self)
            addStroke(palettePopup, self.Theme.BorderActive, 0, self, "BorderActive")
            self:_text(palettePopup, role, {
                Position = UDim2.fromOffset(12, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                ZIndex = 171,
            })
            local colors = {
                Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 228, 239), Color3.fromRGB(156, 171, 193),
                Color3.fromRGB(103, 120, 146), Color3.fromRGB(24, 34, 48), Color3.fromRGB(11, 14, 23),
                Color3.fromRGB(255, 89, 94), Color3.fromRGB(245, 104, 121), Color3.fromRGB(217, 119, 6),
                Color3.fromRGB(255, 202, 58), Color3.fromRGB(138, 201, 38), Color3.fromRGB(16, 185, 129),
                Color3.fromRGB(25, 130, 196), Color3.fromRGB(59, 66, 159), Color3.fromRGB(99, 102, 241),
                Color3.fromRGB(129, 130, 255), Color3.fromRGB(155, 93, 229), Color3.fromRGB(205, 48, 76),
                Color3.fromRGB(91, 139, 197), Color3.fromRGB(30, 34, 70), Color3.fromRGB(17, 22, 37),
                Color3.fromRGB(242, 246, 250), Color3.fromRGB(225, 233, 246), Color3.fromRGB(21, 22, 43),
            }
            for index, color in ipairs(colors) do
                local column = (index - 1) % 6
                local line = math.floor((index - 1) / 6)
                local swatch = make("TextButton", {
                    AutoButtonColor = false,
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(14 + column * 36, 36 + line * 34),
                    Size = UDim2.fromOffset(28, 26),
                    Text = "",
                    ZIndex = 171,
                }, palettePopup)
                addCorner(swatch, 5)
                addStroke(swatch, self.Theme.Border, 0.4, self)
                self:_connect(swatch.Activated, function()
                    setDraftColor(role, color)
                    closeColorMap()
                end, paletteOwner)
            end
            local exactHex = make("TextBox", {
                BackgroundColor3 = self.Theme.ControlSurface,
                ClearTextOnFocus = false,
                Font = Enum.Font.Code,
                Position = UDim2.fromOffset(14, 178),
                Size = UDim2.new(1, -90, 0, 32),
                Text = colorToHex(draftPalette[role]),
                TextColor3 = self.Theme.TextPrimary,
                TextSize = 12,
                ZIndex = 171,
            }, palettePopup)
            addCorner(exactHex, 6, self)
            local applyColor = self:_button(palettePopup, "Apply", function()
                local ok, color = pcall(colorFromHex, exactHex.Text, role)
                if ok then
                    setDraftColor(role, color)
                    closeColorMap()
                else
                    warn("[AstraUI] Invalid theme color: " .. tostring(color))
                end
            end, {
                Height = 32,
                Owner = paletteOwner,
                Position = UDim2.new(1, -68, 0, 178),
                Radius = 6,
                Role = "AccentSecondary",
                Size = UDim2.fromOffset(54, 32),
                TextSize = 10,
                ZIndex = 171,
            })
            applyColor.Position = UDim2.new(1, -68, 0, 178)
        end
        for index, role in ipairs(THEME_COLOR_ROLE_ORDER) do
            local row = make("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = index,
                Size = UDim2.new(1, 0, 0, 30),
                ZIndex = 153,
            }, paletteList)
            self:_text(row, role, {
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(0.4, -4, 1, 0),
                TextSize = 10,
                ZIndex = 154,
            })
            local swatch = make("TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = draftPalette[role],
                BorderSizePixel = 0,
                Position = UDim2.new(0.4, 0, 0.5, -11),
                Size = UDim2.fromOffset(26, 22),
                Text = "",
                ZIndex = 154,
            }, row)
            addCorner(swatch, 5)
            addStroke(swatch, self.Theme.Border, 0.35, self)
            local hexInput = make("TextBox", {
                BackgroundColor3 = self.Theme.ControlSurface,
                ClearTextOnFocus = false,
                Font = Enum.Font.Code,
                Position = UDim2.new(0.4, 34, 0.5, -12),
                Size = UDim2.new(0.6, -40, 0, 24),
                Text = colorToHex(draftPalette[role]),
                TextColor3 = self.Theme.TextPrimary,
                TextSize = 10,
                ZIndex = 154,
            }, row)
            addCorner(hexInput, 5, self)
            self:_connect(swatch.Activated, function()
                openColorMap(role)
            end, owner)
            self:_connect(hexInput.FocusLost, function()
                local ok, color = pcall(colorFromHex, hexInput.Text, role)
                if ok then
                    setDraftColor(role, color)
                else
                    warn("[AstraUI] Invalid theme color: " .. tostring(color))
                    updatePaletteRow(role)
                end
            end, owner)
            paletteRows[role] = {
                Swatch = swatch,
                Hex = hexInput,
            }
        end
        self:_connect(paletteLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            paletteList.CanvasSize = UDim2.new(0, 0, 0, paletteLayout.AbsoluteContentSize.Y
                + palettePadding.PaddingTop.Offset)
        end, owner)
        local copiedPresetImage
        for _, preset in ipairs({"Dark", "Light", "Lilith"}) do
            local presetName = preset
            local presetButton = self:_button(presetRow, preset, function()
                local source = presetName == "Dark" and DEFAULT_THEME
                    or (presetName == "Light" and LIGHT_THEME or LILITH_THEME)
                draftPalette = shallowCopy(source)
                for _, role in ipairs(THEME_COLOR_ROLE_ORDER) do
                    updatePaletteRow(role)
                end
                setSurfaceTransparency(draftPalette.SurfaceTransparency or 0)
                if imageInput.Text == "" or imageInput.Text == copiedPresetImage then
                    imageInput.Text = presetName == "Lilith" and LILITH_BACKGROUND_URL or ""
                end
                copiedPresetImage = presetName == "Lilith" and LILITH_BACKGROUND_URL or nil
            end, {
                Height = 30,
                Owner = owner,
                Radius = 6,
                Role = "Surface",
                Size = UDim2.new(1 / 3, -4, 1, 0),
                TextSize = 10,
                ZIndex = 153,
            })
            presetButton.LayoutOrder = #presetRow:GetChildren()
        end
        local footer = make("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 1, -46),
            Size = UDim2.new(1, -24, 0, 34),
            ZIndex = 153,
        }, modal)
        layoutRow(footer, 8)
        local saveTheme = self:_button(footer, themeName and "Save changes" or "Save theme", function()
            local name = string.gsub(nameInput.Text, "^%s*(.-)%s*$", "%1")
            local ok, err = pcall(function()
                assert(name ~= "", "Enter a theme name")
                assert(name ~= "Custom" and name ~= "Dark" and name ~= "Light" and name ~= "Lilith",
                    "This name is reserved")
                assert(not self._customThemes[name] or name == themeName,
                    "A theme with this name already exists")
                local profile = self:_getSettingsProfile()
                local previousName = themeName
                local wasSelected = previousName and profile.Theme == previousName
                profile.ThemeImages = profile.ThemeImages or {}
                if previousName and previousName ~= name then
                    profile.CustomThemes[previousName] = nil
                    profile.ThemeImages[previousName] = nil
                end
                profile.CustomThemes[name] = encodeTheme(draftPalette)
                if not previousName or wasSelected then
                    profile.Theme = name
                end
                local image = string.gsub(imageInput.Text, "^%s*(.-)%s*$", "%1")
                if image == "" then
                    profile.ThemeImages[name] = nil
                else
                    local normalizedOk, normalizedImage = pcall(normalizeThemeImage, image, "Theme image")
                    assert(normalizedOk, tostring(normalizedImage))
                    profile.ThemeImages[name] = normalizedImage
                end
                self:_setSharedSettingsProfile(profile, true)
            end)
            if not ok then
                warn("[AstraUI] Could not save theme: " .. tostring(err))
                settingsNotice("Error", "Could not save theme", tostring(err))
                return
            end
            settingsNotice("Success", "Theme saved", name)
            closeModal()
        end, {
            Height = 34,
            Owner = owner,
            Role = "AccentSecondary",
            Size = UDim2.new(0.44, -5, 1, 0),
            TextSize = 11,
            ZIndex = 154,
        })
        local exportTheme = self:_button(footer, "Export preset", function()
            local name = string.gsub(nameInput.Text, "^%s*(.-)%s*$", "%1")
            local ok, err = pcall(function()
                assert(name ~= "", "Enter a theme name")
                local preset = {
                    Name = name,
                    Theme = encodeTheme(draftPalette),
                }
                local image = string.gsub(imageInput.Text, "^%s*(.-)%s*$", "%1")
                if image ~= "" then
                    preset.Image = normalizeThemeImage(image, "Theme image")
                end
                copySettingsText(prettyJson(HttpService:JSONEncode(preset)))
            end)
            if not ok then
                warn("[AstraUI] Could not export theme preset: " .. tostring(err))
                settingsNotice("Error", "Export failed", tostring(err))
                return
            end
            settingsNotice("Success", "Preset exported", "Preset JSON copied")
        end, {
            Height = 34,
            Owner = owner,
            Role = "Surface",
            Size = UDim2.new(0.32, -5, 1, 0),
            TextSize = 9,
            ZIndex = 154,
        })
        local cancelTheme = self:_button(footer, "Cancel", closeModal, {
            Height = 34,
            Owner = owner,
            Role = "Surface",
            Size = UDim2.new(0.23, -5, 1, 0),
            TextSize = 11,
            ZIndex = 154,
        })
        saveTheme.LayoutOrder = 1
        exportTheme.LayoutOrder = 2
        cancelTheme.LayoutOrder = 3
    end

    settingsNotice = function(kind, titleText, contentText)
        self:Notify({
            Type = kind,
            Title = self:_resolveText(titleText),
            Content = self:_resolveText(contentText),
            Duration = 3,
        })
    end
    local function confirmDelete(itemKind, itemName, callback)
        local titleText = itemKind == "theme" and "Delete theme?" or "Delete language?"
        local detailText = itemKind == "theme"
            and "This theme will be permanently deleted."
            or "This language will be permanently deleted."
        local modal, owner, closeModal = createModal(titleText, 360, 190)
        self:_text(modal, self:_resolveText(detailText) .. "\n" .. itemName .. "\n"
            .. self:_resolveText("This cannot be undone."), {
            Position = UDim2.fromOffset(16, 54),
            Size = UDim2.new(1, -32, 0, 68),
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 12,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 152,
        })
        local footer = make("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 1, -48),
            Size = UDim2.new(1, -28, 0, 34),
            ZIndex = 152,
        }, modal)
        layoutRow(footer, 8)
        local cancelButton = self:_button(footer, "Cancel", closeModal, {
            Height = 34,
            Owner = owner,
            Role = "Surface",
            Size = UDim2.new(0.5, -4, 1, 0),
            TextSize = 11,
            ZIndex = 153,
        })
        local deleteButton = self:_button(footer, "Delete", function()
            local ok, err = pcall(callback)
            if not ok then
                warn("[AstraUI] Could not delete " .. itemKind .. ": " .. tostring(err))
                settingsNotice("Error", "Delete failed", tostring(err))
                return
            end
            closeModal()
        end, {
            Height = 34,
            Owner = owner,
            Role = "Danger",
            Size = UDim2.new(0.5, -4, 1, 0),
            TextSize = 11,
            ZIndex = 153,
        })
        cancelButton.LayoutOrder = 1
        deleteButton.LayoutOrder = 2
    end
    copySettingsText = function(text)
        local copy = self._settingsAdapter and self._settingsAdapter.Copy
        if copy then
            local result, reason = copy(text)
            assert(result ~= false, tostring(reason or "Clipboard copy failed"))
        elseif type(setclipboard) == "function" then
            setclipboard(text)
        else
            error("Configure Settings.Copy to enable clipboard copy")
        end
    end
    local function makeLocaleTemplate()
        local translations = {}
        for _, item in ipairs(self._localized) do
            local value = item.Value
            local key
            local fallback
            if type(value) == "table" and value.Key then
                key = safeString(value.Key)
                fallback = safeString(value.Default or value.Key)
            elseif type(value) == "string" then
                key = value
                fallback = value
            end
            if key and key ~= "" then
                translations[key] = fallback
            end
        end
        for _, key in ipairs({
            "Settings", "Color theme", "Language", "UI toggle key", "Window behavior",
            "Add theme", "Add language", "Resize", "Drag", "On", "Off",
            "Create theme", "Edit theme", "Delete theme", "Theme name", "Name", "Copy preset",
            "Background image URL", "Image URL (optional)", "Image URL or asset ID (optional)",
            "Surface transparency", "Color map", "Save theme", "Export preset",
            "Preset exported", "Preset JSON copied", "Export failed",
            "Save changes", "Delete", "Save", "Apply",
            "Theme saved", "Could not save theme", "Enter a theme name", "This name is reserved",
            "A theme with this name already exists", "Theme image failed",
            "Edit language", "Delete language", "Save language", "Delete theme?", "Delete language?",
            "This theme will be permanently deleted.", "This language will be permanently deleted.",
            "This cannot be undone.", "Delete failed",
            "Copy JSON template", "Cancel", "Copied", "JSON configuration copied",
            "Copy failed", "Invalid JSON", "Language name",
        }) do
            translations[key] = translations[key] or key
        end
        return {
            Locale = "xx-XX",
            Name = "Language name",
            Translations = translations,
        }
    end
    local function showLocaleEditor(localeCode)
        assert(localeCode ~= "en-US" and localeCode ~= "th-TH",
            "Default languages cannot be edited")
        local localeDefinition = localeCode and self.Localization.Locales[localeCode]
        assert(not localeCode or localeDefinition, "Locale does not exist")
        local localeConfig = localeDefinition and {
            Locale = localeCode,
            Name = localeDefinition.Name or localeCode,
            Translations = deepCopy(localeDefinition.Translations or {}),
        } or makeLocaleTemplate()
        local modalTitle = localeCode and "Edit language" or "Add language"
        local modal, owner, closeModal = createModal(modalTitle, 460, 440)
        local localeEditorScroll = make("ScrollingFrame", {
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            BackgroundColor3 = self.Theme.ControlInset,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ClipsDescendants = true,
            Position = UDim2.fromOffset(14, 52),
            ScrollBarImageColor3 = self.Theme.AccentSecondary,
            ScrollBarThickness = 4,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Size = UDim2.new(1, -28, 1, -108),
            ZIndex = 152,
        }, modal)
        self:_trackTheme(localeEditorScroll, "ControlInset", "BackgroundColor3")
        self:_trackTheme(localeEditorScroll, "AccentSecondary", "ScrollBarImageColor3")
        addCorner(localeEditorScroll, 7, self)
        addStroke(localeEditorScroll, self.Theme.Border, 0.3, self, "Border")
        local localeEditor = make("TextBox", {
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            Font = Enum.Font.Code,
            MultiLine = true,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -8, 0, 100),
            Text = prettyJson(HttpService:JSONEncode(localeConfig)),
            TextColor3 = self.Theme.TextPrimary,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 153,
        }, localeEditorScroll)
        make("UIPadding", {
            PaddingBottom = UDim.new(0, 7),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 7),
        }, localeEditor)
        local function updateLocaleEditorSize()
            local width = math.max(1, localeEditorScroll.AbsoluteSize.X - 28)
            local textSize = TextService:GetTextSize(
                localeEditor.Text,
                localeEditor.TextSize,
                localeEditor.Font,
                Vector2.new(width, 100000)
            )
            local height = math.max(localeEditorScroll.AbsoluteSize.Y, textSize.Y + 16)
            localeEditor.Size = UDim2.new(1, -8, 0, height)
            localeEditorScroll.CanvasSize = UDim2.new(0, 0, 0, height)
        end
        self:_connect(localeEditor:GetPropertyChangedSignal("Text"), updateLocaleEditorSize, owner)
        self:_connect(localeEditorScroll:GetPropertyChangedSignal("AbsoluteSize"), updateLocaleEditorSize, owner)
        task.defer(updateLocaleEditorSize)
        local actions = make("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 1, -46),
            Size = UDim2.new(1, -28, 0, 34),
            ZIndex = 152,
        }, modal)
        layoutRow(actions, 6)
        local copyButton = self:_button(actions, "Copy JSON template", function()
            local ok, err = pcall(copySettingsText, localeEditor.Text)
            if ok then
                settingsNotice("Success", "Copied", "JSON configuration copied")
            else
                warn("[AstraUI] Failed to copy locale JSON: " .. tostring(err))
                settingsNotice("Error", "Copy failed", tostring(err))
            end
        end, {
            Height = 34,
            Owner = owner,
            Role = "Surface",
            Size = UDim2.new(0.42, -4, 1, 0),
            TextSize = 9,
            ZIndex = 153,
        })
        local saveButton = self:_button(actions, localeCode and "Save language" or "Add language", function()
            local ok, err = pcall(function()
                local localeConfig = HttpService:JSONDecode(localeEditor.Text)
                assert(type(localeConfig) == "table", "Locale JSON must be an object")
                assert(type(localeConfig.Locale) == "string" and localeConfig.Locale ~= "",
                    "Locale must be a non-empty code")
                assert(type(localeConfig.Name) == "string" and localeConfig.Name ~= "",
                    "Name must be a non-empty display name")
                assert(type(localeConfig.Translations) == "table",
                    "Translations must be an object")
                assert(localeConfig.Locale ~= "en-US" and localeConfig.Locale ~= "th-TH",
                    "Default languages cannot be edited")
                validateLocales({
                    [localeConfig.Locale] = {
                        Name = localeConfig.Name,
                        Translations = localeConfig.Translations,
                    },
                })
                local profile = self:_getSettingsProfile()
                profile.RemovedLocales = profile.RemovedLocales or {}
                local wasSelected = localeCode and profile.Locale == localeCode
                if not localeCode then
                    assert(profile.Locales[localeConfig.Locale] == nil, "Locale already exists")
                end
                if localeCode and localeCode ~= localeConfig.Locale then
                    assert(profile.Locales[localeConfig.Locale] == nil,
                        "Locale already exists")
                    profile.Locales[localeCode] = nil
                    profile.RemovedLocales[localeCode] = true
                end
                profile.RemovedLocales[localeConfig.Locale] = nil
                profile.Locales[localeConfig.Locale] = {
                    Name = localeConfig.Name,
                    Translations = deepCopy(localeConfig.Translations),
                }
                if not localeCode or wasSelected then
                    profile.Locale = localeConfig.Locale
                end
                self:_setSharedSettingsProfile(profile, true)
            end)
            if ok then
                closeModal()
            else
                warn("[AstraUI] Could not add locale: " .. tostring(err))
                settingsNotice("Error", "Invalid JSON", tostring(err))
            end
        end, {
            Height = 34,
            Owner = owner,
            Role = "AccentSecondary",
            Size = UDim2.new(0.33, -4, 1, 0),
            TextSize = 9,
            ZIndex = 153,
        })
        copyButton.LayoutOrder = 1
        copyButton.Size = UDim2.new(0.5, -3, 1, 0)
        saveButton.LayoutOrder = 2
        saveButton.Size = UDim2.new(0.5, -3, 1, 0)
    end

    local themeLabel = addLabel("Color theme", "ธีมสี")
    local themesHost = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = order + 1,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 122,
    }, content)
    order = order + 1
    local choiceGridCache = {}
    local function renderChoiceGrid(host, choices, selected, callback)
        local signatureParts = {}
        for _, choice in ipairs(choices) do
            table.insert(signatureParts, choice.Value .. "\t" .. choice.Label
                .. "\t" .. (choice.Actions and choice.Actions.Kind or ""))
        end
        local signature = table.concat(signatureParts, "\n")
        local cached = choiceGridCache[host]
        if cached and cached.Signature == signature then
            for _, item in ipairs(cached.Items) do
                setChoiceSelected(item.Button, item.Stroke, item.Outline, item.Value == selected)
            end
            return
        end
        for _, child in ipairs(host:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        local gridLayout = host:FindFirstChildOfClass("UIListLayout")
        if not gridLayout then
            gridLayout = make("UIListLayout", {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, host)
        end
        local items = {}
        local columns = 2
        for index = 1, #choices, columns do
            local row = make("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = math.ceil(index / columns),
                Size = UDim2.new(1, 0, 0, 34),
                ZIndex = 122,
            }, host)
            layoutRow(row, 6)
            for offset = 0, columns - 1 do
                local choice = choices[index + offset]
                if choice then
                    local choiceValue = choice.Value
                    local button, stroke, outline = addChoice(row, choice.Label, function()
                        callback(choiceValue)
                    end, 0.5, offset + 1, choice.Actions)
                    setChoiceSelected(button, stroke, outline, choiceValue == selected)
                    table.insert(items, {
                        Value = choiceValue,
                        Button = button,
                        Stroke = stroke,
                        Outline = outline,
                    })
                end
            end
        end
        choiceGridCache[host] = {
            Signature = signature,
            Items = items,
        }
    end
    local function getSortedNames(map)
        local names = {}
        for name in pairs(map or {}) do
            table.insert(names, name)
        end
        table.sort(names)
        return names
    end
    local function deleteTheme(themeName)
        assert(themeName ~= "Dark" and themeName ~= "Light" and themeName ~= "Lilith"
            and themeName ~= "Custom", "Default themes cannot be deleted")
        local profile = self:_getSettingsProfile()
        assert(profile.CustomThemes[themeName], "Theme does not exist")
        profile.CustomThemes[themeName] = nil
        profile.ThemeImages = profile.ThemeImages or {}
        profile.ThemeImages[themeName] = nil
        if profile.Theme == themeName then
            profile.Theme = self._themePreset or "Lilith"
            if profile.Theme == "Custom" then
                profile.Theme = "Lilith"
            end
        end
        self:_setSharedSettingsProfile(profile, true)
    end
    local function deleteLocale(localeCode)
        assert(localeCode ~= "en-US" and localeCode ~= "th-TH",
            "Default languages cannot be deleted")
        local profile = self:_getSettingsProfile()
        assert(profile.Locales[localeCode], "Locale does not exist")
        profile.Locales[localeCode] = nil
        profile.RemovedLocales = profile.RemovedLocales or {}
        profile.RemovedLocales[localeCode] = true
        if profile.Locale == localeCode then
            profile.Locale = "en-US"
        end
        self:_setSharedSettingsProfile(profile, true)
    end
    local settingToggleRows = {}
    local function refreshThemeSelection()
        local choices = {
            {Label = "Dark", Value = "Dark"},
            {Label = "Light", Value = "Light"},
            {Label = "Lilith", Value = "Lilith"},
        }
        for _, name in ipairs(getSortedNames(self._customThemes)) do
            if name ~= "Custom" and name ~= "Dark" and name ~= "Light" and name ~= "Lilith" then
                local customThemeName = name
                table.insert(choices, {
                    Actions = {
                        Delete = function()
                            confirmDelete("theme", customThemeName, function()
                                deleteTheme(customThemeName)
                            end)
                        end,
                        Edit = function()
                            showThemeEditor(customThemeName)
                        end,
                        Kind = "theme",
                    },
                    Label = customThemeName,
                    Value = customThemeName,
                })
            end
        end
        local selectedTheme = self._settingsThemeName or self._themePreset
        if selectedTheme == "Custom" and self._customThemes.Custom then
            for _, preset in ipairs({
                {Name = "Dark", Theme = DEFAULT_THEME},
                {Name = "Light", Theme = LIGHT_THEME},
                {Name = "Lilith", Theme = LILITH_THEME},
            }) do
                if matchesThemePreset(self._customThemes.Custom, preset.Theme) then
                    selectedTheme = preset.Name
                    break
                end
            end
        end
        renderChoiceGrid(themesHost, choices, selectedTheme, function(name)
            if name == "Dark" or name == "Light" or name == "Lilith" then
                self:SetThemePreset(name)
            else
                self._applyingSharedSettings = true
                self:SetTheme(self._customThemes[name])
                self._settingsThemeName = name
                self._applyingSharedSettings = false
                self:_applyThemeImage(self._customThemeImages and self._customThemeImages[name])
                self:_settingsRefreshTheme()
                self:_syncSharedSettings()
            end
        end)
        for _, setting in ipairs(settingToggleRows) do
            setting.Refresh()
        end
    end
    self._settingsRefreshTheme = refreshThemeSelection
    refreshThemeSelection()
    local addThemeButton = addChoice(addRow(36), "Add theme", showThemeEditor, 1, 1)

    local languageLabel = addLabel("Language", "ภาษา")
    local languagesHost = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = order + 1,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 122,
    }, content)
    order = order + 1
    local function refreshLocaleChoices()
        local choices = {}
        for _, locale in ipairs(getSortedNames(self.Localization.Locales)) do
            local definition = self.Localization.Locales[locale]
            local localeName = locale
            local localeDefinition = definition
            local actions
            if localeName ~= "en-US" and localeName ~= "th-TH" then
                actions = {
                    Delete = function()
                        confirmDelete("language", localeDefinition.Name or localeName, function()
                            deleteLocale(localeName)
                        end)
                    end,
                    Edit = function()
                        showLocaleEditor(localeName)
                    end,
                    Kind = "language",
                }
            end
            table.insert(choices, {
                Actions = actions,
                Label = localeDefinition.Name or localeName,
                Value = localeName,
            })
        end
        renderChoiceGrid(languagesHost, choices, self.Localization.Locale, function(locale)
            self:SetLocale(locale)
        end)
    end
    local addLanguageButton = addChoice(addRow(36), "Add language", showLocaleEditor, 1, 1)

    local keyLabel = addLabel("UI toggle key", "ปุ่มเปิด/ปิด UI")
    local keyButton
    keyButton = addChoice(addRow(36), "", function()
        self._capturingToggleKey = true
        keyButton.Text = self:_resolveText("Press a key...")
    end, 1, 1)
    local function refreshKeybind()
        if not keyButton.Parent then
            return
        end
        if self._capturingToggleKey then
            keyButton.Text = self:_resolveText("Press a key...")
        else
            keyButton.Text = self._toggleKey and string.gsub(tostring(self._toggleKey), "^Enum%.KeyCode%.", "") or "None"
        end
    end
    self._settingsRefreshKeybind = refreshKeybind
    refreshKeybind()

    local behaviorLabel = addLabel("Window behavior", "การทำงานของหน้าต่าง")
    local function addSettingToggle(label, initialValue, callback)
        local row = addRow(38)
        local labelObject = self:_text(row, label, {
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -76, 1, 0),
            TextSize = 11,
            ZIndex = 123,
        })
        local switch = make("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = self.Theme.ControlTrack,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -58, 0.5, -14),
            Size = UDim2.fromOffset(52, 28),
            Text = "",
            ZIndex = 123,
        }, row)
        addCorner(switch, 14)
        local switchStroke = addStroke(switch, self.Theme.ControlBorder, 0.3, self, "ControlBorder")
        local knob = make("Frame", {
            BackgroundColor3 = self.Theme.ControlKnob,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.fromOffset(22, 22),
            ZIndex = 124,
        }, switch)
        addCorner(knob, 11)
        self:_trackTheme(knob, "ControlKnob", "BackgroundColor3")
        local setting = {
            Label = labelObject,
            Switch = switch,
            Stroke = switchStroke,
            Knob = knob,
            Value = initialValue,
            Callback = callback,
        }
        local function refresh()
            local enabled = setting.Value
            switch.BackgroundColor3 = enabled and self.Theme.AccentSecondary or self.Theme.ControlTrack
            switchStroke.Color = enabled and self.Theme.AccentSecondary or self.Theme.ControlBorder
            knob.Position = enabled and UDim2.new(1, -25, 0, 3) or UDim2.fromOffset(3, 3)
            labelObject.Text = self:_resolveText(label) .. ": " .. stateWord(enabled)
        end
        setting.Refresh = refresh
        self:_connect(switch.Activated, function()
            setting.Callback(not setting.Value)
        end, self._overlayOwner)
        table.insert(settingToggleRows, setting)
        refresh()
    end
    addSettingToggle("Resize", self.Resizable, function(value)
        self:SetResizable(value)
    end)
    addSettingToggle("Drag", self._draggable, function(value)
        self:SetDraggable(value)
    end)

    local function refreshLocale()
        if not panel.Parent then
            return
        end
        title.Text = self:_resolveText("Settings")
        themeLabel.Text = self:_resolveText("Color theme")
        languageLabel.Text = self:_resolveText("Language")
        keyLabel.Text = self:_resolveText("UI toggle key")
        behaviorLabel.Text = self:_resolveText("Window behavior")
        addThemeButton.Text = self:_resolveText("Add theme")
        addLanguageButton.Text = self:_resolveText("Add language")
        settingToggleRows[1].Value = self.Resizable
        settingToggleRows[2].Value = self._draggable
        for _, setting in ipairs(settingToggleRows) do
            setting.Refresh()
        end
        refreshKeybind()
        refreshThemeSelection()
        refreshLocaleChoices()
    end
    self._settingsRefreshLocale = refreshLocale
    refreshLocale()
    content.CanvasSize = UDim2.new(
        0,
        0,
        0,
        contentLayout.AbsoluteContentSize.Y / self._contentScale.Scale
            + contentPadding.PaddingTop.Offset
            + contentPadding.PaddingBottom.Offset
    )

    self:_connect(overlay.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if self._settingsModal then
            return
        end
        local position = input.Position
        local topLeft = panel.AbsolutePosition
        local bottomRight = topLeft + panel.AbsoluteSize
        if position.X < topLeft.X or position.X > bottomRight.X or position.Y < topLeft.Y or position.Y > bottomRight.Y then
            self:_closeOverlay()
        end
    end, self._overlayOwner)
end

function WindowMethods:SetSize(size)
    assert(typeof(size) == "UDim2", "SetSize expects a UDim2")
    self._requestedSize = size
    self:_setResponsiveLayout()
end

function WindowMethods:_beginDrag(input)
    if self._narrow or not self._draggable then
        return
    end
    self._dragInput = input
    self._dragStart = input.Position
    self._dragStartPosition = self._panel.Position
end

function WindowMethods:_updateDrag(input)
    if not self._dragInput or self._narrow then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local delta = input.Position - self._dragStart
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1024, 768)
    local halfWidth = self._panel.AbsoluteSize.X / 2
    local halfHeight = self._panel.AbsoluteSize.Y / 2
    local scale = self._contentScale.Scale
    local x = self._dragStartPosition.X.Offset * scale + delta.X
    local y = self._dragStartPosition.Y.Offset * scale + delta.Y
    local insetTopLeft, insetBottomRight = GuiService:GetGuiInset()
    x = clamp(x, -viewport.X / 2 + halfWidth + insetTopLeft.X, viewport.X / 2 - halfWidth - insetBottomRight.X)
    y = clamp(y, -viewport.Y / 2 + halfHeight + insetTopLeft.Y, viewport.Y / 2 - halfHeight - insetBottomRight.Y)
    self._panel.Position = UDim2.new(0.5, x / scale, 0.5, y / scale)
end

function WindowMethods:_beginRestoreButtonDrag(input)
    if not self._restoreButton.Visible
        or (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) then
        return
    end
    self._restoreDragInput = input
    self._restoreDragStart = input.Position
    self._restoreDragStartPosition = self._restoreButton.Position
    self._restoreWasDragged = false
end

function WindowMethods:_updateRestoreButtonDrag(input)
    if not self._restoreDragInput
        or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then
        return
    end
    if self._restoreDragInput.UserInputType == Enum.UserInputType.Touch and input ~= self._restoreDragInput then
        return
    end
    local delta = input.Position - self._restoreDragStart
    if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
        self._restoreWasDragged = true
    end
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1024, 768)
    local insetTopLeft, insetBottomRight = GuiService:GetGuiInset()
    local buttonSize = self._restoreButton.AbsoluteSize
    local maxX = math.max(8, viewport.X - insetBottomRight.X - buttonSize.X - 8)
    local maxY = math.max(8, viewport.Y - insetTopLeft.Y - insetBottomRight.Y - buttonSize.Y - 8)
    local x = clamp(self._restoreDragStartPosition.X.Offset + delta.X, 8, maxX)
    local y = clamp(self._restoreDragStartPosition.Y.Offset + delta.Y, 8, maxY)
    self._restoreButton.Position = UDim2.fromOffset(x, y)
end

function WindowMethods:_beginResize(input)
    if not self.Resizable or self._narrow then
        return
    end
    self._resizeInput = input
    self._resizeStart = input.Position
    self._resizeStartSize = self._panel.AbsoluteSize / self._contentScale.Scale
end

function WindowMethods:_updateResize(input)
    if not self._resizeInput then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local delta = (input.Position - self._resizeStart) / self._contentScale.Scale
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or self._resizeStartSize
    local insetTopLeft, insetBottomRight = GuiService:GetGuiInset()
    local maxWidth = viewport.X - insetTopLeft.X - insetBottomRight.X - 20
    local maxHeight = viewport.Y - insetTopLeft.Y - insetBottomRight.Y - 20
    local width = clamp(self._resizeStartSize.X + delta.X, math.min(680, maxWidth), maxWidth)
    local height = clamp(self._resizeStartSize.Y + delta.Y, math.min(440, maxHeight), maxHeight)
    self._requestedSize = UDim2.fromOffset(width, height)
    self:_setResponsiveLayout()
end

function WindowMethods:GetState()
    local values = {}
    for _, component in ipairs(shallowCopy(self._components)) do
        if component.Id and component.GetValue then
            local value = component:GetValue()
            if typeof(value) == "Color3" then
                value = {R = value.R, G = value.G, B = value.B}
            elseif typeof(value) == "EnumItem" then
                value = value.Name
            elseif type(value) == "table" then
                value = shallowCopy(value)
            end
            values[component.Id] = value
        end
    end
    return {
        Version = 1,
        SelectedTab = self._selectedTab and self._selectedTab._explicitId and self._selectedTab.Id or nil,
        ThemePreset = self._themePreset,
        Locale = self.Localization.Locale,
        ToggleKey = self._toggleKey and self._toggleKey.Name or nil,
        Resizable = self.Resizable,
        Draggable = self._draggable,
        Values = values,
    }
end

function WindowMethods:SetState(state)
    validConfig(state, "SetState")
    assert(type(state.Values) == "table", "SetState.Values must be a table")
    if state.Version ~= 1 then
        warn("[AstraUI] State version is not supported: " .. tostring(state.Version))
    end
    if state.ThemePreset ~= nil then
        assert(state.ThemePreset == "Dark" or state.ThemePreset == "Light" or state.ThemePreset == "Lilith",
            "SetState.ThemePreset must be Dark, Light, or Lilith")
        self:SetThemePreset(state.ThemePreset)
    end
    if state.Locale ~= nil then
        assert(type(state.Locale) == "string", "SetState.Locale must be a string")
        self:SetLocale(state.Locale)
    end
    if state.ToggleKey ~= nil then
        assert(type(state.ToggleKey) == "string", "SetState.ToggleKey must be a KeyCode name")
        local toggleKey = Enum.KeyCode[state.ToggleKey]
        assert(isKeyCode(toggleKey), "SetState.ToggleKey is not a valid KeyCode")
        self:SetToggleKey(toggleKey)
    end
    if state.Resizable ~= nil then
        self:SetResizable(state.Resizable)
    end
    if state.Draggable ~= nil then
        self:SetDraggable(state.Draggable)
    end
    for id in pairs(state.Values) do
        if not self._ids[id] then
            warn("[AstraUI] Ignoring unknown state Id: " .. tostring(id))
        end
    end
    for _, component in ipairs(self._components) do
        if component.Id and component.SetValue and state.Values[component.Id] ~= nil then
            local value = state.Values[component.Id]
            if component._kind == "Colorpicker" and type(value) == "table" then
                value = Color3.new(value.R, value.G, value.B)
            elseif component._kind == "Keybind" and type(value) == "string" then
                value = Enum.KeyCode[value]
            end
            local ok, err = pcall(function()
                component:SetValue(value)
            end)
            if not ok then
                warn("[AstraUI] Invalid state for " .. component.Id .. ": " .. tostring(err))
            end
        end
    end
    if state.SelectedTab then
        for _, tab in ipairs(self._tabs) do
            if tab.Id == state.SelectedTab then
                self:_selectTab(tab)
                break
            end
        end
    end
end

function WindowMethods:SaveStateToFile(path)
    path = path or (self._statePersistence and self._statePersistence.Path)
    assert(type(path) == "string" and path ~= "", "SaveStateToFile requires a file path")
    local ok, err = pcall(function()
        local encoded = HttpService:JSONEncode(self:GetState())
        writeTextFile(path, encoded)
        self._stateFileSnapshot = encoded
    end)
    if not ok then
        return false, tostring(err)
    end
    return true
end

function WindowMethods:LoadStateFromFile(path)
    path = path or (self._statePersistence and self._statePersistence.Path)
    assert(type(path) == "string" and path ~= "", "LoadStateFromFile requires a file path")
    local readOk, contents = pcall(readTextFile, path)
    if not readOk then
        return false, tostring(contents)
    end
    if contents == nil then
        return false, nil
    end
    local ok, err = pcall(function()
        local state = HttpService:JSONDecode(contents)
        assert(type(state) == "table" and type(state.Values) == "table",
            "Saved state file has an invalid format")
        self:SetState(state)
        self._stateFileSnapshot = HttpService:JSONEncode(self:GetState())
    end)
    if not ok then
        return false, tostring(err)
    end
    return true
end

function WindowMethods:StartStateAutoSave(interval)
    local persistence = self._statePersistence or {}
    local path = persistence.Path
    assert(type(path) == "string" and path ~= "", "StatePersistence.Path is required for autosave")
    interval = interval or persistence.AutoSaveInterval or 1
    assert(type(interval) == "number" and interval > 0,
        "StartStateAutoSave interval must be a positive number")
    if type(writefile) ~= "function" or type(makefolder) ~= "function"
        or type(isfolder) ~= "function" then
        return false, "File write APIs are unavailable in this environment"
    end
    local ok, snapshot = pcall(function()
        return HttpService:JSONEncode(self:GetState())
    end)
    if not ok then
        return false, tostring(snapshot)
    end
    self._stateFileSnapshot = self._stateFileSnapshot or snapshot
    self._stateAutoSaveGeneration = (self._stateAutoSaveGeneration or 0) + 1
    local generation = self._stateAutoSaveGeneration
    task.spawn(function()
        while not self._destroyed and self._stateAutoSaveGeneration == generation do
            task.wait(interval)
            if self._destroyed or self._stateAutoSaveGeneration ~= generation then
                break
            end
            local encodeOk, current = pcall(function()
                return HttpService:JSONEncode(self:GetState())
            end)
            if not encodeOk then
                warn("[AstraUI] State autosave stopped: " .. tostring(current))
                break
            end
            if current ~= self._stateFileSnapshot then
                local saved, saveError = self:SaveStateToFile(path)
                if not saved then
                    warn("[AstraUI] State autosave stopped: " .. tostring(saveError))
                    break
                end
            end
        end
    end)
    return true
end

function WindowMethods:_onInputBegan(input, processed)
    if self._capturingToggleKey and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape then
            self._capturingToggleKey = false
        elseif input.KeyCode ~= Enum.KeyCode.Unknown then
            self:SetToggleKey(input.KeyCode)
            self._capturingToggleKey = false
        end
        if self._settingsRefreshKeybind then
            self._settingsRefreshKeybind()
        end
        return
    end
    if processed or isTextFocused() or self._destroyed then
        return
    end
    if self._toggleKey and input.KeyCode == self._toggleKey then
        self:SetVisible(not self._visibilityTarget)
        return
    end
    if input.KeyCode == Enum.KeyCode.Escape and self._overlay then
        self:_closeOverlay()
        return
    end
    for _, control in ipairs(self._keybinds) do
        if control._capturing then
            return
        end
    end
    for _, control in ipairs(self._keybinds) do
        if control._keyCode == input.KeyCode and control.Enabled then
            self:_warnCallback(control.Name .. " keybind", control.Callback, input.KeyCode)
        end
    end
end

function WindowMethods:Destroy()
    if self._destroyed then
        return
    end
    self._destroyed = true
    self._stateAutoSaveGeneration = (self._stateAutoSaveGeneration or 0) + 1
    self:_setBackgroundLoading(self._customThemePngBackgroundImage, false)
    self:_setBackgroundLoading(self._lilithBackgroundImage, false)
    if self._settingsStore then
        self._settingsStore.Windows[self] = nil
    end
    while #self._toasts > 0 do
        self._toasts[1]:Dismiss()
    end
    if self._search then
        self._search:Destroy()
    end
    self:_closeOverlay()
    self._visibilityGeneration = self._visibilityGeneration + 1
    for _, tween in ipairs(self._visibilityTweens) do
        tween:Cancel()
    end
    table.clear(self._visibilityTweens)
    for _, component in ipairs(shallowCopy(self._components)) do
        if component.Destroy then
            pcall(function()
                component:Destroy()
            end)
        end
    end
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    if self._restoreEditableImage then
        self._restoreEditableImage:Destroy()
        self._restoreEditableImage = nil
    end
    if self._lilithEditableImage then
        self._lilithEditableImage:Destroy()
        self._lilithEditableImage = nil
    end
    for _, editableImage in pairs(self._themeImageCache or {}) do
        editableImage:Destroy()
    end
    self._themeImageCache = {}
    self._themeImageCacheOrder = {}
    self._customThemeEditableImage = nil
    if self._screenGui then
        self._screenGui:Destroy()
    end
end

function WindowMethods:Tab(config)
    validConfig(config, "Tab")
    assert(config.Name ~= nil, "Tab.Name is required")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "Tab.Icon must be a non-empty string")
    assert(config.Category == nil or (type(config.Category) == "string" and config.Category ~= ""), "Tab.Category must be a non-empty string")
    local category
    if config.Category then
        category = self._tabCategories[config.Category]
        if not category then
            self._tabNavOrder = self._tabNavOrder + 1
            local header = make("TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = self.Theme.Surface,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = self._tabNavOrder,
                Size = UDim2.new(1, -24, 0, 30),
                Text = "",
                ZIndex = 5,
            }, self._tabList)
            local label = self:_text(header, config.Category, {
                Position = UDim2.new(0, 30, 0, 0),
                Size = UDim2.new(1, -38, 1, 0),
                Font = Enum.Font.GothamBold,
                TextColor3 = self.Theme.TextMuted,
                TextSize = 11,
                ZIndex = 6,
            })
            local function updateCategoryIcon()
                if category and category.Icon and category.Icon.Parent then
                    category.Icon:Destroy()
                end
                category.Icon = self:_icon(header, category.Collapsed and "chevron-right" or "chevron-down", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 14, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14),
                    TextColor3 = self.Theme.TextMuted,
                    ZIndex = 6,
                }, category.Collapsed and ">" or "v")
            end
            category = {
                Name = config.Category,
                Collapsed = false,
                Header = header,
                Label = label,
                Icon = nil,
                Tabs = {},
            }
            updateCategoryIcon()
            self._tabCategories[config.Category] = category
            self:_connect(header.Activated, function()
                category.Collapsed = not category.Collapsed
                updateCategoryIcon()
                self:_setResponsiveLayout()
            end)
        end
    end
    local nameValue = config.Name
    local name = self:_resolveText(nameValue)
    local tabId = config.Id or ("tab-" .. tostring(#self._tabs + 1))
    if config.Id ~= nil then
        assert(type(config.Id) == "string" and config.Id ~= "", "Tab.Id must be a non-empty string")
    end
    for _, existing in ipairs(self._tabs) do
        assert(existing.Id ~= tabId, "Duplicate tab Id: " .. tostring(tabId))
    end
    local tab = setmetatable({
        _window = self,
        _nameValue = nameValue,
        Name = name,
        Id = tabId,
        _explicitId = config.Id ~= nil,
        Icon = config.Icon,
        Category = config.Category,
        _category = category,
        _sections = {},
        _cardLayouts = {},
    }, TabMethods)
    table.insert(self._tabs, tab)
    if category then
        table.insert(category.Tabs, tab)
    end
    self._tabNavOrder = self._tabNavOrder + 1

    local tabButton = make("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        LayoutOrder = self._tabNavOrder,
        Size = UDim2.new(1, -24, 0, 46),
        Text = "",
        ZIndex = 5,
    }, self._tabList)
    tab._button = tabButton
    addCorner(tabButton, 9, self)
    tab._stroke = addStroke(tabButton, self.Theme.Border, 1, self)
    local nameLabel = self:_text(tabButton, nameValue, {
        Position = UDim2.new(0, config.Icon and 40 or 16, 0, 0),
        Size = UDim2.new(1, config.Icon and -46 or -22, 1, 0),
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14,
        ZIndex = 6,
    })
    tab._nameLabel = nameLabel
    if config.Icon then
        local iconLabel = self:_icon(tabButton, config.Icon, {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(20, 20),
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 6,
        })
        tab._iconLabel = iconLabel
    end
    self:_connect(tabButton.Activated, function()
        self:_selectTab(tab)
    end)

    local page = make("ScrollingFrame", {
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = self.Theme.AccentSecondary,
        ScrollBarThickness = 4,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 2,
    }, self._pageHost)
    tab._page = page
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 18),
        PaddingTop = UDim.new(0, 14),
    }, page)
    local pageLayout = make("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    tab._pageLayout = pageLayout
    self:_connect(pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        self:_updatePageCanvas(tab)
    end)
    self:_connect(tabButton.MouseButton1Click, function()
        if self._narrow then
            self._drawer.Visible = false
        end
    end)
    if not self._selectedTab then
        self:_selectTab(tab)
    end
    self:_setResponsiveLayout()
    return tab
end

local function createSection(window, parent, config, ownerTab)
    validConfig(config, "Section")
    assert(config.Name ~= nil, "Section.Name is required")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "Section.Icon must be a non-empty string")
    local section = setmetatable({
        _window = window,
        _parent = parent,
        _connections = {},
        _components = {},
        _controlsFrame = nil,
        _tab = ownerTab,
    }, SectionMethods)
    local card = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 3,
    }, parent)
    section._frame = card
    addCorner(card, 6, window, true)
    addStroke(card, window.Theme.Border, 0, window)
    window:_trackTheme(card, "StateSurface", "BackgroundColor3")
    window:_trackLilithSurface(card, LILITH_SURFACE_BASE_TRANSPARENCY)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 11),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 11),
    }, card)
    local titleRow = make("Frame", {
        LayoutOrder = 1,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 24),
        ZIndex = 4,
    }, card)
    local title = window:_text(titleRow, config.Name, {
        Position = UDim2.new(0, config.Icon and 24 or 0, 0, 0),
        Size = UDim2.new(1, config.Icon and -24 or 0, 1, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        ZIndex = 4,
    })
    if config.Icon then
        window:_icon(titleRow, config.Icon, {
            Position = UDim2.new(0, 0, 0.5, -9),
            Size = UDim2.fromOffset(18, 18),
            TextColor3 = window.Theme.AccentSecondary,
            TextSize = 16,
            ZIndex = 5,
        })
    end
    section.Name = window:_resolveText(config.Name)
    section._title = title
    section._list = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 4,
    }, card)
    section._layout = make("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, section._list)
    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, card)
    window:_connect(section._layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if ownerTab then
            window:_updatePageCanvas(ownerTab)
        end
    end)
    table.insert(section._connections, window:_connect(title:GetPropertyChangedSignal("Text"), function()
        section.Name = title.Text
    end))
    return section
end

function TabMethods:Section(config)
    validConfig(config, "Section")
    if config.Side ~= nil then
        assert(config.Side == "Left" or config.Side == "Right", "Section.Side must be Left or Right")
        if not self._sideColumns then
            local window = self._window
            local frame = make("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                ZIndex = 3,
            }, self._page)
            local left = make("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0.5, -7, 0, 0),
                ZIndex = 3,
            }, frame)
            local right = make("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 7, 0, 0),
                Size = UDim2.new(0.5, -7, 0, 0),
                ZIndex = 3,
            }, frame)
            local leftLayout = make("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, left)
            local rightLayout = make("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, right)
            local function relayout()
                if not frame.Parent then
                    return
                end
                local scale = window._contentScale.Scale
                local leftHeight = leftLayout.AbsoluteContentSize.Y / scale
                local rightHeight = rightLayout.AbsoluteContentSize.Y / scale
                local stacked = frame.AbsoluteSize.X < 360 * scale
                if stacked then
                    left.Position = UDim2.new(0, 0, 0, 0)
                    left.Size = UDim2.new(1, 0, 0, leftHeight)
                    right.Position = UDim2.new(0, 0, 0, leftHeight + 10)
                    right.Size = UDim2.new(1, 0, 0, rightHeight)
                    frame.Size = UDim2.new(1, 0, 0, leftHeight + rightHeight + 10)
                else
                    left.Position = UDim2.new(0, 0, 0, 0)
                    left.Size = UDim2.new(0.5, -7, 0, leftHeight)
                    right.Position = UDim2.new(0.5, 7, 0, 0)
                    right.Size = UDim2.new(0.5, -7, 0, rightHeight)
                    frame.Size = UDim2.new(1, 0, 0, math.max(leftHeight, rightHeight))
                end
                window:_updatePageCanvas(self)
            end
            window:_connect(frame:GetPropertyChangedSignal("AbsoluteSize"), relayout)
            window:_connect(leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"), relayout)
            window:_connect(rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"), relayout)
            self._sideColumns = {Frame = frame, Left = left, Right = right, Relayout = relayout}
        end
        local sideParent = self._sideColumns[config.Side]
        local section = createSection(self._window, sideParent, config, self)
        self._sideColumns.Relayout()
        table.insert(self._sections, section)
        return section
    end
    local section = createSection(self._window, self._page, config, self)
    table.insert(self._sections, section)
    return section
end

function SectionMethods:_register(component)
    component._window = self._window
    component._section = component._section or self
    component._connections = component._connections or {}
    table.insert(self._components, component)
    self._window:_registerComponent(component)
    return component
end

function SectionMethods:_row(config, kind)
    config = config or {}
    local window = self._window
    local row = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
    }, self._list)
    window:_trackTheme(row, "StateSurface", "BackgroundColor3")
    window:_trackLilithSurface(row, LILITH_SURFACE_BASE_TRANSPARENCY)
    addCorner(row, 6, window, true)
    addStroke(row, window.Theme.Border, 0, window)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 9),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 9),
    }, row)
    local rowLayout = make("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, row)
    local titleValue = config.Name or config.Title or kind
    local label = window:_text(row, titleValue, {
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        ZIndex = 6,
    })
    local description
    if config.Description then
        description = window:_text(row, config.Description, {
            LayoutOrder = 2,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextColor3 = window.Theme.TextMuted,
            TextSize = 12,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 6,
        })
    end
    local body = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 6,
    }, row)
    local component = {
        Id = config.Id,
        Name = window:_resolveText(titleValue),
        Description = window:_resolveText(config.Description or ""),
        _kind = kind,
        _row = row,
        _rowLayout = rowLayout,
        _label = label,
        _description = description,
        _body = body,
        _config = config,
        Enabled = config.Enabled ~= false,
        Callback = config.Callback,
        _window = window,
        _section = self,
        _connections = {},
        _value = config.Default,
    }
    table.insert(self._window._localized, {Object = label, Value = titleValue, Property = "Text"})
    return self:_register(setmetatable(component, ControlMethods))
end

function ControlMethods:Destroy()
    if self._destroyed then
        return
    end
    self._destroyed = true
    for _, connection in ipairs(self._connections or {}) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    if self._cleanup then
        local ok, err = pcall(self._cleanup)
        if not ok then
            warn("[AstraUI] Component cleanup failed: " .. tostring(err))
        end
    end
    if self._row and self._row.Parent then
        self._row:Destroy()
    elseif self._instance and self._instance.Parent then
        self._instance:Destroy()
    end
end

function ControlMethods:SetEnabled(enabled)
    assert(type(enabled) == "boolean", "SetEnabled expects a boolean")
    self.Enabled = enabled
    if self._button then
        self._button.Active = enabled
        self._button.AutoButtonColor = false
        self._button.TextTransparency = enabled and 0 or 0.45
    end
    if self._switch then
        self._switch.Active = enabled
    end
    if self._hit then
        self._hit.Active = enabled
    end
    if self._input then
        self._input.TextEditable = enabled
    end
end

function ControlMethods:SetLoading(loading)
    assert(self._kind == "Button", "SetLoading is only available on Button")
    assert(type(loading) == "boolean", "SetLoading expects a boolean")
    self._loading = loading
    self:SetEnabled(not loading and self._config.Enabled ~= false)
    if self._button then
        self._button.Text = loading and "Loading…" or self.Name
    end
end

function ControlMethods:SetError(message)
    assert(self._kind == "Input", "SetError is only available on Input")
    self._errorLabel.Text = safeString(message)
    self._errorLabel.Visible = message ~= nil and message ~= ""
    local role = self._errorLabel.Visible and "Danger" or "Border"
    self._window:_trackTheme(self._inputStroke, role, "Color")
    self._inputStroke.Color = self._window.Theme[role]
end

function ControlMethods:GetValue()
    if type(self._value) == "table" then
        return shallowCopy(self._value)
    end
    return self._value
end

function ControlMethods:_changed(value, fromUser)
    self._value = type(value) == "table" and shallowCopy(value) or value
    if fromUser and self.Callback then
        local callbackValue = type(value) == "table" and shallowCopy(value) or value
        self._window:_warnCallback(self.Name, self.Callback, callbackValue)
    end
end

function ControlMethods:SetValue(value)
    local kind = self._kind
    if kind == "Toggle" then
        assert(type(value) == "boolean", "Toggle value must be boolean")
        self._value = value
        local backgroundRole = value and "AccentSecondary" or "ControlTrack"
        self._window:_trackTheme(self._switch, backgroundRole, "BackgroundColor3")
        TweenService:Create(self._switch, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = self._window.Theme[backgroundRole],
        }):Play()
        TweenService:Create(self._switchKnob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = value and UDim2.new(1, -29, 0, 3) or UDim2.new(0, 3, 0, 3),
        }):Play()
    elseif kind == "Slider" then
        assert(type(value) == "number", "Slider value must be a number")
        value = clamp(value, self._min, self._max)
        if self._step then
            value = self._min + math.floor((value - self._min) / self._step + 0.5) * self._step
            value = clamp(value, self._min, self._max)
        end
        self._value = value
        self._valueLabel.Text = tostring(value)
        local fraction = (value - self._min) / (self._max - self._min)
        self._fill.Size = UDim2.new(fraction, 0, 1, 0)
        self._sliderKnob.Position = UDim2.new(fraction, -7, 0.5, -7)
    elseif kind == "Dropdown" then
        local found = false
        for _, option in ipairs(self._options) do
            if option == value then
                found = true
                break
            end
        end
        assert(found, "Dropdown value must exist in Options")
        self._value = value
        self._button.Text = tostring(value)
    elseif kind == "PlayerDropdown" then
        assert(value == nil or type(value) == "table", "PlayerDropdown value must be an array of Players or nil")
        for _, connection in ipairs(self._playerBadgeConnections or {}) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        if self._playerBadgeConnections then
            local oldConnections = {}
            for _, connection in ipairs(self._playerBadgeConnections) do
                oldConnections[connection] = true
            end
            for index = #self._connections, 1, -1 do
                if oldConnections[self._connections[index]] then
                    table.remove(self._connections, index)
                end
            end
        end
        self._playerBadgeConnections = {}
        local currentPlayers = {}
        for _, player in ipairs(Players:GetPlayers()) do
            currentPlayers[player] = true
        end
        local selected = {}
        local selectedLookup = {}
        for _, player in ipairs(value or {}) do
            assert(typeof(player) == "Instance" and player:IsA("Player") and currentPlayers[player],
                "PlayerDropdown values must contain current Players")
            assert(not (self._excludeLocalPlayer and player == LocalPlayer),
                "PlayerDropdown cannot select the local player when ExcludeLocalPlayer is enabled")
            if not selectedLookup[player] then
                selectedLookup[player] = true
                table.insert(selected, player)
            end
        end
        self._value = selected
        self._button.Text = self._window:_resolveText(self._placeholder)
        for _, child in ipairs(self._selectedList:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        for index, player in ipairs(selected) do
            local badge = make("Frame", {
                BackgroundColor3 = self._window.Theme.ControlInset,
                BorderSizePixel = 0,
                LayoutOrder = index,
                Size = UDim2.new(0, 0, 0, 40),
                ZIndex = self._button.ZIndex + 1,
            }, self._selectedList)
            addCorner(badge, 6, self._window, true)
            self._window:_trackTheme(badge, "ControlInset", "BackgroundColor3")
            addStroke(badge, self._window.Theme.ControlBorder, 0.5, self._window, "ControlBorder")
            local avatar = make("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = self._window.Theme.ControlTrack,
                BorderSizePixel = 0,
                Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", player.UserId),
                Position = UDim2.new(0, 4, 0.5, 0),
                Size = UDim2.fromOffset(32, 32),
                ZIndex = badge.ZIndex + 1,
            }, badge)
            addCorner(avatar, 16, self._window, true)
            self._window:_text(badge, player.DisplayName, {
                Position = UDim2.new(0, 42, 0, 3),
                Size = UDim2.new(1, -82, 0, 18),
                Font = Enum.Font.GothamMedium,
                TextColor3 = self._window.Theme.TextPrimary,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextWrapped = false,
                ZIndex = badge.ZIndex + 1,
            })
            self._window:_text(badge, "@" .. player.Name, {
                Position = UDim2.new(0, 42, 0, 20),
                Size = UDim2.new(1, -82, 0, 16),
                TextColor3 = self._window.Theme.TextMuted,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextWrapped = false,
                ZIndex = badge.ZIndex + 1,
            })
            local remove = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                AutoButtonColor = false,
                BackgroundColor3 = self._window.Theme.ControlHover,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -4, 0.5, 0),
                Size = UDim2.fromOffset(30, 30),
                Text = "×",
                TextColor3 = self._window.Theme.TextSecondary,
                TextSize = 18,
                ZIndex = badge.ZIndex + 2,
            }, badge)
            remove:SetAttribute("AstraLabel", "Remove " .. player.DisplayName)
            addCorner(remove, 5, self._window, true)
            self._window:_trackTheme(remove, "ControlHover", "BackgroundColor3")
            self._window:_trackTextColor(remove, self._window.Theme.TextSecondary)
            local connection = self._window:_connect(remove.Activated, function()
                if self._destroyed then
                    return
                end
                local remaining = {}
                for _, selectedPlayer in ipairs(self._value) do
                    if selectedPlayer ~= player then
                        table.insert(remaining, selectedPlayer)
                    end
                end
                self:SetValue(remaining)
                self:_changed(remaining, true)
            end, self)
            table.insert(self._playerBadgeConnections, connection)
        end
        if self._layoutPlayerBadges then
            self._layoutPlayerBadges()
        end
    elseif kind == "MultiDropdown" then
        assert(type(value) == "table", "MultiDropdown value must be an array")
        local selected = {}
        local lookup = {}
        for _, option in ipairs(self._options) do
            lookup[option] = true
        end
        for _, item in ipairs(value) do
            assert(lookup[item], "MultiDropdown value contains an unknown option")
            table.insert(selected, item)
        end
        self._value = selected
        self._button.Text = #selected == 0 and "Select…" or table.concat(selected, ", ")
    elseif kind == "Input" then
        assert(type(value) == "string", "Input value must be a string")
        if self._config.MaxLength then
            value = truncateText(value, self._config.MaxLength)
        end
        self._value = value
        self._input.Text = value
    elseif kind == "Colorpicker" then
        assert(typeof(value) == "Color3", "Colorpicker value must be a Color3")
        self._value = value
        if self._colorMainSwatch and self._colorMainSwatch.Parent then
            self._colorMainSwatch.BackgroundColor3 = value
        end
        if self._colorSwatch and self._colorSwatch.Parent then
            self._colorSwatch.BackgroundColor3 = value
        end
        if self._hexInput and self._hexInput.Parent then
            self._hexInput.Text = string.format("#%02X%02X%02X", math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255))
        end
    elseif kind == "Keybind" then
        assert(isKeyCode(value), "Keybind value must be an Enum.KeyCode")
        self._value = value
        self._keyCode = value
        self._button.Text = "Change key"
        self._keyBadge.Text = value.Name
    else
        error("SetValue is not available for " .. tostring(kind))
    end
    return self
end

local function newControlButton(component, text, callback, height, style)
    style = style or {}
    local controlButton = component._window:_button(component._body, text, callback, {
        Owner = component,
        Height = height or 38,
        Background = style.Background or component._window.Theme.ControlSurface,
        HoverBackground = style.HoverBackground,
        HoverRole = style.HoverRole or "ControlHover",
        PressedBackground = style.PressedBackground,
        TextColor = style.TextColor or (style.Role == "AccentSecondary"
            and component._window.Theme.AccentForeground or component._window.Theme.TextPrimary),
        Role = style.Role or "ControlSurface",
        Stroke = style.Stroke,
        StrokeRole = style.StrokeRole,
        Radius = 6,
        PreserveRadius = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 13,
        TextWrapped = style.TextWrapped ~= false,
        TextTruncate = style.TextTruncate or Enum.TextTruncate.None,
        PaddingLeft = style.PaddingLeft or 14,
        PaddingRight = style.PaddingRight or 42,
        StrokeTransparency = style.StrokeTransparency or 0.45,
        HoverStrokeTransparency = style.HoverStrokeTransparency or 0.18,
    })
    component._button = controlButton
    return controlButton
end

function SectionMethods:Button(config)
    validConfig(config, "Button")
    assert(type(config.Callback) == "function", "Button.Callback must be a function")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "Button.Icon must be a non-empty string")
    local component = self:_row(config, "Button")
    component._label.Visible = false
    if component._description then
        component._rowLayout.Padding = UDim.new(0, 10)
    end
    local actionButton = newControlButton(component, config.Name or config.Title, function()
        if component.Enabled and not component._loading then
            component._window:_warnCallback(component.Name, config.Callback)
        end
    end, nil, {
        Background = self._window.Theme.AccentSecondary,
        HoverRole = "AccentSecondary",
        HoverStrokeTransparency = 0.1,
        Role = "AccentSecondary",
        Stroke = self._window.Theme.AccentSecondary,
        StrokeRole = "AccentSecondary",
        StrokeTransparency = 0.25,
        TextColor = self._window.Theme.AccentForeground,
        TextXAlignment = config.Icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
        PaddingLeft = config.Icon and 40 or 14,
        PaddingRight = 14,
    })
    component._button = actionButton
    if config.Icon then
        self._window:_icon(component._body, config.Icon, {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(18, 38),
            TextColor3 = self._window.Theme.AccentForeground,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = actionButton.ZIndex + 2,
        })
    end
    return component
end

function SectionMethods:Toggle(config)
    validConfig(config, "Toggle")
    assert(config.Default == nil or type(config.Default) == "boolean", "Toggle.Default must be a boolean")
    assert(config.Callback == nil or type(config.Callback) == "function", "Toggle.Callback must be a function")
    local component = self:_row(config, "Toggle")
    local window = self._window
    local switch = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        AutoButtonColor = false,
        BackgroundColor3 = window.Theme.ControlTrack,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 56, 0, 32),
        Selectable = true,
        Text = "",
        ZIndex = 8,
    }, component._body)
    window:_trackTheme(switch, "ControlTrack", "BackgroundColor3")
    component._switch = switch
    addCorner(switch, 17)
    component._switchStroke = addStroke(switch, window.Theme.ControlBorder, 0.35, window, "ControlBorder")
    component._switchKnob = make("Frame", {
        BackgroundColor3 = window.Theme.ControlKnob,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 3, 0, 3),
        Size = UDim2.new(0, 26, 0, 26),
        ZIndex = 10,
    }, switch)
    addCorner(component._switchKnob, 13)
    window:_trackTheme(component._switchKnob, "ControlKnob", "BackgroundColor3")
    addStroke(component._switchKnob, window.Theme.ControlBorder, 0.2, window, "ControlBorder")
    component._config.Default = config.Default == true
    component:SetValue(config.Default == true)
    window:_connect(switch.Activated, function()
        if component.Enabled then
            component:SetValue(not component._value)
            component:_changed(component._value, true)
        end
    end, component)
    return component
end

function SectionMethods:Slider(config)
    validConfig(config, "Slider")
    local minimum, maximum = config.Min, config.Max
    assert(type(minimum) == "number" and type(maximum) == "number" and maximum > minimum, "Slider requires numeric Min < Max")
    assert(config.Step == nil or (type(config.Step) == "number" and config.Step > 0), "Slider.Step must be a positive number")
    assert(config.Callback == nil or type(config.Callback) == "function", "Slider.Callback must be a function")
    local component = self:_row(config, "Slider")
    local window = self._window
    component._min = minimum
    component._max = maximum
    component._step = config.Step
    component._track = make("Frame", {
        BackgroundColor3 = window.Theme.ControlTrack,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 9),
        Size = UDim2.new(1, 0, 0, 12),
        ZIndex = 8,
    }, component._body)
    window:_trackTheme(component._track, "ControlTrack", "BackgroundColor3")
    addCorner(component._track, 6)
    component._trackStroke = addStroke(component._track, window.Theme.ControlBorder, 0.6, window, "ControlBorder")
    component._fill = make("Frame", {
        BackgroundColor3 = window.Theme.AccentSecondary,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 9,
    }, component._track)
    window:_trackTheme(component._fill, "AccentSecondary", "BackgroundColor3")
    addCorner(component._fill, 5)
    component._sliderKnob = make("Frame", {
        BackgroundColor3 = window.Theme.ControlKnob,
        BorderSizePixel = 0,
        Position = UDim2.new(0, -7, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        ZIndex = 11,
    }, component._track)
    addCorner(component._sliderKnob, 7)
    addStroke(component._sliderKnob, window.Theme.ControlBorder, 0.1, window, "ControlBorder")
    window:_trackTheme(component._sliderKnob, "ControlKnob", "BackgroundColor3")
    local hit = make("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -14),
        Size = UDim2.new(1, 0, 0, 44),
        Selectable = true,
        Text = "",
        ZIndex = 10,
    }, component._track)
    component._hit = hit
    component._valueLabel = window:_text(component._body, "", {
        Position = UDim2.new(0, 0, 0, 27),
        Size = UDim2.new(1, 0, 0, 20),
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 12,
        ZIndex = 8,
    })
    local function update(input)
        local x = clamp((input.Position.X - component._track.AbsolutePosition.X) / math.max(1, component._track.AbsoluteSize.X), 0, 1)
        local value = minimum + x * (maximum - minimum)
        component:SetValue(value)
        component:_changed(component._value, true)
    end
    window:_connect(hit.InputBegan, function(input)
        if component.Enabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            component._dragging = true
            update(input)
        end
    end, component)
    window:_connect(hit.SelectionGained, function()
        window:_trackTheme(component._trackStroke, "BorderActive", "Color")
        component._trackStroke.Color = window.Theme.BorderActive
    end, component)
    window:_connect(hit.SelectionLost, function()
        window:_trackTheme(component._trackStroke, "Border", "Color")
        component._trackStroke.Color = window.Theme.Border
    end, component)
    window:_connect(UserInputService.InputBegan, function(input, processed)
        if processed or not component.Enabled or GuiService.SelectedObject ~= hit then
            return
        end
        local direction
        if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.ButtonL1 then
            direction = -1
        elseif input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.DPadRight or input.KeyCode == Enum.KeyCode.ButtonR1 then
            direction = 1
        end
        if direction then
            local increment = component._step or (maximum - minimum) / 100
            component:SetValue(component._value + increment * direction)
            component:_changed(component._value, true)
        end
    end, component)
    window:_connect(UserInputService.InputChanged, function(input)
        if component._dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end, component)
    window:_connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            component._dragging = false
        end
    end, component)
    component:SetValue(config.Default or minimum)
    return component
end

function WindowMethods:_showOptions(component, multiple)
    self:_closeOverlay()
    local overlay = self:_createOverlay()
    self._openOverlayComponent = component
    local scale = self._contentScale.Scale
    local panelSize = self._panel.AbsoluteSize / scale
    local trigger = component._button
    local triggerPosition = (trigger.AbsolutePosition - self._panel.AbsolutePosition) / scale
    local triggerSize = trigger.AbsoluteSize / scale
    local isPlayerDropdown = component._kind == "PlayerDropdown"
    local optionHeight = isPlayerDropdown and 54 or 38
    local popupWidth = math.min(math.max(triggerSize.X, isPlayerDropdown and 280 or 240), panelSize.X - 24)
    local playerColumns = 1
    if isPlayerDropdown then
        local scaledPopupWidth = popupWidth * scale
        local scaledGap = 4 * scale
        local scaledAvailableWidth = scaledPopupWidth - 26 * scale
        playerColumns = math.max(1, math.min(4, math.floor((scaledAvailableWidth + scaledGap) / (220 * scale + scaledGap))))
    end
    local optionRows = isPlayerDropdown
        and math.ceil(math.max(1, #component._options) / playerColumns)
        or math.max(1, #component._options)
    local popupHeight = math.min(
        276,
        44 + optionRows * optionHeight,
        math.max(90, panelSize.Y - 24)
    )
    local popupX = clamp(triggerPosition.X, 12, panelSize.X - popupWidth - 12)
    local popupY = triggerPosition.Y + triggerSize.Y + 6
    if popupY + popupHeight > panelSize.Y - 12 then
        popupY = triggerPosition.Y - popupHeight - 6
    end
    popupY = clamp(popupY, 12, panelSize.Y - popupHeight - 12)
    local outside = make("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        ZIndex = 100,
    }, overlay)
    self:_connect(outside.Activated, function()
        self:_closeOverlay()
    end, self._overlayOwner)
    local popup = make("Frame", {
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = self.Theme.SurfaceRaised,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(popupX, popupY),
        Size = UDim2.fromOffset(popupWidth, popupHeight),
        ZIndex = 102,
    }, overlay)
    self:_trackTheme(popup, "SurfaceRaised", "BackgroundColor3")
    addCorner(popup, 6, self, true)
    addStroke(popup, self.Theme.Border, 0, self)
    self:_text(popup, component.Name, {
        Position = UDim2.new(0, 12, 0, 7),
        Size = UDim2.new(1, -24, 0, 20),
        Font = Enum.Font.GothamBold,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 12,
        ZIndex = 103,
    })
    local list = make("ScrollingFrame", {
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, #component._options * optionHeight + 8),
        Position = UDim2.new(0, 8, 0, 32),
        ScrollBarImageColor3 = self.Theme.AccentSecondary,
        ScrollBarThickness = 2,
        Size = UDim2.new(1, -16, 1, -38),
        ZIndex = 103,
    }, popup)
    self:_trackTheme(list, "AccentSecondary", "ScrollBarImageColor3")
    make("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, list)
    if isPlayerDropdown and #component._options > 0 then
        local gap = 4
        local playerGrid = make("UIGridLayout", {
            CellPadding = UDim2.fromOffset(gap, gap),
            CellSize = UDim2.fromOffset(220, optionHeight - gap),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, list)
        local function layoutPlayerOptions()
            local scale = self._contentScale.Scale
            local gap = 4
            local scaledGap = gap * scale
            local scaledAvailableWidth = list.AbsoluteSize.X - 10 * scale
            if scaledAvailableWidth <= 0 then
                return
            end
            local columns = math.max(1, math.min(4, math.floor((scaledAvailableWidth + scaledGap) / (220 * scale + scaledGap))))
            local availableWidth = scaledAvailableWidth / scale
            local cellWidth = (availableWidth - gap * (columns - 1)) / columns
            playerGrid.CellSize = UDim2.new(0, cellWidth, 0, optionHeight - gap)
            local rows = math.ceil(#component._options / columns)
            list.CanvasSize = UDim2.new(0, 0, 0, rows * (optionHeight - gap) + math.max(0, rows - 1) * gap + 8)
        end
        self:_connect(list:GetPropertyChangedSignal("AbsoluteSize"), layoutPlayerOptions, self._overlayOwner)
        task.defer(layoutPlayerOptions)
    else
        make("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, list)
    end
    if isPlayerDropdown and #component._options == 0 then
        self:_text(list, component._emptyText, {
            Position = UDim2.new(0, 8, 0, 4),
            Size = UDim2.new(1, -16, 0, 42),
            TextColor3 = self.Theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 104,
        })
    end
    for index, option in ipairs(component._options) do
        local optionValue = option
        local selected = (multiple or isPlayerDropdown) and table.find(component._value, optionValue) ~= nil
            or (not multiple and component._value == optionValue)
        local optionFrame = make("Frame", {
            BackgroundColor3 = isPlayerDropdown and self.Theme.ControlInset or self.Theme.ControlSurface,
            BorderSizePixel = 0,
            LayoutOrder = index,
            Size = UDim2.new(1, -8, 0, optionHeight - 4),
            ZIndex = 104,
        }, list)
        addCorner(optionFrame, 6, self, true)
        self:_trackTheme(optionFrame, isPlayerDropdown and "ControlInset" or "ControlSurface", "BackgroundColor3")
        local optionStroke = addStroke(optionFrame, self.Theme.AccentSecondary, 0, self, "AccentSecondary")
        optionStroke.Thickness = 1
        optionStroke.LineJoinMode = Enum.LineJoinMode.Round
        optionStroke.Transparency = selected and 0 or 1
        self:_button(optionFrame, "", function()
            if isPlayerDropdown then
                if optionValue.Parent == Players then
                    local selectedPlayers = component:GetValue()
                    local selectedIndex = table.find(selectedPlayers, optionValue)
                    if selectedIndex then
                        table.remove(selectedPlayers, selectedIndex)
                    else
                        table.insert(selectedPlayers, optionValue)
                    end
                    component:SetValue(selectedPlayers)
                    component:_changed(selectedPlayers, true)
                end
                self:_showOptions(component, false)
                return
            end
            if multiple then
                local values = shallowCopy(component._value)
                local existing
                for i, current in ipairs(values) do
                    if current == optionValue then
                        existing = i
                        break
                    end
                end
                if existing then
                    table.remove(values, existing)
                else
                    table.insert(values, optionValue)
                end
                component:SetValue(values)
                component:_changed(values, true)
                self:_closeOverlay()
                self:_showOptions(component, true)
            else
                component:SetValue(optionValue)
                component:_changed(optionValue, true)
                self:_closeOverlay()
            end
        end, {
            Background = self.Theme.ControlSurface,
            BackgroundTransparency = 1,
            Owner = self._overlayOwner,
            Size = UDim2.fromScale(1, 1),
            Height = optionHeight - 4,
            HoverRole = "ControlHover",
            HoverStrokeTransparency = 1,
            PaddingLeft = isPlayerDropdown and 50 or 10,
            PaddingRight = 10,
            PreserveRadius = true,
            Radius = 6,
            Role = "ControlSurface",
            Stroke = self.Theme.ControlSurface,
            StrokeTransparency = 1,
            TextColor = self.Theme.TextSecondary,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = false,
            ZIndex = 105,
        })
        if isPlayerDropdown then
            local avatar = make("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = self.Theme.ControlTrack,
                BorderSizePixel = 0,
                Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", optionValue.UserId),
                Position = UDim2.new(0, 7, 0.5, 0),
                Size = UDim2.fromOffset(38, 38),
                ZIndex = 106,
            }, optionFrame)
            addCorner(avatar, 19, self, true)
            local isLocalPlayer = optionValue == LocalPlayer
            self:_text(optionFrame, optionValue.DisplayName, {
                Active = false,
                Position = UDim2.new(0, 52, 0, 6),
                Size = UDim2.new(1, isLocalPlayer and -104 or -62, 0, 19),
                Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.TextPrimary,
                TextSize = 13,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextWrapped = false,
                ZIndex = 106,
            })
            if isLocalPlayer then
                self:_text(optionFrame, self:_resolveText("YOU"), {
                    Active = false,
                    Position = UDim2.new(1, -44, 0, 7),
                    Size = UDim2.fromOffset(36, 16),
                    Font = Enum.Font.GothamBold,
                    TextColor3 = self.Theme.AccentSecondary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextWrapped = false,
                    ZIndex = 106,
                })
            end
            self:_text(optionFrame, "@" .. optionValue.Name, {
                Active = false,
                Position = UDim2.new(0, 52, 0, 26),
                Size = UDim2.new(1, -62, 0, 16),
                TextColor3 = self.Theme.TextMuted,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextWrapped = false,
                ZIndex = 106,
            })
        else
            self:_text(optionFrame, tostring(optionValue), {
                Active = false,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                TextColor3 = self.Theme.TextSecondary,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextWrapped = false,
                ZIndex = 106,
            })
        end
    end
end

function SectionMethods:Dropdown(config)
    validConfig(config, "Dropdown")
    assert(type(config.Options) == "table" and #config.Options > 0, "Dropdown.Options must be a non-empty array")
    assert(config.Callback == nil or type(config.Callback) == "function", "Dropdown.Callback must be a function")
    for _, option in ipairs(config.Options) do
        assert(type(option) == "string", "Dropdown options must be strings")
    end
    local component = self:_row(config, "Dropdown")
    component._options = shallowCopy(config.Options)
    local initial = config.Default
    if initial == nil then
        initial = component._options[1]
    end
    newControlButton(component, tostring(initial), function()
        if component.Enabled then
            component._window:_showOptions(component, false)
        end
    end, nil, {
        PaddingRight = 40,
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    component._dropdownIcon = self._window:_icon(component._body, "chevron-down", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        TextColor3 = self._window.Theme.TextMuted,
        TextSize = 14,
        ZIndex = component._button.ZIndex + 1,
    }, "v")
    component:SetValue(initial)
    return component
end

function SectionMethods:PlayerDropdown(config)
    validConfig(config, "PlayerDropdown")
    assert(config.Id == nil, "PlayerDropdown selections are runtime-only and cannot have a persistent Id")
    assert(config.Default == nil, "PlayerDropdown does not support a default selection")
    assert(config.Callback == nil or type(config.Callback) == "function", "PlayerDropdown.Callback must be a function")
    assert(config.ExcludeLocalPlayer == nil or type(config.ExcludeLocalPlayer) == "boolean",
        "PlayerDropdown.ExcludeLocalPlayer must be a boolean")

    local controlConfig = shallowCopy(config)
    controlConfig.Id = nil
    local component = self:_row(controlConfig, "PlayerDropdown")
    component._excludeLocalPlayer = config.ExcludeLocalPlayer == true
    component._placeholder = config.Placeholder or "Select a player..."
    component._emptyText = self._window:_resolveText(config.EmptyText or "No players are currently available.")
    component._options = {}
    component._value = {}

    local function refreshOptions(removedPlayer)
        if component._destroyed or self._window._destroyed then
            return
        end
        component._options = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= removedPlayer and not (component._excludeLocalPlayer and player == LocalPlayer) then
                table.insert(component._options, player)
            end
        end
        table.sort(component._options, function(first, second)
            local firstName = string.lower(first.DisplayName)
            local secondName = string.lower(second.DisplayName)
            return firstName == secondName and string.lower(first.Name) < string.lower(second.Name)
                or firstName < secondName
        end)

        if #component._value > 0 then
            local remaining = {}
            local removedSelected = false
            for _, selectedPlayer in ipairs(component._value) do
                if selectedPlayer == removedPlayer or selectedPlayer.Parent ~= Players then
                    removedSelected = true
                else
                    table.insert(remaining, selectedPlayer)
                end
            end
            if removedSelected then
                component:SetValue(remaining)
                component:_changed(remaining, true)
            end
        end
        if self._window._openOverlayComponent == component then
            self._window:_showOptions(component, false)
        end
    end

    refreshOptions()
    newControlButton(component, self._window:_resolveText(component._placeholder), function()
        if component.Enabled then
            refreshOptions()
            component._window:_showOptions(component, false)
        end
    end, nil, {
        Background = self._window.Theme.ControlInset,
        PaddingLeft = 12,
        PaddingRight = 0,
        Role = "ControlInset",
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    component._button.LayoutOrder = 1
    component._selectedList = make("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = component._button.ZIndex,
    }, component._body)
    component._playerGrid = make("UIGridLayout", {
        CellPadding = UDim2.fromOffset(6, 6),
        CellSize = UDim2.fromOffset(160, 40),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, component._selectedList)
    component._layoutPlayerBadges = function()
        if component._destroyed or not component._selectedList.Parent then
            return
        end
        local scale = self._window._contentScale.Scale
        local gap = 6
        local scaledGap = gap * scale
        local scaledWidth = component._selectedList.AbsoluteSize.X
        if scaledWidth <= 0 then
            return
        end
        local minCellWidth = 160
        local columns = math.max(1, math.min(4, math.floor((scaledWidth + scaledGap) / (minCellWidth * scale + scaledGap))))
        local width = scaledWidth / scale
        local cellWidth = (width - gap * (columns - 1)) / columns
        component._playerGrid.CellSize = UDim2.new(0, cellWidth, 0, 40)
        local rows = math.ceil(#component._value / columns)
        local height = rows > 0 and rows * 40 + (rows - 1) * gap or 0
        component._selectedList.Size = UDim2.new(1, 0, 0, height)
    end
    self._window:_connect(component._selectedList:GetPropertyChangedSignal("AbsoluteSize"), component._layoutPlayerBadges, component)
    make("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, component._body)
    component._dropdownIcon = self._window:_icon(component._button, "chevron-down", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        TextColor3 = self._window.Theme.TextMuted,
        TextSize = 14,
        ZIndex = component._button.ZIndex + 1,
    }, "v")
    component._playerBadgeConnections = {}
    component:SetValue({})
    task.defer(component._layoutPlayerBadges)

    self._window:_connect(Players.PlayerAdded, function()
        task.defer(refreshOptions)
    end, component)
    self._window:_connect(Players.PlayerRemoving, function(player)
        task.defer(refreshOptions, player)
    end, component)
    task.defer(refreshOptions)

    return component
end

function SectionMethods:MultiDropdown(config)
    validConfig(config, "MultiDropdown")
    assert(type(config.Options) == "table" and #config.Options > 0, "MultiDropdown.Options must be a non-empty array")
    assert(config.Callback == nil or type(config.Callback) == "function", "MultiDropdown.Callback must be a function")
    for _, option in ipairs(config.Options) do
        assert(type(option) == "string", "MultiDropdown options must be strings")
    end
    local component = self:_row(config, "MultiDropdown")
    component._options = shallowCopy(config.Options)
    local initial = config.Default or {}
    newControlButton(component, "Select...", function()
        if component.Enabled then
            component._window:_showOptions(component, true)
        end
    end, nil, {
        PaddingRight = 40,
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    component._dropdownIcon = self._window:_icon(component._body, "chevron-down", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        TextColor3 = self._window.Theme.TextMuted,
        TextSize = 14,
        ZIndex = component._button.ZIndex + 1,
    }, "v")
    component:SetValue(initial)
    return component
end

function SectionMethods:Input(config)
    validConfig(config, "Input")
    assert(config.Callback == nil or type(config.Callback) == "function", "Input.Callback must be a function")
    assert(config.Live == nil or type(config.Live) == "boolean", "Input.Live must be a boolean")
    local component = self:_row(config, "Input")
    local window = self._window
    local input = make("TextBox", {
        BackgroundColor3 = window.Theme.ControlSurface,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderColor3 = window.Theme.TextMuted,
        PlaceholderText = window:_resolveText(config.Placeholder or ""),
        Size = UDim2.new(1, 0, 0, 44),
        Text = safeString(config.Default),
        TextColor3 = window.Theme.TextPrimary,
        TextSize = 14,
        ZIndex = 8,
    }, component._body)
    window:_trackTheme(input, "ControlSurface", "BackgroundColor3")
    component._input = input
    if type(config.Placeholder) == "string" or (type(config.Placeholder) == "table" and config.Placeholder.Key) then
        table.insert(window._localized, {Object = input, Value = config.Placeholder, Property = "PlaceholderText"})
    end
    addCorner(input, 9, window)
    component._inputStroke = addStroke(input, window.Theme.ControlBorder, 0.35, window, "ControlBorder")
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, input)
    window:_connect(input.Focused, function()
        window:_trackTheme(input, "ControlHover", "BackgroundColor3")
        window:_trackTheme(component._inputStroke, "BorderActive", "Color")
        TweenService:Create(component._inputStroke, TweenInfo.new(0.14), {
            Color = window.Theme.BorderActive,
            Transparency = 0.1,
        }):Play()
        TweenService:Create(input, TweenInfo.new(0.14), {
            BackgroundColor3 = window.Theme.ControlHover,
        }):Play()
    end, component)
    component._errorLabel = window:_text(component._body, "", {
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 0, 32),
        TextColor3 = window.Theme.Danger,
        TextSize = 12,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Visible = false,
        ZIndex = 8,
    })
    component._value = safeString(config.Default)
    if config.MaxLength then
        assert(type(config.MaxLength) == "number" and config.MaxLength >= 1, "Input.MaxLength must be positive")
    end
    if config.Numeric then
        input.ClearTextOnFocus = false
    end
    local function commit()
        local value = input.Text
        if config.Numeric and value ~= "" and tonumber(value) == nil then
            component:SetError("Enter a valid number")
            return
        end
        component:SetError(nil)
        component:_changed(value, true)
    end
    window:_connect(input.FocusLost, function()
        if not config.Live then
            commit()
        end
        local strokeRole = component._errorLabel.Visible and "Danger" or "ControlBorder"
        window:_trackTheme(component._inputStroke, strokeRole, "Color")
        component._inputStroke.Color = window.Theme[strokeRole]
        component._inputStroke.Transparency = component._errorLabel.Visible and 0.1 or 0.35
        window:_trackTheme(input, "ControlSurface", "BackgroundColor3")
        TweenService:Create(input, TweenInfo.new(0.14), {
            BackgroundColor3 = window.Theme.ControlSurface,
        }):Play()
    end, component)
    if config.Live or config.MaxLength then
        window:_connect(input:GetPropertyChangedSignal("Text"), function()
            if config.MaxLength and textLength(input.Text) > config.MaxLength then
                input.Text = truncateText(input.Text, config.MaxLength)
            end
            if config.Live then
                component:_changed(input.Text, true)
            end
        end, component)
    end
    return component
end

function SectionMethods:Keybind(config)
    validConfig(config, "Keybind")
    assert(config.Callback == nil or type(config.Callback) == "function", "Keybind.Callback must be a function")
    local default = config.Default or Enum.KeyCode.Unknown
    assert(isKeyCode(default), "Keybind.Default must be an Enum.KeyCode")
    local component = self:_row(config, "Keybind")
    local window = self._window
    component._keyCode = default
    component.Callback = config.Callback
    component._button = newControlButton(component, "Change key", function()
        component._capturing = true
        component._keyBadge.Text = "PRESS KEY"
    end, 44, {
        PaddingRight = 100,
    })
    local keyBadge = make("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = window.Theme.ControlSurface,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 76, 0, 30),
        ZIndex = 11,
    }, component._body)
    addCorner(keyBadge, 7, window)
    window:_trackTheme(keyBadge, "ControlSurface", "BackgroundColor3")
    addStroke(keyBadge, window.Theme.ControlBorder, 0.6, window, "ControlBorder")
    component._keyBadge = window:_text(keyBadge, default.Name, {
        Font = Enum.Font.GothamMedium,
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 12,
    })
    self._window:_connect(UserInputService.InputBegan, function(input, processed)
        if processed or isTextFocused() then
            return
        end
        if component._capturing then
            if input.KeyCode == Enum.KeyCode.Escape then
                component._capturing = false
                component._keyBadge.Text = component._keyCode.Name
                return
            end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                component._capturing = false
                component:SetValue(input.KeyCode)
                component:_changed(input.KeyCode, true)
            end
        end
    end, component)
    component:SetValue(default)
    table.insert(self._window._keybinds, component)
    return component
end

function SectionMethods:Colorpicker(config)
    validConfig(config, "Colorpicker")
    assert(config.Callback == nil or type(config.Callback) == "function", "Colorpicker.Callback must be a function")
    local component = self:_row(config, "Colorpicker")
    local window = self._window
    local initial = config.Default or window.Theme.Accent
    local colorButton
    colorButton = newControlButton(component, "Choose color", function()
        window:_closeOverlay()
        local overlay = window:_createOverlay()
        window._openOverlayComponent = component
        local scale = window._contentScale.Scale
        local panelSize = window._panel.AbsoluteSize / scale
        local popupWidth = math.min(360, panelSize.X - 24)
        local popupHeight = math.min(296, panelSize.Y - 24)
        local buttonPosition = (colorButton.AbsolutePosition - window._panel.AbsolutePosition) / scale
        local buttonSize = colorButton.AbsoluteSize / scale
        local popupX = clamp(
            buttonPosition.X,
            12,
            panelSize.X - popupWidth - 12
        )
        local popupY = buttonPosition.Y + buttonSize.Y + 6
        if popupY + popupHeight > panelSize.Y - 12 then
            popupY = buttonPosition.Y - popupHeight - 6
        end
        popupY = clamp(popupY, 12, panelSize.Y - popupHeight - 12)
        local outside = make("TextButton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            ZIndex = 100,
        }, overlay)
        window:_connect(outside.Activated, function()
            window:_closeOverlay()
        end, window._overlayOwner)
        local popup = make("Frame", {
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = window.Theme.SurfaceRaised,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(popupX, popupY),
            Size = UDim2.fromOffset(popupWidth, popupHeight),
            ZIndex = 102,
        }, overlay)
        window:_trackTheme(popup, "SurfaceRaised", "BackgroundColor3")
        addCorner(popup, 12, window)
        addStroke(popup, window.Theme.Border, 0.25, window)
        window:_text(popup, "Color picker", {
            Position = UDim2.new(0, 14, 0, 12),
            Size = UDim2.new(1, -28, 0, 22),
            Font = Enum.Font.GothamBold,
            ZIndex = 103,
        })
        local color = component._value or initial
        local hue, saturation, brightness = color:ToHSV()
        local colorMap = make("Frame", {
            BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Position = UDim2.new(0, 14, 0, 42),
            Size = UDim2.new(1, -28, 0, 142),
            ZIndex = 104,
        }, popup)
        addCorner(colorMap, 7)
        addStroke(colorMap, window.Theme.Border, 0.35, window)
        local saturationLayer = make("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 105,
        }, colorMap)
        make("UIGradient", {
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, saturationLayer)
        local brightnessLayer = make("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 106,
        }, colorMap)
        make("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
        }, brightnessLayer)
        local mapPointer = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(saturation, 0, 1 - brightness, 0),
            Size = UDim2.fromOffset(14, 14),
            ZIndex = 108,
        }, colorMap)
        addCorner(mapPointer, 7, nil, true)
        addStroke(mapPointer, Color3.new(1, 1, 1), 0, nil)
        local mapHit = make("TextButton", {
            Active = true,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            ZIndex = 109,
        }, colorMap)
        mapPointer.ZIndex = 110
        local hueRail = make("Frame", {
            BackgroundColor3 = Color3.new(1, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 14, 0, 194),
            Size = UDim2.new(1, -28, 0, 16),
            ZIndex = 104,
        }, popup)
        addCorner(hueRail, 8, nil, true)
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
                ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
                ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
                ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
                ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
            }),
        }, hueRail)
        local huePointer = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Position = UDim2.new(hue, 0, 0.5, 0),
            Size = UDim2.new(0, 4, 1, 6),
            ZIndex = 108,
        }, hueRail)
        addCorner(huePointer, 2, nil, true)
        local hueHit = make("TextButton", {
            Active = true,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            ZIndex = 109,
        }, hueRail)
        huePointer.ZIndex = 110
        component._colorSwatch = make("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 14, 0, 220),
            Size = UDim2.fromOffset(34, 30),
            ZIndex = 104,
        }, popup)
        addCorner(component._colorSwatch, 7)
        local hex = make("TextBox", {
            BackgroundColor3 = window.Theme.ControlSurface,
            BorderSizePixel = 0,
            ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,
            Position = UDim2.new(0, 56, 0, 220),
            Size = UDim2.new(1, -70, 0, 30),
            Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)),
            TextColor3 = window.Theme.TextPrimary,
            TextSize = 13,
            ZIndex = 104,
        }, popup)
        window:_trackTheme(hex, "ControlSurface", "BackgroundColor3")
        component._hexInput = hex
        addCorner(hex, 8, window)
        addStroke(hex, window.Theme.ControlBorder, 0.4, window, "ControlBorder")
        make("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
        }, hex)
        local apply = window:_button(popup, "Apply", function()
            local text = string.gsub(hex.Text, "#", "")
            if #text == 6 and string.match(text, "^%x%x%x%x%x%x$") then
                local r = tonumber(string.sub(text, 1, 2), 16)
                local g = tonumber(string.sub(text, 3, 4), 16)
                local b = tonumber(string.sub(text, 5, 6), 16)
                component:SetValue(Color3.fromRGB(r, g, b))
                component:_changed(component._value, true)
                window:_closeOverlay()
            else
                warn("[AstraUI] Colorpicker expects a 6-digit hex value")
            end
        end, {
            Position = UDim2.new(0, 14, 1, -36),
            Size = UDim2.new(1, -28, 0, 28),
            Height = 28,
            Background = window.Theme.AccentSecondary,
            HoverRole = "AccentSecondary",
            Role = "AccentSecondary",
            Stroke = window.Theme.AccentSecondary,
            StrokeRole = "AccentSecondary",
            StrokeTransparency = 0.25,
            HoverStrokeTransparency = 0.1,
            TextColor = window.Theme.AccentForeground,
            ZIndex = 104,
            Owner = window._overlayOwner,
        })
        apply.Position = UDim2.new(0, 14, 1, -36)
        local function updateColorPicker(input, mode)
            if mode == "Hue" then
                hue = clamp((input.Position.X - hueRail.AbsolutePosition.X) / math.max(1, hueRail.AbsoluteSize.X), 0, 1)
                huePointer.Position = UDim2.new(hue, 0, 0.5, 0)
                colorMap.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            else
                saturation = clamp((input.Position.X - colorMap.AbsolutePosition.X) / math.max(1, colorMap.AbsoluteSize.X), 0, 1)
                brightness = 1 - clamp((input.Position.Y - colorMap.AbsolutePosition.Y) / math.max(1, colorMap.AbsoluteSize.Y), 0, 1)
                mapPointer.Position = UDim2.new(saturation, 0, 1 - brightness, 0)
            end
            local selectedColor = Color3.fromHSV(hue, saturation, brightness)
            component:SetValue(selectedColor)
            component:_changed(selectedColor, true)
        end
        window:_connect(mapHit.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                component._colorDragMode = "Map"
                updateColorPicker(input, "Map")
            end
        end, window._overlayOwner)
        window:_connect(hueHit.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                component._colorDragMode = "Hue"
                updateColorPicker(input, "Hue")
            end
        end, window._overlayOwner)
        window:_connect(UserInputService.InputChanged, function(input)
            if component._colorDragMode == "Map"
                and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorPicker(input, "Map")
            elseif component._colorDragMode == "Hue"
                and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorPicker(input, "Hue")
            end
        end, window._overlayOwner)
        window:_connect(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                component._colorDragMode = nil
            end
        end, window._overlayOwner)
    end, 44, {
        PaddingRight = 54,
    })
    component._colorButton = colorButton
    component._value = initial
    component._colorMainSwatch = make("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = initial,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 38, 0, 30),
        ZIndex = colorButton.ZIndex + 2,
    }, component._body)
    addCorner(component._colorMainSwatch, 7)
    component:SetValue(initial)
    return component
end

function SectionMethods:Paragraph(config)
    validConfig(config, "Paragraph")
    assert(config.Content ~= nil, "Paragraph.Content is required")
    local window = self._window
    local frame = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
    }, self._list)
    if config.Title then
        window:_text(frame, config.Title, {
            Size = UDim2.new(1, 0, 0, 22),
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            ZIndex = 6,
        })
    end
    local contentFrame = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, config.Title and 24 or 0),
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
    }, frame)
    window:_trackTheme(contentFrame, "StateSurface", "BackgroundColor3")
    addCorner(contentFrame, 6, window)
    addStroke(contentFrame, window.Theme.Border, 0.4, window)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 8),
    }, contentFrame)
    make("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, contentFrame)
    local content = window:_text(contentFrame, config.Content, {
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 13,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 6,
    })
    local item = self:_register({
        Id = config.Id,
        _kind = "Paragraph",
        _instance = frame,
        _window = window,
        SetContent = function(_, text)
            content.Text = window:_resolveText(text)
        end,
        Destroy = function(_, target)
            target = target or frame
            if target.Parent then
                target:Destroy()
            end
        end,
    })
    return item
end

local CONSOLE_SEVERITY_ROLES = {
    info = "TextSecondary",
    success = "Success",
    warning = "Warning",
    error = "Danger",
}

local function removeConsoleEntry(console, index)
    local entry = table.remove(console._entries, index)
    if not entry then
        return
    end
    local themeTargets = console._window._themeTargets
    for targetIndex = #themeTargets, 1, -1 do
        if themeTargets[targetIndex].Object == entry then
            table.remove(themeTargets, targetIndex)
        end
    end
    entry:Destroy()
end

function ConsoleMethods:Log(message, level)
    assert(not self._destroyed, "Cannot write to a destroyed Console")
    assert(message ~= nil, "Console:Log requires a message")
    level = level or "Info"
    assert(type(level) == "string", "Console:Log level must be a string")
    local normalizedLevel = string.lower(level)
    local themeRole = CONSOLE_SEVERITY_ROLES[normalizedLevel]
    assert(themeRole, "Console:Log level must be Info, Success, Warning, or Error")

    local window = self._window
    local entry = make("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        LayoutOrder = #self._entries + 1,
        Size = UDim2.new(1, -12, 0, 0),
        Text = "[" .. string.upper(normalizedLevel) .. "] " .. safeString(message),
        TextColor3 = window.Theme[themeRole],
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 8,
    }, self._scroll)
    window:_trackTheme(entry, themeRole, "TextColor3")
    table.insert(self._entries, entry)
    while #self._entries > self._maxEntries do
        removeConsoleEntry(self, 1)
    end

    local scroll = self._scroll
    task.defer(function()
        if not self._destroyed and scroll.Parent then
            local maxY = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteSize.Y)
            scroll.CanvasPosition = Vector2.new(0, maxY)
        end
    end)
    return self
end

function ConsoleMethods:Clear()
    for index = #self._entries, 1, -1 do
        removeConsoleEntry(self, index)
    end
    if self._scroll and self._scroll.Parent then
        self._scroll.CanvasPosition = Vector2.zero
    end
    return self
end

function ConsoleMethods:Destroy()
    if self._destroyed then
        return
    end
    self:Clear()
    ControlMethods.Destroy(self)
end

function SectionMethods:Console(config)
    config = config or {}
    validConfig(config, "Console")
    assert(config.Height == nil or (type(config.Height) == "number" and config.Height > 0 and config.Height < math.huge), "Console.Height must be a positive number")
    assert(config.MaxEntries == nil or (type(config.MaxEntries) == "number" and config.MaxEntries >= 1 and config.MaxEntries < math.huge and config.MaxEntries == math.floor(config.MaxEntries)), "Console.MaxEntries must be a positive integer")

    local component = self:_row(config, "Console")
    setmetatable(component, ConsoleMethods)
    component._entries = {}
    component._maxEntries = config.MaxEntries or 100

    local window = self._window
    local panel = make("Frame", {
        BackgroundColor3 = window.Theme.ControlInset,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Height or 160),
        ZIndex = 7,
    }, component._body)
    window:_trackTheme(panel, "ControlInset", "BackgroundColor3")
    addCorner(panel, 7, window)
    addStroke(panel, window.Theme.Border, 0.25, window)

    component._scroll = make("ScrollingFrame", {
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Position = UDim2.fromOffset(8, 8),
        ScrollBarImageColor3 = window.Theme.AccentSecondary,
        ScrollBarThickness = 3,
        Size = UDim2.new(1, -16, 1, -16),
        ZIndex = 7,
    }, panel)
    window:_trackTheme(component._scroll, "StateSurface", "BackgroundColor3")
    window:_trackTheme(component._scroll, "AccentSecondary", "ScrollBarImageColor3")
    addCorner(component._scroll, 5, window)
    addStroke(component._scroll, window.Theme.Border, 0.4, window)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
        PaddingTop = UDim.new(0, 7),
    }, component._scroll)
    make("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, component._scroll)
    return component
end

function SectionMethods:Divider(config)
    config = config or {}
    local line = make("Frame", {
        BackgroundColor3 = self._window.Theme.Border,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 5,
    }, self._list)
    self._window:_trackTheme(line, "Border", "BackgroundColor3")
    return self:_register({
        _kind = "Divider",
        _instance = line,
        _window = self._window,
        Destroy = function()
            if line.Parent then
                line:Destroy()
            end
        end,
    })
end

function SectionMethods:Progress(config)
    config = config or {}
    validConfig(config, "Progress")
    assert(config.Value == nil or (type(config.Value) == "number" and config.Value >= 0 and config.Value <= 1), "Progress.Value must be in [0, 1]")
    local row = self:_row(config, "Progress")
    local window = self._window
    local track = make("Frame", {
        BackgroundColor3 = window.Theme.ControlTrack,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 8),
        Size = UDim2.new(1, 0, 0, 12),
        ZIndex = 8,
    }, row._body)
    window:_trackTheme(track, "ControlTrack", "BackgroundColor3")
    addCorner(track, 6)
    local fill = make("Frame", {
        BackgroundColor3 = window.Theme.AccentSecondary,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 9,
    }, track)
    window:_trackTheme(fill, "AccentSecondary", "BackgroundColor3")
    addCorner(fill, 6)
    local valueLabel = window:_text(row._body, "", {
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(1, 0, 0, 20),
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 12,
        ZIndex = 8,
    })
    local component = self:_register({
        Id = config.Id,
        Name = row.Name,
        _kind = "Progress",
        _window = window,
        _row = row._row,
        _fill = fill,
        _valueLabel = valueLabel,
        _indeterminate = config.Indeterminate == true,
        SetValue = function(target, value)
            assert(type(value) == "number" and value >= 0 and value <= 1, "Progress.Value must be in [0, 1]")
            target._value = value
            fill.Size = UDim2.new(value, 0, 1, 0)
            valueLabel.Text = config.ShowValue and (tostring(math.floor(value * 100 + 0.5)) .. "%") or safeString(config.Label or "")
        end,
        GetValue = function(target)
            return target._value
        end,
        Destroy = function(target)
            if target._row and target._row.Parent then
                target._row:Destroy()
            end
        end,
    })
    if component._indeterminate then
        fill.Size = UDim2.new(0.35, 0, 1, 0)
    else
        component:SetValue(config.Value or 0)
    end
    return component
end

function SectionMethods:State(config)
    validConfig(config, "State")
    assert(config.Action == nil or type(config.Action.Callback) == "function", "State.Action.Callback must be a function")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "State.Icon must be a non-empty string")
    local window = self._window
    local frame = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
    }, self._list)
    window:_trackTheme(frame, "StateSurface", "BackgroundColor3")
    window:_trackLilithSurface(frame, LILITH_SURFACE_BASE_TRANSPARENCY)
    addStroke(frame, window.Theme.Border, 0.3, window, "Border")
    addCorner(frame, 12, window)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingTop = UDim.new(0, 10),
    }, frame)
    make("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)
    local titleRow = make("Frame", {
        LayoutOrder = 1,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -28, 0, 22),
        ZIndex = 6,
    }, frame)
    local title = window:_text(titleRow, config.Title or config.Type or "Notice", {
        Position = UDim2.new(0, config.Icon and 22 or 0, 0, 0),
        Size = UDim2.new(1, config.Icon and -22 or 0, 1, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 6,
    })
    if config.Icon then
        window:_icon(titleRow, config.Icon, {
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.fromOffset(16, 16),
            TextColor3 = window.Theme.AccentSecondary,
            TextSize = 15,
            ZIndex = 7,
        })
    end
    local content = window:_text(frame, config.Description or "", {
        LayoutOrder = 2,
        Size = UDim2.new(1, -28, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 6,
    })
    if config.Action then
        local actionButton = window:_button(frame, config.Action.Name or "Try again", function()
            window:_warnCallback("State action", config.Action.Callback)
        end, {
            Height = 44,
            Role = "SurfaceRaised",
            ZIndex = 7,
        })
        actionButton.LayoutOrder = 3
        actionButton.Size = UDim2.new(1, 0, 0, 44)
    end
    return self:_register({
        Id = config.Id,
        Name = window:_resolveText(config.Title or config.Type or ""),
        _kind = "State",
        _window = window,
        _instance = frame,
        SetState = function(_, kind, message)
            assert(kind == "Loading" or kind == "Empty" or kind == "Error" or kind == "Success", "Invalid State.Type")
            title.Text = kind
            content.Text = safeString(message)
        end,
        Destroy = function()
            if frame.Parent then
                frame:Destroy()
            end
        end,
    })
end

function SectionMethods:EmptyState(config)
    config = shallowCopy(config or {})
    config.Type = "Empty"
    config.Title = config.Title or "Nothing here yet"
    return self:State(config)
end

function SectionMethods:Badge(config)
    validConfig(config, "Badge")
    local window = self._window
    local themeToken = {
        Neutral = "TextMuted",
        Info = "AccentSecondary",
        Success = "Success",
        Warning = "Warning",
        Error = "Danger",
    }
    local palette = {
        Neutral = window.Theme[themeToken.Neutral],
        Info = window.Theme[themeToken.Info],
        Success = window.Theme[themeToken.Success],
        Warning = window.Theme[themeToken.Warning],
        Error = window.Theme[themeToken.Error],
    }
    assert(config.Type == nil or palette[config.Type] ~= nil, "Invalid Badge.Type")
    local badgeType = config.Type or "Neutral"
    local frame = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = window.Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, 30),
        ZIndex = 5,
    }, self._list)
    window:_trackTheme(frame, "Surface", "BackgroundColor3")
    addCorner(frame, 8, window, true)
    local outline = addStroke(frame, palette[badgeType], 0.5, window, themeToken[badgeType])
    local dot = make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = palette[badgeType],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0.5, 0),
        Size = UDim2.fromOffset(6, 6),
        ZIndex = 6,
    }, frame)
    addCorner(dot, 4, nil, true)
    local text = window:_text(frame, config.Text or "", {
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 19, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        TextColor3 = window.Theme[themeToken[badgeType]],
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 6,
    })
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 8),
    }, frame)
    local badge = self:_register({
        Id = config.Id,
        _kind = "Badge",
        _badgeType = badgeType,
        _instance = frame,
        _window = window,
        SetText = function(_, value)
            text.Text = safeString(value)
        end,
        SetType = function(target, kind)
            assert(palette[kind], "Unknown Badge.Type")
            target._badgeType = kind
            local color = window.Theme[themeToken[kind]]
            dot.BackgroundColor3 = color
            outline.Color = color
            text.TextColor3 = color
            window:_trackTheme(dot, themeToken[kind], "BackgroundColor3")
            window:_trackTheme(outline, themeToken[kind], "Color")
            window:_trackTheme(text, themeToken[kind], "TextColor3")
        end,
        Destroy = function()
            if frame.Parent then
                frame:Destroy()
            end
        end,
    })
    return badge
end

function TabMethods:Card(config)
    validConfig(config, "Card")
    assert(config.Title ~= nil, "Card.Title is required")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "Card.Icon must be a non-empty string")
    local cardSize = config.Size or "Auto"
    assert(cardSize == "Auto" or cardSize == "Small" or cardSize == "Medium" or cardSize == "Wide", "Card.Size must be Auto, Small, Medium, or Wide")
    assert(config.Height == nil or (type(config.Height) == "number" and config.Height > 0), "Card.Height must be positive")
    local window = self._window
    local layoutFrame = self._cardLayoutFrame
    if not layoutFrame then
        layoutFrame = make("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            ZIndex = 3,
        }, self._page)
        local cards = {}
        local cardLayout = function()
            if not layoutFrame.Parent then
                return
            end
            local scale = window._contentScale.Scale
            local gap = 8
            local scaledGap = gap * scale
            local scaledWidth = layoutFrame.AbsoluteSize.X
            if scaledWidth <= 0 then
                return
            end
            local cols = math.min(2, math.max(1, math.floor((scaledWidth + scaledGap) / (220 * scale + scaledGap))))
            local width = scaledWidth / scale
            local unit = (width - gap * (cols - 1)) / cols
            local rows = {}
            local currentRow = {Cards = {}, Used = 0, Height = 0}
            table.insert(rows, currentRow)
            for _, card in ipairs(cards) do
                local span = card._span == "Wide" and cols or (card._span == "Medium" and math.min(2, cols) or 1)
                if currentRow.Used + span > cols then
                    currentRow = {Cards = {}, Used = 0, Height = 0}
                    table.insert(rows, currentRow)
                end
                local cardWidth = unit * span + gap * (span - 1)
                local textWidth = math.max(120, cardWidth - (card.Icon and 64 or 40))
                local titleHeight = math.max(18, TextService:GetTextSize(card._titleLabel.Text, 12, Enum.Font.GothamMedium, Vector2.new(textWidth, 1000)).Y)
                local valueHeight = math.max(28, TextService:GetTextSize(safeString(card._value), 23, Enum.Font.GothamBold, Vector2.new(textWidth, 1000)).Y)
                local descriptionHeight = 0
                if card._descriptionLabel then
                    descriptionHeight = TextService:GetTextSize(card._descriptionLabel.Text, 11, Enum.Font.Gotham, Vector2.new(textWidth, 1000)).Y
                end
                card._height = math.max(card._baseHeight, 12 + titleHeight + 4 + valueHeight + descriptionHeight + 12)
                card._titleLabel.Size = UDim2.new(1, -(card.Icon and 64 or 40), 0, titleHeight)
                card._valueLabel.Position = UDim2.new(0, 26, 0, 12 + titleHeight + 4)
                card._valueLabel.Size = UDim2.new(1, -40, 0, valueHeight)
                if card._descriptionLabel then
                    card._descriptionLabel.Position = UDim2.new(0, 26, 0, 12 + titleHeight + 4 + valueHeight)
                    card._descriptionLabel.Size = UDim2.new(1, -40, 0, descriptionHeight)
                end
                table.insert(currentRow.Cards, {Item = card, Span = span, Column = currentRow.Used + 1})
                currentRow.Used = currentRow.Used + span
                currentRow.Height = math.max(currentRow.Height, card._height)
            end
            local totalHeight = 0
            for _, row in ipairs(rows) do
                for _, placement in ipairs(row.Cards) do
                    local card = placement.Item
                    card.Frame.Position = UDim2.new(0, (placement.Column - 1) * (unit + gap), 0, totalHeight)
                    card.Frame.Size = UDim2.new(0, unit * placement.Span + gap * (placement.Span - 1), 0, row.Height)
                end
                totalHeight = totalHeight + row.Height + gap
            end
            layoutFrame.Size = UDim2.new(1, 0, 0, math.max(0, totalHeight - gap))
            window:_updatePageCanvas(self)
        end
        self._cardLayoutFrame = layoutFrame
        self._cards = cards
        self._cardLayout = cardLayout
        table.insert(self._cardLayouts, cardLayout)
        window:_connect(layoutFrame:GetPropertyChangedSignal("AbsoluteSize"), cardLayout)
    end
    local cards = self._cards
    local cardLayout = self._cardLayout
    local frame = make("Frame", {
        BackgroundColor3 = window.Theme.StateSurface,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 220, 0, config.Height or 104),
        ZIndex = 4,
    }, layoutFrame)
    window:_trackTheme(frame, "StateSurface", "BackgroundColor3")
    window:_trackLilithSurface(frame, LILITH_SURFACE_BASE_TRANSPARENCY)
    addCorner(frame, 6, window, true)
    addStroke(frame, window.Theme.Border, 0, window, "Border")
    local accentRole = (config.Accent == "Green" or config.Accent == "Cyan") and "AccentSecondary" or (config.Accent == "None" and "Border" or "Accent")
    local accentColor = window.Theme[accentRole]
    local accent = make("Frame", {
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 14, 0, 14),
        Size = UDim2.new(0, 3, 1, -28),
        ZIndex = 5,
    }, frame)
    window:_trackTheme(accent, accentRole, "BackgroundColor3")
    addCorner(accent, 3)
    local title = window:_text(frame, config.Title or "", {
        Position = UDim2.new(0, 26, 0, 12),
        Size = UDim2.new(1, -(config.Icon and 64 or 40), 0, 20),
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        ZIndex = 5,
    })
    if config.Icon then
        window:_icon(frame, config.Icon, {
            Position = UDim2.new(1, -28, 0, 14),
            Size = UDim2.fromOffset(16, 16),
            TextColor3 = accentColor,
            TextSize = 14,
            ZIndex = 6,
        })
    end
    local value = window:_text(frame, config.Value or "", {
        Position = UDim2.new(0, 26, 0, 34),
        Size = UDim2.new(1, -40, 0, 34),
        Font = Enum.Font.GothamBold,
        TextSize = 23,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 5,
    })
    local description
    if config.Description then
        description = window:_text(frame, config.Description, {
            Position = UDim2.new(0, 26, 0, 70),
            Size = UDim2.new(1, -40, 0, 26),
            TextColor3 = window.Theme.TextMuted,
            TextSize = 11,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 5,
        })
    end
    local card
    card = window:_registerComponent({
        Id = config.Id,
        _tab = self,
        _kind = "Card",
        _window = window,
        Frame = frame,
        Icon = config.Icon,
        Description = window:_resolveText(config.Description or ""),
        _span = cardSize,
        _baseHeight = config.Height or (config.Description and 112 or 88),
        _height = config.Height or (config.Description and 112 or 88),
        _titleLabel = title,
        _valueLabel = value,
        _descriptionLabel = description,
        _value = config.Value,
        SetValue = function(target, nextValue)
            target._value = nextValue
            value.Text = safeString(nextValue)
            cardLayout()
        end,
        GetValue = function(target)
            return target._value
        end,
        Destroy = function(target)
            for index, item in ipairs(cards) do
                if item == target then
                    table.remove(cards, index)
                    break
                end
            end
            if target.Frame.Parent then
                target.Frame:Destroy()
            end
            cardLayout()
        end,
    })
    table.insert(cards, card)
    cardLayout()
    return card
end

function TabMethods:Search(config)
    return self._window:Search(config)
end

function SectionMethods:Accordion(config, build)
    validConfig(config, "Accordion")
    assert(type(build) == "function", "Accordion requires a build callback")
    local window = self._window
    local frame = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
    }, self._list)
    local layout = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)
    local isExpanded = config.DefaultOpen == true
    local content
    local headerStroke
    local headerIcon
    local updateHeaderStroke
    local updateHeaderStyle
    local header, stroke = window:_button(frame, "", function()
        isExpanded = not isExpanded
        content.Visible = isExpanded
        updateHeaderStyle()
    end, {
        Height = 42,
        Role = "Surface",
        HoverRole = "SurfaceHover",
        StrokeRole = "Border",
        Radius = 8,
        Stroke = isExpanded and window.Theme.BorderActive or window.Theme.Border,
        StrokeTransparency = isExpanded and 0.15 or 0.35,
        HoverStrokeTransparency = 0.18,
        ZIndex = 6,
    })
    header.LayoutOrder = 1
    headerStroke = stroke
    updateHeaderStroke = function()
        local role = isExpanded and "BorderActive" or "Border"
        window:_trackTheme(headerStroke, role, "Color")
        headerStroke.Color = window.Theme[role]
    end
    updateHeaderStroke()
    local headerLabel = window:_text(header, config.Name, {
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -56, 1, 0),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        ZIndex = header.ZIndex + 1,
    })
    headerIcon = window:_icon(header, "chevron-down", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -20, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        TextColor3 = window.Theme.TextMuted,
        TextSize = 14,
        Rotation = isExpanded and 180 or 0,
        ZIndex = header.ZIndex + 1,
    }, "⌄")
    updateHeaderStyle = function()
        updateHeaderStroke()
        headerStroke.Transparency = isExpanded and 0.15 or 0.35
        headerIcon.Rotation = isExpanded and 180 or 0
    end
    updateHeaderStyle()
    if type(config.Name) == "table" and config.Name.Key then
        table.insert(window._localized, {Object = headerLabel, Value = config.Name, Property = "Text"})
    end
    content = make("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = isExpanded,
        ZIndex = 6,
    }, frame)
    local contentLayout = make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 8),
    }, content)
    local divider = make("Frame", {
        BackgroundColor3 = window.Theme.Border,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 6,
    }, content)
    window:_trackTheme(divider, "Border", "BackgroundColor3")
    local innerSection = createSection(window, content, {Name = config.Name}, self._tab)
    innerSection._frame.BackgroundTransparency = 1
    local innerStroke = innerSection._frame:FindFirstChildOfClass("UIStroke")
    if innerStroke then
        innerStroke:Destroy()
    end
    innerSection._title.Parent.Visible = false
    local innerPadding = innerSection._frame:FindFirstChildOfClass("UIPadding")
    if innerPadding then
        innerPadding:Destroy()
    end
    innerSection._frame.LayoutOrder = 2
    innerSection._frame.Size = UDim2.new(1, 0, 0, 0)
    local ok, err = pcall(build, innerSection)
    if not ok then
        warn("[AstraUI] Accordion build failed: " .. tostring(err))
    end
    window:_connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if self._tab then
            window:_updatePageCanvas(self._tab)
        end
    end)
    window:_connect(innerSection._layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if self._tab then
            window:_updatePageCanvas(self._tab)
        end
    end)
    window:_connect(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if self._tab then
            window:_updatePageCanvas(self._tab)
        end
    end)
    local accordion = self:_register({
        Id = config.Id,
        Name = window:_resolveText(config.Name),
        _kind = "Accordion",
        _window = window,
        _instance = frame,
        SetExpanded = function(_, expanded)
            assert(type(expanded) == "boolean", "SetExpanded expects a boolean")
            isExpanded = expanded
            content.Visible = expanded
            updateHeaderStyle()
        end,
        Destroy = function()
            frame:Destroy()
        end,
    })
    return accordion
end

function SectionMethods:Custom(config)
    validConfig(config, "Custom")
    assert(type(config.Build) == "function", "Custom.Build must be a function")
    assert(type(config.Height) == "number" and config.Height > 0, "Custom.Height must be positive")
    local window = self._window
    local host = make("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, config.Height),
        ZIndex = 5,
    }, self._list)
    local cleanups = {}
    local context = {
        GetTheme = function()
            return shallowCopy(window.Theme)
        end,
        GetLayoutMode = function()
            return window._narrow and "Narrow" or (window._compact and "Compact" or "Wide")
        end,
        RegisterCleanup = function(_, cleanup)
            assert(type(cleanup) == "function", "RegisterCleanup expects a function")
            table.insert(cleanups, cleanup)
        end,
    }
    local ok, root, cleanup = pcall(config.Build, host, context)
    if not ok then
        host:Destroy()
        error("Custom.Build failed: " .. tostring(root))
    end
    assert(root and root:IsA("GuiObject"), "Custom.Build must return a GuiObject")
    root.Parent = host
    if cleanup then
        assert(type(cleanup) == "function", "Custom cleanup must be a function")
        table.insert(cleanups, cleanup)
    end
    return self:_register({
        Id = config.Id,
        _kind = "Custom",
        _window = window,
        _instance = host,
        _cleanup = function()
            for _, callback in ipairs(cleanups) do
                local cleanupOk, cleanupError = pcall(callback)
                if not cleanupOk then
                    warn("[AstraUI] Custom cleanup failed: " .. tostring(cleanupError))
                end
            end
        end,
        Destroy = function(target)
            if target._cleanup then
                target._cleanup()
                target._cleanup = nil
            end
            if host.Parent then
                host:Destroy()
            end
        end,
    })
end

function WindowMethods:Search(config)
    config = config or {}
    validConfig(config, "Search")
    assert(config.Icon == nil or (type(config.Icon) == "string" and config.Icon ~= ""), "Search.Icon must be a non-empty string")
    if self._search then
        return self._search
    end
    local searchFrame = make("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.new(1, -12, 0, 34),
        ZIndex = 14,
    }, self._tabList)
    local searchSurface = make("Frame", {
        BackgroundColor3 = self.Theme.ControlSurface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 14,
    }, searchFrame)
    self:_trackTheme(searchSurface, "ControlSurface", "BackgroundColor3")
    addCorner(searchSurface, 8, self)
    local searchStroke = addStroke(searchSurface, self.Theme.AccentSecondary, 0.2, self, "AccentSecondary")
    local input = make("TextBox", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderColor3 = self.Theme.TextMuted,
        PlaceholderText = self:_resolveText(config.Placeholder or "Search"),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 13,
        ZIndex = 15,
    }, searchSurface)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 34),
        PaddingRight = UDim.new(0, 12),
    }, input)
    local iconName = config.Icon or "search"
    local searchIcon = self:_icon(searchSurface, iconName, {
        Position = UDim2.new(0, 4, 0, 0),
        Size = UDim2.new(0, 22, 1, 0),
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 16,
    }, "⌕")
    local resultFrame = make("Frame", {
        BackgroundColor3 = self.Theme.ControlSurface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, 5),
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
        ZIndex = 90,
    }, searchFrame)
    self:_trackTheme(resultFrame, "ControlSurface", "BackgroundColor3")
    resultFrame.AutomaticSize = Enum.AutomaticSize.Y
    addCorner(resultFrame, 9, self)
    addStroke(resultFrame, self.Theme.Border, 0.3, self)
    make("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 6),
    }, resultFrame)
    local resultsLayout = make("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, resultFrame)
    local search = setmetatable({
        _window = self,
        _frame = searchFrame,
        _input = input,
        _icon = searchIcon,
        _stroke = searchStroke,
        _results = resultFrame,
        _layout = resultsLayout,
        _connections = {},
    }, SearchMethods)
    self._search = search
    if type(config.Placeholder) == "string" or (type(config.Placeholder) == "table" and config.Placeholder.Key) then
        table.insert(self._localized, {Object = input, Value = config.Placeholder, Property = "PlaceholderText"})
    end
    self:_connect(input:GetPropertyChangedSignal("Text"), function()
        search:_update()
    end, search)
    self:_connect(input.Focused, function()
        self:_trackTheme(searchStroke, "BorderActive", "Color")
        local colorProperty = searchIcon:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
        TweenService:Create(searchStroke, TweenInfo.new(0.14), {
            Color = self.Theme.BorderActive,
            Transparency = 0,
        }):Play()
        TweenService:Create(searchIcon, TweenInfo.new(0.14), {[colorProperty] = self.Theme.TextSecondary}):Play()
    end, search)
    self:_connect(input.FocusLost, function()
        self:_trackTheme(searchStroke, "AccentSecondary", "Color")
        local colorProperty = searchIcon:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
        TweenService:Create(searchStroke, TweenInfo.new(0.14), {
            Color = self.Theme.AccentSecondary,
            Transparency = 0.2,
        }):Play()
        TweenService:Create(searchIcon, TweenInfo.new(0.14), {[colorProperty] = self.Theme.TextSecondary}):Play()
    end, search)
    self:_connect(UserInputService.InputBegan, function(inputObject)
        if inputObject.KeyCode == Enum.KeyCode.Escape and resultFrame.Visible then
            input.Text = ""
            resultFrame.Visible = false
        end
    end, search)
    self:_setResponsiveLayout()
    return search
end

function SearchMethods:Destroy()
    for _, connection in ipairs(self._connections or {}) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    for _, connection in ipairs(self._resultConnections or {}) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    if self._frame and self._frame.Parent then
        self._frame:Destroy()
    end
    if self._window._search == self then
        self._window._search = nil
    end
end

function SearchMethods:_update()
    local window = self._window
    local trimmedText = string.gsub(self._input.Text, "^%s*(.-)%s*$", "%1")
    local query = string.lower(trimmedText)
    for _, connection in ipairs(self._resultConnections or {}) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    self._resultConnections = {}
    local owner = {_connections = self._resultConnections}
    for _, child in ipairs(self._results:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    if query == "" then
        self._results.Visible = false
        return
    end
    local matches = 0
    for _, component in ipairs(window._components) do
        local haystack = string.lower((component.Name or "") .. " " .. (component.Description or ""))
        if component.Name and string.find(haystack, query, 1, true) then
            matches = matches + 1
            local target = component
            window:_button(self._results, component.Name, function()
                local tab = target._section and target._section._tab or target._tab
                if tab then
                    window:_selectTab(tab)
                end
                self._input:ReleaseFocus()
                self._input.Text = ""
                self._results.Visible = false
                local row = target._row or target.Frame or target._instance
                local targetTab = target._section and target._section._tab or target._tab
                if row and row.Parent and targetTab then
                    local page = targetTab._page
                    page.CanvasPosition = Vector2.new(
                        0,
                        math.max(0, row.AbsolutePosition.Y - page.AbsolutePosition.Y) / window._contentScale.Scale
                    )
                end
            end, {
                Background = window.Theme.Surface,
                Height = 42,
                PaddingLeft = 12,
                Role = "Surface",
                StrokeTransparency = 1,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 91,
                Owner = owner,
            })
        end
    end
    if matches == 0 then
        window:_text(self._results, "No results", {
            LayoutOrder = 1,
            Size = UDim2.new(1, -20, 0, 36),
            Position = UDim2.new(0, 10, 0, 0),
            TextColor3 = window.Theme.TextMuted,
            TextSize = 12,
            ZIndex = 91,
        })
    end
    self._results.Visible = true
end

loadRestoreImage = function(
    window,
    imageUrl,
    configuredPngDecoder,
    pngDecoderUrl,
    targetImage,
    configuredJpegDecoder,
    jpegDecoderUrl
)
    targetImage = targetImage or window._restoreImageLabel
    local generation = invalidatePngLoad(window, targetImage)
    if targetImage == window._customThemePngBackgroundImage
        or targetImage == window._lilithBackgroundImage then
        window:_setBackgroundLoading(targetImage, true)
    end
    local function isCurrentRequest()
        return window._pngLoadGenerations[targetImage] == generation
    end
    task.spawn(function()
        local editableImage
        local ok, err = pcall(function()
            assert(type(buffer) == "table" and type(buffer.fromstring) == "function", "buffer.fromstring is unavailable")
            local encoded = game:HttpGet(imageUrl)
            assert(not window._destroyed and isCurrentRequest(), "Image loading cancelled")
            assert(type(encoded) == "string" and #encoded >= 4 and #encoded <= 8 * 1024 * 1024,
                "Image data is empty or exceeds 8 MB")

            local imageFormat
            if string.sub(encoded, 1, 8) == "\137PNG\13\10\26\10" then
                imageFormat = "png"
            elseif string.sub(encoded, 1, 2) == "\255\216" then
                imageFormat = "jpeg"
            else
                error("Image URL did not return a PNG or JPEG")
            end

            local decoderName = if imageFormat == "png" then "PNG" else "JPEG"
            local headerWidth, headerHeight
            if imageFormat == "png" then
                assert(#encoded >= 24, "PNG data is truncated")
                local function readBigEndian(offset)
                    return (((string.byte(encoded, offset) * 256 + string.byte(encoded, offset + 1)) * 256
                        + string.byte(encoded, offset + 2)) * 256 + string.byte(encoded, offset + 3))
                end
                headerWidth, headerHeight = readBigEndian(17), readBigEndian(21)
            else
                local offset = 3
                while offset <= #encoded do
                    assert(string.byte(encoded, offset) == 0xFF, "invalid JPEG marker alignment")
                    while offset <= #encoded and string.byte(encoded, offset) == 0xFF do
                        offset += 1
                    end
                    assert(offset <= #encoded, "unexpected end before JPEG marker")
                    local marker = string.byte(encoded, offset)
                    offset += 1
                    if marker == 0xD8 or marker == 0x01 or (marker >= 0xD0 and marker <= 0xD7) then
                        continue
                    end
                    assert(offset + 1 <= #encoded, "truncated JPEG segment")
                    local segmentLength = string.byte(encoded, offset) * 256 + string.byte(encoded, offset + 1)
                    assert(segmentLength >= 2 and offset + segmentLength - 1 <= #encoded, "invalid JPEG segment length")
                    if marker == 0xC0 then
                        assert(segmentLength >= 8 and string.byte(encoded, offset + 2) == 8,
                            "only baseline 8-bit JPEG images are supported")
                        headerHeight = string.byte(encoded, offset + 3) * 256 + string.byte(encoded, offset + 4)
                        headerWidth = string.byte(encoded, offset + 5) * 256 + string.byte(encoded, offset + 6)
                        break
                    elseif marker == 0xC2 then
                        error("progressive JPEG is not supported")
                    end
                    offset += segmentLength
                end
                assert(headerWidth and headerHeight, "JPEG frame header was not found")
            end
            assert(headerWidth > 0 and headerHeight > 0 and headerWidth <= 4096 and headerHeight <= 4096
                and headerWidth * headerHeight <= 4 * 1024 * 1024,
                decoderName .. " dimensions exceed the supported 4096 x 4096 pixel limit")

            local decoder = if imageFormat == "png" then configuredPngDecoder else configuredJpegDecoder
            local decoderUrl = if imageFormat == "png" then pngDecoderUrl else jpegDecoderUrl
            local incompatibleModules = {}
            local scriptInstance = typeof(script) == "Instance" and script or nil
            if not decoder and scriptInstance then
                local roots = {}
                local seenModules = {}
                if scriptInstance.Parent then
                    table.insert(roots, scriptInstance.Parent)
                    if scriptInstance.Parent.Parent then
                        table.insert(roots, scriptInstance.Parent.Parent)
                    end
                end
                for _, root in ipairs(roots) do
                    for _, descendant in ipairs(root:GetDescendants()) do
                        if descendant:IsA("ModuleScript") and not seenModules[descendant] then
                            local moduleName = string.lower((string.gsub(descendant.Name, "[^%w]", "")))
                            local matchesFormat
                            if imageFormat == "png" then
                                matchesFormat = moduleName == "png" or moduleName == "luaupng" or moduleName == "pngluau"
                            else
                                matchesFormat = moduleName == "jpeg" or moduleName == "jpg"
                                    or moduleName == "luaujpeg" or moduleName == "jpegluau"
                            end
                            if matchesFormat then
                                seenModules[descendant] = true
                                local candidate = require(descendant)
                                if type(candidate) == "table" and type(candidate.decode) == "function"
                                    and candidate.supportsYieldIfNeeded == true then
                                    decoder = candidate
                                    break
                                end
                                table.insert(incompatibleModules, descendant:GetFullName())
                            end
                        end
                    end
                    if decoder then
                        break
                    end
                end
            end
            if not decoder then
                if not decoderUrl then
                    local detail = #incompatibleModules > 0
                        and (" Found incompatible ModuleScript(s): " .. table.concat(incompatibleModules, ", ") .. ".")
                        or ""
                    if imageFormat == "png" then
                        error("Add the updated yielding PNG decoder as a sibling ModuleScript named 'png' or 'luau-png', pass PngDecoder, or set PngDecoderUrl." .. detail)
                    else
                        error("Add jpeg.luau as a sibling ModuleScript named 'jpeg' or 'jpg', pass JpegDecoder, or set JpegDecoderUrl." .. detail)
                    end
                end
                assert(type(loadstring) == "function", "loadstring is unavailable")
                local decoderSource = game:HttpGet(decoderUrl)
                assert(type(decoderSource) == "string" and decoderSource ~= "", "Unable to download " .. decoderName .. " decoder")
                if imageFormat == "jpeg" and string.find(decoderSource, "local JPEG = {", 1, true)
                    and not string.match(decoderSource, "%sreturn%s+JPEG%s*$") then
                    -- jpeg.luau keeps its module return conditional so it can also be concatenated with the test script.
                    decoderSource = decoderSource .. "\nreturn JPEG"
                end
                local decoderChunk, compileError = loadstring(decoderSource)
                assert(type(decoderChunk) == "function",
                    "Unable to compile " .. decoderName .. " decoder: " .. tostring(compileError))
                decoder = decoderChunk()
            end
            assert(type(decoder) == "table" and type(decoder.decode) == "function",
                decoderName .. " decoder must expose decode(buffer)")
            assert(decoder.supportsYieldIfNeeded == true,
                decoderName .. " decoder must support cooperative yielding (supportsYieldIfNeeded = true)")
            if imageFormat == "png" then
                window._pngDecoder = decoder
            else
                window._jpegDecoder = decoder
            end

            local lastYield = os.clock()
            local decoded = decoder.decode(buffer.fromstring(encoded), {
                yieldIfNeeded = function()
                    if window._destroyed or not isCurrentRequest() then
                        error("Image loading cancelled")
                    end
                    if os.clock() - lastYield >= 1 / 60 then
                        lastYield = os.clock()
                        task.wait()
                    end
                end,
            })
            assert(type(decoded) == "table" and type(decoded.width) == "number"
                and type(decoded.height) == "number" and typeof(decoded.pixels) == "buffer",
                decoderName .. " decoder returned invalid image data")
            local width, height = decoded.width, decoded.height
            assert(width > 0 and height > 0 and width <= 4096 and height <= 4096
                and width * height <= 4 * 1024 * 1024,
                decoderName .. " dimensions exceed the supported 4096 x 4096 pixel limit")
            assert(width == headerWidth and height == headerHeight, decoderName .. " decoder returned invalid dimensions")
            if window._destroyed or not isCurrentRequest() or not targetImage or not targetImage.Parent then
                return
            end

            local maxDimension = targetImage == window._restoreImageLabel and 256 or 1023
            local scale = math.min(1, maxDimension / math.max(width, height))
            local outputWidth = math.max(1, math.floor(width * scale))
            local outputHeight = math.max(1, math.floor(height * scale))
            local outputPixels = decoded.pixels
            if outputWidth ~= width or outputHeight ~= height then
                outputPixels = buffer.create(outputWidth * outputHeight * 4)
                for y = 0, outputHeight - 1 do
                    local sourceY = math.min(height - 1, math.floor(y * height / outputHeight))
                    for x = 0, outputWidth - 1 do
                        local sourceX = math.min(width - 1, math.floor(x * width / outputWidth))
                        buffer.copy(outputPixels, (y * outputWidth + x) * 4, decoded.pixels, (sourceY * width + sourceX) * 4, 4)
                    end
                    if os.clock() - lastYield >= 1 / 60 then
                        if window._destroyed or not isCurrentRequest() then
                            error("Image loading cancelled")
                        end
                        lastYield = os.clock()
                        task.wait()
                    end
                end
            end
            if window._destroyed or not isCurrentRequest() or not targetImage.Parent then
                return
            end
            editableImage = game:GetService("AssetService"):CreateEditableImage({
                Size = Vector2.new(outputWidth, outputHeight),
            })
            assert(editableImage, "EditableImage creation is unavailable")
            editableImage:WritePixelsBuffer(Vector2.zero, Vector2.new(outputWidth, outputHeight), outputPixels)
            targetImage.ImageContent = Content.fromObject(editableImage)
            if targetImage == window._restoreImageLabel then
                window._restoreEditableImage = editableImage
                targetImage.Visible = true
                window._restoreIcon.Visible = false
            elseif targetImage == window._customThemePngBackgroundImage then
                window._customThemeEditableImage = editableImage
                cacheThemeImage(window, imageUrl, editableImage)
                targetImage.Visible = true
            else
                window._lilithEditableImage = editableImage
                window._lilithImageLoadState = "loaded"
                targetImage.Visible = window._themePreset == "Lilith"
                    and not window._customThemeBackgroundImage.Visible
                window:_applyLilithSurfaceMode()
            end
            if targetImage == window._customThemePngBackgroundImage
                or targetImage == window._lilithBackgroundImage then
                window:_setBackgroundLoading(targetImage, false)
            end
        end)
        if not ok then
            if editableImage then
                editableImage:Destroy()
            end
            if not window._destroyed and isCurrentRequest() then
                if targetImage == window._customThemePngBackgroundImage
                    or targetImage == window._lilithBackgroundImage then
                    window:_setBackgroundLoading(targetImage, false)
                end
                if targetImage == window._lilithBackgroundImage then
                    window._lilithImageLoadState = "failed"
                    window:_applyLilithSurfaceMode()
                end
                local imageName = targetImage == window._lilithBackgroundImage and "Lilith background"
                    or (targetImage == window._customThemePngBackgroundImage and "custom theme background"
                    or "restore button")
                local message = "[AstraUI] Unable to load " .. imageName .. " image: " .. tostring(err)
                warn(message)
                if targetImage == window._customThemePngBackgroundImage and window._ready then
                    window:Notify({
                        Type = "Error",
                        Title = window:_resolveText("Theme image failed"),
                        Content = tostring(err),
                        Duration = 5,
                    })
                end
            end
        end
    end)
end

function WindowMethods:_build(config)
    local parent = config.Parent
    if parent == nil then
        local getHiddenGui = gethui or get_hidden_gui
        assert(type(getHiddenGui) == "function",
            "AstraUI requires gethui(), get_hidden_gui(), or an explicit Parent")
        parent = getHiddenGui()
    end
    assert(typeof(parent) == "Instance", "AstraUI Parent must be an Instance")
    self._screenGui = make("ScreenGui", {
        DisplayOrder = 50,
        IgnoreGuiInset = false,
        Name = "AstraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)
    self._uiRoot = make("Frame", {
        AnchorPoint = Vector2.zero,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
    }, self._screenGui)
    self._contentScale = make("UIScale", {
        Scale = 1,
    }, self._uiRoot)
    local cornerSize = self.Theme.CornerRadius
    self._panel = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(self._requestedSize.X.Offset, self._requestedSize.Y.Offset),
        Visible = false,
        ZIndex = 1,
    }, self._uiRoot)
    self._panelMotionScale = make("UIScale", {
        Scale = 1,
    }, self._panel)
    self._contentGroup = make("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
    }, self._panel)
    addCorner(self._panel, cornerSize, self)
    self._panelStroke = addStroke(self._panel, self.Theme.WindowBorder, 0, self, "WindowBorder")
    self._panelStrokeTargetTransparency = self._panelStroke.Transparency
    self._panelStroke.Transparency = 1
    self:_trackTheme(self._panel, "Background", "BackgroundColor3")
    self._lilithBackgroundImage = make("ImageLabel", {
        Active = false,
        BackgroundTransparency = 1,
        ImageTransparency = 0.08,
        Position = UDim2.fromScale(0, 0),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 2,
    }, self._contentGroup)
    addCorner(self._lilithBackgroundImage, cornerSize, self)
    self._customThemeBackgroundImage = make("ImageLabel", {
        Active = false,
        BackgroundTransparency = 1,
        ImageTransparency = 0.08,
        Position = UDim2.fromScale(0, 0),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 2,
    }, self._contentGroup)
    addCorner(self._customThemeBackgroundImage, cornerSize, self)
    self._customThemePngBackgroundImage = make("ImageLabel", {
        Active = false,
        BackgroundTransparency = 1,
        ImageTransparency = 0.08,
        Position = UDim2.fromScale(0, 0),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 2,
    }, self._contentGroup)
    addCorner(self._customThemePngBackgroundImage, cornerSize, self)
    self._backgroundLoadingIndicator = make("Frame", {
        Active = false,
        BackgroundColor3 = self.Theme.SurfaceRaised,
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Selectable = false,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 90,
    }, self._contentGroup)
    self:_trackTheme(self._backgroundLoadingIndicator, "SurfaceRaised", "BackgroundColor3")
    addCorner(self._backgroundLoadingIndicator, cornerSize, self)
    self:_text(self._backgroundLoadingIndicator, "Loading background", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -32, 0, 28),
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 91,
    })
    local aurora = make("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
    }, self._contentGroup)
    self:_trackTheme(aurora, "Accent", "BackgroundColor3")
    self._auroraGradient = make("UIGradient", {
        Color = ColorSequence.new(self.Theme.Accent, self.Theme.AccentSecondary),
        Rotation = 28,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.55, 0.9),
            NumberSequenceKeypoint.new(1, 0.42),
        }),
    }, aurora)
    self._restoreButton = self:_button(self._screenGui, "", function()
        if not self._restoreWasDragged then
            self:SetVisible(not self._visibilityTarget)
        end
    end, {
        Size = UDim2.new(0, 58, 0, 58),
        Height = 58,
        HoverRole = "AccentSecondary",
        Role = "AccentSecondary",
        StrokeRole = "AccentSecondary",
        StrokeTransparency = 0.1,
        ZIndex = 200,
    })
    self._restoreButton.Position = UDim2.fromOffset(24, 72)
    self._restoreButton.Visible = true
    self._restoreButton:SetAttribute("AstraLabel", "Toggle window visibility")
    self._restoreIcon = self:_icon(self._restoreButton, "heart", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(26, 26),
        TextColor3 = self.Theme.AccentForeground,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = self._restoreButton.ZIndex + 1,
    }, "▦")
    self._restoreImageLabel = make("ImageLabel", {
        Active = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromOffset(46, 46),
        Visible = false,
        ZIndex = self._restoreButton.ZIndex + 1,
    }, self._restoreButton)
    addCorner(self._restoreImageLabel, 7, nil, true)
    local pngDecoderUrl = config.PngDecoderUrl or DEFAULT_PNG_DECODER_URL
    local jpegDecoderUrl = config.JpegDecoderUrl or DEFAULT_JPEG_DECODER_URL
    self._pngDecoder = config.PngDecoder
    self._pngDecoderUrl = pngDecoderUrl
    self._jpegDecoder = config.JpegDecoder
    self._jpegDecoderUrl = jpegDecoderUrl
    if config.RestoreImageUrl then
        loadRestoreImage(
            self,
            config.RestoreImageUrl,
            self._pngDecoder,
            self._pngDecoderUrl,
            nil,
            self._jpegDecoder,
            self._jpegDecoderUrl
        )
    end
    self._lilithImageLoadState = "idle"
    self:_connect(self._restoreButton.InputBegan, function(input)
        self:_beginRestoreButtonDrag(input)
    end)
    local header = make("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        ZIndex = 4,
    }, self._contentGroup)
    self._header = header
    self:_trackLilithSurface(header, LILITH_SURFACE_BASE_TRANSPARENCY)
    self._headerCorner = make("UICorner", {}, header)
    self:_applyComponentCorners()
    self:_trackTheme(header, "Surface", "BackgroundColor3")
    local title = self:_text(header, config.Title or "Astra UI", {
        Active = true,
        Position = UDim2.new(0, 58, 0, 7),
        Size = UDim2.new(0.4, -58, 0, 25),
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        ZIndex = 6,
    })
    self._titleLabel = title
    local subtitle = self:_text(header, config.Subtitle or "", {
        Active = true,
        Position = UDim2.new(0, 58, 0, 31),
        Size = UDim2.new(0.45, -58, 0, 18),
        TextColor3 = self.Theme.TextMuted,
        TextSize = 11,
        ZIndex = 6,
    })
    self._subtitleLabel = subtitle
    local logo = make("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 16, 0, 14),
        Size = UDim2.new(0, 30, 0, 30),
        ZIndex = 6,
    }, header)
    self._logo = logo
    self:_trackTheme(logo, "Accent", "BackgroundColor3")
    addCorner(logo, 9)
    local logoMark = self:_text(logo, "A", {
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 7,
    })
    self._menuButton = self:_button(header, "", function()
        if self._narrow then
            self._drawer.Visible = not self._drawer.Visible
        else
            local sidebarCollapsed = self._sidebarCollapsed
            if sidebarCollapsed == nil then
                sidebarCollapsed = self._compact
            end
            self._sidebarCollapsed = not sidebarCollapsed
            self:_setResponsiveLayout(true)
        end
    end, {
        Position = UDim2.new(0, 8, 0, 7),
        Size = UDim2.new(0, 44, 0, 44),
        Height = 44,
        Background = self.Theme.SurfaceRaised,
        HoverRole = "SurfaceHover",
        HoverStrokeTransparency = 0.05,
        Role = "SurfaceRaised",
        Stroke = self.Theme.AccentSecondary,
        StrokeTransparency = 0.2,
        TextColor = self.Theme.AccentSecondary,
        ZIndex = 10,
    })
    self._menuButton.Position = UDim2.new(0, 8, 0, 7)
    local function updateSidebarToggleIcon()
        local collapsed = self._sidebarCollapsed
        if collapsed == nil then
            collapsed = self._compact
        end
        local iconName = self._narrow and "menu" or (collapsed and "panel-left-open" or "panel-left-close")
        if self._sidebarToggleIconName == iconName and self._sidebarToggleIcon and self._sidebarToggleIcon.Parent then
            return
        end
        if self._sidebarToggleIcon and self._sidebarToggleIcon.Parent then
            self._sidebarToggleIcon:Destroy()
        end
        self._sidebarToggleIconName = iconName
        self._sidebarToggleIcon = self:_icon(self._menuButton, iconName, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(18, 18),
            TextColor3 = self.Theme.AccentSecondary,
            TextSize = 17,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = self._menuButton.ZIndex + 1,
        }, self._narrow and "☰" or (collapsed and "›" or "‹"))
    end
    self._updateSidebarToggleIcon = updateSidebarToggleIcon
    updateSidebarToggleIcon()
    self._headerVersion = self:_text(header, self._headerVersionText or "", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 8),
        Size = UDim2.new(0, 132, 0, 40),
        Font = Enum.Font.GothamBold,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = self._headerVersionText ~= nil and self._headerVersionText ~= "",
        ZIndex = 6,
    })
    self._headerActionGroup = make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = self.Theme.SurfaceRaised,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(1, -8, 0, 6),
        Size = UDim2.fromOffset(136, 44),
        ZIndex = 9,
    }, header)
    self:_trackTheme(self._headerActionGroup, "SurfaceRaised", "BackgroundColor3")
    addCorner(self._headerActionGroup, 9, self)
    addStroke(self._headerActionGroup, self.Theme.Border, 0.35, self)
    self._headerActionDividerLeft = make("Frame", {
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(46, 10),
        Size = UDim2.new(0, 1, 1, -20),
        ZIndex = 11,
    }, self._headerActionGroup)
    self:_trackTheme(self._headerActionDividerLeft, "Border", "BackgroundColor3")
    self._headerActionDividerRight = make("Frame", {
        BackgroundColor3 = self.Theme.Border,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(89, 10),
        Size = UDim2.new(0, 1, 1, -20),
        ZIndex = 11,
    }, self._headerActionGroup)
    self:_trackTheme(self._headerActionDividerRight, "Border", "BackgroundColor3")
    self._discordButton = self:_button(self._headerActionGroup, "", function()
        if not self._discordUrl or self._discordUrl == "" then
            self:Notify({
                Type = "Warning",
                Title = self:_discordText("url_missing.title"),
                Content = self:_discordText("url_missing.content"),
            })
            return
        end
        if not self._discordCopy then
            self:Notify({
                Type = "Warning",
                Title = self:_discordText("copy_missing.title"),
                Content = self:_discordText("copy_missing.content"),
            })
            return
        end
        local ok, err = pcall(self._discordCopy, self._discordUrl)
        if not ok then
            warn("[AstraUI] Discord link copy failed: " .. tostring(err))
            self:Notify({
                Type = "Error",
                Title = self:_discordText("copy_failed.title"),
                Content = self:_discordText("copy_failed.content"),
            })
            return
        end
        self:Notify({
            Type = "Success",
            Title = self:_discordText("copied.title"),
            Content = self:_discordText("copied.content"),
        })
    end, {
        Position = UDim2.fromOffset(47, 1),
        Size = UDim2.fromOffset(42, 42),
        Height = 42,
        Background = self.Theme.SurfaceRaised,
        HoverRole = "SurfaceHover",
        Role = "SurfaceRaised",
        Stroke = self.Theme.Border,
        StrokeTransparency = 1,
        HoverStrokeTransparency = 1,
        Radius = 6,
        TextColor = self.Theme.AccentSecondary,
        ZIndex = 10,
    })
    self:_icon(self._discordButton, "message-circle-more", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(18, 18),
        TextColor3 = self.Theme.AccentSecondary,
        TextSize = 16,
        ZIndex = self._discordButton.ZIndex + 1,
    }, "D")
    self._discordButton:SetAttribute("AstraLabel", self:_discordText("button"))
    self._settingsButton = self:_button(self._headerActionGroup, "", function()
        self:OpenSettings()
    end, {
        Position = UDim2.fromOffset(4, 1),
        Size = UDim2.fromOffset(42, 42),
        Height = 42,
        Background = self.Theme.SurfaceRaised,
        HoverRole = "SurfaceHover",
        Role = "SurfaceRaised",
        Stroke = self.Theme.Border,
        StrokeTransparency = 1,
        HoverStrokeTransparency = 1,
        Radius = 6,
        TextColor = self.Theme.AccentSecondary,
        ZIndex = 10,
    })
    self:_icon(self._settingsButton, "settings-2", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(18, 18),
        TextColor3 = self.Theme.AccentSecondary,
        TextSize = 17,
        ZIndex = self._settingsButton.ZIndex + 1,
    }, "⚙")
    self._settingsButton:SetAttribute("AstraLabel", "Open settings")
    self._selectedTabLabel = self:_text(header, "", {
        Position = UDim2.new(0, 56, 0, 0),
        Size = UDim2.new(0.35, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Visible = false,
        ZIndex = 6,
    })
    local headerDivider = make("Frame", {
        BackgroundColor3 = self.Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 8,
    }, header)
    self:_trackTheme(headerDivider, "Border", "BackgroundColor3")
    local headerDragSurface = make("Frame", {
        Active = true,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
    }, header)
    local hideButton = self:_button(self._headerActionGroup, "", function()
        self:SetVisible(false)
    end, {
        Position = UDim2.fromOffset(90, 1),
        Size = UDim2.fromOffset(42, 42),
        Height = 44,
        Background = self.Theme.SurfaceRaised,
        HoverRole = "SurfaceHover",
        Role = "SurfaceRaised",
        Stroke = self.Theme.Border,
        StrokeTransparency = 1,
        HoverStrokeTransparency = 1,
        Radius = 6,
        ZIndex = 10,
    })
    self._hideButton = hideButton
    self:_icon(hideButton, "minus", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(18, 18),
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = hideButton.ZIndex + 1,
    }, "−")
    hideButton:SetAttribute("AstraLabel", "Minimize window")
    self._body = make("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 56),
        Size = UDim2.new(1, 0, 1, -56),
        ZIndex = 2,
    }, self._contentGroup)
    self._sidebar = make("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 210, 1, 0),
        ZIndex = 3,
    }, self._body)
    self:_trackLilithSurface(self._sidebar, LILITH_SURFACE_BASE_TRANSPARENCY)
    self._sidebarCorner = make("UICorner", {}, self._sidebar)
    self:_applyComponentCorners()
    self:_trackTheme(self._sidebar, "Surface", "BackgroundColor3")
    self._tabList = make("ScrollingFrame", {
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 8, 0, 12),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = self.Theme.AccentSecondary,
        ScrollBarThickness = 3,
        Size = UDim2.new(1, -16, 1, -24),
        ZIndex = 4,
    }, self._sidebar)
    self:_trackTheme(self._tabList, "AccentSecondary", "ScrollBarImageColor3")
    make("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self._tabList)
    self._drawer = make("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 6),
        Size = UDim2.new(0, 230, 1, -12),
        Visible = false,
        ZIndex = 50,
    }, self._body)
    self:_trackLilithSurface(self._drawer, LILITH_SURFACE_BASE_TRANSPARENCY)
    addCorner(self._drawer, 12, self)
    addStroke(self._drawer, self.Theme.Border, 0.2, self)
    local drawerList = make("ScrollingFrame", {
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 8, 0, 8),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = self.Theme.AccentSecondary,
        ScrollBarThickness = 3,
        Size = UDim2.new(1, -16, 1, -16),
        ZIndex = 51,
    }, self._drawer)
    self:_trackTheme(drawerList, "AccentSecondary", "ScrollBarImageColor3")
    self._tabList = self._tabList
    self._drawerList = drawerList
    make("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, drawerList)
    self._content = make("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 210, 0, 0),
        Size = UDim2.new(1, -210, 1, 0),
        ZIndex = 2,
    }, self._body)
    self._pageHost = make("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
    }, self._content)
    self._toastContainer = make("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.new(0, 280, 0, 320),
        ZIndex = 200,
    }, self._uiRoot)
    make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, self._toastContainer)
    self._resizeHandle = make("TextButton", {
        AnchorPoint = Vector2.new(1, 1),
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -4, 1, -4),
        Size = UDim2.fromOffset(30, 30),
        Text = "",
        ZIndex = 20,
    }, self._contentGroup)
    for index = 1, 3 do
        local mark = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.TextMuted,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 11 + index * 5, 0, 11 + index * 5),
            Rotation = -45,
            Size = UDim2.fromOffset(8, 1),
            ZIndex = self._resizeHandle.ZIndex + 1,
        }, self._resizeHandle)
        self:_trackTheme(mark, "TextMuted", "BackgroundColor3")
    end
    self:_connect(self._resizeHandle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_beginResize(input)
        end
    end)
    self._draggable = config.Draggable ~= false
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_beginDrag(input)
        end
    end
    self:_connect(title.InputBegan, beginDrag)
    self:_connect(subtitle.InputBegan, beginDrag)
    self:_connect(headerDragSurface.InputBegan, beginDrag)
    self:_connect(logo.InputBegan, beginDrag)
    self:_connect(logoMark.InputBegan, beginDrag)
    self:_connect(self._selectedTabLabel.InputBegan, beginDrag)
    self:_connect(self._headerVersion.InputBegan, beginDrag)
    self:_connect(headerDivider.InputBegan, beginDrag)
    local originalTab = self._tabList
    self._tabList = originalTab
    self:_connect(UserInputService.InputBegan, function(input, processed)
        self:_onInputBegan(input, processed)
    end)
    self:_connect(UserInputService.InputChanged, function(input)
        self:_updateResize(input)
        self:_updateDrag(input)
        self:_updateRestoreButtonDrag(input)
    end)
    self:_connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._resizeInput = nil
            self._dragInput = nil
            self._restoreDragInput = nil
        end
    end)
    local camera = workspace.CurrentCamera
    if camera then
        self:_connect(camera:GetPropertyChangedSignal("ViewportSize"), function()
            self:_setResponsiveLayout()
        end)
    end
    self:_connect(self._panel:GetPropertyChangedSignal("AbsoluteSize"), function()
        self:_setResponsiveLayout()
    end)
    if self._themePreset == "Lilith" then
        self._lilithImageLoadState = "loading"
        loadRestoreImage(
            self,
            LILITH_BACKGROUND_URL,
            self._pngDecoder,
            self._pngDecoderUrl,
            self._lilithBackgroundImage,
            self._jpegDecoder,
            self._jpegDecoderUrl
        )
    end
    self:_setResponsiveLayout()
    self._ready = true
end

local function createWindow(config)
    validConfig(config, "CreateWindow")
    local initialSize = config.Size or UDim2.fromOffset(800, 500)
    assert(typeof(initialSize) == "UDim2", "CreateWindow.Size must be a UDim2")
    assert(config.Theme == nil or type(config.Theme) == "table", "CreateWindow.Theme must be a table")
    assert(config.ToggleKey == nil or isKeyCode(config.ToggleKey), "CreateWindow.ToggleKey must be an Enum.KeyCode")
    assert(config.Responsive == nil or type(config.Responsive) == "boolean", "CreateWindow.Responsive must be a boolean")
    assert(config.Resizable == nil or type(config.Resizable) == "boolean", "CreateWindow.Resizable must be a boolean")
    assert(config.Draggable == nil or type(config.Draggable) == "boolean", "CreateWindow.Draggable must be a boolean")
    assert(config.HeaderVersion == nil or type(config.HeaderVersion) == "string", "CreateWindow.HeaderVersion must be a string")
    assert(config.RestoreImageUrl == nil or (type(config.RestoreImageUrl) == "string"
        and config.RestoreImageUrl ~= "" and string.match(config.RestoreImageUrl, "^https?://")),
        "CreateWindow.RestoreImageUrl must be an HTTP(S) URL")
    assert(config.PngDecoder == nil or (type(config.PngDecoder) == "table"
        and type(config.PngDecoder.decode) == "function"),
        "CreateWindow.PngDecoder must expose decode(buffer, options)")
    assert(config.PngDecoderUrl == nil or (type(config.PngDecoderUrl) == "string"
        and config.PngDecoderUrl ~= "" and string.match(config.PngDecoderUrl, "^https?://")),
        "CreateWindow.PngDecoderUrl must be an HTTP(S) URL")
    assert(config.JpegDecoder == nil or (type(config.JpegDecoder) == "table"
        and type(config.JpegDecoder.decode) == "function"),
        "CreateWindow.JpegDecoder must expose decode(buffer, options)")
    assert(config.JpegDecoderUrl == nil or (type(config.JpegDecoderUrl) == "string"
        and config.JpegDecoderUrl ~= "" and string.match(config.JpegDecoderUrl, "^https?://")),
        "CreateWindow.JpegDecoderUrl must be an HTTP(S) URL")
    assert(config.Discord == nil or type(config.Discord) == "table", "CreateWindow.Discord must be a table")
    assert(config.Discord == nil or config.Discord.Url == nil or type(config.Discord.Url) == "string", "CreateWindow.Discord.Url must be a string")
    assert(config.Discord == nil or config.Discord.Copy == nil or type(config.Discord.Copy) == "function", "CreateWindow.Discord.Copy must be a function")
    assert(config.Localization == nil or type(config.Localization) == "table", "CreateWindow.Localization must be a table")
    assert(config.Localization == nil or config.Localization.Locale == nil
        or (type(config.Localization.Locale) == "string" and config.Localization.Locale ~= ""),
        "CreateWindow.Localization.Locale must be a non-empty string")
    assert(config.Localization == nil or config.Localization.Locales == nil
        or type(config.Localization.Locales) == "table",
        "CreateWindow.Localization.Locales must be a table")
    assert(config.Localization == nil or config.Localization.Resolve == nil
        or type(config.Localization.Resolve) == "function",
        "CreateWindow.Localization.Resolve must be a function")
    assert(config.Settings == nil or type(config.Settings) == "table", "CreateWindow.Settings must be a table")
    assert(config.Settings == nil or config.Settings.ProfileKey == nil
        or (type(config.Settings.ProfileKey) == "string" and config.Settings.ProfileKey ~= ""),
        "CreateWindow.Settings.ProfileKey must be a non-empty string")
    assert(config.Settings == nil or config.Settings.Load == nil or type(config.Settings.Load) == "function",
        "CreateWindow.Settings.Load must be a function")
    assert(config.Settings == nil or config.Settings.Save == nil or type(config.Settings.Save) == "function",
        "CreateWindow.Settings.Save must be a function")
    assert(config.Settings == nil or config.Settings.Copy == nil or type(config.Settings.Copy) == "function",
        "CreateWindow.Settings.Copy must be a function")
    assert(config.Settings == nil or config.Settings.FilePath == nil
        or (type(config.Settings.FilePath) == "string" and config.Settings.FilePath ~= ""),
        "CreateWindow.Settings.FilePath must be a non-empty string")
    assert(config.StatePersistence == nil or type(config.StatePersistence) == "table",
        "CreateWindow.StatePersistence must be a table")
    assert(config.StatePersistence == nil or config.StatePersistence.Path == nil
        or (type(config.StatePersistence.Path) == "string" and config.StatePersistence.Path ~= ""),
        "CreateWindow.StatePersistence.Path must be a non-empty string")
    assert(config.StatePersistence == nil or config.StatePersistence.AutoSaveInterval == nil
        or (type(config.StatePersistence.AutoSaveInterval) == "number"
            and config.StatePersistence.AutoSaveInterval > 0),
        "CreateWindow.StatePersistence.AutoSaveInterval must be a positive number")
    assert(config.IconLibrary == nil or (type(config.IconLibrary) == "table" and type(config.IconLibrary.GetAsset) == "function"), "CreateWindow.IconLibrary must expose GetAsset(name)")
    assert(config.IconLibraries == nil or type(config.IconLibraries) == "table", "CreateWindow.IconLibraries must be a table")
    assert(config.IconLibraries == nil or config.IconLibraries.Lucide == nil or (type(config.IconLibraries.Lucide) == "table" and type(config.IconLibraries.Lucide.GetAsset) == "function"), "CreateWindow.IconLibraries.Lucide must expose GetAsset(name)")
    assert(config.IconLibraries == nil or config.IconLibraries.Solar == nil or type(config.IconLibraries.Solar) == "table", "CreateWindow.IconLibraries.Solar must be an icon map")
    local settingsAdapter = shallowCopy(config.Settings)
    if settingsAdapter.FilePath then
        local settingsPath = settingsAdapter.FilePath
        settingsAdapter.Load = settingsAdapter.Load or function()
            return readTextFile(settingsPath)
        end
        settingsAdapter.Save = settingsAdapter.Save or function(json)
            writeTextFile(settingsPath, json)
        end
    end
    local theme = shallowCopy(LILITH_THEME)
    for key, value in pairs(config.Theme or {}) do
        assert(THEME_KEYS[key], "Unknown theme token: " .. tostring(key))
        if key == "CornerRadius" then
            assert(type(value) == "number" and value >= 0 and value <= 32, "Theme.CornerRadius must be between 0 and 32")
        elseif key == "Density" then
            assert(value == "Compact" or value == "Comfortable", "Theme.Density must be Compact or Comfortable")
        elseif key == "SurfaceTransparency" then
            assert(type(value) == "number" and value >= 0 and value <= 1,
                "Theme.SurfaceTransparency must be between 0 and 1")
        else
            assert(typeof(value) == "Color3", "Theme." .. key .. " must be a Color3")
        end
        theme[key] = value
    end
    local iconLibraries = shallowCopy(DEFAULT_ICON_LIBRARIES)
    for name, library in pairs(config.IconLibraries or {}) do
        assert(type(name) == "string", "CreateWindow.IconLibraries keys must be strings")
        iconLibraries[string.lower(name)] = library
    end
    if config.IconLibrary ~= nil
        and (config.IconLibraries == nil or (config.IconLibraries.Lucide == nil and config.IconLibraries.lucide == nil)) then
        iconLibraries.lucide = config.IconLibrary
    end
    local themeAccentOverrides = {}
    for _, role in ipairs(THEME_ACCENT_ROLES) do
        if config.Theme and config.Theme[role] ~= nil then
            themeAccentOverrides[role] = config.Theme[role]
        end
    end
    local localization = shallowCopy(config.Localization)
    local thaiSettingsTranslations = {
        ["Settings"] = "ตั้งค่า",
        ["Color theme"] = "ธีมสี",
        ["Language"] = "ภาษา",
        ["UI toggle key"] = "ปุ่มเปิด/ปิด UI",
        ["Window behavior"] = "การทำงานของหน้าต่าง",
        ["Add theme"] = "เพิ่มธีม",
        ["Add language"] = "เพิ่มภาษา",
        ["Create theme"] = "สร้างธีม",
        ["Edit theme"] = "แก้ไขธีม",
        ["Delete theme"] = "ลบธีม",
        ["Delete theme?"] = "ยืนยันการลบธีม?",
        ["Theme name"] = "ชื่อธีม",
        ["Name"] = "ชื่อ",
        ["Copy preset"] = "คัดลอกชุดสี",
        ["Background image URL"] = "URL ภาพพื้นหลัง",
        ["Image URL (optional)"] = "URL ภาพ (ไม่บังคับ)",
        ["Image URL or asset ID (optional)"] = "URL ภาพหรือ Asset ID (ไม่บังคับ)",
        ["Surface transparency"] = "ความโปร่งใสของพื้นผิว",
        ["Color map"] = "ชุดสี",
        ["Save theme"] = "บันทึกธีม",
        ["Save changes"] = "บันทึกการแก้ไข",
        ["Theme saved"] = "บันทึกธีมแล้ว",
        ["Could not save theme"] = "บันทึกธีมไม่สำเร็จ",
        ["Enter a theme name"] = "กรุณาระบุชื่อธีม",
        ["This name is reserved"] = "ชื่อนี้เป็นชื่อที่สงวนไว้",
        ["A theme with this name already exists"] = "มีธีมชื่อนี้อยู่แล้ว",
        ["Theme image failed"] = "โหลดรูปธีมไม่สำเร็จ",
        ["Loading background"] = "กำลังโหลดพื้นหลัง",
        ["Export preset"] = "ส่งออก preset",
        ["Preset exported"] = "ส่งออก preset แล้ว",
        ["Preset JSON copied"] = "คัดลอก JSON ของ preset แล้ว",
        ["Export failed"] = "ส่งออกไม่สำเร็จ",
        ["Save"] = "บันทึก",
        ["Delete"] = "ลบ",
        ["Edit"] = "แก้ไข",
        ["Edit language"] = "แก้ไขภาษา",
        ["Delete language"] = "ลบภาษา",
        ["Delete language?"] = "ยืนยันการลบภาษา?",
        ["Save language"] = "บันทึกภาษา",
        ["This theme will be permanently deleted."] = "ธีมนี้จะถูกลบอย่างถาวร",
        ["This language will be permanently deleted."] = "ภาษานี้จะถูกลบอย่างถาวร",
        ["This cannot be undone."] = "การดำเนินการนี้ย้อนกลับไม่ได้",
        ["Delete failed"] = "ลบไม่สำเร็จ",
        ["Cancel"] = "ยกเลิก",
        ["Copy JSON template"] = "คัดลอก JSON ต้นแบบ",
        ["Resize"] = "ปรับขนาด",
        ["Drag"] = "ลาก",
        ["On"] = "เปิด",
        ["Off"] = "ปิด",
        ["Language name"] = "ชื่อภาษา",
        ["Press a key..."] = "กดปุ่มที่ต้องการ...",
        ["Copied"] = "คัดลอกแล้ว",
        ["JSON configuration copied"] = "คัดลอกการตั้งค่า JSON แล้ว",
        ["Copy failed"] = "คัดลอกไม่สำเร็จ",
        ["Invalid JSON"] = "JSON ไม่ถูกต้อง",
    }
    local locales = {
        ["en-US"] = {Name = "English", Translations = {}},
        ["th-TH"] = {Name = "ไทย", Translations = deepCopy(thaiSettingsTranslations)},
    }
    for locale, definition in pairs(localization.Locales or {}) do
        local localeDefinition = deepCopy(definition)
        if locale == "th-TH" then
            localeDefinition.Translations = localeDefinition.Translations or {}
            for key, value in pairs(thaiSettingsTranslations) do
                if localeDefinition.Translations[key] == nil then
                    localeDefinition.Translations[key] = value
                end
            end
        end
        locales[locale] = localeDefinition
    end
    validateLocales(locales)
    localization.Locales = locales
    localization.Locale = localization.Locale or "en-US"
    local window = setmetatable({
        _connections = {},
        _components = {},
        _ids = {},
        _localized = {},
        _themeTargets = {},
        _buttonThemeTargets = {},
        _themeAccentOverrides = themeAccentOverrides,
        _applyingThemePreset = false,
        _tabs = {},
        _tabCategories = {},
        _tabNavOrder = 0,
        _toasts = {},
        _keybinds = {},
        _destroyed = false,
        _visibilityTarget = false,
        _visibilityTweens = {},
        _visibilityGeneration = 0,
        _themePreset = matchesThemePreset(theme, LILITH_THEME) and "Lilith"
            or (matchesThemePreset(theme, DEFAULT_THEME) and "Dark"
            or (matchesThemePreset(theme, LIGHT_THEME) and "Light" or nil)),
        _settingsThemeName = nil,
        _customThemes = {},
        _customThemeImages = {},
        _applyingSharedSettings = false,
        _requestedSize = initialSize,
        _toggleKey = config.ToggleKey,
        _narrow = false,
        _compact = false,
        _sidebarCollapsed = nil,
        _sidebarWidth = 210,
        Responsive = config.Responsive ~= false,
        Resizable = config.Resizable ~= false,
        Theme = theme,
        _statePersistence = shallowCopy(config.StatePersistence),
        IconLibrary = config.IconLibrary,
        IconLibraries = iconLibraries,
        _headerVersionText = config.HeaderVersion or "",
        _discordUrl = config.Discord and config.Discord.Url,
        _discordCopy = config.Discord and config.Discord.Copy,
        Localization = localization,
        _settingsAdapter = settingsAdapter,
    }, WindowMethods)
    window._settingsThemeName = window._themePreset or "Custom"
    if not window._themePreset then
        window._customThemes.Custom = shallowCopy(theme)
    end
    window:_build(config)
    local settingsAdapter = window._settingsAdapter
    local profileKey = settingsAdapter.ProfileKey or "default"
    local store = SHARED_SETTINGS[profileKey]
    if not store then
        store = {
            Windows = {},
            Save = settingsAdapter.Save,
            Json = nil,
        }
        SHARED_SETTINGS[profileKey] = store
        if settingsAdapter.Load then
            local loadOk, loaded = pcall(settingsAdapter.Load)
            if loadOk and loaded ~= nil then
                local decodeOk, profile = pcall(function()
                    assert(type(loaded) == "string", "Settings.Load must return a JSON string or nil")
                    local decoded = HttpService:JSONDecode(loaded)
                    validateSettingsProfile(decoded)
                    return decoded
                end)
                if decodeOk then
                    store.Json = HttpService:JSONEncode(profile)
                else
                    warn("[AstraUI] Failed to load shared settings: " .. tostring(profile))
                end
            elseif not loadOk then
                warn("[AstraUI] Failed to load shared settings: " .. tostring(loaded))
            end
        end
    elseif not store.Save and settingsAdapter.Save then
        store.Save = settingsAdapter.Save
    end
    window._settingsStore = store
    store.Windows[window] = true
    if store.Json then
        local applyOk, applyError = pcall(function()
            window:_applySettingsProfile(HttpService:JSONDecode(store.Json))
            store.Json = HttpService:JSONEncode(window:_getSettingsProfile())
        end)
        if not applyOk then
            warn("[AstraUI] Failed to apply shared settings: " .. tostring(applyError))
        end
    else
        store.Json = HttpService:JSONEncode(window:_getSettingsProfile())
    end
    window:SetVisible(true)
    return window
end

local AstraUI = {
    Version = "0.1.0",
    CreateWindow = function(first, second)
        return createWindow(second or first)
    end,
}

return AstraUI