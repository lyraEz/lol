
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "mobhub_cursor_config.json"
local ENV_KEY = "MOBHUB_CURSOR_CONFIG"

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "MOBHUB_CursorFixMobilador"
local CURSOR_IMAGE = "rbxassetid://2128690040"
local DEFAULT_SIZE, MIN_SIZE, MAX_SIZE = 32, 12, 100

local cursorSize = DEFAULT_SIZE
local offsetX, offsetY = 0, 0
local cursorEnabled = true
 -- O modo PC prende o mouse onde ele está. CENTRO fica como alternativa.
local lockMode = "PC"

local function configSnapshot()
    return {
        cursorSize = cursorSize,
        offsetX = offsetX,
        offsetY = offsetY,
        cursorEnabled = cursorEnabled,
        lockMode = lockMode
    }
end

local function saveConfig()
    local data = configSnapshot()
    pcall(function() getgenv()[ENV_KEY] = data end)
    if type(writefile) == "function" then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function loadConfig()
    local data
    if type(readfile) == "function" and type(isfile) == "function" then
        pcall(function()
            if isfile(CONFIG_FILE) then
                data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            end
        end)
    end
    if type(data) ~= "table" then
        pcall(function() data = getgenv()[ENV_KEY] end)
    end
    if type(data) == "table" then
        cursorSize = math.clamp(tonumber(data.cursorSize) or DEFAULT_SIZE, MIN_SIZE, MAX_SIZE)
        offsetX = math.floor(tonumber(data.offsetX) or 0)
        offsetY = math.floor(tonumber(data.offsetY) or 0)
        if type(data.cursorEnabled) == "boolean" then cursorEnabled = data.cursorEnabled end
        if data.lockMode == "PC" or data.lockMode == "CENTRO" then lockMode = data.lockMode end
    end
end

loadConfig()

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

local panel = Instance.new("Frame")
panel.Name = "ConfigHub"
panel.Size = UDim2.fromOffset(350, 385)
panel.Position = UDim2.new(0.5, -175, 0.5, -192)
panel.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
panel.BackgroundTransparency = 0.13
panel.BorderSizePixel = 0
panel.ZIndex = 1000
panel.Visible = false
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
local offsetText = label("", 210, 13, true)
local modeButton

local function refresh()
    sizeText.Text = "Cursor size: " .. cursorSize
    lockText.Text = "Fix Mobilador (botão direito): " .. (lockMode == "PC" and "igual PC" or "centro")
    offsetText.Text = string.format("Hotspot offset: X %d  |  Y %d", offsetX, offsetY)
    cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
    if modeButton then
        modeButton.Text = lockMode == "PC" and "Modo: PC (prende onde está)" or "Modo: CENTRO (antigo)"
    end
end

button("−", 20, 110, 46, function()
    cursorSize = math.clamp(cursorSize - 4, MIN_SIZE, MAX_SIZE)
    refresh()
    saveConfig()
end)
button("+", 74, 110, 46, function()
    cursorSize = math.clamp(cursorSize + 4, MIN_SIZE, MAX_SIZE)
    refresh()
    saveConfig()
end)
local cursorToggle = button("Cursor ON/OFF", 130, 110, 198, function()
    cursorEnabled = not cursorEnabled
    saveConfig()
end)

modeButton = button("", 20, 164, 308, function()
    lockMode = lockMode == "PC" and "CENTRO" or "PC"
    refresh()
    saveConfig()
end)

button("X−", 20, 238, 62, function() offsetX -= 1 refresh() saveConfig() end)
button("X+", 88, 238, 62, function() offsetX += 1 refresh() saveConfig() end)
button("Y−", 158, 238, 62, function() offsetY -= 1 refresh() saveConfig() end)
button("Y+", 226, 238, 62, function() offsetY += 1 refresh() saveConfig() end)

button("RESETAR CONFIGURAÇÕES", 20, 292, 308, function()
    cursorSize = DEFAULT_SIZE
    offsetX, offsetY = 0, 0
    cursorEnabled = true
    lockMode = "PC"
    -- Resetar preferências não deve interferir no controle de câmera.
    refresh()
    saveConfig()
end)

