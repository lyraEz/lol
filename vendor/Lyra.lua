--[[
    LYRA UI  ·  v1.0.0
    A native Roblox interface library by lyraEz.

    The window, navigation, controls and notifications of Lyra Avatar Studio, packaged so any
    script can use them. Everything is built from plain Roblox instances: no remote UI assets,
    no external modules.

    QUICK START
        local Lyra = loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/Library-UI/main/src/Lyra.lua"))()

        local Window = Lyra:CreateWindow({Title = "My Hub", Subtitle = "by you  ·  v1.0"})
        local Home = Window:Tab({Title = "Home", Icon = "user"})
        Home:Section("Welcome", "Built with Lyra UI.")
        Home:Toggle({Title = "Enabled", Flag = "Enabled", Callback = function(on) print(on) end})
        Window:SettingsTab()
        Window:Notify({Title = "Loaded", Text = "Everything is ready.", Kind = "success"})

    The full reference lives in README.md and on the documentation site (site/docs.html).

    Icons: Lucide (ISC license) and the GitHub/Discord marks (Simple Icons, CC0), baked into one
    64 px sprite sheet. It needs an executor with writefile + getcustomasset; without them every
    icon is drawn with vector frames instead.
]]

local Lyra = {Version = "1.0.0", Themes = {}, ThemeNames = {}}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Windows survive re-execution in this registry, so running a script twice replaces its window.
local Shared = type(getgenv) == "function" and getgenv() or _G
if type(Shared.LyraUI) ~= "table" then Shared.LyraUI = {} end
local Registry = Shared.LyraUI
Registry.Windows = Registry.Windows or {}
Registry.ViewMemory = Registry.ViewMemory or {}

-- Lets public functions be called with a dot or a colon: Lyra.AddTheme(...) and Lyra:AddTheme(...).
local function args(first, ...)
    if first == Lyra then return ... end
    return first, ...
end

-- =============================================================================
-- THEMES
-- =============================================================================
-- Base: window. Card: panels. Raised: buttons and inputs. Line: borders. Accent/AccentDark: highlights.
-- Text/Muted: copy. Green/Red/Gold: success, error and warning. Link: links. SheenA/SheenB: window sheen.
local THEME_KEYS = {"Base", "Card", "Raised", "Line", "Accent", "AccentDark", "Text", "Muted", "Green", "Red", "Gold", "Link", "SheenA", "SheenB"}
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end

function Lyra.AddTheme(...)
    local name, colors = args(...)
    assert(type(name) == "string" and type(colors) == "table", "AddTheme needs (name, colors)")
    local fallback = Lyra.Themes.Lavender or colors
    local theme = {}
    for _, key in ipairs(THEME_KEYS) do theme[key] = colors[key] or fallback[key] end
    if not Lyra.Themes[name] then table.insert(Lyra.ThemeNames, name) end
    Lyra.Themes[name] = theme
    return theme
end

Lyra.AddTheme("Lavender", {Base = rgb(19, 18, 29), Card = rgb(30, 28, 45), Raised = rgb(41, 37, 59), Line = rgb(78, 69, 101),
    Accent = rgb(188, 167, 246), AccentDark = rgb(111, 88, 161), Text = rgb(244, 239, 255), Muted = rgb(201, 193, 223),
    Green = rgb(137, 221, 187), Red = rgb(244, 151, 171), Gold = rgb(239, 205, 143), Link = rgb(108, 180, 255),
    SheenA = rgb(235, 211, 255), SheenB = rgb(124, 120, 174)})
Lyra.AddTheme("Midnight", {Base = rgb(14, 17, 29), Card = rgb(22, 27, 45), Raised = rgb(31, 38, 61), Line = rgb(64, 78, 112),
    Accent = rgb(140, 182, 252), AccentDark = rgb(64, 92, 158), Text = rgb(236, 242, 255), Muted = rgb(180, 192, 222),
    SheenA = rgb(205, 222, 255), SheenB = rgb(92, 112, 172)})
Lyra.AddTheme("Rose", {Base = rgb(27, 17, 25), Card = rgb(42, 27, 38), Raised = rgb(56, 36, 50), Line = rgb(108, 72, 94),
    Accent = rgb(246, 170, 200), AccentDark = rgb(156, 80, 118), Text = rgb(255, 240, 247), Muted = rgb(228, 194, 210),
    SheenA = rgb(255, 216, 234), SheenB = rgb(172, 112, 142)})
Lyra.AddTheme("Mint", {Base = rgb(13, 24, 22), Card = rgb(20, 37, 34), Raised = rgb(28, 50, 46), Line = rgb(58, 100, 91),
    Accent = rgb(137, 221, 187), AccentDark = rgb(52, 124, 100), Text = rgb(236, 255, 248), Muted = rgb(182, 220, 206),
    SheenA = rgb(212, 255, 238), SheenB = rgb(88, 150, 130)})
Lyra.AddTheme("Ember", {Base = rgb(27, 19, 14), Card = rgb(41, 30, 22), Raised = rgb(55, 41, 30), Line = rgb(108, 83, 60),
    Accent = rgb(241, 201, 140), AccentDark = rgb(150, 106, 52), Text = rgb(255, 247, 235), Muted = rgb(228, 208, 182),
    SheenA = rgb(255, 233, 204), SheenB = rgb(172, 132, 92)})

-- Typography: Builder Sans is Roblox's own UI face (clear at small sizes). Falls back to Gotham.
Lyra.Font = {Regular = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Code = Enum.Font.Code}
pcall(function()
    local regular, bold = Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold
    Lyra.Font.Regular, Lyra.Font.Bold = regular, bold
end)

-- =============================================================================
-- SMALL HELPERS
-- =============================================================================
local function new(class, props, parent)
    local item = Instance.new(class)
    for key, value in pairs(props or {}) do item[key] = value end
    if parent then item.Parent = parent end
    return item
end
local function round(item, radius) return new("UICorner", {CornerRadius = UDim.new(0, radius or 14)}, item) end
local function padding(item, top, right, bottom, left)
    return new("UIPadding", {PaddingTop = UDim.new(0, top or 0), PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0), PaddingLeft = UDim.new(0, left or 0)}, item)
end
local function list(item, gap, direction)
    return new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 8),
        FillDirection = direction or Enum.FillDirection.Vertical}, item)
end
-- Every label is nudged up one step so 9-11 px captions stay readable on phones.
local function textSize(n)
    n = n or 14
    if n <= 10 then return 12 elseif n <= 12 then return 13 elseif n <= 13 then return 14 end
    return n
end
local function measure(text, size, font, width)
    local ok, bounds = pcall(function() return TextService:GetTextSize(tostring(text), size, font, Vector2.new(width or 1000, 1000)) end)
    return ok and bounds or Vector2.new(#tostring(text) * size * 0.55, size + 4)
end
local function hex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
end
local function isPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
local function copyText(text)
    local copy = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard) or nil
    if not copy then return false end
    return (pcall(copy, text))
end
-- Options are given as {"A", "B"} or {{Value = 1, Label = "One"}, ...}.
local function normalizeOptions(options)
    local result = {}
    for _, option in ipairs(options or {}) do
        if type(option) == "table" then
            local value = option.Value
            if value == nil then value = option.Label or option.Title or option[1] end
            table.insert(result, {Value = value, Label = tostring(option.Label or option.Title or option[1] or value), Icon = option.Icon})
        else
            table.insert(result, {Value = option, Label = tostring(option)})
        end
    end
    return result
end
local function labelFor(options, value)
    for _, option in ipairs(options) do if option.Value == value then return option.Label end end
    return nil
end
local function initials(text)
    local letters = ""
    for word in tostring(text):gmatch("%w+") do
        letters = letters .. word:sub(1, 1):upper()
        if #letters >= 2 then break end
    end
    return letters ~= "" and letters or "UI"
end

-- Executor file helpers. Each one fails quietly when the function is missing.
local Files = {}
function Files.read(path)
    if type(readfile) ~= "function" then return nil end
    if type(isfile) == "function" then
        local ok, exists = pcall(isfile, path)
        if not ok or not exists then return nil end
    end
    local ok, data = pcall(readfile, path)
    return ok and type(data) == "string" and data or nil
end
function Files.write(path, data)
    if type(writefile) ~= "function" then return false end
    local folder = path:match("^(.+)/[^/]+$")
    if folder and type(makefolder) == "function" then
        local exists = false
        if type(isfolder) == "function" then
            local ok, result = pcall(isfolder, folder)
            exists = ok and result == true
        end
        if not exists then pcall(makefolder, folder) end
    end
    return (pcall(writefile, path, data))
end
local function customAsset()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getsynasset) == "function" then return getsynasset end
    return nil
end

-- Decodes an embedded base64 PNG, checks its size, writes it to the executor workspace and returns its asset id.
local function embeddedAsset(text, size, path)
    local asset = customAsset()
    assert(asset and type(writefile) == "function", "Custom assets are unavailable")
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #alphabet do lookup[alphabet:byte(i)] = i - 1 end
    local data = text:gsub("[^%w%+/]", "")
    local parts = {}
    for i = 1, #data, 4 do
        local remaining = #data - i + 1
        local a, b = lookup[data:byte(i)], lookup[data:byte(i + 1)]
        local c, d = lookup[data:byte(i + 2) or 0] or 0, lookup[data:byte(i + 3) or 0] or 0
        local value = a * 262144 + b * 4096 + c * 64 + d
        if remaining >= 4 then parts[#parts + 1] = string.char(math.floor(value / 65536), math.floor(value / 256) % 256, value % 256)
        elseif remaining == 3 then parts[#parts + 1] = string.char(math.floor(value / 65536), math.floor(value / 256) % 256)
        else parts[#parts + 1] = string.char(math.floor(value / 65536)) end
    end
    local bytes = table.concat(parts)
    assert(#bytes == size and bytes:sub(2, 4) == "PNG", "Embedded image is corrupted")
    writefile(path, bytes)
    local id = asset(path)
    assert(type(id) == "string" and id ~= "", "The image could not be loaded")
    return id
end

-- Downloads a PNG or JPEG from the web and returns a usable asset id (needs request/HttpGet, writefile and
-- getcustomasset). Yields; call it inside task.spawn. Returns nil when anything is unavailable.
function Lyra.WebImage(...)
    local url, path = args(...)
    local asset = customAsset()
    if not asset or type(writefile) ~= "function" then return nil end
    path = path or ("LyraUI_" .. tostring(url):gsub("[^%w]", ""):sub(-40) .. ".png")
    local ok, id = pcall(function()
        local cached = type(isfile) == "function" and isfile(path)
        if not cached then
            local requestFn = (type(request) == "function" and request) or (type(http_request) == "function" and http_request)
                or (type(syn) == "table" and type(syn.request) == "function" and syn.request) or nil
            local body
            if requestFn then
                local response = requestFn({Url = url, Method = "GET"})
                assert(response and response.StatusCode == 200, "Image unavailable")
                body = response.Body
            else
                body = game:HttpGet(url)
            end
            assert(type(body) == "string" and #body > 16 and #body < 4194304, "Invalid image")
            assert(body:sub(1, 8) == "\137PNG\13\10\26\10" or body:sub(1, 3) == "\255\216\255", "Unsupported image format")
            writefile(path, body)
        end
        return asset(path)
    end)
    return ok and type(id) == "string" and id or nil
end

-- =============================================================================
-- ICONS
-- =============================================================================
Lyra.IconNames = {"user", "users", "server", "star", "history", "bookmark", "sliders-horizontal", "code-xml", "search", "x", "menu",
    "maximize-2", "minus", "plus", "undo-2", "copy", "check", "arrow-right", "rotate-ccw", "box", "refresh-cw", "pencil", "share-2",
    "trash-2", "download", "gamepad-2", "shirt", "save", "link", "github", "discord", "bell", "info", "circle-check",
    "triangle-alert", "circle-x", "eye-off", "repeat", "chevron-down", "chevron-up"}
Lyra.IconIndex = {}
for index, iconName in ipairs(Lyra.IconNames) do Lyra.IconIndex[iconName] = index end
-- Friendly names that point at a sprite.
Lyra.IconAlias = {avatar = "user", players = "users", collection = "star", settings = "sliders-horizontal", creator = "code-xml",
    code = "code-xml", close = "x", expand = "maximize-2", undo = "undo-2", arrow = "arrow-right", reset = "rotate-ccw",
    trash = "trash-2", share = "share-2", edit = "pencil", game = "gamepad-2", refresh = "refresh-cw", warning = "triangle-alert",
    success = "circle-check", error = "circle-x", hidden = "eye-off", sliders = "sliders-horizontal",
    home = "star", ["map-pin"] = "bookmark", map = "server", navigation = "arrow-right",
    eye = "user", crosshair = "gamepad-2", move = "gamepad-2", shield = "server",
    package = "box", radar = "server", ["settings-2"] = "sliders-horizontal", power = "x"}
-- The vector drawing used for each sprite when the sheet cannot be loaded.
local VectorAlias = {["sliders-horizontal"] = "settings", ["code-xml"] = "creator", users = "players", server = "players", user = "avatar",
    bookmark = "collection", history = "undo", ["undo-2"] = "undo", ["arrow-right"] = "arrow", ["rotate-ccw"] = "reset", x = "close",
    ["maximize-2"] = "expand", discord = "code", box = "avatar", ["refresh-cw"] = "reset", pencil = "code", ["share-2"] = "copy",
    ["trash-2"] = "trash", download = "arrow", ["gamepad-2"] = "avatar", shirt = "avatar", save = "check", link = "copy",
    bell = "info", ["circle-check"] = "check", ["triangle-alert"] = "info", ["circle-x"] = "close", ["eye-off"] = "minus",
    ["repeat"] = "reset", sliders = "settings", edit = "code", game = "avatar", refresh = "reset", warning = "info",
    success = "check", error = "close", hidden = "minus", trash = "trash", share = "copy"}
Lyra.IconBytes = 18277
Lyra.IconData = [=[
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
]=]
function Lyra.LoadIcons()
    if Lyra.IconSheet ~= nil then return Lyra.IconSheet end
    Lyra.IconSheet = false
    local ok, result = pcall(embeddedAsset, Lyra.IconData, Lyra.IconBytes, "LyraUI_icons_v1.png")
    if ok then Lyra.IconSheet = result end
    return Lyra.IconSheet
end

-- Draws an icon on a 24x24 grid and returns the root plus every coloured part ({instance, property}),
-- so the window can recolour it when the theme changes. name can be a sprite name, an alias,
-- "rbxassetid://123" or a plain asset number.
local function drawIcon(parent, name, position, color)
    local root = new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(24, 24), Position = position or UDim2.new()}, parent)
    local parts = {}
    if type(name) == "number" then name = "rbxassetid://" .. tostring(name) end
    name = tostring(name or "box")
    if name:find("^rbxasset") or name:find("^rbxthumb") then
        local image = new("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Image = name,
            ImageColor3 = color, ScaleType = Enum.ScaleType.Fit}, root)
        table.insert(parts, {image, "ImageColor3"})
        return root, parts
    end
    local spriteName = Lyra.IconAlias[name] or name
    local index = Lyra.IconIndex[spriteName]
    if Lyra.IconSheet and index then
        local image = new("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Image = Lyra.IconSheet,
            ImageRectOffset = Vector2.new(((index - 1) % 8) * 64, math.floor((index - 1) / 8) * 64), ImageRectSize = Vector2.new(64, 64),
            ImageColor3 = color, ScaleType = Enum.ScaleType.Fit}, root)
        table.insert(parts, {image, "ImageColor3"})
        return root, parts
    end
    name = VectorAlias[name] or VectorAlias[spriteName] or name
    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        local item = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1.8), Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = color, BorderSizePixel = 0}, root)
        round(item, 2)
        table.insert(parts, {item, "BackgroundColor3"})
    end
    local function box(x, y, w, h, radius, filled)
        local item = new("Frame", {Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), BackgroundColor3 = color,
            BackgroundTransparency = filled and 0 or 1, BorderSizePixel = 0}, root)
        round(item, radius or 3)
        if filled then table.insert(parts, {item, "BackgroundColor3"})
        else table.insert(parts, {new("UIStroke", {Color = color, Thickness = 1}, item), "Color"}) end
    end
    if name == "avatar" then box(8, 3, 8, 8, 8); line(5, 21, 5, 18); line(5, 18, 8, 15); line(8, 15, 16, 15); line(16, 15, 19, 18); line(19, 18, 19, 21)
    elseif name == "players" then box(3, 4, 7, 7, 7); box(14, 5, 6, 6, 6); line(1, 20, 3, 15); line(3, 15, 10, 15); line(10, 15, 12, 20); line(15, 15, 20, 15); line(20, 15, 22, 20)
    elseif name == "collection" then box(3, 5, 14, 16, 3); line(8, 2, 21, 2); line(21, 2, 21, 16); line(7, 10, 13, 10); line(7, 14, 12, 14)
    elseif name == "settings" then for _, row in ipairs({{5, 8}, {12, 16}, {19, 10}}) do line(3, row[1], 21, row[1]); box(row[2] - 2, row[1] - 2, 4, 4, 4, true) end
    elseif name == "creator" or name == "code" then line(8, 6, 2, 12); line(2, 12, 8, 18); line(16, 6, 22, 12); line(22, 12, 16, 18); line(14, 3, 10, 21)
    elseif name == "search" then box(3, 3, 12, 12, 12); line(14, 14, 21, 21)
    elseif name == "close" then line(6, 6, 18, 18); line(18, 6, 6, 18)
    elseif name == "menu" then line(4, 6, 20, 6); line(4, 12, 20, 12); line(4, 18, 20, 18)
    elseif name == "expand" then line(4, 9, 4, 4); line(4, 4, 9, 4); line(15, 4, 20, 4); line(20, 4, 20, 9); line(4, 15, 4, 20); line(4, 20, 9, 20); line(15, 20, 20, 20); line(20, 20, 20, 15)
    elseif name == "minus" then line(5, 12, 19, 12)
    elseif name == "plus" then line(5, 12, 19, 12); line(12, 5, 12, 19)
    elseif name == "undo" then line(8, 5, 3, 10); line(3, 10, 8, 15); line(3, 10, 15, 10); line(15, 10, 19, 14); line(19, 14, 19, 18)
    elseif name == "copy" then box(3, 7, 13, 14, 3); line(8, 3, 21, 3); line(21, 3, 21, 16)
    elseif name == "github" then box(4, 3, 5, 5, 5); box(15, 15, 5, 5, 5); box(4, 15, 5, 5, 5); line(6.5, 8, 6.5, 15); line(9, 5.5, 17.5, 5.5); line(17.5, 5.5, 17.5, 15)
    elseif name == "star" then
        local points = {}
        for i = 0, 9 do local angle = -math.pi / 2 + i * math.pi / 5; local r = i % 2 == 0 and 10 or 4.5; points[i + 1] = {12 + math.cos(angle) * r, 12 + math.sin(angle) * r} end
        for i = 1, 10 do local a, b = points[i], points[i % 10 + 1]; line(a[1], a[2], b[1], b[2]) end
    elseif name == "check" then line(4, 12, 10, 18); line(10, 18, 21, 6)
    elseif name == "arrow" then line(4, 12, 20, 12); line(14, 6, 20, 12); line(20, 12, 14, 18)
    elseif name == "reset" then line(5, 9, 8, 5); line(8, 5, 17, 5); line(17, 5, 21, 12); line(21, 12, 17, 19); line(17, 19, 8, 19); line(8, 19, 4, 15); line(3, 4, 3, 10); line(3, 10, 9, 10)
    elseif name == "chevron-down" then line(6, 9, 12, 15); line(12, 15, 18, 9)
    elseif name == "chevron-up" then line(6, 15, 12, 9); line(12, 9, 18, 15)
    elseif name == "info" then box(3, 3, 18, 18, 18); line(12, 11, 12, 17); box(11, 6.5, 2, 2, 2, true)
    elseif name == "trash" then box(6, 7, 12, 14, 2); line(4, 7, 20, 7); line(10, 4, 14, 4)
    else box(5, 5, 14, 14, 4) end
    return root, parts
end

-- =============================================================================
-- LYRA TOAST · in-GUI notifications (does not use Roblox's SendNotification)
-- =============================================================================
-- Self-contained: needs only TweenService, TextService and the instances it creates.
--   local notifier = Toast.new({Parent = frame, Theme = {...}, Icon = fn, Font = {...}, Width = 264, Max = 4, Margin = 12})
--   local handle = notifier:Notify({Title = "Saved", Text = "Optional line", Kind = "success", Duration = 4,
--       Icon = "check", Image = "rbxassetid://...", Action = {Text = "Open", Callback = fn}, Featured = true, Dismissible = false})
--   handle:Dismiss(); notifier:Clear(); notifier:Destroy()
-- A toast slides in from the right and fades, a hairline under it shows the time left, and a tap closes it.
-- Heights are measured from the text with TextService, so a toast is always exactly as tall as its content.
local Toast = {}
Toast.__index = Toast
Toast.DefaultTheme = {
    Background = Color3.fromRGB(24, 22, 36), Text = Color3.fromRGB(244, 239, 255),
    Muted = Color3.fromRGB(201, 193, 223), Line = Color3.fromRGB(78, 69, 101),
    Kinds = {info = Color3.fromRGB(188, 167, 246), success = Color3.fromRGB(137, 221, 187),
        warning = Color3.fromRGB(239, 205, 143), error = Color3.fromRGB(244, 151, 171)},
}
Toast.KindGlyphs = {info = "info", success = "check", warning = "alert", error = "cross"}
Toast.Badge = 24

function Toast.new(options)
    assert(type(options) == "table" and options.Parent, "Toast.new needs {Parent = Instance}")
    local self = setmetatable({}, Toast)
    self.Options = options
    self:SetTheme(options.Theme)
    self.Font = options.Font or {Regular = Enum.Font.Gotham, Bold = Enum.Font.GothamBold}
    self.Width, self.Max, self.Margin, self.Lift = options.Width or 264, options.Max or 4, options.Margin or 12, options.Lift or 0
    self.Active = {}
    self.Container = new("Frame", {Name = "LyraToasts", BackgroundTransparency = 1, ZIndex = 200, AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -self.Margin, 1, -(self.Margin + self.Lift)), Size = UDim2.new(0, self.Width, 1, -(self.Margin * 2 + self.Lift))})
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom}, self.Container)
    self.Container.Parent = options.Parent
    self.Order = 0
    return self
