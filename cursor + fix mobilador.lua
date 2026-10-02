--// MOBHUB - CURSOR + FIX MOBILADOR
--// Dark Lavender Liquid Glass configuration hub

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local GUI_NAME = "MOBHUB_CursorFixMobilador"
local CURSOR_IMAGE = "rbxassetid://2128690040"
local DEFAULT_SIZE, MIN_SIZE, MAX_SIZE = 32, 12, 100

local cursorSize = DEFAULT_SIZE
local offsetX, offsetY = 0, 0
local cursorEnabled = true
local lockEnabled = false

local function destroyOld(parent)
    if not parent then return end
    local oldGui = parent:FindFirstChild(GUI_NAME)
    if oldGui then oldGui:Destroy() end
end

pcall(function() destroyOld(PlayerGui) end)
pcall(function() destroyOld(CoreGui) end)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 2147483647
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local parented = false
if type(gethui) == "function" then
    local ok, hiddenUi = pcall(gethui)
    if ok and hiddenUi then
        pcall(function()
            destroyOld(hiddenUi)
            gui.Parent = hiddenUi
            parented = true
        end)
    end
end
if not parented then
    pcall(function()
        gui.Parent = CoreGui
        parented = gui.Parent == CoreGui
    end)
end
if not parented then gui.Parent = PlayerGui end

--// CURSOR: separate high-Z layer
local cursor = Instance.new("ImageLabel")
cursor.Name = "Cursor"
cursor.BackgroundTransparency = 1
cursor.BorderSizePixel = 0
cursor.AnchorPoint = Vector2.new(0, 0)
cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
cursor.Image = CURSOR_IMAGE
cursor.ZIndex = 2147483647
cursor.Active = false
cursor.Selectable = false
cursor.Parent = gui

--// HUB
local panel = Instance.new("Frame")
panel.Name = "ConfigHub"
panel.Size = UDim2.fromOffset(350, 345)
panel.Position = UDim2.new(0.5, -175, 0.5, -172)
panel.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
panel.BackgroundTransparency = 0.13
panel.BorderSizePixel = 0
panel.ZIndex = 1000
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(183, 143, 255)
stroke.Transparency = 0.55
stroke.Thickness = 1
stroke.Parent = panel

local gradient = Instance.new("UIGradient")
gradient.Rotation = 135
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(68, 42, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(31, 22, 47)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(17, 13, 27))
})
gradient.Parent = panel

local function label(text, y, size, bold)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(20, y)
    l.Size = UDim2.new(1, -40, 0, 28)
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.Text = text
    l.TextColor3 = Color3.fromRGB(238, 228, 255)
    l.TextSize = size or 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 1002
    l.Parent = panel
    return l
end

local function button(text, x, y, w, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(w, 34)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = Color3.fromRGB(87, 57, 126)
    b.BackgroundTransparency = 0.18
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamMedium
    b.Text = text
    b.TextColor3 = Color3.fromRGB(246, 240, 255)
    b.TextSize = 13
    b.ZIndex = 1003
    b.AutoButtonColor = true
    b.Parent = panel
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 9)
    bc.Parent = b
    b.MouseButton1Click:Connect(callback)
    return b
end

label("MOBHUB", 16, 20, true)
local subtitle = label("Cursor + Fix Mobilador", 43, 12, false)
subtitle.TextColor3 = Color3.fromRGB(177, 151, 211)

local sizeText = label("", 82, 13, true)
local lockText = label("", 136, 13, true)
local offsetText = label("", 190, 13, true)

local function refresh()
    sizeText.Text = "Cursor size: " .. cursorSize
    lockText.Text = "Fix Mobilador: " .. (lockEnabled and "TRAVADO" or "LIVRE")
    offsetText.Text = string.format("Hotspot offset: X %d  |  Y %d", offsetX, offsetY)
    cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
end

button("−", 20, 110, 46, function()
    cursorSize = math.clamp(cursorSize - 4, MIN_SIZE, MAX_SIZE)
    refresh()
end)
button("+", 74, 110, 46, function()
    cursorSize = math.clamp(cursorSize + 4, MIN_SIZE, MAX_SIZE)
    refresh()
end)
local cursorToggle = button("Cursor ON/OFF", 130, 110, 198, function()
    cursorEnabled = not cursorEnabled
end)

button("X−", 20, 218, 62, function() offsetX -= 1 refresh() end)
button("X+", 88, 218, 62, function() offsetX += 1 refresh() end)
button("Y−", 158, 218, 62, function() offsetY -= 1 refresh() end)
button("Y+", 226, 218, 62, function() offsetY += 1 refresh() end)

button("RESETAR CONFIGURAÇÕES", 20, 272, 308, function()
    cursorSize = DEFAULT_SIZE
    offsetX, offsetY = 0, 0
    cursorEnabled = true
    lockEnabled = false
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    refresh()
end)

local hint = label("Alt: GUI  •  LeftCtrl: trava-mouse", 316, 11, false)
hint.TextColor3 = Color3.fromRGB(155, 131, 186)
hint.TextXAlignment = Enum.TextXAlignment.Center

refresh()

--// Drag
local dragging, dragStart, startPos = false, nil, nil
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--// Keybinds
--// Alt (esquerdo ou direito) alterna a GUI. LeftControl alterna o trava-mouse.
local keyDebounce = {}

UIS.InputBegan:Connect(function(input, processed)
    local key = input.KeyCode

    if (key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt) and not keyDebounce[key] then
        keyDebounce[key] = true
        panel.Visible = not panel.Visible
        return
    end

    if key == Enum.KeyCode.LeftControl and not keyDebounce[key] then
        keyDebounce[key] = true
        lockEnabled = not lockEnabled
        refresh()
        return
    end
end)

UIS.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt or key == Enum.KeyCode.LeftControl then
        keyDebounce[key] = nil
    end
end)

pcall(function() UIS.MouseIconEnabled = false end)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not gui.Parent or not cursor.Parent then
        if connection then connection:Disconnect() end
        return
    end

    -- FIX MOBILADOR: reaplica o estado a cada frame para impedir
    -- que o jogo reverta MouseBehavior logo depois do toggle.
    if UIS.MouseEnabled then
        pcall(function()
            UIS.MouseBehavior = lockEnabled and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
        end)
    end

    if cursorEnabled and UIS.MouseEnabled then
        pcall(function() UIS.MouseIconEnabled = false end)
        local pos = UIS:GetMouseLocation()
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
        if not cursorEnabled then
            pcall(function() UIS.MouseIconEnabled = true end)
        end
    end
end)

print("[MOBHUB] Dark Lavender Cursor Hub carregado.")
print("[MOBHUB] Alt = GUI | LeftControl = trava-mouse.")