local hint = label("Alt: GUI  •  Segure botão direito: câmera", 340, 11, false)
hint.TextColor3 = Color3.fromRGB(155, 131, 186)
hint.TextXAlignment = Enum.TextXAlignment.Center

refresh()

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

local keyDebounce = {}

local rmbActive = false
local rmbBlocked = false
local rmbOverride = false
local savedMousePos = nil
local originalMouseBehavior = nil
local appliedMouseBehavior = nil
local relockAttempts = 0
local MAX_RELOCK_ATTEMPTS = 2

local function startRotate()
    if rmbActive then return end

    rmbActive = true
    savedMousePos = UIS:GetMouseLocation()
    originalMouseBehavior = UIS.MouseBehavior
    appliedMouseBehavior = nil
    relockAttempts = 0

    -- Não disputar o controle de câmera com shift lock, primeira pessoa
    -- ou outros scripts que já estejam gerenciando o mouse.
    rmbOverride = originalMouseBehavior == Enum.MouseBehavior.Default
    if rmbOverride then
        local wanted = lockMode == "PC"
            and Enum.MouseBehavior.LockCurrentPosition
            or Enum.MouseBehavior.LockCenter

        local ok = pcall(function()
            UIS.MouseBehavior = wanted
        end)

        if ok then
            appliedMouseBehavior = wanted
        else
            rmbOverride = false
        end
    end
end

local function stopRotate()
    if not rmbActive then return end

    -- Só liberar um bloqueio que este script aplicou e que ainda está ativo.
    -- Nunca mover o mouse por mousemoveabs: alguns executores travam em código nativo.
    if rmbOverride and appliedMouseBehavior and UIS.MouseBehavior == appliedMouseBehavior then
        pcall(function()
            UIS.MouseBehavior = originalMouseBehavior or Enum.MouseBehavior.Default
        end)
    end

    rmbActive = false
    rmbOverride = false
    savedMousePos = nil
    originalMouseBehavior = nil
    appliedMouseBehavior = nil
    relockAttempts = 0
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gui.Parent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if gameProcessed then
            rmbBlocked = true
        elseif not rmbActive and UIS.MouseEnabled then
            startRotate()
        end
        return
    end

    local key = input.KeyCode
    if (key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt) and not keyDebounce[key] then
        keyDebounce[key] = true
        panel.Visible = not panel.Visible
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        stopRotate()
        rmbBlocked = false
        return
    end

    local key = input.KeyCode
    if key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt then
        keyDebounce[key] = nil
    end
end)

pcall(function() UIS.MouseIconEnabled = false end)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not gui.Parent or not cursor.Parent then
        stopRotate()
        connection:Disconnect()
        return
    end

    if UIS.MouseEnabled then
        -- Fallback caso o executor não dispare InputEnded ao soltar RMB.
        local pressed = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if pressed then
            if not rmbActive and not rmbBlocked then
                startRotate()
            end
            if rmbActive and rmbOverride and appliedMouseBehavior then
                local current = UIS.MouseBehavior
                if current ~= appliedMouseBehavior then
                    -- Tenta recuperar o bloqueio no máximo duas vezes.
                    -- Se outro sistema controlar a câmera, deixa de disputar por frame.
                    if current == Enum.MouseBehavior.Default and relockAttempts < MAX_RELOCK_ATTEMPTS then
                        relockAttempts += 1
                        local ok = pcall(function()
                            UIS.MouseBehavior = appliedMouseBehavior
                        end)
                        if not ok then rmbOverride = false end
                    else
                        rmbOverride = false
                    end
                end
            end
        else
            stopRotate()
            rmbBlocked = false
        end
    else
        stopRotate()
    end

    if cursorEnabled and UIS.MouseEnabled then
        if UIS.MouseIconEnabled then UIS.MouseIconEnabled = false end
        -- Evita o cursor visual saltar enquanto a câmera gira.
        local pos = (rmbActive and rmbOverride and savedMousePos) or UIS:GetMouseLocation()
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
        if not cursorEnabled and not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
    end
end)

print("[MOBHUB] Dark Lavender Cursor Hub carregado.")
print("[MOBHUB] Alt = GUI | Segure RMB = câmera (modo " .. lockMode .. ").")