end
-- Copies, so the caller's tables and the defaults are never modified.
function Toast:SetTheme(theme)
    local merged, kinds = {}, {}
    for key, value in pairs(Toast.DefaultTheme) do merged[key] = value end
    for key, value in pairs(type(theme) == "table" and theme or {}) do merged[key] = value end
    for key, value in pairs(Toast.DefaultTheme.Kinds) do kinds[key] = value end
    for key, value in pairs(type(theme) == "table" and type(theme.Kinds) == "table" and theme.Kinds or {}) do kinds[key] = value end
    self.Theme, self.Kinds = merged, kinds
end
function Toast:_reduced()
    local check = self.Options.ReducedMotion
    return type(check) == "function" and check() == true
end
function Toast:_tween(item, goal, duration)
    if self:_reduced() then for key, value in pairs(goal) do item[key] = value end; return nil end
    local tween = TweenService:Create(item, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal)
    tween:Play(); return tween
end
-- Glyphs are laid out on the badge's 24x24 grid with rounded 2 px strokes.
function Toast.glyph(parent, name, color)
    local function stroke(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        local item = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + 2, 2), Rotation = math.deg(math.atan2(dy, dx)),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 203}, parent)
        round(item, 99)
    end
    local function dot(x, y)
        local item = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(2.6, 2.6),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 203}, parent)
        round(item, 99)
    end
    if name == "check" then stroke(7.5, 12.5, 10.5, 15.5); stroke(10.5, 15.5, 16.5, 9)
    elseif name == "cross" then stroke(8.5, 8.5, 15.5, 15.5); stroke(15.5, 8.5, 8.5, 15.5)
    elseif name == "alert" then stroke(12, 7.5, 12, 12.5); dot(12, 16.2)
    else dot(12, 7.8); stroke(12, 11, 12, 16.5) end
end

function Toast:Notify(spec)
    if type(spec) == "string" then spec = {Title = spec} end
    assert(type(spec) == "table" and spec.Title, "Notify needs {Title = string}")
    local kind = self.Kinds[spec.Kind or "info"] and (spec.Kind or "info") or "info"
    local color, theme = self.Kinds[kind], self.Theme
    local duration = spec.Duration == nil and 4 or spec.Duration
    -- Fit narrow screens: never wider than the parent minus the margins.
    -- A featured toast is wider, with a larger picture badge and a stronger accent.
    local featured = spec.Featured == true
    local parentWidth = self.Options.Parent.AbsoluteSize.X
    local wanted = featured and self.Width + 56 or self.Width
    local width = parentWidth > 0 and math.min(wanted, parentWidth - self.Margin * 2) or wanted
    self.Container.Size = UDim2.new(0, math.min(self.Width, width), 1, -(self.Margin * 2 + self.Lift))
    self.Order = self.Order + 1

    -- Fixed layout: every height is measured from the text, so nothing relies on AutomaticSize.
    local title, text = tostring(spec.Title), spec.Text and tostring(spec.Text) or ""
    local badgeSize = featured and 40 or Toast.Badge
    local textLeft, textRight = 20 + badgeSize, 14
    local textWidth = math.max(60, width - textLeft - textRight)
    local function height(value, size, font)
        if value == "" then return 0 end
        local ok, bounds = pcall(function() return TextService:GetTextSize(value, size, font, Vector2.new(textWidth, 10000)) end)
        return ok and math.ceil(bounds.Y) or size + 4
    end
    local titleHeight = height(title, 13, self.Font.Bold)
    local textHeight = height(text, 12, self.Font.Regular)
    local action = type(spec.Action) == "table" and spec.Action or nil
    local actionHeight = action and 38 or 0
    local contentHeight = math.max(badgeSize, titleHeight + (textHeight > 0 and textHeight + 1 or 0) + actionHeight)
    local total = 10 + contentHeight + 11

    -- holder keeps the list slot; card slides inside it.
    local holder = new("Frame", {Name = "Toast", BackgroundTransparency = 1, Size = UDim2.fromOffset(width, total), LayoutOrder = self.Order, ZIndex = 200}, self.Container)
    local card = new("CanvasGroup", {BackgroundColor3 = theme.Background, BackgroundTransparency = 0.06, Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromOffset(24, 0), GroupTransparency = 1, BorderSizePixel = 0, ZIndex = 200}, holder)
    round(card, 12)
    new("UIStroke", {Color = featured and color or theme.Line, Transparency = featured and 0.25 or 0.4, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, card)
    -- Soft wash of the kind's colour from the left edge, fading out across the card.
    local wash = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = color, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 200}, card)
    new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, featured and 0.7 or 0.84),
        NumberSequenceKeypoint.new(0.45, featured and 0.92 or 0.97), NumberSequenceKeypoint.new(1, 1)})}, wash)
    -- Badge with the glyph, the caller's icon or picture, in the kind's colour.
    local badgeTop = featured and 10 or 10 + math.floor((contentHeight - badgeSize) / 2)
    local badge = new("Frame", {Position = UDim2.fromOffset(10, badgeTop), Size = UDim2.fromOffset(badgeSize, badgeSize), BackgroundColor3 = color,
        BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 201}, card)
    round(badge, featured and 12 or 99)
    new("UIStroke", {Color = color, Transparency = 0.55, Thickness = 1}, badge)
    local drew = false
    if type(spec.Image) == "string" and spec.Image ~= "" then
        local picture = new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = spec.Image, ScaleType = Enum.ScaleType.Crop, ZIndex = 202}, badge)
        round(picture, featured and 12 or 99)
        drew = true
    end
    if not drew and spec.Icon and type(self.Options.Icon) == "function" then
        local holderIcon = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, ZIndex = 202}, badge)
        new("UIScale", {Scale = featured and 1 or 0.62}, holderIcon)
        drew = pcall(self.Options.Icon, holderIcon, spec.Icon, UDim2.new(), color)
        if not drew then holderIcon:Destroy() end
    end
    if not drew then Toast.glyph(badge, Toast.KindGlyphs[kind], color) end
    -- Title and optional text, vertically centred next to the badge when short.
    local top = 10 + math.floor((contentHeight - titleHeight - (textHeight > 0 and textHeight + 1 or 0) - actionHeight) / 2)
    new("TextLabel", {Position = UDim2.fromOffset(textLeft, top), Size = UDim2.fromOffset(textWidth, titleHeight), BackgroundTransparency = 1, Text = title,
        TextColor3 = theme.Text, Font = self.Font.Bold, TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 201}, card)
    if textHeight > 0 then
        new("TextLabel", {Position = UDim2.fromOffset(textLeft, top + titleHeight + 1), Size = UDim2.fromOffset(textWidth, textHeight), BackgroundTransparency = 1,
            Text = text, TextColor3 = theme.Muted, Font = self.Font.Regular, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 201}, card)
    end
    -- Hairline along the bottom, shrinking over the toast's lifetime.
    local fill = new("Frame", {Position = UDim2.new(0, 12, 1, -2), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = color, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, ZIndex = 202, Visible = duration > 0}, card)
    -- Whole card is tappable to dismiss (unless Dismissible = false); the action button sits above that tap area.
    local hit = spec.Dismissible ~= false and new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 204}, card) or nil
    local actionButton
    if action then
        local label = tostring(action.Text or "Open")
        local bounds = measure(label, 13, self.Font.Bold, 1000)
        local buttonWidth = math.clamp(math.ceil(bounds.X) + 28, 90, math.max(90, textWidth))
        actionButton = new("TextButton", {Position = UDim2.fromOffset(textLeft, top + titleHeight + (textHeight > 0 and textHeight + 1 or 0) + 8),
            Size = UDim2.fromOffset(buttonWidth, 30), BackgroundColor3 = color, Text = label, TextColor3 = theme.Background, Font = self.Font.Bold,
            TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 205}, card)
        round(actionButton, 9)
    end

    local handle = {Closed = false}
    local notifier = self
    function handle:Dismiss()
        if handle.Closed then return end
        handle.Closed = true
        for i, item in ipairs(notifier.Active) do if item == handle then table.remove(notifier.Active, i); break end end
        if notifier:_reduced() then holder:Destroy(); return end
        notifier:_tween(card, {GroupTransparency = 1, Position = UDim2.fromOffset(24, 0)}, 0.2)
        task.delay(0.22, function() if holder.Parent then holder:Destroy() end end)
    end
    if hit then hit.Activated:Connect(function() handle:Dismiss() end) end
    if actionButton then
        actionButton.Activated:Connect(function()
            handle:Dismiss()
            if type(action.Callback) == "function" then task.spawn(action.Callback) end
        end)
    end
    table.insert(self.Active, handle)
    while #self.Active > self.Max do self.Active[1]:Dismiss() end

    self:_tween(card, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.3)
    if duration > 0 then
        if not self:_reduced() then
            TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 1)}):Play()
        end
        task.delay(duration, function() handle:Dismiss() end)
    end
    return handle
end
function Toast:Clear()
    for i = #self.Active, 1, -1 do self.Active[i]:Dismiss() end
end
function Toast:Destroy()
    self.Active = {}
    if self.Container then self.Container:Destroy(); self.Container = nil end
end
Lyra.Toast = Toast
-- =============================================================================
-- END LYRA TOAST
-- =============================================================================

-- =============================================================================
-- WINDOW
-- =============================================================================
local Window = {}
Window.__index = Window
local Container = {}
Container.__index = Container
local Element = {}
Element.__index = Element
function Element:SetVisible(visible) self.Root.Visible = visible ~= false end
function Element:Destroy() if self.Root then self.Root:Destroy() end end
local function element(root, fields)
    local object = setmetatable(fields or {}, Element)
    object.Root = root
    return object
end
Lyra.Element, Lyra.Container, Lyra.WindowClass = Element, Container, Window

local HEADER = 52
local STATUS_KEYS = {error = "Red", warning = "Gold", success = "Green", loading = "Accent", info = "Muted"}
local DEFAULT_SETTINGS = {Scale = 0, WindowW = 0, WindowH = 0, Blur = true, ReducedMotion = false, LowEffects = false, FloatingButton = true,
    MenuReopen = true, StartHidden = false, Keybind = "RightControl", Notifications = true, HideTipSeen = false, Theme = ""}

local function resolveTheme(value)
    if type(value) == "string" and Lyra.Themes[value] then return Lyra.Themes[value], value end
    if type(value) == "table" then
        local base = Lyra.Themes[value.Extends or "Lavender"] or Lyra.Themes.Lavender
        local theme = {}
        for _, key in ipairs(THEME_KEYS) do theme[key] = value[key] or base[key] end
        return theme, nil
    end
    return Lyra.Themes.Lavender, "Lavender"
end
local function runHooks(hooks, ...)
    for i = #hooks, 1, -1 do
        if hooks[i].Root.Parent == nil then table.remove(hooks, i) end
    end
    for _, hook in ipairs(hooks) do
        local ok, problem = pcall(hook.Fn, ...)
        if not ok then warn("[Lyra UI] " .. tostring(problem)) end
    end
end

function Lyra.CreateWindow(...)
    local options = args(...)
    options = type(options) == "table" and options or {}
    local self = setmetatable({}, Window)
    self.Options = options
    self.Title = tostring(options.Title or "Lyra UI")
    self.Subtitle = tostring(options.Subtitle or ("Lyra UI  ·  v" .. Lyra.Version))
    self.Name = tostring(options.Name or self.Title)
    local previous = Registry.Windows[self.Name]
    if type(previous) == "table" and previous ~= self and type(previous.Destroy) == "function" then pcall(previous.Destroy, previous) end
    self.Alive = true
    self.Connections, self.Tweens, self.Painted, self.PaintCount, self.PruneAt = {}, {}, {}, 0, 600
    self.ThemeHooks, self.LayoutHooks, self.Tabs, self.Flags, self.FlagObjects, self.Keybinds, self.Commands = {}, {}, {}, {}, {}, {}, {}
    self.ChatInstances, self.SettingControls = {}, {}
    self.TabScroll = {}
    self.ViewMemory = Registry.ViewMemory[self.Name]
    self.PendingTabTitle = self.ViewMemory and self.ViewMemory.Tab or nil
    if self.ViewMemory and type(self.ViewMemory.Scroll) == "table" then
        for title, y in pairs(self.ViewMemory.Scroll) do
            if type(title) == "string" and type(y) == "number" then self.TabScroll[title] = math.max(0, y) end
        end
    end
    self.Visible, self.Minimized, self.Maximized, self.Drawer = true, false, false, false
    local size = options.Size
    if typeof(size) == "Vector2" then self.DefaultW, self.DefaultH = size.X, size.Y
    elseif typeof(size) == "UDim2" then self.DefaultW, self.DefaultH = size.X.Offset, size.Y.Offset
    elseif type(size) == "table" then self.DefaultW, self.DefaultH = size.Width or size.W or size[1], size.Height or size.H or size[2] end
    self.DefaultW = math.clamp(tonumber(self.DefaultW) or 820, 300, 4000)
    self.DefaultH = math.clamp(tonumber(self.DefaultH) or 600, 240, 4000)
    Registry.Windows[self.Name] = self
    self:_loadConfig()
    local saved = self.Settings.Theme
    self.Theme, self.ThemeName = resolveTheme(saved ~= "" and Lyra.Themes[saved] and saved or options.Theme)
    self:_build()
    return self
end
Lyra.new = Lyra.CreateWindow

-- -----------------------------------------------------------------------------
-- Config: interface settings and element flags in one JSON file.
-- -----------------------------------------------------------------------------
function Window:_loadConfig()
    local o, s = self.Options, {}
    for key, value in pairs(DEFAULT_SETTINGS) do s[key] = value end
    if o.Keybind ~= nil then s.Keybind = typeof(o.Keybind) == "EnumItem" and o.Keybind.Name or tostring(o.Keybind) end
    for _, key in ipairs({"FloatingButton", "Blur", "MenuReopen", "StartHidden", "Notifications", "ReducedMotion", "LowEffects"}) do
        if type(o[key]) == "boolean" then s[key] = o[key] end
    end
    if type(o.Scale) == "number" then s.Scale = o.Scale end
    self.Settings, self.Saved = s, {}
    local file = o.ConfigFile
    if file ~= false then
        if type(file) ~= "string" or file == "" then
            local clean = self.Name:gsub("[^%w%-_ ]", ""):gsub("%s+", "_")
            file = "LyraUI/" .. (clean ~= "" and clean or "Window")
        end
        if not file:find("%.json$") then file = file .. ".json" end
        self.ConfigPath = file
        local raw = Files.read(file)
        if raw then
            local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(data) == "table" then
                if type(data.Settings) == "table" then
                    for key, value in pairs(data.Settings) do
                        if DEFAULT_SETTINGS[key] ~= nil and type(value) == type(DEFAULT_SETTINGS[key]) then s[key] = value end
                    end
                end
                if type(data.Flags) == "table" then self.Saved = data.Flags end
            end
        end
    end
    s.Scale = s.Scale == 0 and 0 or math.clamp(s.Scale, 50, 150)
    s.WindowW = s.WindowW == 0 and 0 or math.clamp(s.WindowW, 300, 4000)
    s.WindowH = s.WindowH == 0 and 0 or math.clamp(s.WindowH, 240, 4000)
end
function Window:Save()
    self.SavePending = false
    if not self.ConfigPath then return false end
    local flags = {}
    for key, value in pairs(self.Saved) do flags[key] = value end
    for key, value in pairs(self.Flags) do
        local kind = type(value)
        if kind == "boolean" or kind == "number" or kind == "string" then flags[key] = value end
    end
    local ok, json = pcall(function() return HttpService:JSONEncode({Version = 1, Settings = self.Settings, Flags = flags}) end)
    return ok and Files.write(self.ConfigPath, json) or false
end
function Window:_queueSave()
    if not self.ConfigPath then return end
    self.SavePending = true
    self.SaveToken = (self.SaveToken or 0) + 1
    local token = self.SaveToken
    task.delay(0.4, function() if self.Alive and token == self.SaveToken then self:Save() end end)
end
-- The starting value of an element: its saved flag when one exists, otherwise the default.
function Window:_initial(spec, default)
    local flag = spec.Flag
    if flag ~= nil then
        local saved = self.Saved[flag]
        if saved ~= nil and (default == nil or type(saved) == type(default)) then return saved, saved ~= default end
    end
    return default, false
end
function Window:_setFlag(flag, value)
    if flag == nil then return end
    self.Flags[flag] = value
    self:_queueSave()
end
function Window:_registerFlag(flag, object)
    if flag == nil then return end
    self.FlagObjects[flag] = object
    self.Flags[flag] = object:Get()
end
function Window:GetFlag(flag) return self.Flags[flag] end
function Window:SetFlag(flag, value)
    local object = self.FlagObjects[flag]
    if object then object:Set(value) else self.Flags[flag] = value; self:_queueSave() end
end

-- -----------------------------------------------------------------------------
-- Plumbing: connections, callbacks, tweens and theme painting.
-- -----------------------------------------------------------------------------
-- Global signals (UserInputService, RunService…): disconnected by Destroy.
function Window:_connect(signal, fn)
    local connection = signal:Connect(function(...) if self.Alive then fn(...) end end)
    table.insert(self.Connections, connection)
    return connection
end
-- Signals of the window's own instances: they end when the instance is destroyed.
function Window:_on(signal, fn)
    return signal:Connect(function(...) if self.Alive then fn(...) end end)
end
-- Runs a script callback without letting an error break the interface.
function Window:_fire(callback, ...)
    if type(callback) ~= "function" then return end
    task.spawn(function(...)
        local ok, problem = pcall(callback, ...)
        if not ok then
            warn("[Lyra UI] " .. tostring(problem))
            if self.Alive and self.StatusText then self:Status("A callback failed: " .. tostring(problem), "error") end
        end
    end, ...)
end
-- One running tween per instance and channel; a new tween on the same channel replaces the old one.
function Window:_tween(item, goal, duration, style, direction, channel)
    if not item or not self.Alive then return end
    channel = channel or "main"
    local running = self.Tweens[item]
    if running and running[channel] then running[channel]:Cancel(); running[channel] = nil end
    local s = self.Settings
    if s.ReducedMotion or s.LowEffects or (duration or 0.18) <= 0 then
        for key, value in pairs(goal) do item[key] = value end
        return
    end
    local tween = TweenService:Create(item, TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), goal)
    running = self.Tweens[item] or {}
    self.Tweens[item] = running
    running[channel] = tween
    local connection
    connection = tween.Completed:Connect(function()
        connection:Disconnect()
        local current = self.Tweens[item]
        if current and current[channel] == tween then
            current[channel] = nil
            if next(current) == nil then self.Tweens[item] = nil end
        end
    end)
    tween:Play()
end
function Window:_stopTween(item, channel)
    local running = self.Tweens[item]
    channel = channel or "main"
    if running and running[channel] then running[channel]:Cancel(); running[channel] = nil end
end
-- Colours are stored as theme keys ("Accent", "Muted"…) so SetTheme can repaint every instance.
-- A Color3 value is applied as is and stops following the theme.
function Window:_paint(item, map)
    local entry = self.Painted[item]
    if not entry then
        entry = {}
        self.Painted[item] = entry
        self.PaintCount = self.PaintCount + 1
        if self.PaintCount > self.PruneAt then self:_prune() end
    end
    for property, value in pairs(map) do
        if type(value) == "string" then
            entry[property] = value
            local color = self.Theme[value]
            if color then item[property] = color end
        else
            entry[property] = nil
            item[property] = value
        end
    end
    return item
end
-- Animated paint; extra holds non-colour goals that belong to the same tween.
function Window:_tint(item, map, duration, extra)
    local goal = {}
    for key, value in pairs(extra or {}) do goal[key] = value end
    local entry = self.Painted[item] or {}
    if not self.Painted[item] then self.Painted[item] = entry; self.PaintCount = self.PaintCount + 1 end
    for property, value in pairs(map) do
        if type(value) == "string" then entry[property] = value; goal[property] = self.Theme[value]
        else entry[property] = nil; goal[property] = value end
    end
    self:_tween(item, goal, duration)
end
-- Forgets destroyed instances so lists that re-render do not grow the paint table forever.
function Window:_prune()
    local count = 0
    for item in pairs(self.Painted) do
        if item.Parent == nil then self.Painted[item] = nil else count = count + 1 end
    end
    self.PaintCount = count
    self.PruneAt = math.max(600, count * 2)
end
function Window:_color(value) return type(value) == "string" and self.Theme[value] or value end
function Window:_onTheme(root, fn) table.insert(self.ThemeHooks, {Root = root, Fn = fn}); fn() end
function Window:_onLayout(root, fn)
    table.insert(self.LayoutHooks, {Root = root, Fn = fn})
    if self.LayoutState then fn(self.LayoutState) end
end

function Window:SetTheme(value)
    local theme, name = resolveTheme(value)
    self.Theme, self.ThemeName = theme, name
    if name and self.Settings.Theme ~= name then self.Settings.Theme = name; self:_queueSave() end
    self:_prune()
    for item, map in pairs(self.Painted) do
        for property, key in pairs(map) do
            local color = theme[key]
            if color then pcall(function() item[property] = color end) end
        end
    end
    runHooks(self.ThemeHooks)
    local drop = self.SettingControls.Theme
    if drop and name then drop:Set(name, true) end
end
function Window:GetTheme() return self.Theme, self.ThemeName end

-- -----------------------------------------------------------------------------
-- Building blocks shared by the window and every element.
-- -----------------------------------------------------------------------------
function Window:_text(parent, value, size, color, bold)
    local label = new("TextLabel", {BackgroundTransparency = 1, Text = tostring(value or ""), TextSize = textSize(size),
        Font = bold and Lyra.Font.Bold or Lyra.Font.Regular, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0}, parent)
    self:_paint(label, {TextColor3 = color or "Text"})
    return label
end
function Window:_paragraph(parent, value, size, color, bold)
    local label = self:_text(parent, value, size, color, bold)
    label.Size = UDim2.new(1, 0, 0, 0); label.AutomaticSize = Enum.AutomaticSize.Y; label.TextWrapped = true
    label.TextTruncate = Enum.TextTruncate.None; label.TextYAlignment = Enum.TextYAlignment.Top
    return label
end
function Window:_stroke(item, transparency, color)
    local stroke = new("UIStroke", {Transparency = transparency or 0.3, Thickness = 1}, item)
    self:_paint(stroke, {Color = color or "Line"})
    return stroke
end
function Window:_card(parent, height)
    local card = new("Frame", {Size = UDim2.new(1, 0, 0, height or 58), BackgroundTransparency = 0.22, BorderSizePixel = 0}, parent)
    self:_paint(card, {BackgroundColor3 = "Card"})
    round(card, 16)
    self:_stroke(card, 0.55)
    return card
end
function Window:_autoCard(parent, gap, pad)
    local card = self:_card(parent, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    list(card, gap or 10)
    padding(card, pad or 16, pad or 16, pad or 16, pad or 16)
    return card
end
function Window:_icon(parent, name, position, color)
    color = color or "Muted"
    local root, parts = drawIcon(parent, name, position, self:_color(color))
    if type(color) == "string" then
        for _, part in ipairs(parts) do self:_paint(part[1], {[part[2]] = color}) end
    end
    return root, parts
end
function Window:_recolor(parts, color)
    for _, part in ipairs(parts or {}) do self:_paint(part[1], {[part[2]] = color}) end
end
function Window:_gradient(parent, keyA, keyB, rotation)
    local gradient = new("UIGradient", {Rotation = rotation or 0}, parent)
    self:_onTheme(gradient, function() gradient.Color = ColorSequence.new(self.Theme[keyA], self.Theme[keyB]) end)
    return gradient
end
-- The brand mark inside a rounded frame: the Logo image, or the title's initials.
function Window:_brandMark(parent, radius, size)
    local logo = self.Options.Logo
    if logo ~= nil and logo ~= "" then
        if type(logo) == "number" then logo = "rbxassetid://" .. tostring(logo) end
        local image = new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = tostring(logo), ScaleType = Enum.ScaleType.Crop}, parent)
        round(image, radius)
        return image
    end
    local letters = self:_text(parent, self.Options.LogoText or initials(self.Title), size or 15, "Text", true)
    letters.Size = UDim2.fromScale(1, 1); letters.TextXAlignment = Enum.TextXAlignment.Center
    return letters
end
-- Button with hover and press feedback. Key is the theme colour of its background.
function Window:_button(parent, text, primary, callback, icon)
    local window = self
    local root = new("TextButton", {Size = UDim2.new(1, 0, 0, 44), Text = "", AutoButtonColor = false, BorderSizePixel = 0}, parent)
    round(root, 12)
    local object = element(root, {Key = primary and "Accent" or "Raised", Primary = primary == true, Enabled = true, Callback = callback})
    self:_paint(root, {BackgroundColor3 = object.Key})
    local label = self:_text(root, text or "", 13, primary and "Base" or "Text", true)
    object.Label = label
    if icon then object.Icon, object.IconParts = self:_icon(root, icon, UDim2.new(0, 10, 0.5, -12), primary and "Base" or "Accent") end
    function object:Place()
        local showIcon = object.Icon ~= nil and object.Icon.Visible
        local hasText = label.Text ~= ""
        if object.Icon then object.Icon.Position = (hasText or not showIcon) and UDim2.new(0, 10, 0.5, -12) or UDim2.new(0.5, -12, 0.5, -12) end
        label.Position = UDim2.fromOffset(showIcon and 40 or 8, 0)
        label.Size = UDim2.new(1, showIcon and -48 or -16, 1, 0)
        label.TextXAlignment = showIcon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    end
    function object:SetText(value) label.Text = tostring(value or ""); object:Place() end
    function object:GetText() return label.Text end
    function object:SetIconVisible(visible) if object.Icon then object.Icon.Visible = visible ~= false; object:Place() end end
    function object:SetKey(key)
        object.Key = key
        window:_tint(root, {BackgroundColor3 = key})
    end
    function object:SetPrimary(on)
        object.Primary = on == true
        object:SetKey(on and "Accent" or "Raised")
        window:_paint(label, {TextColor3 = on and "Base" or "Text"})
        window:_recolor(object.IconParts, on and "Base" or "Accent")
    end
    function object:SetEnabled(on)
        on = on ~= false
        object.Enabled = on; root.Active = on; root.Selectable = on
        label.TextTransparency = on and 0 or 0.55
        root.BackgroundTransparency = on and 0 or 0.55
    end
    function object:Fire() if object.Enabled then window:_fire(object.Callback) end end
    self:_on(root.MouseEnter, function()
        if object.Enabled then self:_tween(root, {BackgroundColor3 = self.Theme[object.Key]:Lerp(Color3.new(1, 1, 1), 0.08)}) end
    end)
    self:_on(root.MouseLeave, function() self:_tween(root, {BackgroundColor3 = self.Theme[object.Key]}) end)
    self:_on(root.InputBegan, function(input)
        if object.Enabled and isPointer(input) then self:_tween(root, {BackgroundColor3 = self.Theme[object.Key]:Lerp(self.Theme.Base, 0.18)}, 0.08) end
    end)
    self:_on(root.InputEnded, function(input) if isPointer(input) then self:_tween(root, {BackgroundColor3 = self.Theme[object.Key]}) end end)
    self:_on(root.Activated, function() object:Fire() end)
    object:Place()
    return object
end
-- A card with a title, a wrapping description and room for a control on the right.
function Window:_controlCard(parent, title, description, controlWidth)
    local card = self:_card(parent, 58)
    local hasText = description ~= nil and description ~= ""
    local name = self:_text(card, title, 13, "Text", true)
    name.Position = UDim2.fromOffset(12, hasText and 8 or 18); name.Size = UDim2.new(1, -(controlWidth + 26), 0, 22)
    local hint
    if hasText then
        hint = self:_text(card, description, 11, "Muted")
        hint.Position = UDim2.fromOffset(12, 30); hint.Size = UDim2.new(1, -(controlWidth + 26), 0, 0); hint.AutomaticSize = Enum.AutomaticSize.Y
        hint.TextWrapped = true; hint.TextTruncate = Enum.TextTruncate.None; hint.TextYAlignment = Enum.TextYAlignment.Top
    end
    card.AutomaticSize = Enum.AutomaticSize.Y
    padding(card, 0, 0, 9, 0)
    return card, name, hint
end
-- Lays out n children across a row with equal widths and a fixed gap.
local function spread(items, gap)
    local count = #items
    for index, item in ipairs(items) do
        item.Position = UDim2.new((index - 1) / count, math.floor((index - 1) * gap / count), 0, 0)
        item.Size = UDim2.new(1 / count, -math.floor((count - 1) * gap / count), 1, 0)
    end
end

-- -----------------------------------------------------------------------------
-- Shell: the window frame, header, side rail, status line and floating button.
-- -----------------------------------------------------------------------------
function Window:_guiParent()
    local o = self.Options
    if typeof(o.Parent) == "Instance" then return o.Parent end
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then return hui end
    end
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
end
function Window:_build()
    local o, s = self.Options, self.Settings
    pcall(Lyra.LoadIcons)
    local parent = self:_guiParent()
    assert(parent, "Lyra UI: PlayerGui is unavailable.")
    local guiName = "LyraUI_" .. self.Name
    local old = parent:FindFirstChild(guiName)
    if old then old:Destroy() end
    local oldBlur = Lighting:FindFirstChild("LyraUI_Blur_" .. self.Name)
    if oldBlur then oldBlur:Destroy() end
    self.Gui = new("ScreenGui", {Name = guiName, ResetOnSpawn = false, DisplayOrder = o.DisplayOrder or 990, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = false}, parent)
    self.Surface = new("Frame", {Name = "Surface", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, self.Gui)
    self:_setupChat()
    -- Start hidden with the floating button off waits (at most 2 s) for the chat check, because it decides
    -- whether anything could bring the window back. Start hidden is skipped when nothing could.
    if s.StartHidden and not s.FloatingButton and self.ChatAlias then
        local deadline = os.clock() + 2
        while not self.ChatChecked and os.clock() < deadline do task.wait(0.05) end
    end
    self.StartSkipped = s.StartHidden and not self:_canReopen()
    self.Visible = not (s.StartHidden and not self.StartSkipped)

    self.Main = new("Frame", {Name = "Window", Position = UDim2.fromOffset(20, 20), Size = UDim2.fromOffset(self.DefaultW, self.DefaultH),
        BackgroundTransparency = 0.16, BorderSizePixel = 0, ClipsDescendants = true, Visible = self.Visible}, self.Surface)
    self:_paint(self.Main, {BackgroundColor3 = "Base"})
    round(self.Main, 22)
    self.WindowStroke = self:_stroke(self.Main, 0.28, "Accent")
    self.WindowScale = new("UIScale", {Scale = 1}, self.Main)
    self.Sheen = self:_gradient(self.Main, "SheenA", "SheenB", 65)

    -- Header: brand mark, title, subtitle and the window buttons.
    self.Header = new("Frame", {Name = "Header", Size = UDim2.new(1, 0, 0, HEADER), BackgroundTransparency = 1, Active = true}, self.Main)
    self.Logo = new("Frame", {Position = UDim2.fromOffset(14, 10), Size = UDim2.fromOffset(32, 32), BorderSizePixel = 0}, self.Header)
    self:_paint(self.Logo, {BackgroundColor3 = "AccentDark"})
    round(self.Logo, 11)
    self:_brandMark(self.Logo, 11, 13)
    self.HeaderTitle = self:_text(self.Header, self.Title, 16, "Text", true)
    self.HeaderTitle.Position = UDim2.fromOffset(58, 8); self.HeaderTitle.Size = UDim2.new(1, -210, 0, 22)
    self.HeaderSubtitle = self:_text(self.Header, self.Subtitle, 10, "Muted")
    self.HeaderSubtitle.Position = UDim2.fromOffset(58, 30); self.HeaderSubtitle.Size = UDim2.new(1, -210, 0, 15)
    local close = self:_button(self.Header, "", false, function() self:_closeHub() end, "close")
    close.Root.Size = UDim2.fromOffset(42, 42); close.Root.Position = UDim2.new(1, -48, 0, 5)
    self.MaxButton = self:_button(self.Header, "", false, function() self:Maximize(not self.Maximized) end, "expand")
    self.MaxButton.Root.Size = UDim2.fromOffset(42, 42); self.MaxButton.Root.Position = UDim2.new(1, -94, 0, 5)
    local minimize = self:_button(self.Header, "", false, function() self:Minimize(not self.Minimized) end, "minus")
    minimize.Root.Size = UDim2.fromOffset(42, 42); minimize.Root.Position = UDim2.new(1, -140, 0, 5)
    self.MenuButton = self:_button(self.Header, "", false, function() self.Drawer = not self.Drawer; self:_layout(false) end, "menu")
    self.MenuButton.Root.Position = UDim2.fromOffset(8, 5); self.MenuButton.Root.Size = UDim2.fromOffset(42, 42); self.MenuButton.Root.Visible = false
    self.Divider = new("Frame", {Position = UDim2.fromOffset(18, HEADER - 1), Size = UDim2.new(1, -36, 0, 1), BackgroundTransparency = 0.8, BorderSizePixel = 0}, self.Main)
    self:_paint(self.Divider, {BackgroundColor3 = "Line"})

    -- Content: a glass panel behind the pages, which fade in on a CanvasGroup.
    self.ContentBack = new("Frame", {BackgroundTransparency = 0.56, BorderSizePixel = 0}, self.Main)
    self:_paint(self.ContentBack, {BackgroundColor3 = "Card"})
    round(self.ContentBack, 18)
    self:_stroke(self.ContentBack, 0.83, "Accent")
    self.Content = new("CanvasGroup", {BackgroundTransparency = 1, BorderSizePixel = 0, GroupTransparency = 0}, self.Main)

    -- Side rail: wide with labels, a 60 px icon rail on medium windows, a drawer behind the menu button on narrow ones.
    self.DrawerScrim = new("TextButton", {Size = UDim2.new(1, 0, 1, -64), Position = UDim2.fromOffset(0, 64), Text = "", BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 9, Visible = false, AutoButtonColor = false}, self.Main)
    self:_on(self.DrawerScrim.Activated, function() self.Drawer = false; self:_layout(false) end)
    self.Nav = new("ScrollingFrame", {Name = "Rail", CanvasSize = UDim2.fromOffset(0, 470), ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y,
        BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 10}, self.Main)
    self:_paint(self.Nav, {BackgroundColor3 = "Base", ScrollBarImageColor3 = "AccentDark"})
    round(self.Nav, 16)
    self.NavCaption = self:_text(self.Nav, o.NavCaption or "WORKSPACE", 9, "Muted", true)
    self.NavCaption.Position = UDim2.fromOffset(14, 7); self.NavCaption.Size = UDim2.new(1, -28, 0, 18)
    self.NavFooter = self:_text(self.Nav, o.Footer or self.Title:upper(), 9, "Muted", true)
    self.NavFooter.Position = UDim2.new(0, 16, 1, -46); self.NavFooter.Size = UDim2.new(1, -32, 0, 32)
    self.NavFooter.TextWrapped = true; self.NavFooter.TextTruncate = Enum.TextTruncate.None; self.NavFooter.TextYAlignment = Enum.TextYAlignment.Bottom

    -- Status line under the content.
    self.StatusFrame = new("Frame", {Position = UDim2.new(0, 20, 1, -119), Size = UDim2.new(1, -40, 0, 30), BackgroundTransparency = 1}, self.Main)
    self.StatusDot = new("Frame", {Position = UDim2.new(0, 0, 0.5, -3), Size = UDim2.fromOffset(6, 6), BorderSizePixel = 0}, self.StatusFrame)
    round(self.StatusDot, 6)
    self:_paint(self.StatusDot, {BackgroundColor3 = "Accent"})
    self.StatusText = self:_text(self.StatusFrame, o.Status or "Ready.", 11, "Muted")
    self.StatusText.Position = UDim2.fromOffset(16, 0); self.StatusText.Size = UDim2.new(1, -16, 1, 0)
    self.StatusText.TextWrapped = true; self.StatusText.TextTruncate = Enum.TextTruncate.None

    -- Floating button: a transparent hit area holding a centred face, so the face can scale around its centre.
    self.Orb = new("TextButton", {Name = "FloatingButton", Size = UDim2.fromOffset(52, 52), Position = UDim2.new(1, -68, 0.5, -26), Text = "", BackgroundTransparency = 1,
        AutoButtonColor = false, BorderSizePixel = 0, Visible = false}, self.Surface)
    self.OrbFace = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), BorderSizePixel = 0}, self.Orb)
    self:_paint(self.OrbFace, {BackgroundColor3 = "AccentDark"})
    round(self.OrbFace, 18)
    self:_stroke(self.OrbFace, 0.15, "Accent")
    self.OrbScale = new("UIScale", {Scale = 1}, self.OrbFace)
    self:_brandMark(self.OrbFace, 18, 20)
    self:_on(self.Orb.Activated, function() if os.clock() > (self.OrbIgnoreUntil or 0) then self:SetVisible(not self.Visible) end end)

    self.Blur = new("BlurEffect", {Name = "LyraUI_Blur_" .. self.Name, Size = 0, Enabled = true}, Lighting)
    self:_drag(self.Header, self.Main, false)
    self:_drag(self.Orb, self.Orb, true)
    self:_buildGrip()
    self:_buildModal()
    self.Toasts = Toast.new({Parent = self.Surface, Font = Lyra.Font, Max = 4, Margin = 10, Theme = self:_toastTheme(),
        Icon = function(holder, name, position, color)
            assert(Lyra.IconSheet and Lyra.IconIndex[Lyra.IconAlias[name] or name], "Icon sheet unavailable")
            return drawIcon(holder, name, position, color)
        end,
        ReducedMotion = function() return self.Settings.ReducedMotion end})
    self:_onTheme(self.Main, function() self.Toasts:SetTheme(self:_toastTheme()) end)
    self:_on(self.Surface:GetPropertyChangedSignal("AbsoluteSize"), function() self:_layout(false) end)
    -- The sheen follows the camera a little, like light moving across glass.
    local elapsed = 0
    self:_connect(RunService.RenderStepped, function(dt)
        if not self.Visible or self.Minimized or self.Settings.LowEffects or self.Settings.ReducedMotion then return end
        elapsed = elapsed + (dt or 0)
        if elapsed < 1 / 30 then return end
        elapsed = 0
        local camera = workspace.CurrentCamera
        if camera then
            local look = camera.CFrame.LookVector
            self.Sheen.Rotation = self.Sheen.Rotation + (65 + look.X * 12 - look.Y * 8 - self.Sheen.Rotation) * 0.12
        end
    end)
    self:_inputs()
    self:_layout(true)
    task.defer(function() if self.Alive then self:_layout(true) end end)
    if not self.Visible then self:_effects(); self:_hiddenHint() end
    if self.StartSkipped then self:Status("Start hidden was skipped: nothing could reopen the window. Turn on a way to reopen it in Settings.", "warning") end
end
function Window:_toastTheme()
    local t = self.Theme
    return {Background = t.Base, Text = t.Text, Muted = t.Muted, Line = t.Line, Kinds = {info = t.Accent, success = t.Green, warning = t.Gold, error = t.Red}}
end

-- Drag the window by its header (not over the buttons) or the floating button anywhere.
function Window:_drag(handle, target, orb)
    local dragging, touch, start, origin, moved
    self:_on(handle.InputBegan, function(input)
        if not isPointer(input) then return end
        local scale = self.CurrentScale or 1
        if not orb and (self.Maximized or input.Position.X > self.Main.AbsolutePosition.X + self.Main.AbsoluteSize.X - 146 * scale
            or (self.Narrow and input.Position.X < self.Main.AbsolutePosition.X + 54 * scale)) then return end
        -- Stop any layout animation on the window so it doesn't fight the drag.
        if not orb then self:_stopTween(self.Main) end
        dragging = true
        touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        start = Vector2.new(input.Position.X, input.Position.Y)
        origin = target.AbsolutePosition - self.Surface.AbsolutePosition
        moved = false
    end)
    self:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if touch and input ~= touch then return end
        if not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - start
        if delta.Magnitude > 7 then moved = true end
        if moved then
            if orb then self.OrbIgnoreUntil = os.clock() + 1 end
            local size = self.Surface.AbsoluteSize
            local wanted = origin + delta
            target.Position = UDim2.fromOffset(math.clamp(wanted.X, 8, math.max(8, size.X - target.AbsoluteSize.X - 8)),
                math.clamp(wanted.Y, 8, math.max(8, size.Y - target.AbsoluteSize.Y - 8)))
        end
    end)
    self:_connect(UserInputService.InputEnded, function(input)
        if dragging and ((touch and input == touch) or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            if orb and moved then self.OrbIgnoreUntil = os.clock() + 0.3 end
            dragging = false
            touch = nil
        end
    end)
end

-- Bottom-right grip: drag to resize the window live. The size is remembered.
function Window:_buildGrip()
    local grip = new("TextButton", {Name = "ResizeGrip", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -7, 1, -7), Size = UDim2.fromOffset(28, 28), Text = "",
        BackgroundTransparency = 0.35, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 30}, self.Main)
    self:_paint(grip, {BackgroundColor3 = "Raised"})
    round(grip, 10)
    -- Three diagonal strokes, the usual "resize corner" mark.
    for i, length in ipairs({16, 10, 4}) do
        local stroke = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(14 + (i - 1) * 3.6, 14 + (i - 1) * 3.6), Size = UDim2.fromOffset(length, 2),
            Rotation = -45, BorderSizePixel = 0, ZIndex = 31}, grip)
        self:_paint(stroke, {BackgroundColor3 = "Accent"})
        round(stroke, 2)
    end
    self.ResizeGrip = grip
    -- Small badge with the live size, shown near the grip while dragging.
    self.SizeBadge = new("TextLabel", {AnchorPoint = Vector2.new(1, 1), Size = UDim2.fromOffset(96, 26), BackgroundTransparency = 1, TextTransparency = 1,
        Font = Lyra.Font.Bold, TextSize = textSize(12), Text = "", BorderSizePixel = 0, ZIndex = 60}, self.Surface)
    self:_paint(self.SizeBadge, {BackgroundColor3 = "Base", TextColor3 = "Text"})
    round(self.SizeBadge, 9)
    local badgeStroke = self:_stroke(self.SizeBadge, 1, "Accent")
    local s = self.Settings
    local function badge(visible)
        self.SizeBadge.Text = tostring(math.floor(s.WindowW)) .. " × " .. tostring(math.floor(s.WindowH))
        local corner = self.Main.AbsolutePosition + self.Main.AbsoluteSize - self.Surface.AbsolutePosition
        self.SizeBadge.Position = UDim2.fromOffset(corner.X - 4, corner.Y - 40)
        self:_tween(self.SizeBadge, {BackgroundTransparency = visible and 0.08 or 1, TextTransparency = visible and 0 or 1}, visible and 0.12 or 0.4)
        self:_tween(badgeStroke, {Transparency = visible and 0.35 or 1}, visible and 0.12 or 0.4)
    end
    local active, touch, start, startW, startH
    self:_on(grip.InputBegan, function(input)
        if not isPointer(input) then return end
        active = true
        touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        start = Vector2.new(input.Position.X, input.Position.Y)
        startW, startH = self.Main.Size.X.Offset, self.Main.Size.Y.Offset
        self.Resizing = true
        self.Maximized = false
        self:_tween(grip, {BackgroundTransparency = 0}, 0.1)
    end)
    self:_connect(UserInputService.InputChanged, function(input)
        if not active then return end
        if touch and input ~= touch then return end
        if not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local scale = self.CurrentScale or 1
        local delta = (Vector2.new(input.Position.X, input.Position.Y) - start) / scale
        local size = self.Surface.AbsoluteSize
        local corner = self.Main.AbsolutePosition - self.Surface.AbsolutePosition
        s.WindowW = math.floor(math.clamp(startW + delta.X, 300, math.max(300, (size.X - corner.X - 10) / scale)))
        s.WindowH = math.floor(math.clamp(startH + delta.Y, 240, math.max(240, (size.Y - corner.Y - 10) / scale)))
        self:_layout(false)
        badge(true)
    end)
    self:_connect(UserInputService.InputEnded, function(input)
        if active and ((touch and input == touch) or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            active = false
            touch = nil
            self.Resizing = false
            self:_tween(grip, {BackgroundTransparency = 0.35}, 0.15)
            self:_layout(false)
            self:_queueSave()
            task.delay(0.5, function() if self.Alive and not active then badge(false) end end)
        end
    end)
end

-- Window geometry. The window is sized in unscaled pixels and UIScale shrinks or grows it.
function Window:_scale()
    local percent = self.Settings.Scale
    if percent and percent > 0 then return percent / 100 end
    local size = self.Surface and self.Surface.AbsoluteSize or Vector2.new(1280, 720)
    -- Auto: a touch smaller on phones, where every pixel of the game view matters.
    return math.min(size.X, size.Y) < 500 and 0.94 or 1
end
function Window:_layout(center)
    if not self.Main or not self.Alive then return end
    local size = self.Surface.AbsoluteSize
    if size.X < 1 or size.Y < 1 then return end
    local s = self.Settings
    local scale = self:_scale()
    local scaleChanged = self.CurrentScale ~= nil and self.CurrentScale ~= scale
    self.CurrentScale = scale
    -- Motion: 0.25 s for settings and resets, a light 0.08 s smoothing while the corner grip is dragged.
    local motion = self.Resizing and 0.08 or 0.25
    if self.Visible and (scaleChanged or (self.WindowScale.Scale ~= scale and not self.ShowingTo)) then self:_tween(self.WindowScale, {Scale = scale}, motion) end
    local availW, availH = math.max(300, (size.X - 20) / scale), math.max(240, (size.Y - 20) / scale)
    local phone = math.min(size.X, size.Y) < 500
    local w, h
    if self.Maximized then
        w, h = availW, availH
    else
        w = s.WindowW > 0 and s.WindowW or (phone and 560 or self.DefaultW)
        w = math.clamp(w, 300, availW)
        h = s.WindowH > 0 and s.WindowH or ((phone or w < 520) and availH or self.DefaultH)
        h = math.clamp(h, 240, availH)
    end
    local narrow = w < 520
    local rail = not narrow and (w < 760 and 60 or 196) or 0
    local left = rail > 0 and rail + 18 or 10
    local compact, lowHeight = w - left - 22 < 470, h < 480
    self.Narrow, self.Compact, self.LowHeight = narrow, compact, lowHeight
    local minimized = self.Minimized
    local visualW, visualH = w * scale, (minimized and HEADER or h) * scale
    -- While the window flies open, lay it out around where it is landing, not where it is right now.
    local pos = self.ShowingTo or self.Main.Position
    local x = center and (size.X - visualW) / 2 or pos.X.Offset
    local y = center and (size.Y - visualH) / 2 or pos.Y.Offset
    -- Size and position animate together, so a reset glides back to the centre.
    local goal = {Size = UDim2.fromOffset(w, minimized and HEADER or h),
        Position = UDim2.fromOffset(math.clamp(x, 10, math.max(10, size.X - visualW - 10)), math.clamp(y, 10, math.max(10, size.Y - visualH - 10)))}
    if not (self.ShowingTo and self.ShowingTo == goal.Position and self.Main.Size == goal.Size) then
        self:_tween(self.Main, goal, motion)
        if self.ShowingTo then self.ShowingTo = goal.Position end
    end
    self.Content.Visible = not minimized; self.StatusFrame.Visible = not minimized; self.ContentBack.Visible = not minimized
    self.ResizeGrip.Visible = not minimized and not self.Maximized
    -- The content area slides with the side rail instead of jumping when the rail changes width.
    self:_tween(self.ContentBack, {Position = UDim2.fromOffset(left, HEADER + 6), Size = UDim2.new(1, -left - 10, 1, -(HEADER + 6 + 40))}, motion)
    self:_tween(self.Content, {Position = UDim2.fromOffset(left + 8, HEADER + 12), Size = UDim2.new(1, -left - 26, 1, -(HEADER + 12 + 48))}, motion)
    self:_tween(self.StatusFrame, {Position = UDim2.new(0, left + 6, 1, -36), Size = UDim2.new(1, -left - 46, 0, 28)}, motion)
    self.Nav.Visible = not minimized and (not narrow or self.Drawer == true)
    self.Nav.Position = UDim2.fromOffset(8, HEADER + 6)
    self:_tween(self.Nav, {Size = UDim2.new(0, narrow and 216 or rail, 1, -(HEADER + 16))}, motion)
    self.Nav.BackgroundTransparency = narrow and 0.03 or 0.72
    self.DrawerScrim.Position = UDim2.fromOffset(0, HEADER); self.DrawerScrim.Size = UDim2.new(1, 0, 1, -HEADER)
    self.DrawerScrim.Visible = narrow and self.Drawer == true and not minimized
    self.MenuButton.Root.Visible = narrow; self.Logo.Visible = not narrow
    self.HeaderTitle.TextSize = textSize(narrow and 14 or 16)
    local mini = rail == 60
    self:_navLabels(not mini, not lowHeight)
    local first, step, height = lowHeight and 6 or 30, lowHeight and 42 or 46, lowHeight and 38 or 42
    local slot = 0
    for _, tab in ipairs(self.Tabs) do
        local button = tab.RailButton
        button.Root.Visible = not tab.Hidden
        if not tab.Hidden then
            button.Root.Position = UDim2.fromOffset(5, first + slot * step)
            button.Root.Size = UDim2.new(1, -10, 0, height)
            slot = slot + 1
        end
        if self.LastMini ~= mini then self:_tween(button.Icon, {Position = UDim2.new(0, mini and 13 or 11, 0.5, -12)}, motion) end
    end
    self.LastMini = mini
    self.Nav.CanvasSize = UDim2.fromOffset(0, first + slot * step + (lowHeight and 6 or 46))
    local orb = self.Orb.AbsolutePosition - self.Surface.AbsolutePosition
    self.Orb.Position = UDim2.fromOffset(math.clamp(orb.X, 8, math.max(8, size.X - 60)), math.clamp(orb.Y, 8, math.max(8, size.Y - 60)))
    self:_effects()
    local state = {Narrow = narrow, Compact = compact, LowHeight = lowHeight, Mini = mini, Width = w, Height = h}
    self.LayoutState = state
    local key = tostring(narrow) .. tostring(compact) .. tostring(lowHeight)
    if key ~= self.LayoutKey then
        self.LayoutKey = key
        runHooks(self.LayoutHooks, state)
    end
end
-- Tab names, the caption and the footer fade in when the rail widens and fade out before it narrows.
function Window:_navLabels(show, extras)
    local state = tostring(show) .. tostring(extras)
    if self.NavLabelState == state then return end
    local first = self.NavLabelState == nil
    self.NavLabelState = state
    self.NavShow = show
    self.NavLabelGeneration = (self.NavLabelGeneration or 0) + 1
    local generation = self.NavLabelGeneration
    local items = {}
    for _, tab in ipairs(self.Tabs) do table.insert(items, {Label = tab.RailButton.Label, Show = show}) end
    table.insert(items, {Label = self.NavCaption, Show = show and extras})
    table.insert(items, {Label = self.NavFooter, Show = show and extras})
    local reduced = self.Settings.ReducedMotion
    for _, item in ipairs(items) do
        local label = item.Label
        if item.Show then
            if first then label.Visible = true; label.TextTransparency = 0
            elseif not label.Visible then
                label.TextTransparency = 1; label.Visible = true
                -- Wait for the rail to open a little before the text appears.
                task.delay(reduced and 0 or 0.08, function()
                    if self.Alive and generation == self.NavLabelGeneration then self:_tween(label, {TextTransparency = 0}, 0.22) end
                end)
            end
        elseif first then label.Visible = false
        elseif label.Visible then
            self:_tween(label, {TextTransparency = 1}, 0.1)
            task.delay(reduced and 0 or 0.1, function() if self.Alive and generation == self.NavLabelGeneration then label.Visible = false end end)
        end
    end
end
function Window:_effects(keepOrb)
    local s = self.Settings
    if not keepOrb then self.Orb.Visible = (not self.Visible or self.Minimized) and s.FloatingButton == true end
    self:_tween(self.Blur, {Size = self.Visible and not self.Minimized and s.Blur and not s.LowEffects and 9 or 0}, 0.25)
    self.Main.BackgroundTransparency = s.LowEffects and 0 or 0.16
    self.ContentBack.BackgroundTransparency = s.LowEffects and 0 or 0.56
end

-- -----------------------------------------------------------------------------
-- Open, close and the ways back.
-- -----------------------------------------------------------------------------
function Window:_reopenMethods()
    local methods = {}
    if UserInputService.KeyboardEnabled then table.insert(methods, "press " .. self.Settings.Keybind) end
    if self.Settings.MenuReopen then table.insert(methods, "open and close the Roblox menu 3 times") end
    if self.ChatAlias and self.ChatOK ~= false then table.insert(methods, "type " .. self.ChatAlias .. " in chat") end
    return methods
end
function Window:_canReopen() return self.Settings.FloatingButton == true or #self:_reopenMethods() > 0 end
function Window:_reopenText()
    local methods = self:_reopenMethods()
    if #methods == 0 then return "Turn on a reopen method in Settings." end
    local text
    if #methods == 1 then text = methods[1]
    elseif #methods == 2 then text = methods[1] .. " or " .. methods[2]
    else text = table.concat(methods, ", ", 1, #methods - 1) .. ", or " .. methods[#methods] end
    return "To reopen it, " .. text .. "."
end
-- With the floating button off there is no on-screen way back, so say how to reopen.
function Window:_hiddenHint()
    if not self.Settings.FloatingButton then
        self:Notify({Title = self.Title .. " hidden", Text = self:_reopenText(), Kind = "info", Icon = "eye-off", Duration = 6})
    end
end
function Window:Hide() self:SetVisible(false); self:_hiddenHint() end
function Window:Show()
    self.Minimized = false
    self:SetVisible(true)
    self:_layout(false)
    self:_restoreCurrentScroll()
end
function Window:Toggle() if self.Visible then self:SetVisible(false) else self:Show() end end
function Window:Minimize(state) self.Minimized = state ~= false; self:_layout(false) end
function Window:Maximize(state) self.Maximized = state ~= false; self:_layout(true) end
-- The close button. With the floating button on there is always a way back. With it off, the window is
-- never hidden without one, and the first hide asks for a confirmation that times out on its own.
function Window:_closeHub()
    if not self.Visible then return end
    local s = self.Settings
    if self.Options.CloseAction == "Destroy" then
        self:Confirm({Title = "Close " .. self.Title .. "?", Text = "The window and everything it runs will be closed.", Confirm = "Close", Cancel = "Keep open", Seconds = 10,
            Callback = function() self:Destroy() end})
        return
    end
    if s.FloatingButton then self:Hide(); return end
    if #self:_reopenMethods() == 0 then
        self:Confirm({Title = "Nothing can reopen the window", Text = "There is no keyboard, chat is unavailable and the Roblox menu shortcut is off. Turn the shortcut on and hide the window?",
            Confirm = "Turn on and hide", Cancel = "Keep open", Seconds = 15,
            Callback = function() s.MenuReopen = true; self:_queueSave(); self:_syncSetting("MenuReopen"); self:Hide() end})
        return
    end
    if not s.HideTipSeen then
        self:Confirm({Title = "Hide " .. self.Title .. "?", Text = self:_reopenText() .. " Make sure you can use one of these before hiding.",
            Confirm = "Hide it", Cancel = "Keep open", Seconds = 10,
            Callback = function() s.HideTipSeen = true; self:_queueSave(); self:Hide() end})
        return
    end
    self:Hide()
end

-- Window flight: hiding shrinks the window into the floating button (or, with the button off, into a brand
-- badge at the window's centre that then pops away); showing grows it back out the same way. Only the
-- window's Position and UIScale tween, so its centre glides in a straight line and nothing re-lays out.
local FLIGHT_TIME, FLIGHT_SCALE = 0.42, 0.06
function Window:_orbCenter()
    local size, p = self.Surface.AbsoluteSize, self.Orb.Position
    return Vector2.new(p.X.Scale * size.X + p.X.Offset + self.Orb.Size.X.Offset / 2, p.Y.Scale * size.Y + p.Y.Offset + self.Orb.Size.Y.Offset / 2)
end
function Window:_windowCenter(position, scale)
    return Vector2.new(position.X.Offset + self.Main.Size.X.Offset * scale / 2, position.Y.Offset + self.Main.Size.Y.Offset * scale / 2)
end
function Window:_flightBadge(point)
    if not self.Badge then
        self.Badge = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(56, 56), BorderSizePixel = 0, Visible = false, ZIndex = 80}, self.Surface)
        self:_paint(self.Badge, {BackgroundColor3 = "AccentDark"})
        round(self.Badge, 18)
        self:_stroke(self.Badge, 0.15, "Accent")
        self:_brandMark(self.Badge, 18, 20)
        self.BadgeScale = new("UIScale", {Scale = 0}, self.Badge)
    end
    self.Badge.Position = UDim2.fromOffset(point.X, point.Y)
    return self.Badge
end
function Window:SetVisible(value)
    value = value ~= false
    -- Opening an open window or closing a closed one does nothing, so a second call never strands the badge.
    if value == self.Visible or not self.Alive then return end
    if not value then self:_rememberView() end
    self.VisibilityGeneration = (self.VisibilityGeneration or 0) + 1
    local generation = self.VisibilityGeneration
    if self.Badge then self.Badge.Visible = false end
    self.Visible = value
    self:_closeDropdown(true)
    local scale = self.CurrentScale or self:_scale()
    local still = self.Settings.ReducedMotion or self.Settings.LowEffects
    local useOrb = self.Settings.FloatingButton == true
    local function later(delay, fn) task.delay(still and 0 or delay, function() if self.Alive and generation == self.VisibilityGeneration then fn() end end) end
    local function spot(point)
        return UDim2.fromOffset(point.X - self.Main.Size.X.Offset * scale * FLIGHT_SCALE / 2, point.Y - self.Main.Size.Y.Offset * scale * FLIGHT_SCALE / 2)
    end
    if type(self.Options.OnVisibilityChanged) == "function" then self:_fire(self.Options.OnVisibilityChanged, value) end
    if value then
        local home = self.HomePosition or self.Main.Position
        self.HomePosition = nil
        self.ShowingTo = home
        later(FLIGHT_TIME, function() self.ShowingTo = nil end)
        if self.Main.Visible then
            -- Reopened mid-flight: turn around from wherever the window is.
            self:_tween(self.Main, {Position = home}, FLIGHT_TIME * 0.7)
            self:_tween(self.WindowScale, {Scale = scale}, FLIGHT_TIME * 0.7)
        else
            local point = useOrb and self:_orbCenter() or self:_windowCenter(home, scale)
            self.Main.Position = spot(point)
            self.WindowScale.Scale = scale * FLIGHT_SCALE
            self.Main.Visible = true
            local delay = 0
            if not useOrb then
                local badge = self:_flightBadge(point)
                badge.Visible = true
                self.BadgeScale.Scale = 0.4
                self:_tween(self.BadgeScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back)
                later(0.2, function() self:_tween(self.BadgeScale, {Scale = 0}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In) end)
                later(0.44, function() badge.Visible = false end)
                delay = 0.1
            end
            later(delay, function()
                self:_tween(self.Main, {Position = self.ShowingTo or home}, FLIGHT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                self:_tween(self.WindowScale, {Scale = scale}, FLIGHT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end)
        end
        if useOrb and self.Orb.Visible then
            self:_tween(self.OrbScale, {Scale = 0.55}, 0.16)
            self:_effects(true)
            later(0.16, function() self:_effects(); self.OrbScale.Scale = 1 end)
        else
            self:_effects()
        end
        self:_restoreCurrentScroll()
        return
    end
    if not self.Main.Visible then self:_effects(); return end
    local home = self.ShowingTo or self.Main.Position
    self.ShowingTo = nil
    self.HomePosition = home
    local point = useOrb and self:_orbCenter() or self:_windowCenter(home, scale)
    if useOrb then
        -- The button appears first, then swells as the window lands inside it.
        self.Orb.Visible = true
        self.OrbScale.Scale = 0.7
        self:_tween(self.OrbScale, {Scale = 1}, 0.24)
        later(FLIGHT_TIME * 0.9, function() self.OrbScale.Scale = 1.14; self:_tween(self.OrbScale, {Scale = 1}, 0.32, Enum.EasingStyle.Back) end)
    else
        local badge = self:_flightBadge(point)
        badge.Visible = true
        self.BadgeScale.Scale = 0
        self:_tween(self.BadgeScale, {Scale = 1}, 0.26, Enum.EasingStyle.Back)
        later(FLIGHT_TIME + 0.04, function() self:_tween(self.BadgeScale, {Scale = 1.12}, 0.1) end)
        later(FLIGHT_TIME + 0.16, function() self:_tween(self.BadgeScale, {Scale = 0}, 0.24, Enum.EasingStyle.Back, Enum.EasingDirection.In) end)
        later(FLIGHT_TIME + 0.42, function() badge.Visible = false end)
    end
    self:_tween(self.Main, {Position = spot(point)}, FLIGHT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    self:_tween(self.WindowScale, {Scale = scale * FLIGHT_SCALE}, FLIGHT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    later(FLIGHT_TIME, function() self.Main.Visible = false end)
    self:_effects(true)
end

-- Reopen by opening and closing the Roblox menu 3 times within 5 seconds. Only a hidden window reacts, and a
-- notice explains it, so a player who did it by accident learns how to turn it off.
function Window:_watchMenu()
    local stamps, openedAt = {}, nil
    self:_connect(GuiService.MenuOpened, function()
        openedAt = (not self.Visible and self.Settings.MenuReopen) and os.clock() or nil
    end)
    -- A close only counts when its open was seen while the window was hidden and the shortcut was on.
    self:_connect(GuiService.MenuClosed, function()
        local opened = openedAt
        openedAt = nil
        if not opened or self.Visible or not self.Settings.MenuReopen then table.clear(stamps); return end
        local now = os.clock()
        table.insert(stamps, now)
        while #stamps > 0 and now - stamps[1] > 5 do table.remove(stamps, 1) end
        if #stamps >= 3 then
            table.clear(stamps)
            self:Show()
            self:Notify({Title = self.Title .. " reopened", Text = "You opened the Roblox menu 3 times in a row. If that was by accident, you can turn this shortcut off.",
                Kind = "info", Icon = "menu", Duration = 9,
                Action = {Text = "Turn off shortcut", Callback = function()
                    if not self.Alive then return end
                    self.Settings.MenuReopen = false
                    self:_queueSave()
                    self:_syncSetting("MenuReopen")
                    self:Status("Roblox menu shortcut turned off. You can turn it back on in Settings.", "info")
                end}})
        end
    end)
end
function Window:_setupChat()
    local command = self.Options.ChatCommand
    if type(command) ~= "string" or command == "" then return end
    self.ChatCommandName = command:lower():gsub("^/e%s+", ""):gsub("^/", ""):gsub("%s+", "")
    self.ChatAlias = "/" .. self.ChatCommandName
    -- Some accounts cannot chat; then the chat command is not offered as a way to reopen the window.
    task.spawn(function()
        local ok, can = pcall(function() return game:GetService("TextChatService"):CanUserChatAsync(LocalPlayer.UserId) end)
        self.ChatChecked = true
        if self.Alive and ok and type(can) == "boolean" then self.ChatOK = can end
        if self.Alive then self:_refreshReopen() end
    end)
end
function Window:_chatCommandInstance(name)
    pcall(function()
        local service = game:GetService("TextChatService")
        local item = new("TextChatCommand", {Name = "LyraUI_" .. name, PrimaryAlias = "/" .. name}, service)
        table.insert(self.ChatInstances, item)
        self:_on(item.Triggered, function(source, text)
            if not source or source.UserId == LocalPlayer.UserId then self:_chat(type(text) == "string" and text or ("/" .. name)) end
        end)
    end)
end
function Window:_chat(message)
    if type(message) ~= "string" then return end
    local text = message:lower():gsub("^%s+", ""):gsub("%s+$", "")
    local body = text:match("^/e%s+(.+)$") or text:match("^/(.+)$")
    if not body then return end
    local name, rest = body:match("^(%S+)%s*(.*)$")
    if not name then return end
    local handler = name == self.ChatCommandName and "window" or self.Commands[name]
    if not handler then return end
    -- The same message can arrive through more than one chat event; act on it once.
    if self.LastChat == text and os.clock() - (self.LastChatAt or 0) < 1 then return end
    self.LastChat, self.LastChatAt = text, os.clock()
    if handler == "window" then self:Show() else self:_fire(handler, rest) end
end
-- Window:Command("next", function(args) end) runs on "/next" or "/e next" typed by the local player.
function Window:Command(name, callback)
    name = tostring(name):lower():gsub("^/", "")
    self.Commands[name] = callback
    self:_chatCommandInstance(name)
end
function Window:_inputs()
    self:_watchMenu()
    self:_connect(UserInputService.InputBegan, function(input, processed)
        if self.Capture and input.UserInputType == Enum.UserInputType.Keyboard then
            local capture = self.Capture
            self.Capture = nil
            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Unknown then capture.Cancel() else capture.Done(input.KeyCode.Name) end
            return
        end
        if processed or UserInputService:GetFocusedTextBox() or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local key = input.KeyCode.Name
        if key == self.Settings.Keybind then self:Toggle() end
        for _, bind in ipairs(self.Keybinds) do
            if bind.Value == key and bind.Root.Parent then self:_fire(bind.Pressed, key) end
        end
    end)
    if self.ChatCommandName then
        self:_connect(LocalPlayer.Chatted, function(message) self:_chat(message) end)
        pcall(function()
            local service = game:GetService("TextChatService")
            -- "/e name" is handled by Roblox's emote command, so it never reaches the chat window.
            pcall(function()
                local commands = service:FindFirstChild("TextChatCommands")
                local emote = commands and commands:FindFirstChild("RBXEmoteCommand")
                if emote then
                    self:_connect(emote.Triggered, function(source, text)
                        if (not source or source.UserId == LocalPlayer.UserId) and type(text) == "string" then self:_chat(text) end
                    end)
                end
            end)
            self:_connect(service.MessageReceived, function(message)
                if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then self:_chat(message.Text) end
            end)
        end)
        self:_chatCommandInstance(self.ChatCommandName)
    end
end

-- -----------------------------------------------------------------------------
-- Status line, notifications and the confirmation dialog.
-- -----------------------------------------------------------------------------
function Window:Status(message, kind)
    kind = STATUS_KEYS[kind] and kind or "info"
    self.StatusText.Text = tostring(message or "")
    self:_paint(self.StatusText, {TextColor3 = STATUS_KEYS[kind]})
    self:_paint(self.StatusDot, {BackgroundColor3 = kind == "info" and "Accent" or STATUS_KEYS[kind]})
end
function Window:Notify(spec)
    if type(spec) == "string" then spec = {Title = spec} end
    if not self.Alive or (not self.Settings.Notifications and not spec.Force) then return nil end
    local ok, handle = pcall(function() return self.Toasts:Notify(spec) end)
    if not ok then warn("[Lyra UI] " .. tostring(handle)); return nil end
    return handle
end
function Window:_buildModal()
    self.Modal = new("Frame", {Name = "Dialog", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.3, ZIndex = 50, Visible = false, Active = true}, self.Main)
    local card = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -48, 0, 224), BorderSizePixel = 0}, self.Modal)
    self:_paint(card, {BackgroundColor3 = "Card"})
    round(card, 18)
    self:_stroke(card, 0.1)
    new("UISizeConstraint", {MaxSize = Vector2.new(440, 224)}, card)
    self.ModalTitle = self:_text(card, "", 18, "Text", true)
    self.ModalTitle.Position = UDim2.fromOffset(18, 20); self.ModalTitle.Size = UDim2.new(1, -36, 0, 28)
    self.ModalText = self:_text(card, "", 12, "Muted")
    self.ModalText.Position = UDim2.fromOffset(18, 61); self.ModalText.Size = UDim2.new(1, -36, 0, 88)
    self.ModalText.TextWrapped = true; self.ModalText.TextTruncate = Enum.TextTruncate.None; self.ModalText.TextYAlignment = Enum.TextYAlignment.Top
    local function finish(confirmed)
        self.ModalToken = (self.ModalToken or 0) + 1
        self.Modal.Visible = false
        local action = confirmed and self.ModalAction or self.ModalCancelAction
        self.ModalAction, self.ModalCancelAction = nil, nil
        self:_fire(action)
    end
    self.ModalCancel = self:_button(card, "Cancel", false, function() finish(false) end)
    self.ModalCancel.Root.Position = UDim2.new(0, 16, 1, -60); self.ModalCancel.Root.Size = UDim2.new(0.5, -22, 0, 44)
    self.ModalConfirm = self:_button(card, "Confirm", true, function() finish(true) end)
    self.ModalConfirm.Root.Position = UDim2.new(0.5, 6, 1, -60); self.ModalConfirm.Root.Size = UDim2.new(0.5, -22, 0, 44)
end
-- Window:Confirm({Title, Text, Confirm = "Confirm", Cancel = "Cancel", Seconds = nil, Callback, OnCancel})
-- or Window:Confirm(title, text, callback). Seconds closes it as a Cancel after that long, counting down on the button.
function Window:Confirm(spec, text, callback)
    if type(spec) ~= "table" then spec = {Title = spec, Text = text, Callback = callback} end
    self.ModalToken = (self.ModalToken or 0) + 1
    local token = self.ModalToken
    self.ModalTitle.Text = tostring(spec.Title or "Are you sure?")
    self.ModalText.Text = tostring(spec.Text or spec.Description or "")
    self.ModalAction, self.ModalCancelAction = spec.Callback, spec.OnCancel
    local cancelText = tostring(spec.Cancel or "Cancel")
    self.ModalConfirm:SetText(spec.Confirm or "Confirm")
    self.ModalCancel:SetText(cancelText)
    self:_closeDropdown(true)
    self.Modal.Visible = true
    if not spec.Seconds then return end
    task.spawn(function()
        for left = spec.Seconds, 1, -1 do
            if not self.Alive or token ~= self.ModalToken then return end
            self.ModalCancel:SetText(cancelText .. " (" .. tostring(left) .. ")")
            task.wait(1)
        end
        if self.Alive and token == self.ModalToken then
            self.ModalToken = token + 1
            self.Modal.Visible = false
            local action = self.ModalCancelAction
            self.ModalAction, self.ModalCancelAction = nil, nil
            self.ModalCancel:SetText(cancelText)
            self:_fire(action)
        end
    end)
end

-- -----------------------------------------------------------------------------
-- Dropdown: the list floats above the window so no scrolling container clips it; tapping outside closes it.
-- -----------------------------------------------------------------------------
function Window:_dropdown(parent, options, get, set, placeholder)
    local button = new("TextButton", {Size = UDim2.new(1, 0, 0, 40), Text = "", AutoButtonColor = false, BorderSizePixel = 0}, parent)
    self:_paint(button, {BackgroundColor3 = "Raised"})
    round(button, 12)
    local stroke = self:_stroke(button, 0.6)
    local label = self:_text(button, "", 12, "Text", true)
    label.Position = UDim2.fromOffset(12, 0); label.Size = UDim2.new(1, -42, 1, 0)
    local chevron = self:_icon(button, "chevron-down", UDim2.new(1, -32, 0.5, -12), "Accent")
    local drop = {Root = button, Label = label, Options = options, Get = get, Set = set, Chevron = chevron, Stroke = stroke}
    function drop.refresh()
        label.Text = labelFor(drop.Options, get()) or placeholder or "Select…"
    end
    self:_on(button.Activated, function() if self.OpenDrop == drop then self:_closeDropdown() else self:_openDropdown(drop) end end)
    self:_on(button.MouseEnter, function() self:_tween(button, {BackgroundColor3 = self.Theme.Raised:Lerp(Color3.new(1, 1, 1), 0.06)}) end)
    self:_on(button.MouseLeave, function() self:_tween(button, {BackgroundColor3 = self.Theme.Raised}) end)
    drop.refresh()
    return drop
end
function Window:_openDropdown(drop)
    self:_closeDropdown(true)
    if not self.DropLayer then
        self.DropLayer = new("Frame", {Name = "DropdownLayer", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 70, Visible = false}, self.Main)
        local catcher = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, self.DropLayer)
        self:_on(catcher.Activated, function() self:_closeDropdown() end)
    end
    -- Children of the window are laid out before its UIScale, so absolute pixels are divided by it.
    local scale = self.WindowScale.Scale > 0 and self.WindowScale.Scale or 1
    local at = (drop.Root.AbsolutePosition - self.Main.AbsolutePosition) / scale
    local buttonSize = drop.Root.AbsoluteSize / scale
    local area = self.Main.AbsoluteSize / scale
    local rowHeight = 38
    local width = math.max(180, buttonSize.X)
    local height = math.min(#drop.Options, 7) * rowHeight + 8
    local below = at.Y + buttonSize.Y + 6
    local up = below + height > area.Y - 8
    local x = math.clamp(at.X + buttonSize.X - width, 8, math.max(8, area.X - width - 8))
    local y = up and math.max(8, at.Y - height - 6) or below
    local panel = new("CanvasGroup", {Position = UDim2.fromOffset(x, y + (up and 6 or -6)), Size = UDim2.fromOffset(width, height), BorderSizePixel = 0, GroupTransparency = 1}, self.DropLayer)
    self:_paint(panel, {BackgroundColor3 = "Card"})
    round(panel, 12)
    self:_stroke(panel, 0.45, "Accent")
    local scroll = new("ScrollingFrame", {Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -8, 1, -8), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        CanvasSize = UDim2.fromOffset(0, #drop.Options * rowHeight), ScrollingDirection = Enum.ScrollingDirection.Y}, panel)
    self:_paint(scroll, {ScrollBarImageColor3 = "AccentDark"})
    local current = drop.Get()
    for index, option in ipairs(drop.Options) do
        local selected = option.Value == current
        local row = new("TextButton", {Position = UDim2.fromOffset(0, (index - 1) * rowHeight), Size = UDim2.new(1, 0, 0, rowHeight - 2), Text = "", AutoButtonColor = false,
            BackgroundTransparency = selected and 0.4 or 1, BorderSizePixel = 0}, scroll)
        self:_paint(row, {BackgroundColor3 = "AccentDark"})
        round(row, 9)
        local text = self:_text(row, option.Label, 12, selected and "Text" or "Muted", selected)
        text.Position = UDim2.fromOffset(10, 0); text.Size = UDim2.new(1, -40, 1, 0)
        if selected then self:_icon(row, "check", UDim2.new(1, -30, 0.5, -12), "Accent") end
        self:_on(row.MouseEnter, function() if not selected then self:_tween(row, {BackgroundTransparency = 0.75}) end end)
        self:_on(row.MouseLeave, function() if not selected then self:_tween(row, {BackgroundTransparency = 1}) end end)
        self:_on(row.Activated, function()
            self:_closeDropdown()
            if option.Value ~= drop.Get() then drop.Set(option.Value); drop.refresh() end
        end)
    end
    if #drop.Options > 7 then
        for index, option in ipairs(drop.Options) do
            if option.Value == current then scroll.CanvasPosition = Vector2.new(0, math.max(0, (index - 4) * rowHeight)) end
        end
    end
    self.OpenDrop, self.DropList = drop, panel
    self.DropLayer.Visible = true
    self:_tween(panel, {GroupTransparency = 0, Position = UDim2.fromOffset(x, y)}, 0.16)
    self:_tween(drop.Chevron, {Rotation = 180}, 0.16)
    self:_tint(drop.Stroke, {Color = "Accent"}, 0.16, {Transparency = 0.2})
end
function Window:_closeDropdown(instant)
    local drop, panel = self.OpenDrop, self.DropList
    if not drop then return end
    self.OpenDrop, self.DropList = nil, nil
    self:_tween(drop.Chevron, {Rotation = 0}, instant and 0 or 0.16)
    self:_tint(drop.Stroke, {Color = "Line"}, instant and 0 or 0.16, {Transparency = 0.6})
    if instant or self.Settings.ReducedMotion or self.Settings.LowEffects then
        panel:Destroy()
        self.DropLayer.Visible = false
        return
    end
    self:_tween(panel, {GroupTransparency = 1}, 0.1)
    task.delay(0.11, function()
        panel:Destroy()
        if not self.OpenDrop and self.DropLayer then self.DropLayer.Visible = false end
    end)
end

-- -----------------------------------------------------------------------------
-- Tabs
-- -----------------------------------------------------------------------------
local function newContainer(window, frame, page)
    return setmetatable({Window = window, Frame = frame, Page = page, Order = 0}, Container)
end
-- Window:Tab({Title = "Home", Icon = "user", OnSelect = fn}) or Window:Tab("Home", "user")
function Window:Tab(spec, icon)
    if type(spec) ~= "table" then spec = {Title = spec, Icon = icon} end
    local title = tostring(spec.Title or spec.Name or ("Tab " .. tostring(#self.Tabs + 1)))
    local page = new("ScrollingFrame", {Name = title, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, ClipsDescendants = true}, self.Content)
    self:_paint(page, {ScrollBarImageColor3 = "AccentDark"})
    padding(page, 2, 6, 10, 2)
    list(page, spec.Gap or 8)
    -- An open dropdown list would drift away from its button, so scrolling closes it.
    self:_on(page:GetPropertyChangedSignal("CanvasPosition"), function()
        if self.OpenDrop then self:_closeDropdown() end
        if self.Visible and page.Visible and not self.RestoringScroll then
            self.TabScroll[title] = math.max(0, page.CanvasPosition.Y)
        end
    end)
    local tab = newContainer(self, page, page)
    tab.Title, tab.Icon, tab.OnSelect = title, spec.Icon or "box", spec.OnSelect
    local index = #self.Tabs + 1
    local button = new("TextButton", {Position = UDim2.fromOffset(6, 42 + (index - 1) * 54), Size = UDim2.new(1, -12, 0, 48), Text = "", AutoButtonColor = false,
        BackgroundTransparency = 1, BorderSizePixel = 0}, self.Nav)
    self:_paint(button, {BackgroundColor3 = "Raised"})
    round(button, 12)
    local mini = self.LastMini == true
    local iconRoot = self:_icon(button, tab.Icon, UDim2.new(0, mini and 13 or 11, 0.5, -12), "Accent")
    local label = self:_text(button, title, 12, "Muted", true)
    label.Position = UDim2.fromOffset(44, 0); label.Size = UDim2.new(1, -48, 1, 0)
    label.Visible = self.NavShow ~= false
    local marker = new("Frame", {Position = UDim2.new(0, 0, 0.5, -9), Size = UDim2.fromOffset(3, 18), BorderSizePixel = 0, Visible = false}, button)
    self:_paint(marker, {BackgroundColor3 = "Accent"})
    round(marker, 3)
    tab.RailButton = {Root = button, Label = label, Icon = iconRoot, Marker = marker}
    self:_on(button.Activated, function() self:SelectTab(tab) end)
    self:_on(button.MouseEnter, function() if self.CurrentTab ~= tab then self:_tween(button, {BackgroundTransparency = 0.55}) end end)
    self:_on(button.MouseLeave, function() if self.CurrentTab ~= tab then self:_tween(button, {BackgroundTransparency = 1}) end end)
    table.insert(self.Tabs, tab)
    if not self.CurrentTab then self:SelectTab(tab) end
    if self.PendingTabTitle == title then
        self.PendingTabTitle = nil
        self:SelectTab(tab)
    end
    self:_layout(false)
    return tab
end
function Window:SelectTab(target)
    local tab = target
    if type(target) ~= "table" then
        for _, item in ipairs(self.Tabs) do if item.Title == target then tab = item end end
    end
    if type(tab) ~= "table" or not tab.Page then return end
    if self.CurrentTab and self.CurrentTab.Page then
        self.TabScroll[self.CurrentTab.Title] = math.max(0, self.CurrentTab.Page.CanvasPosition.Y)
    end
    self.CurrentTab = tab
    self:_closeDropdown(true)
    if self.Drawer then self.Drawer = false; self:_layout(false) end
    for _, item in ipairs(self.Tabs) do
        local on = item == tab
        item.Page.Visible = on
        self:_tween(item.RailButton.Root, {BackgroundTransparency = on and 0 or 1})
        self:_paint(item.RailButton.Label, {TextColor3 = on and "Text" or "Muted"})
        item.RailButton.Marker.Visible = on
    end
    self.Content.GroupTransparency = self.Settings.ReducedMotion and 0 or 0.25
    self:_tween(self.Content, {GroupTransparency = 0}, 0.22, nil, nil, "fade")
    self:_restoreCurrentScroll()
    self:_fire(tab.OnSelect, tab)
end
function Window:_rememberView()
    if self.CurrentTab and self.CurrentTab.Page then
        self.TabScroll[self.CurrentTab.Title] = math.max(0, self.CurrentTab.Page.CanvasPosition.Y)
    end
    local snapshot = {Tab = self.CurrentTab and self.CurrentTab.Title or nil, Scroll = {}}
    for title, y in pairs(self.TabScroll or {}) do snapshot.Scroll[title] = math.max(0, tonumber(y) or 0) end
    Registry.ViewMemory[self.Name] = snapshot
    self.ViewMemory = snapshot
end
function Window:_restoreCurrentScroll()
    local tab = self.CurrentTab
    if not tab or not tab.Page then return end
    local y = math.max(0, tonumber(self.TabScroll[tab.Title]) or 0)
    local generation = self.VisibilityGeneration
    task.defer(function()
        if not self.Alive or self.CurrentTab ~= tab or generation ~= self.VisibilityGeneration then return end
        self.RestoringScroll = true
        tab.Page.CanvasPosition = Vector2.new(0, y)
        self.RestoringScroll = false
    end)
end
function Window:SetTitle(title, subtitle)
    if title then self.Title = tostring(title); self.HeaderTitle.Text = self.Title end
    if subtitle then self.Subtitle = tostring(subtitle); self.HeaderSubtitle.Text = self.Subtitle end
end
function Window:SetScale(percent)
    self.Settings.Scale = (tonumber(percent) or 0) <= 0 and 0 or math.clamp(tonumber(percent), 50, 150)
    self:_queueSave()
    self:_layout(false)
end
function Window:ResetSize()
    local s = self.Settings
    s.WindowW, s.WindowH, s.Scale = 0, 0, 0
    self.Maximized = false
    self:_syncSetting("Scale")
    self:_queueSave()
    self:_layout(true)
end
-- Keeps the built-in settings controls in step with a setting changed somewhere else.
function Window:_syncSetting(key)
    local control = self.SettingControls[key]
    if control then control:Set(self.Settings[key], true) end
    self:_refreshReopen()
end
function Window:Destroy()
    if not self.Alive then return end
    self:_rememberView()
    if self.SavePending then pcall(self.Save, self) end
    self.Alive = false
    for _, connection in ipairs(self.Connections) do pcall(function() connection:Disconnect() end) end
    for _, channels in pairs(self.Tweens) do for _, tween in pairs(channels) do pcall(function() tween:Cancel() end) end end
    for _, item in ipairs(self.ChatInstances) do pcall(function() item:Destroy() end) end
    pcall(function() self.Blur:Destroy() end)
    pcall(function() self.Gui:Destroy() end)
    self.Connections, self.Tweens, self.Painted, self.ThemeHooks, self.LayoutHooks = {}, {}, {}, {}, {}
    if Registry.Windows[self.Name] == self then Registry.Windows[self.Name] = nil end
    if type(self.Options.OnDestroy) == "function" then task.spawn(self.Options.OnDestroy) end
end

-- =============================================================================
-- ELEMENTS
-- =============================================================================
-- Every tab, group, column and collapsible section is a Container with the same element methods.
-- Elements return an object with Root, SetVisible and Destroy, plus Set/Get when they hold a value.
-- Spec.Flag stores the value in the config file and restores it on the next run (the callback then runs once).

local function decimals(step)
    local text = tostring(step)
    local dot = text:find("%.")
    return dot and math.min(6, #text - dot) or 0
end
local function snap(value, step, min)
    local snapped = min + math.floor((value - min) / step + 0.5) * step
    return tonumber(string.format("%." .. decimals(step) .. "f", snapped))
end
local function escape(text)
    return (tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function Container:_add(item)
    self.Order = self.Order + 1
    item.LayoutOrder = self.Order
    return item
end
-- Selects this tab (tabs only).
function Container:Select() if self.RailButton then self.Window:SelectTab(self) end end
function Container:SetVisible(visible)
    visible = visible ~= false
    if self.RailButton then
        -- A hidden tab leaves the rail; if it was open, the first visible tab opens instead.
        self.Hidden = not visible
        local window = self.Window
        window:_layout(false)
        if self.Hidden and window.CurrentTab == self then
            for _, tab in ipairs(window.Tabs) do if not tab.Hidden then window:SelectTab(tab); break end end
        end
        return
    end
    local root = self.Root or self.Frame
    root.Visible = visible
end
function Container:Destroy() if self.Root then self.Root:Destroy() end end

function Container:Section(title, description)
    if type(title) == "table" then description = title.Description or title.Subtitle; title = title.Title end
    local window = self.Window
    local frame = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, description and 50 or 26), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame))
    padding(frame, 2, 0, description and 4 or 0, 0)
    local label = window:_text(frame, title or "", 17, "Text", true)
    label.Size = UDim2.new(1, 0, 0, 24)
    local hint
    if description then
        hint = window:_text(frame, description, 12, "Muted")
        hint.Position = UDim2.fromOffset(0, 25); hint.Size = UDim2.new(1, 0, 0, 0); hint.AutomaticSize = Enum.AutomaticSize.Y
        hint.TextWrapped = true; hint.TextTruncate = Enum.TextTruncate.None; hint.TextYAlignment = Enum.TextYAlignment.Top
    end
    local object = element(frame, {TitleLabel = label, DescriptionLabel = hint})
    function object:Set(newTitle, newDescription)
        if newTitle then label.Text = tostring(newTitle) end
        if newDescription and hint then hint.Text = tostring(newDescription) end
    end
    return object
end

function Container:Paragraph(text, options)
    if type(text) == "table" then options = text; text = options.Text end
    options = options or {}
    local label = self:_add(self.Window:_paragraph(self.Frame, text or "", options.Size or 12, options.Color or (options.Muted and "Muted" or "Text"), options.Bold))
    label.RichText = options.RichText == true
    local object = element(label)
    function object:Set(value) label.Text = tostring(value or "") end
    return object
end

-- One muted line, handy for counters ("12 items").
function Container:Label(text, color)
    local window = self.Window
    local label = self:_add(window:_text(self.Frame, text or "", 11, color or "Muted"))
    label.Size = UDim2.new(1, 0, 0, 20)
    local object = element(label)
    function object:Set(value, newColor)
        label.Text = tostring(value or "")
        if newColor then window:_paint(label, {TextColor3 = newColor}) end
    end
    return object
end

function Container:Divider()
    local line = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.6, BorderSizePixel = 0}, self.Frame))
    self.Window:_paint(line, {BackgroundColor3 = "Line"})
    return element(line)
end

function Container:Button(spec, callback)
    if type(spec) ~= "table" then spec = {Title = spec, Callback = callback} end
    local button = self.Window:_button(self.Frame, spec.Title or "Button", spec.Primary, spec.Callback, spec.Icon)
    button.Root.Size = UDim2.new(1, 0, 0, spec.Height or 42)
    self:_add(button.Root)
    if spec.Enabled == false then button:SetEnabled(false) end
    return button
end

-- Buttons side by side with equal widths. On narrow windows they drop their icons so each label fits.
function Container:ButtonRow(buttons, options)
    options = options or {}
    local window = self.Window
    local frame = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, options.Height or 40), BackgroundTransparency = 1}, self.Frame))
    local items, roots = {}, {}
    for _, spec in ipairs(buttons or {}) do
        local button = window:_button(frame, spec.Title or "", spec.Primary, spec.Callback, spec.Icon)
        if spec.Enabled == false then button:SetEnabled(false) end
        table.insert(items, button)
        table.insert(roots, button.Root)
    end
    spread(roots, options.Gap or 8)
    window:_onLayout(frame, function(state)
        for _, button in ipairs(items) do if button.Label.Text ~= "" then button:SetIconVisible(not state.Compact) end end
    end)
    return element(frame, {Buttons = items})
end

-- A settings card with a button on the right.
function Container:Action(spec)
    spec = spec or {}
    local window = self.Window
    local text = tostring(spec.Button or "Run")
    local width = spec.Width or math.max(96, math.ceil(measure(text, textSize(13), Lyra.Font.Bold).X) + (spec.Icon and 56 or 30))
    local card = self:_add((window:_controlCard(self.Frame, spec.Title or "Action", spec.Description, width)))
    local button = window:_button(card, text, spec.Primary, spec.Callback, spec.Icon)
    button.Root.Size = UDim2.fromOffset(width, 38); button.Root.Position = UDim2.new(1, -(width + 12), 0.5, -19)
    return element(card, {Button = button})
end

function Container:Toggle(spec)
    spec = spec or {}
    local window = self.Window
    local value, restored = window:_initial(spec, spec.Default == true)
    value = value == true
    local card = self:_add((window:_controlCard(self.Frame, spec.Title or "Toggle", spec.Description, 58)))
    local switch = new("TextButton", {Position = UDim2.new(1, -62, 0.5, -15), Size = UDim2.fromOffset(50, 30), Text = "", AutoButtonColor = false, BorderSizePixel = 0}, card)
    round(switch, 30)
    local knob = new("Frame", {Position = UDim2.fromOffset(4, 4), Size = UDim2.fromOffset(22, 22), BorderSizePixel = 0}, switch)
    round(knob, 22)
    local object = element(card, {Flag = spec.Flag, Switch = switch})
    local function refresh(instant)
        window:_tint(switch, {BackgroundColor3 = value and "AccentDark" or "Raised"}, instant and 0 or nil)
        window:_tint(knob, {BackgroundColor3 = value and "Text" or "Muted"}, instant and 0 or nil, {Position = UDim2.fromOffset(value and 24 or 4, 4)})
    end
    function object:Set(newValue, silent)
        newValue = newValue == true
        if newValue == value then return end
        value = newValue
        refresh()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    function object:Toggle() object:Set(not value) end
    window:_on(switch.Activated, function() object:Set(not value) end)
    refresh(true)
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

local function stepValues(spec)
    if type(spec.Values) == "table" and #spec.Values > 0 then return spec.Values end
    local min, max, step = tonumber(spec.Min) or 0, tonumber(spec.Max) or 10, tonumber(spec.Step) or 1
    if step <= 0 then step = 1 end
    local values = {}
    for i = 0, math.clamp(math.floor((max - min) / step + 0.5), 0, 1000) do table.insert(values, snap(min + i * step, step, min)) end
    return values
end
-- Minus / value / plus. Values = {…} or Min, Max and Step.
function Container:Stepper(spec)
    spec = spec or {}
    local window = self.Window
    local values = stepValues(spec)
    local format = spec.Format or function(v) return tostring(v) .. (spec.Suffix or "") end
    local value, restored = window:_initial(spec, spec.Default or values[1])
    local card = self:_add((window:_controlCard(self.Frame, spec.Title or "Stepper", spec.Description, 140)))
    local box = new("Frame", {Size = UDim2.fromOffset(140, 38), Position = UDim2.new(1, -152, 0.5, -19), BackgroundTransparency = 1}, card)
    local label = window:_text(box, "", 13, "Text", true)
    label.Position = UDim2.fromOffset(38, 0); label.Size = UDim2.new(1, -76, 1, 0); label.TextXAlignment = Enum.TextXAlignment.Center
    local object = element(card, {Flag = spec.Flag})
    local function show() label.Text = tostring(format(value)) end
    function object:Set(newValue, silent)
        if newValue == value then show(); return end
        value = newValue
        show()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    local function step(direction)
        local index = 1
        for i, item in ipairs(values) do if item <= value then index = i end end
        object:Set(values[math.clamp(index + direction, 1, #values)])
    end
    local minus = window:_button(box, "", false, function() step(-1) end, "minus")
    minus.Root.Size = UDim2.fromOffset(36, 38)
    local plus = window:_button(box, "", false, function() step(1) end, "plus")
    plus.Root.Size = UDim2.fromOffset(36, 38); plus.Root.Position = UDim2.new(1, -36, 0, 0)
    show()
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

-- A track with a knob. Drag or tap anywhere on the track.
function Container:Slider(spec)
    spec = spec or {}
    local window, container = self.Window, self
    local min, max = tonumber(spec.Min) or 0, tonumber(spec.Max) or 100
    if max <= min then max = min + 1 end
    local step = tonumber(spec.Step) or 1
    if step <= 0 then step = 1 end
    local format = spec.Format or function(v) return tostring(v) .. (spec.Suffix or "") end
    local value, restored = window:_initial(spec, snap(math.clamp(tonumber(spec.Default) or min, min, max), step, min))
    local card = self:_add((window:_controlCard(self.Frame, spec.Title or "Slider", spec.Description, 176)))
    local holder = new("Frame", {Size = UDim2.fromOffset(176, 38), Position = UDim2.new(1, -188, 0.5, -19), BackgroundTransparency = 1}, card)
    local label = window:_text(holder, "", 13, "Text", true)
    label.Size = UDim2.new(0, 52, 1, 0); label.TextXAlignment = Enum.TextXAlignment.Center
    local track = new("Frame", {Position = UDim2.new(0, 64, 0.5, -3), Size = UDim2.new(1, -74, 0, 6), BorderSizePixel = 0}, holder)
    window:_paint(track, {BackgroundColor3 = "Raised"})
    round(track, 3)
    local fill = new("Frame", {Size = UDim2.fromScale(0, 1), BorderSizePixel = 0}, track)
    window:_paint(fill, {BackgroundColor3 = "Accent"})
    round(fill, 3)
    local knob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(18, 18), BorderSizePixel = 0}, track)
    window:_paint(knob, {BackgroundColor3 = "Text"})
    round(knob, 9)
    window:_stroke(knob, 0.1, "AccentDark")
    local hit = new("TextButton", {Position = UDim2.fromOffset(56, 0), Size = UDim2.new(1, -56, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, holder)
    local object = element(card, {Flag = spec.Flag})
    local function show(instant)
        local ratio = (value - min) / (max - min)
        label.Text = tostring(format(value))
        window:_tween(fill, {Size = UDim2.fromScale(ratio, 1)}, instant and 0 or 0.08)
        window:_tween(knob, {Position = UDim2.fromScale(ratio, 0.5)}, instant and 0 or 0.08)
    end
    function object:Set(newValue, silent)
        newValue = snap(math.clamp(tonumber(newValue) or min, min, max), step, min)
        if newValue == value then return end
        value = newValue
        show()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    local dragging, touch
    local function update(x)
        local width = track.AbsoluteSize.X
        if width <= 0 then return end
        object:Set(min + math.clamp((x - track.AbsolutePosition.X) / width, 0, 1) * (max - min))
    end
    window:_on(hit.InputBegan, function(input)
        if not isPointer(input) then return end
        dragging = true
        touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        if container.Page then container.Page.ScrollingEnabled = false end
        update(input.Position.X)
    end)
    window:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if touch and input ~= touch then return end
        if not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        update(input.Position.X)
    end)
    window:_connect(UserInputService.InputEnded, function(input)
        if dragging and ((touch and input == touch) or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            dragging = false
            touch = nil
            if container.Page then container.Page.ScrollingEnabled = true end
            window:_fire(spec.Released, value)
        end
    end)
    show(true)
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

-- With a Title it is a settings card with the picker on the right; without one, a full-width picker.
function Container:Dropdown(spec)
    spec = spec or {}
    local window = self.Window
    local options = normalizeOptions(spec.Options)
    local default = spec.Default
    if default == nil and spec.Placeholder == nil and options[1] then default = options[1].Value end
    local value, restored = window:_initial(spec, default)
    local object = element(nil, {Flag = spec.Flag})
    local width = spec.Width or 150
    local card = spec.Title and (window:_controlCard(self.Frame, spec.Title, spec.Description, width)) or nil
    local drop = window:_dropdown(card or self.Frame, options, function() return value end, function(newValue) object:Set(newValue) end, spec.Placeholder)
    if card then
        drop.Root.Size = UDim2.fromOffset(width, 40); drop.Root.Position = UDim2.new(1, -(width + 12), 0.5, -20)
    end
    object.Root = self:_add(card or drop.Root)
    function object:Set(newValue, silent)
        if newValue == value then drop.refresh(); return end
        value = newValue
        drop.refresh()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    function object:SetOptions(newOptions, keepValue)
        options = normalizeOptions(newOptions)
        drop.Options = options
        if not keepValue and labelFor(options, value) == nil then
            value = options[1] and options[1].Value or nil
            window:_setFlag(spec.Flag, value)
        end
        drop.refresh()
    end
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

-- Text field. Callback(text, enterPressed) runs when it loses focus or its button is pressed;
-- Changed(text) runs while typing (debounced). Button = true adds an arrow button on the right.
function Container:Input(spec)
    if type(spec) ~= "table" then spec = {Placeholder = spec} end
    local window = self.Window
    local value, restored = window:_initial(spec, tostring(spec.Default or ""))
    local root, holder = nil, self.Frame
    if spec.Title then
        root = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame)
        list(root, 6)
        local title = window:_text(root, spec.Title, 12, "Muted", true)
        title.Size = UDim2.new(1, 0, 0, 18); title.LayoutOrder = 1
        holder = root
    end
    local frame = window:_card(holder, 42)
    frame.LayoutOrder = 2
    window:_paint(frame, {BackgroundColor3 = "Base"})
    local left = 14
    if spec.Icon ~= false then window:_icon(frame, spec.Icon or "search", UDim2.new(0, 11, 0.5, -12), "Muted"); left = 42 end
    local box = new("TextBox", {Position = UDim2.fromOffset(left, 0), Size = UDim2.new(1, -(left + 12 + (spec.Button and 46 or 0)), 1, 0), BackgroundTransparency = 1,
        Text = value, PlaceholderText = spec.Placeholder or "", Font = Lyra.Font.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = spec.ClearOnFocus == true}, frame)
    window:_paint(box, {TextColor3 = "Text", PlaceholderColor3 = "Muted"})
    local border = frame:FindFirstChildOfClass("UIStroke")
    self:_add(root or frame)
    local object = element(root or frame, {Box = box, Flag = spec.Flag})
    local function submit(entered)
        value = box.Text
        window:_setFlag(spec.Flag, value)
        window:_fire(spec.Callback, value, entered == true)
    end
    if spec.Button then
        local go = window:_button(frame, "", false, function() submit(true) end, spec.ButtonIcon or "arrow")
        go.Root.Size = UDim2.fromOffset(38, 34); go.Root.Position = UDim2.new(1, -42, 0.5, -17)
        object.Button = go
    end
    window:_on(box.Focused, function() window:_tint(border, {Color = "Accent"}, nil, {Transparency = 0.15}) end)
    window:_on(box.FocusLost, function(enter)
        window:_tint(border, {Color = "Line"}, nil, {Transparency = 0.55})
        submit(enter)
    end)
    local token = 0
    window:_on(box:GetPropertyChangedSignal("Text"), function()
        local text = box.Text
        if spec.Numeric then text = text:gsub("[^%d%.%-]", "") end
        if spec.MaxLength and #text > spec.MaxLength then text = text:sub(1, spec.MaxLength) end
        if text ~= box.Text then box.Text = text; return end
        if spec.Changed then
            token = token + 1
            local mine = token
            task.delay(spec.Debounce or 0.25, function() if window.Alive and mine == token then window:_fire(spec.Changed, box.Text) end end)
        end
    end)
    function object:Set(text, silent)
        box.Text = tostring(text or "")
        value = box.Text
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value, false) end
    end
    function object:Get() return box.Text end
    function object:Focus() box:CaptureFocus() end
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value, false) end
    return object
end

-- Multi-line box (monospace by default). Editable = false makes it a read-only code display.
function Container:TextArea(spec)
    spec = spec or {}
    local window = self.Window
    local value, restored = window:_initial(spec, tostring(spec.Default or spec.Text or ""))
    local box = self:_add(new("TextBox", {Size = UDim2.new(1, 0, 0, spec.Height or 58), BorderSizePixel = 0, Text = value, PlaceholderText = spec.Placeholder or "",
        TextSize = textSize(12), Font = spec.Code == false and Lyra.Font.Regular or Lyra.Font.Code, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false,
        TextEditable = spec.Editable ~= false, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, self.Frame))
    window:_paint(box, {BackgroundColor3 = "Card", TextColor3 = "Text", PlaceholderColor3 = "Muted"})
    round(box, 12)
    padding(box, 8, 10, 8, 10)
    local object = element(box, {Box = box, Flag = spec.Flag})
    window:_on(box.FocusLost, function()
        value = box.Text
        window:_setFlag(spec.Flag, value)
        window:_fire(spec.Callback, value)
    end)
    function object:Set(text) box.Text = tostring(text or ""); value = box.Text; window:_setFlag(spec.Flag, value) end
    function object:Get() return box.Text end
    function object:Copy() return copyText(box.Text) end
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end
Container.Code = Container.TextArea

function Container:Keybind(spec)
    spec = spec or {}
    local window = self.Window
    local default = spec.Default
    if typeof(default) == "EnumItem" then default = default.Name end
    local value, restored = window:_initial(spec, default ~= nil and tostring(default) or "None")
    local card = self:_add((window:_controlCard(self.Frame, spec.Title or "Keybind", spec.Description, 124)))
    local object = element(card, {Flag = spec.Flag, Value = value, Pressed = spec.Callback})
    local button
    local function show() button:SetText(value == "None" and "Not set" or value) end
    function object:Set(key, silent)
        if typeof(key) == "EnumItem" then key = key.Name end
        value = tostring(key or "None")
        object.Value = value
        show()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Changed, value) end
    end
    function object:Get() return value end
    button = window:_button(card, "", false, function()
        button:SetText("Press a key…")
        window.CaptureToken = (window.CaptureToken or 0) + 1
        local token = window.CaptureToken
        window.Capture = {
            Done = function(key)
                if type(spec.Blocked) == "table" and table.find(spec.Blocked, key) then
                    window:Status("That key is already used by the game. Choose another one.", "warning")
                    show()
                    return
                end
                object:Set(key)
            end,
            Cancel = show,
        }
        task.delay(10, function()
            if window.Alive and token == window.CaptureToken and window.Capture then window.Capture = nil; show() end
        end)
    end)
    button.Root.Size = UDim2.fromOffset(124, 38); button.Root.Position = UDim2.new(1, -136, 0.5, -19)
    show()
    table.insert(window.Keybinds, object)
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Changed, value) end
    return object
end

-- A row of pill filters that scrolls sideways. Small = true for a second, lighter row.
function Container:Chips(spec)
    spec = spec or {}
    local window = self.Window
    local options = normalizeOptions(spec.Options)
    local default = spec.Default
    if default == nil and options[1] then default = options[1].Value end
    local value, restored = window:_initial(spec, default)
    local small = spec.Small == true
    local height = small and 30 or 34
    local scroll = self:_add(new("ScrollingFrame", {Size = UDim2.new(1, 0, 0, height + 2), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, ElasticBehavior = Enum.ElasticBehavior.Never}, self.Frame))
    list(scroll, 6, Enum.FillDirection.Horizontal)
    local chips = {}
    local object = element(scroll, {Flag = spec.Flag})
    local function paint()
        for _, chip in ipairs(chips) do
            local selected = chip.Value == value
            window:_paint(chip.Root, {BackgroundColor3 = selected and "AccentDark" or "Raised", TextColor3 = selected and "Text" or "Muted"})
        end
    end
    local function build()
        for _, chip in ipairs(chips) do chip.Root:Destroy() end
        chips = {}
        for index, option in ipairs(options) do
            local chip = new("TextButton", {LayoutOrder = index, Size = UDim2.fromOffset(0, height), AutomaticSize = Enum.AutomaticSize.X, Text = option.Label,
                Font = Lyra.Font.Bold, TextSize = textSize(small and 11 or 12), AutoButtonColor = false, BorderSizePixel = 0}, scroll)
            round(chip, height / 2)
            padding(chip, 0, small and 12 or 14, 0, small and 12 or 14)
            table.insert(chips, {Root = chip, Value = option.Value})
            window:_on(chip.Activated, function() object:Set(option.Value) end)
        end
        paint()
    end
    function object:Set(newValue, silent)
        if newValue == value then return end
        value = newValue
        paint()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    function object:SetOptions(newOptions)
        options = normalizeOptions(newOptions)
        if labelFor(options, value) == nil then value = options[1] and options[1].Value or nil end
        build()
    end
    build()
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

-- Two or more buttons that act as tabs inside a page (one is always selected).
function Container:Segmented(spec)
    spec = spec or {}
    local window = self.Window
    local options = normalizeOptions(spec.Options)
    local default = spec.Default
    if default == nil and options[1] then default = options[1].Value end
    local value, restored = window:_initial(spec, default)
    local frame = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, spec.Height or 44), BackgroundTransparency = 1}, self.Frame))
    local object = element(frame, {Flag = spec.Flag, Buttons = {}})
    local roots = {}
    local function paint()
        for _, entry in ipairs(object.Buttons) do entry.Button:SetKey(entry.Value == value and "AccentDark" or "Raised") end
    end
    for _, option in ipairs(options) do
        local button = window:_button(frame, option.Label, false, function() object:Set(option.Value) end, option.Icon)
        table.insert(object.Buttons, {Button = button, Value = option.Value})
        table.insert(roots, button.Root)
    end
    spread(roots, spec.Gap or 12)
    function object:Set(newValue, silent)
        if newValue == value then return end
        value = newValue
        paint()
        window:_setFlag(spec.Flag, value)
        if not silent then window:_fire(spec.Callback, value) end
    end
    function object:Get() return value end
    paint()
    window:_registerFlag(spec.Flag, object)
    if restored then window:_fire(spec.Callback, value) end
    return object
end

-- A card that holds other elements. Title adds a small accent caption on top.
function Container:Group(spec)
    if type(spec) ~= "table" then spec = {Title = spec} end
    local window = self.Window
    local card = self:_add(window:_autoCard(self.Frame, spec.Gap or 8, spec.Padding or 14))
    local group = newContainer(window, card, self.Page)
    group.Root = card
    if spec.Title then group:_add(window:_paragraph(card, spec.Title, 10, "Accent", true)) end
    return group
end

-- Two columns side by side that stack on narrow windows. Returns (left, right).
function Container:Columns(spec)
    spec = spec or {}
    local window = self.Window
    local gap, inner = spec.Gap or 10, spec.InnerGap or 8
    local holder = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame))
    local layout = list(holder, gap, Enum.FillDirection.Horizontal)
    local function column(order)
        local frame = new("Frame", {LayoutOrder = order, Size = UDim2.new(0.5, -math.floor(gap / 2), 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, holder)
        list(frame, inner)
        local item = newContainer(window, frame, self.Page)
        item.Root = frame
        return item
    end
    local left, right = column(1), column(2)
    window:_onLayout(holder, function(state)
        local stack = state.Compact
        layout.FillDirection = stack and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, stack and inner or gap)
        local size = stack and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, -math.floor(gap / 2), 0, 0)
        left.Frame.Size, right.Frame.Size = size, size
    end)
    return left, right
end

-- Options that stay folded until opened (progressive disclosure), so a page starts short.
function Container:Collapsible(spec)
    if type(spec) ~= "table" then spec = {Title = spec} end
    local window = self.Window
    local closedTitle = spec.Title or "Show advanced options"
    local openTitle = spec.OpenTitle or (spec.Title and spec.Title or "Hide advanced options")
    local holder = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame))
    list(holder, 6)
    local body = new("Frame", {LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = spec.Open == true}, holder)
    list(body, spec.Gap or 6)
    local section = newContainer(window, body, self.Page)
    section.Root = holder
    local head = window:_button(holder, body.Visible and openTitle or closedTitle, false, function() section:SetOpen(not body.Visible) end, spec.Icon or "chevron-down")
    head.Root.LayoutOrder = 1
    section.Header = head
    function section:SetOpen(open)
        body.Visible = open == true
        head:SetText(body.Visible and openTitle or closedTitle)
        if head.Icon then head.Icon.Rotation = body.Visible and 180 or 0 end
        window:_fire(spec.Callback, body.Visible)
    end
    function section:IsOpen() return body.Visible end
    if head.Icon then head.Icon.Rotation = body.Visible and 180 or 0 end
    return section
end

-- An underlined "How it works" link that unfolds a short guide.
function Container:Guide(spec)
    spec = spec or {}
    local window = self.Window
    local closedTitle = spec.Title or "How it works"
    local openTitle = spec.OpenTitle or ("Hide " .. closedTitle:sub(1, 1):lower() .. closedTitle:sub(2))
    local row = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1}, self.Frame))
    local label = new("TextLabel", {Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, RichText = true,
        Text = "<u>" .. escape(closedTitle) .. "</u>", Font = Lyra.Font.Bold, TextSize = textSize(12), TextXAlignment = Enum.TextXAlignment.Left}, row)
    window:_paint(label, {TextColor3 = "Accent"})
    local chevrons = new("Frame", {Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 0, 0.5, -9), BackgroundTransparency = 1}, row)
    new("UIScale", {Scale = 0.75}, chevrons)
    local down = window:_icon(chevrons, "chevron-down", UDim2.new(), "Accent")
    local up = window:_icon(chevrons, "chevron-up", UDim2.new(), "Accent")
    up.Visible = false
    -- The chevron follows the label's measured width.
    local function place() chevrons.Position = UDim2.new(0, label.AbsoluteSize.X / (window.CurrentScale or 1) + 4, 0.5, -9) end
    window:_on(label:GetPropertyChangedSignal("AbsoluteSize"), place)
    task.defer(place)
    local hit = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3}, row)
    local card = self:_add(window:_autoCard(self.Frame, 6, 12))
    local lines = spec.Lines or {}
    for index, text in ipairs(lines) do window:_paragraph(card, text, 12, "Text").LayoutOrder = index end
    if spec.Note then window:_paragraph(card, spec.Note, 11, "Muted").LayoutOrder = #lines + 1 end
    local object = element(row, {Card = card})
    function object:SetOpen(open)
        card.Visible = open == true
        label.Text = "<u>" .. escape(card.Visible and openTitle or closedTitle) .. "</u>"
        down.Visible, up.Visible = not card.Visible, card.Visible
    end
    function object:SetVisible(visible)
        row.Visible = visible ~= false
        if not row.Visible then card.Visible = false end
    end
    function object:Destroy() card:Destroy(); row:Destroy() end
    window:_on(hit.Activated, function() object:SetOpen(not card.Visible) end)
    object:SetOpen(spec.Open == true)
    return object
end

-- -----------------------------------------------------------------------------
-- Rows, lists, grids and cards
-- -----------------------------------------------------------------------------
-- One list row: optional number badge, picture or icon, title, subtitle and buttons on the right.
-- Buttons with an icon and a title shrink to the icon on narrow windows.
function Window:_row(parent, spec, number)
    local window = self
    local card = self:_card(parent, 58)
    local stroke = card:FindFirstChildOfClass("UIStroke")
    local object = element(card, {Spec = spec, Buttons = {}})
    local left = 10
    if number then
        local badge = new("Frame", {Position = UDim2.fromOffset(9, 15), Size = UDim2.fromOffset(28, 28), BorderSizePixel = 0}, card)
        round(badge, 9)
        self:_paint(badge, {BackgroundColor3 = spec.Current and "Accent" or "Raised"})
        local digits = self:_text(badge, tostring(number), 12, spec.Current and "Base" or "Text", true)
        digits.Size = UDim2.fromScale(1, 1); digits.TextXAlignment = Enum.TextXAlignment.Center
        left = 44
    end
    local thumb = new("ImageLabel", {Position = UDim2.fromOffset(left, 9), Size = UDim2.fromOffset(40, 40), BorderSizePixel = 0, Image = "", ScaleType = Enum.ScaleType.Crop, ClipsDescendants = true}, card)
    self:_paint(thumb, {BackgroundColor3 = "Raised"})
    round(thumb, 12)
    if spec.Image then thumb.Image = tostring(spec.Image) elseif spec.Icon then self:_icon(thumb, spec.Icon, UDim2.fromOffset(8, 8), "Accent") end
    local textLeft = left + 50
    local title = self:_text(card, spec.Title or "", 13, "Text", true)
    title.Position = UDim2.fromOffset(textLeft, 8)
    local sub = self:_text(card, spec.Subtitle or "", 11, "Muted")
    sub.Position = UDim2.fromOffset(textLeft, 30)
    object.Thumb, object.TitleLabel, object.SubtitleLabel = thumb, title, sub
    local function state()
        local selected, current = object.Spec.Selected == true, object.Spec.Current == true
        self:_paint(stroke, {Color = (selected or current) and "Accent" or "Line"})
        stroke.Transparency = selected and 0 or current and 0.1 or 0.55
        self:_paint(title, {TextColor3 = selected and "Accent" or "Text"})
        self:_paint(sub, {TextColor3 = (current or object.Spec.Highlight) and "Accent" or "Muted"})
    end
    for _, buttonSpec in ipairs(spec.Buttons or {}) do
        local button = self:_button(card, buttonSpec.Title or "", buttonSpec.Primary, function()
            if type(buttonSpec.Callback) == "function" then buttonSpec.Callback(spec, object) end
        end, buttonSpec.Icon)
        button.Spec = buttonSpec
        table.insert(object.Buttons, button)
    end
    local function place(compact)
        local x = 10
        for index = #object.Buttons, 1, -1 do
            local button = object.Buttons[index]
            local buttonSpec = button.Spec
            local text = tostring(buttonSpec.Title or "")
            local iconOnly = text == "" or (compact and buttonSpec.Icon ~= nil and buttonSpec.Collapse ~= false)
            button:SetText(iconOnly and "" or text)
            local width = buttonSpec.Width or (iconOnly and 40 or math.max(58, math.ceil(measure(text, textSize(13), Lyra.Font.Bold).X) + (buttonSpec.Icon and 52 or 26)))
            button.Root.Size = UDim2.fromOffset(width, 38)
            button.Root.Position = UDim2.new(1, -(x + width), 0.5, -19)
            x = x + width + 6
        end
        title.Size = UDim2.new(1, -(textLeft + x + 4), 0, 22)
        sub.Size = UDim2.new(1, -(textLeft + x + 4), 0, 20)
    end
    function object:SetTitle(text) title.Text = tostring(text or "") end
    function object:SetSubtitle(text) sub.Text = tostring(text or "") end
    function object:SetImage(image) thumb.Image = tostring(image or "") end
    function object:SetSelected(on) object.Spec.Selected = on == true; state() end
    function object:SetCurrent(on) object.Spec.Current = on == true; state() end
    state()
    place(window.Compact == true)
    self:_onLayout(card, function(layout) place(layout.Compact) end)
    return object
end
function Window:_empty(parent, title, hint, icon)
    local card = self:_card(parent, 126)
    self:_icon(card, icon or "search", UDim2.new(0.5, -12, 0, 16), "AccentDark")
    local label = self:_text(card, title or "Nothing here", 14, "Text", true)
    label.Position = UDim2.fromOffset(14, 53); label.Size = UDim2.new(1, -28, 0, 23); label.TextXAlignment = Enum.TextXAlignment.Center
    local text = self:_text(card, hint or "", 11, "Muted")
    text.Position = UDim2.fromOffset(14, 80); text.Size = UDim2.new(1, -28, 0, 31); text.TextWrapped = true
    text.TextTruncate = Enum.TextTruncate.None; text.TextXAlignment = Enum.TextXAlignment.Center
    return card
end

function Container:Row(spec)
    local row = self.Window:_row(self.Frame, spec or {})
    self:_add(row.Root)
    return row
end
function Container:Empty(spec, hint, icon)
    if type(spec) ~= "table" then spec = {Title = spec, Text = hint, Icon = icon} end
    return element(self:_add(self.Window:_empty(self.Frame, spec.Title, spec.Text or spec.Description, spec.Icon)))
end

-- A list of rows with an empty state. Reorderable = true adds number badges: drag the number or picture of a
-- row to move it (a line marks where it will land and the page scrolls near the edges).
function Container:List(spec)
    spec = spec or {}
    local window, container = self.Window, self
    local frame = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame))
    list(frame, 6)
    local reorder = spec.Reorderable == true or type(spec.OnReorder) == "function"
    local object = element(frame, {Items = {}, Rows = {}})
    local emptyCard
    local startDrag
    local function addRow(item, index)
        if emptyCard then emptyCard:Destroy(); emptyCard = nil end
        local row = window:_row(frame, item, reorder and index or nil)
        row.Root.LayoutOrder = index
        row.Index = index
        if reorder then
            local grip = new("TextButton", {Size = UDim2.new(0, 92, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0}, row.Root)
            window:_on(grip.InputBegan, function(input) if isPointer(input) then startDrag(row.Index, row.Root, input) end end)
        end
        table.insert(object.Rows, row)
        return row
    end
    local function render()
        for _, row in ipairs(object.Rows) do row.Root:Destroy() end
        object.Rows = {}
        if emptyCard then emptyCard:Destroy(); emptyCard = nil end
        for index, item in ipairs(object.Items) do addRow(item, index) end
        if #object.Items == 0 and spec.Empty ~= false then
            emptyCard = window:_empty(frame, spec.EmptyTitle or "Nothing here yet", spec.EmptyText or "Items you add will appear here.", spec.EmptyIcon)
        end
    end
    function startDrag(index, row, input)
        if object.Dragging or #object.Items < 2 then return end
        local touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        local drag = {From = index, Slot = nil, Connections = {}}
        object.Dragging = drag
        local page = container.Page
        if page then page.ScrollingEnabled = false end
        local stroke = row:FindFirstChildOfClass("UIStroke")
        if stroke then window:_paint(stroke, {Color = "Accent"}); stroke.Transparency = 0 end
        row.BackgroundTransparency = 0.55
        local width = frame.AbsoluteSize.X
        drag.Line = new("Frame", {Size = UDim2.fromOffset(width, 3), BorderSizePixel = 0, ZIndex = 40}, window.Surface)
        window:_paint(drag.Line, {BackgroundColor3 = "Accent"})
        round(drag.Line, 2)
        drag.Ghost = new("TextLabel", {Size = UDim2.fromOffset(math.max(120, math.min(260, width - 24)), 36), BackgroundTransparency = 0.05,
            Text = "  " .. tostring(object.Items[index].Title or ""), Font = Lyra.Font.Bold, TextSize = textSize(13), TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 41, BorderSizePixel = 0}, window.Surface)
        window:_paint(drag.Ghost, {BackgroundColor3 = "AccentDark", TextColor3 = "Text"})
        round(drag.Ghost, 10)
        window:_stroke(drag.Ghost, 0.2, "Accent")
        local function update(y)
            local top, surface = frame.AbsolutePosition.Y, window.Surface.AbsolutePosition
            -- Rows live inside the scaled window, so one step on screen is (row + gap) times the window scale.
            local step = 64 * (window.CurrentScale or 1)
            drag.Slot = math.clamp(math.floor((y - top) / step + 0.5), 0, #object.Items)
            drag.Line.Position = UDim2.fromOffset(frame.AbsolutePosition.X - surface.X, top + drag.Slot * step - 4 - surface.Y)
            drag.Ghost.Position = UDim2.fromOffset(frame.AbsolutePosition.X - surface.X + 12, y - 18 - surface.Y)
            if page then
                local pageTop = page.AbsolutePosition.Y
                local pageBottom = pageTop + page.AbsoluteSize.Y
                if y < pageTop + 48 then page.CanvasPosition = Vector2.new(0, math.max(0, page.CanvasPosition.Y - 14))
                elseif y > pageBottom - 48 then page.CanvasPosition = Vector2.new(0, page.CanvasPosition.Y + 14) end
            end
        end
        local function finish()
            for _, connection in ipairs(drag.Connections) do connection:Disconnect() end
            object.Dragging = nil
            pcall(function() drag.Line:Destroy(); drag.Ghost:Destroy() end)
            if page then page.ScrollingEnabled = true end
            if not window.Alive then return end
            if drag.Slot then
                -- Slot s is the gap before item s+1 in the original order.
                local target = math.clamp(drag.Slot >= drag.From and drag.Slot or drag.Slot + 1, 1, #object.Items)
                if target ~= drag.From then
                    table.insert(object.Items, target, table.remove(object.Items, drag.From))
                    render()
                    window:_fire(spec.OnReorder, drag.From, target, object.Items)
                    return
                end
            end
            render()
        end
        table.insert(drag.Connections, UserInputService.InputChanged:Connect(function(changed)
            if touch and changed ~= touch then return end
            if not touch and changed.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if window.Alive then update(changed.Position.Y) end
        end))
        table.insert(drag.Connections, UserInputService.InputEnded:Connect(function(ended)
            if (touch and ended == touch) or (not touch and ended.UserInputType == Enum.UserInputType.MouseButton1) then finish() end
        end))
        update(input.Position.Y)
    end
    function object:Add(item)
        table.insert(object.Items, item)
        return addRow(item, #object.Items)
    end
    function object:Remove(index)
        if type(index) == "table" then index = table.find(object.Items, index) end
        if index and object.Items[index] then table.remove(object.Items, index); render() end
    end
    function object:Set(items)
        object.Items = {}
        for _, item in ipairs(items or {}) do table.insert(object.Items, item) end
        render()
    end
    function object:Get() return object.Items end
    function object:Clear() object:Set({}) end
    function object:Refresh() render() end
    object:Set(spec.Items)
    return object
end

-- A grid of picture cards (shop items, presets, games…). Columns follow the window width.
function Container:Grid(spec)
    spec = spec or {}
    local window = self.Window
    local cellHeight, minCell = spec.CellHeight or 200, spec.MinWidth or 150
    local frame = self:_add(new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, self.Frame))
    local layout = new("UIGridLayout", {CellSize = UDim2.fromOffset(minCell, cellHeight), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder}, frame)
    local object = element(frame, {Cards = {}, Count = 0})
    -- Cells are sized in whole pixels so every column fits the row exactly (scale-based cells could round
    -- one column onto the next row and leave a gap on the right).
    local function columns()
        local scale = window.WindowScale.Scale > 0 and window.WindowScale.Scale or 1
        local width = math.floor(frame.AbsoluteSize.X / scale)
        if width <= 0 then return end
        local count = math.clamp(math.floor((width + 8) / (minCell + 8)), spec.MinColumns or 2, spec.MaxColumns or 6)
        layout.FillDirectionMaxCells = count
        layout.CellSize = UDim2.fromOffset(math.floor((width - 8 * (count - 1)) / count), cellHeight)
    end
    window:_on(frame:GetPropertyChangedSignal("AbsoluteSize"), columns)
    function object:Add(item)
        item = item or {}
        object.Count = object.Count + 1
        local card = new("Frame", {LayoutOrder = object.Count, BackgroundTransparency = 0.22, BorderSizePixel = 0}, frame)
        window:_paint(card, {BackgroundColor3 = "Card"})
        round(card, 14)
        window:_stroke(card, 0.55)
        local thumb = new("TextButton", {Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 96), Text = "", AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true}, card)
        window:_paint(thumb, {BackgroundColor3 = "Raised"})
        round(thumb, 10)
        local picture = new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Fit, Image = tostring(item.Image or "")}, thumb)
        if not item.Image and item.Icon then
            local icon = window:_icon(thumb, item.Icon, UDim2.new(0.5, -12, 0.5, -12), "AccentDark")
            new("UIScale", {Scale = 1.6}, icon)
        end
        if item.Tag then
            local tag = window:_text(thumb, tostring(item.Tag), 9, "Base", true)
            tag.AutomaticSize = Enum.AutomaticSize.X; tag.Size = UDim2.fromOffset(0, 18); tag.Position = UDim2.fromOffset(6, 6); tag.BackgroundTransparency = 0
            window:_paint(tag, {BackgroundColor3 = "Accent"})
            round(tag, 9)
            padding(tag, 0, 7, 0, 7)
        end
        -- Green check on the picture for items that are selected / owned / worn.
        local check = new("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 6), Size = UDim2.fromOffset(24, 24), BorderSizePixel = 0, Visible = item.Checked == true}, thumb)
        window:_paint(check, {BackgroundColor3 = "Green"})
        round(check, 12)
        Toast.glyph(check, "check", window.Theme.Base)
        local name = window:_text(card, item.Title or "", 12, "Text", true)
        name.Position = UDim2.fromOffset(10, 110); name.Size = UDim2.new(1, -20, 0, 32); name.TextWrapped = true; name.TextYAlignment = Enum.TextYAlignment.Top
        local caption = window:_text(card, item.Caption or "", 10, "Muted")
        caption.Position = UDim2.fromOffset(10, 142); caption.Size = UDim2.new(1, -20, 0, 16)
        local entry = element(card, {Item = item, Picture = picture})
        if item.Button ~= false then
            local buttonSpec = type(item.Button) == "table" and item.Button or {Title = type(item.Button) == "string" and item.Button or "Select"}
            local button = window:_button(card, buttonSpec.Title or "Select", buttonSpec.Primary ~= false, function()
                local callback = buttonSpec.Callback or item.Callback
                if type(callback) == "function" then callback(item, entry) end
            end, buttonSpec.Icon)
            button.Root.Position = UDim2.new(0, 8, 1, -42); button.Root.Size = UDim2.new(1, -16, 0, 34)
            entry.Button = button
        end
        if item.OnClick or item.Callback then
            window:_on(thumb.Activated, function() window:_fire(item.OnClick or item.Callback, item, entry) end)
        end
        function entry:SetChecked(on) check.Visible = on == true end
        function entry:SetCaption(text) caption.Text = tostring(text or "") end
        function entry:SetTitle(text) name.Text = tostring(text or "") end
        table.insert(object.Cards, entry)
        columns()
        return entry
    end
    function object:Clear()
        for _, entry in ipairs(object.Cards) do entry.Root:Destroy() end
        object.Cards, object.Count = {}, 0
    end
    function object:Set(items)
        object:Clear()
        for _, item in ipairs(items or {}) do object:Add(item) end
    end
    object:Set(spec.Items)
    task.defer(columns)
    return object
end

-- A 3D model viewer: drag to rotate, wheel or buttons to zoom. Pass a model you own (a clone);
-- the preview destroys the previous model when a new one is set.
function Container:Preview(spec)
    spec = spec or {}
    local window, container = self.Window, self
    local card = self:_add(window:_card(self.Frame, spec.Height or 300))
    window:_gradient(card, "Raised", "Card", 60)
    local tag = window:_text(card, spec.Title or "3D PREVIEW", 10, "Accent", true)
    tag.Position = UDim2.fromOffset(16, 13); tag.Size = UDim2.new(1, -32, 0, 16)
    local viewport = new("ViewportFrame", {Position = UDim2.fromOffset(8, 32), Size = UDim2.new(1, -16, 1, -87), BackgroundTransparency = 1, Ambient = Color3.fromRGB(195, 186, 213),
        LightColor = Color3.fromRGB(255, 244, 233), LightDirection = Vector3.new(-1, -1, -1), Active = true, Visible = false}, card)
    local fallback = new("ImageLabel", {Position = UDim2.fromOffset(8, 30), Size = UDim2.new(1, -16, 1, -90), BackgroundTransparency = 1, Image = "", ScaleType = Enum.ScaleType.Fit, Visible = false}, card)
    local world = new("WorldModel", {}, viewport)
    local camera = new("Camera", {FieldOfView = 35}, viewport)
    viewport.CurrentCamera = camera
    local empty = new("Frame", {Position = UDim2.fromOffset(8, 40), Size = UDim2.new(1, -16, 1, -106), BackgroundTransparency = 1}, card)
    local motif = window:_icon(empty, spec.Icon or "user", UDim2.new(0.5, -12, 0.5, -48), "AccentDark")
    new("UIScale", {Scale = 1.5}, motif)
    local defaultHint = spec.Hint or "Nothing to preview yet."
    local hint = window:_text(empty, defaultHint, 13, "Muted")
    hint.Position = UDim2.new(0, 12, 0.5, 10); hint.Size = UDim2.new(1, -24, 0, 42); hint.TextWrapped = true
    hint.TextTruncate = Enum.TextTruncate.None; hint.TextXAlignment = Enum.TextXAlignment.Center
    local bar = new("Frame", {Position = UDim2.new(0.2, 0, 0.5, 61), Size = UDim2.new(0.6, 0, 0, 3), BackgroundTransparency = 0.6, BorderSizePixel = 0, Visible = false}, empty)
    window:_paint(bar, {BackgroundColor3 = "AccentDark"})
    round(bar, 4)
    local fill = new("Frame", {Size = UDim2.new(0.2, 0, 1, 0), BorderSizePixel = 0}, bar)
    window:_paint(fill, {BackgroundColor3 = "Accent"})
    round(fill, 4)
    local controls = new("Frame", {Position = UDim2.new(0, 12, 1, -49), Size = UDim2.new(1, -24, 0, 38), BackgroundTransparency = 1}, card)
    local object = element(card, {Viewport = viewport, World = world, Camera = camera, Rotation = 0, Pitch = 0.05, Zoom = 1})
    local function aim(immediate)
        if not object.Bounds then return end
        local bounds, size = object.Bounds, viewport.AbsoluteSize
        local aspect = math.max(0.3, size.X / math.max(1, size.Y))
        local distance = (math.max(bounds.Y, bounds.X / aspect) * 0.5 / math.tan(math.rad(camera.FieldOfView / 2)) + bounds.Z * 0.5) * 1.18 * object.Zoom
        local offset = Vector3.new(math.sin(object.Rotation) * math.cos(object.Pitch), math.sin(object.Pitch), -math.cos(object.Rotation) * math.cos(object.Pitch)) * distance
        window:_tween(camera, {CFrame = CFrame.lookAt(object.Center + offset, object.Center)}, immediate and 0 or 0.16)
    end
    local zoomOut = window:_button(controls, "", false, function() object.Zoom = math.clamp(object.Zoom * 1.14, 0.55, 1.8); aim() end, "minus")
    zoomOut.Root.Size = UDim2.fromOffset(38, 38)
    local zoomIn = window:_button(controls, "", false, function() object.Zoom = math.clamp(object.Zoom / 1.14, 0.55, 1.8); aim() end, "plus")
    zoomIn.Root.Size = UDim2.fromOffset(38, 38); zoomIn.Root.Position = UDim2.fromOffset(44, 0)
    local reset = window:_button(controls, "", false, function() object.Rotation, object.Pitch, object.Zoom = 0, 0.05, 1; aim() end, "reset")
    reset.Root.Size = UDim2.fromOffset(38, 38); reset.Root.Position = UDim2.fromOffset(88, 0)
    local dragHint = window:_text(controls, spec.ControlsHint or "Drag to rotate", 10, "Muted")
    dragHint.Position = UDim2.fromOffset(134, 0); dragHint.Size = UDim2.new(1, -138, 1, 0); dragHint.TextWrapped = true
    local generation = 0
    function object:Loading(on, message)
        on = on == true
        bar.Visible = on
        if message then hint.Text = tostring(message) end
        if on then empty.Visible = true; motif.Visible = true; viewport.Visible = false; fallback.Visible = false end
        generation = generation + 1
        local mine = generation
        if on and not window.Settings.ReducedMotion and not window.Settings.LowEffects then
            task.spawn(function()
                while window.Alive and mine == generation and bar.Visible and bar.Parent do
                    fill.Position = UDim2.new()
                    window:_tween(fill, {Position = UDim2.new(0.8, 0, 0, 0)}, 0.65)
                    task.wait(0.7)
                end
            end)
        end
    end
    function object:SetModel(model, keepView)
        assert(typeof(model) == "Instance" and model:IsA("Model"), "SetModel needs a Model")
        if object.Model and object.Model ~= model then object.Model:Destroy() end
        object.Model = model
        if spec.Anchor ~= false then
            for _, part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then part.Anchored = true end end
        end
        model.Parent = world
        local center, size = model:GetBoundingBox()
        object.Center, object.Bounds = center.Position, size
        if not keepView then object.Rotation, object.Pitch, object.Zoom = 0, 0.05, 1 end
        object:Loading(false)
        empty.Visible, fallback.Visible, viewport.Visible = false, false, true
        aim(true)
    end
    function object:SetImage(image, message)
        object:Loading(false, message or "")
        fallback.Image = tostring(image or "")
        fallback.Visible, viewport.Visible = true, false
        empty.Visible, motif.Visible = message ~= nil, false
    end
    function object:Clear(message)
        if object.Model then object.Model:Destroy(); object.Model = nil end
        object.Bounds = nil
        object:Loading(false, message or defaultHint)
        empty.Visible, motif.Visible, viewport.Visible, fallback.Visible = true, true, false, false
    end
    function object:SetTitle(text) tag.Text = tostring(text or "") end
    local dragging, last, touch
    window:_on(viewport.InputBegan, function(input)
        if not isPointer(input) then return end
        dragging = true
        last = Vector2.new(input.Position.X, input.Position.Y)
        touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        if container.Page then container.Page.ScrollingEnabled = false end
    end)
    window:_connect(UserInputService.InputChanged, function(input)
        if not dragging or (touch and input ~= touch) or (not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement) then return end
        local position = Vector2.new(input.Position.X, input.Position.Y)
        local delta = position - last
        last = position
        object.Rotation = object.Rotation - delta.X * 0.012
        object.Pitch = math.clamp(object.Pitch + delta.Y * 0.006, -0.35, 0.6)
        aim(true)
    end)
    window:_connect(UserInputService.InputEnded, function(input)
        if dragging and ((touch and input == touch) or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            dragging = false
            touch = nil
            if container.Page then container.Page.ScrollingEnabled = true end
        end
    end)
    window:_on(viewport.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            object.Zoom = math.clamp(object.Zoom * (input.Position.Z > 0 and 0.9 or 1.1), 0.55, 1.8)
            aim()
        end
    end)
    window:_on(viewport:GetPropertyChangedSignal("AbsoluteSize"), function() aim(true) end)
    return object
end

-- A strip of thumbnails that scrolls sideways (history, recent items…), with optional buttons underneath.
function Container:Strip(spec)
    spec = spec or {}
    local window = self.Window
    local buttons = spec.Buttons or {}
    local card = self:_add(window:_card(self.Frame, #buttons > 0 and 156 or 112))
    window:_icon(card, spec.Icon or "history", UDim2.fromOffset(12, 9), "Accent")
    local title = window:_text(card, spec.Title or "Timeline", 13, "Text", true)
    title.Position = UDim2.fromOffset(42, 9); title.Size = UDim2.new(0.5, -42, 0, 24)
    local hint = window:_text(card, spec.Hint or "", 11, "Muted")
    hint.Position = UDim2.new(0.5, 0, 0, 9); hint.Size = UDim2.new(0.5, -14, 0, 24); hint.TextXAlignment = Enum.TextXAlignment.Right
    local strip = new("ScrollingFrame", {Position = UDim2.fromOffset(8, 40), Size = UDim2.new(1, -16, 0, 66), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, ElasticBehavior = Enum.ElasticBehavior.Never}, card)
    window:_paint(strip, {ScrollBarImageColor3 = "AccentDark"})
    list(strip, 4, Enum.FillDirection.Horizontal)
    local object = element(card, {Strip = strip, Buttons = {}})
    if #buttons > 0 then
        local row = new("Frame", {Position = UDim2.new(0, 10, 1, -46), Size = UDim2.new(1, -20, 0, 36), BackgroundTransparency = 1}, card)
        local roots = {}
        for _, buttonSpec in ipairs(buttons) do
            local button = window:_button(row, buttonSpec.Title or "", buttonSpec.Primary, buttonSpec.Callback, buttonSpec.Icon)
            table.insert(object.Buttons, button)
            table.insert(roots, button.Root)
        end
        spread(roots, 8)
        window:_onLayout(card, function(state)
            for _, button in ipairs(object.Buttons) do if button.Label.Text ~= "" then button:SetIconVisible(not state.Compact) end end
        end)
    end
    function object:Set(items)
        for _, child in ipairs(strip:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
        items = items or {}
        if #items == 0 then
            local emptyText = window:_text(strip, spec.Empty or "Nothing here yet.", 11, "Muted")
            emptyText.Size = UDim2.fromScale(1, 1)
            return
        end
        for index, item in ipairs(items) do
            local tile = new("TextButton", {LayoutOrder = index, Size = UDim2.fromOffset(58, 64), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, BorderSizePixel = 0}, strip)
            local frame = new("Frame", {Position = UDim2.fromOffset(7, 0), Size = UDim2.fromOffset(44, 44), BorderSizePixel = 0, ClipsDescendants = true}, tile)
            window:_paint(frame, {BackgroundColor3 = "Raised"})
            round(frame, 12)
            window:_stroke(frame, item.Current and 0 or 0.6, item.Current and "Accent" or "Line").Thickness = item.Current and 2 or 1
            if item.Image then
                new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = tostring(item.Image), ScaleType = Enum.ScaleType.Crop}, frame)
            else
                window:_icon(frame, item.Icon or "user", UDim2.new(0.5, -12, 0.5, -12), "AccentDark")
            end
            local label = window:_text(tile, item.Label or "", 10, item.Current and "Accent" or "Muted", item.Current)
            label.Position = UDim2.fromOffset(0, 46); label.Size = UDim2.new(1, 0, 0, 18); label.TextXAlignment = Enum.TextXAlignment.Center
            if not item.Current and item.Callback then
                window:_on(tile.Activated, function() window:_fire(item.Callback, item) end)
                window:_on(tile.MouseEnter, function() window:_tint(frame, {BackgroundColor3 = "AccentDark"}) end)
                window:_on(tile.MouseLeave, function() window:_tint(frame, {BackgroundColor3 = "Raised"}) end)
            end
        end
        -- Keep the newest item in view.
        if spec.ScrollToEnd ~= false then
            task.defer(function()
                if strip.Parent then strip.CanvasPosition = Vector2.new(math.max(0, strip.AbsoluteCanvasSize.X - strip.AbsoluteWindowSize.X), 0) end
            end)
        end
    end
    function object:SetHint(text) hint.Text = tostring(text or "") end
    object:Set(spec.Items)
    return object
end

-- Blue, underlined link (tap to copy) followed by a Copy link button. Without clipboard access the link
-- turns into a selectable text box.
function Window:_linkBlock(card, order, label, url)
    local holder = new("Frame", {LayoutOrder = order, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, card)
    local link = new("TextButton", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, AutoButtonColor = false, RichText = true,
        Text = "", TextSize = textSize(13), Font = Lyra.Font.Regular, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, holder)
    self:_onTheme(link, function()
        link.Text = '<u><font color="' .. hex(self.Theme.Link) .. '">' .. escape(url) .. "</font></u>"
        link.TextColor3 = self.Theme.Link
    end)
    local fallback = new("TextBox", {Visible = false, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = url, TextEditable = false,
        ClearTextOnFocus = false, TextSize = textSize(13), Font = Lyra.Font.Regular, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, holder)
    self:_paint(fallback, {TextColor3 = "Link"})
    local button
    local function copy()
        if copyText(url) then
            button:SetText("Copied!")
            self:Status(label .. " link copied.", "success")
            task.delay(1.5, function() if self.Alive and button.Root.Parent then button:SetText("Copy link") end end)
            return
        end
        link.Visible, fallback.Visible = false, true
        fallback:CaptureFocus()
        fallback.SelectionStart = 1
        fallback.CursorPosition = #url + 1
        self:Status("Automatic clipboard access is unavailable. Select the link and copy it manually.", "warning")
    end
    button = self:_button(card, "Copy link", false, copy, "copy")
    button.Root.LayoutOrder = order + 1
    self:_on(link.Activated, copy)
    self:_on(fallback.FocusLost, function() fallback.Visible, link.Visible = false, true end)
    return button
end
function Container:Link(spec)
    spec = spec or {}
    local window = self.Window
    local card = self:_add(window:_autoCard(self.Frame, 12, 16))
    local header = new("Frame", {LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1}, card)
    local badge = new("Frame", {Size = UDim2.fromOffset(44, 44), BorderSizePixel = 0}, header)
    window:_paint(badge, {BackgroundColor3 = "Raised"})
    round(badge, 13)
    window:_icon(badge, spec.Icon or "link", UDim2.fromOffset(10, 10), "Accent")
    local heading = window:_text(header, spec.Title or "Link", 17, "Text", true)
    heading.Position = UDim2.fromOffset(58, 0); heading.Size = UDim2.new(1, -58, 0, 24)
    local caption = window:_text(header, spec.Subtitle or spec.Description or "", 12, "Muted")
    caption.Position = UDim2.fromOffset(58, 25); caption.Size = UDim2.new(1, -58, 0, 20)
    local copy = window:_linkBlock(card, 2, spec.Label or spec.Title or "Link", tostring(spec.Url or ""))
    return element(card, {Button = copy})
end
-- A profile card: portrait (image, web image or initial), caption, name, handle, bio and an optional link.
function Container:Profile(spec)
    spec = spec or {}
    local window = self.Window
    local card = self:_add(window:_autoCard(self.Frame, 8, 12))
    window:_gradient(card, "AccentDark", "Card", 28)
    local header = new("Frame", {LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1}, card)
    local portrait = new("Frame", {Size = UDim2.fromOffset(52, 52), BorderSizePixel = 0}, header)
    window:_paint(portrait, {BackgroundColor3 = "Accent"})
    round(portrait, 16)
    window:_stroke(portrait, 0.32, "Accent")
    local letter = window:_text(portrait, spec.Initial or initials(spec.Title or "?"):sub(1, 1), 28, "Base", true)
    letter.Size = UDim2.fromScale(1, 1); letter.TextXAlignment = Enum.TextXAlignment.Center
    local photo = new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = tostring(spec.Image or ""), BorderSizePixel = 0, ZIndex = 2, ScaleType = Enum.ScaleType.Crop}, portrait)
    round(photo, 16)
    local caption = window:_text(header, spec.Caption or "PROFILE", 10, "Accent", true)
    caption.Position = UDim2.fromOffset(64, 0); caption.Size = UDim2.new(1, -64, 0, 16)
    local name = window:_text(header, spec.Title or "", 19, "Text", true)
    name.Position = UDim2.fromOffset(64, 15); name.Size = UDim2.new(1, -64, 0, 24)
    local handle = window:_text(header, spec.Handle or "", 11, "Muted")
    handle.Position = UDim2.fromOffset(64, 37); handle.Size = UDim2.new(1, -64, 0, 16)
    if spec.Bio then
        local bio = window:_paragraph(card, spec.Bio, 12, "Text")
        bio.RichText = true
        bio.LayoutOrder = 2
    end
    if spec.Url then window:_linkBlock(card, 3, spec.Label or spec.Title or "Profile", tostring(spec.Url)) end
    if spec.ImageUrl then
        task.spawn(function()
            local id = Lyra.WebImage(spec.ImageUrl)
            if id and photo.Parent then photo.Image = id end
        end)
    end
    return element(card, {Photo = photo})
end
-- A rounded picture (banner, preview, logo).
function Container:Image(spec)
    if type(spec) ~= "table" then spec = {Image = spec} end
    local window = self.Window
    local card = self:_add(window:_card(self.Frame, spec.Height or 140))
    card.ClipsDescendants = true
    local image = new("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Image = tostring(spec.Image or ""),
        ScaleType = spec.ScaleType or Enum.ScaleType.Crop}, card)
    round(image, 16)
    if spec.Caption then
        local shade = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0}, card)
        round(shade, 16)
        new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.35)})}, shade)
        local caption = window:_text(card, spec.Caption, 13, "Text", true)
        caption.Position = UDim2.new(0, 14, 1, -32); caption.Size = UDim2.new(1, -28, 0, 22)
    end
    local object = element(card, {Image = image})
    function object:SetImage(value) image.Image = tostring(value or "") end
    return object
end

-- =============================================================================
-- BUILT-IN SETTINGS TAB
-- =============================================================================
-- Interface size, window size, theme, notifications, start hidden, the ways to reopen the window and
-- the effects. Returns the tab, so a script can add its own options under them.
function Window:_reopenCard(container)
    local card = container:_add(self:_autoCard(container.Frame, 6, 14))
    self.ReopenRows = {}
    for index = 1, 4 do
        local row = new("Frame", {LayoutOrder = index, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1}, card)
        local name = self:_text(row, "", 12, "Text", true)
        name.Size = UDim2.new(0.58, 0, 1, 0)
        local state = self:_text(row, "", 12, "Muted", true)
        state.Position = UDim2.new(0.58, 0, 0, 0); state.Size = UDim2.new(0.42, 0, 1, 0); state.TextXAlignment = Enum.TextXAlignment.Right
        self.ReopenRows[index] = {Root = row, Name = name, State = state}
    end
    self.ReopenWarning = self:_paragraph(card, "", 11, "Gold", true)
    self.ReopenWarning.LayoutOrder = 10
    return card
end
-- Live status of every way to bring the hidden window back, so a player can see what works on this device.
function Window:_refreshReopen()
    local rows = self.ReopenRows
    if not rows then return end
    local s = self.Settings
    local keyboard = UserInputService.KeyboardEnabled
    local data = {
        {"Floating button", s.FloatingButton and "On" or "Off", s.FloatingButton and "Green" or "Muted"},
        {"Roblox menu shortcut", s.MenuReopen and "On" or "Off", s.MenuReopen and "Green" or "Muted"},
        {"Shortcut key (" .. s.Keybind .. ")", keyboard and "Ready" or "No keyboard", keyboard and "Green" or "Gold"},
    }
    if self.ChatAlias then
        local chat = (self.ChatOK == false and {"Blocked on this account", "Gold"}) or (self.ChatOK == true and {"Ready", "Green"})
            or (self.ChatChecked and {"Not detected", "Muted"}) or {"Checking…", "Muted"}
        table.insert(data, {"Chat  " .. self.ChatAlias, chat[1], chat[2]})
    end
    for index, row in ipairs(rows) do
        local entry = data[index]
        row.Root.Visible = entry ~= nil
        if entry then
            row.Name.Text, row.State.Text = entry[1], entry[2]
            self:_paint(row.State, {TextColor3 = entry[3]})
        end
    end
    local can = self:_canReopen()
    self.ReopenWarning.Text = can and "" or "Nothing can reopen the window right now. Turn on the floating button or the Roblox menu shortcut."
    self.ReopenWarning.Visible = not can
end
function Window:SettingsTab(spec)
    spec = spec or {}
    local s, controls = self.Settings, self.SettingControls
    local tab = self:Tab({Title = spec.Title or "Settings", Icon = spec.Icon or "sliders-horizontal"})
    tab:Section(spec.Title or "Settings", spec.Description or "The defaults work for most people. Change only what you need.")
    local function setting(key, after)
        return function(value)
            s[key] = value
            self:_queueSave()
            if after then after(value) end
        end
    end
    controls.Scale = tab:Stepper({Title = "Interface size", Description = "Makes the window and its text smaller or larger. Auto fits your screen.",
        Values = {0, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 130}, Default = s.Scale,
        Format = function(value) return value == 0 and "Auto" or (tostring(value) .. "%") end, Callback = setting("Scale", function() self:_layout(false) end)})
    tab:Action({Title = "Window size", Description = "Drag the corner at the bottom right of the window to resize it. Reset restores the default size.",
        Button = "Reset", Icon = "reset", Callback = function() self:ResetSize(); self:Status("Window size and interface size reset.", "info") end})
    if spec.Themes ~= false then
        controls.Theme = tab:Dropdown({Title = "Theme", Description = "The colours of the whole window.", Options = Lyra.ThemeNames, Default = self.ThemeName,
            Placeholder = "Custom", Callback = function(name) self:SetTheme(name) end})
    end
    tab:Section("Notifications")
    controls.Notifications = tab:Toggle({Title = "Show notifications", Description = "Small pop-ups in the bottom-right corner. Turn off to hide them all.",
        Default = s.Notifications, Callback = setting("Notifications", function(on) if not on then self.Toasts:Clear() end end)})
    tab:Section("Open & close")
    controls.StartHidden = tab:Toggle({Title = "Start hidden", Description = "The window stays closed when the script runs. It is skipped if nothing could reopen the window.",
        Default = s.StartHidden, Callback = setting("StartHidden")})
    tab:Section("How to reopen the window", "Keep at least one on, so the window can always come back.")
    self:_reopenCard(tab)
    controls.FloatingButton = tab:Toggle({Title = "Floating button", Description = "Shows a draggable button while the window is closed.",
        Default = s.FloatingButton, Callback = setting("FloatingButton", function() self:_effects(); self:_refreshReopen() end)})
    controls.MenuReopen = tab:Toggle({Title = "Reopen with the Roblox menu",
        Description = "While the window is hidden, open and close the Roblox menu 3 times in a row (Esc on PC, the Roblox logo on phones). Works without chat.",
        Default = s.MenuReopen, Callback = setting("MenuReopen", function() self:_refreshReopen() end)})
    controls.Keybind = tab:Keybind({Title = "Window shortcut", Description = "Tap, then press a key to change it. Esc cancels.", Default = s.Keybind,
        Blocked = {"W", "A", "S", "D", "Space", "Return", "Tab", "Backspace", "Slash"}, Changed = setting("Keybind", function() self:_refreshReopen() end)})
    local advanced = tab:Collapsible({Title = "Show advanced options", OpenTitle = "Hide advanced options"})
    advanced:Section("Effects")
    controls.Blur = advanced:Toggle({Title = "Background blur", Description = "Blurs the game behind the window.", Default = s.Blur,
        Callback = setting("Blur", function() self:_effects() end)})
    controls.ReducedMotion = advanced:Toggle({Title = "Reduced motion", Description = "Turns off window animations.", Default = s.ReducedMotion,
        Callback = setting("ReducedMotion", function() self:_effects() end)})
    controls.LowEffects = advanced:Toggle({Title = "Performance mode", Description = "Turns off extra visual effects. Helps on slower devices.", Default = s.LowEffects,
        Callback = setting("LowEffects", function() self:_effects() end)})
    tab.Advanced = advanced
    self:_refreshReopen()
    return tab
end

-- Familiar names for people coming from other libraries: Tab:AddToggle, Window:AddTab…
for _, name in ipairs({"Section", "Paragraph", "Label", "Divider", "Button", "ButtonRow", "Action", "Toggle", "Stepper", "Slider", "Dropdown", "Input",
    "TextArea", "Keybind", "Chips", "Segmented", "Group", "Columns", "Collapsible", "Guide", "Row", "Empty", "List", "Grid", "Preview", "Strip",
    "Link", "Profile", "Image"}) do
    Container["Add" .. name] = Container[name]
end
Window.AddTab = Window.Tab
Window.Dialog = Window.Confirm
-- Window:Connect(signal, fn): a connection that is disconnected when the window is destroyed.
Window.Connect = Window._connect

function Lyra.GetWindow(...)
    local name = args(...)
    return Registry.Windows[tostring(name)]
end
function Lyra.DestroyAll()
    for _, window in pairs(Registry.Windows) do
        if type(window) == "table" and type(window.Destroy) == "function" then pcall(window.Destroy, window) end
    end
end

return Lyra
