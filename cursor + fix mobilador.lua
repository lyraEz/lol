
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "mobhub_cursor_config.json"
local ENV_KEY = "MOBHUB_CURSOR_CONFIG"

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Uma execução nova encerra os eventos da execução anterior.
local env = (type(getgenv) == "function" and getgenv()) or _G
local SESSION_KEY = "MOBHUB_CURSOR_FIX_SESSION"
local previousSession = env[SESSION_KEY]
if type(previousSession) == "table" and type(previousSession.stop) == "function" then
    pcall(previousSession.stop)
end
local session = { alive = true, connections = {} }
env[SESSION_KEY] = session

local function connect(signal, handler)
    local connection = signal:Connect(handler)
    table.insert(session.connections, connection)
    return connection
end

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
    connect(b.MouseButton1Click, callback)
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
    -- A liberação do RMB cuida do unlock; nunca força aqui.
    refresh()
    saveConfig()
end)

local hint = label("Alt: GUI  •  Segure botão direito: câmera", 340, 11, false)
hint.TextColor3 = Color3.fromRGB(155, 131, 186)
hint.TextXAlignment = Enum.TextXAlignment.Center

refresh()

local dragging, dragStart, startPos = false, nil, nil
connect(panel.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
connect(UIS.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
connect(UIS.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local keyDebounce = {}
local rmbActive, rmbBlocked, rmbOverride = false, false, false
local savedMousePos = nil
local lockedByScript, lockedMode = false, nil
local rotationToken, pollElapsed = 0, 0
local POLL_INTERVAL, UNLOCK_DELAY = 0.15, 0.12

local function rightMouseDown()
    local ok, pressed = pcall(function()
        return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end)
    return ok and pressed
end

local function applyLock()
    if not session.alive or not rmbActive or not rmbOverride or not rightMouseDown() then return end
    local wanted = lockMode == "PC"
        and Enum.MouseBehavior.LockCurrentPosition or Enum.MouseBehavior.LockCenter

    -- Apenas muda o lock em caso de transição ou correção, nunca a cada frame.
    if UIS.MouseBehavior ~= wanted then
        local ok = pcall(function() UIS.MouseBehavior = wanted end)
        if not ok then return end
    end
    lockedByScript = true
    lockedMode = wanted
end

local function startRotate()
    if rmbActive or not UIS.MouseEnabled then return end
    rmbActive = true
    rotationToken += 1
    savedMousePos = UIS:GetMouseLocation()
    -- Shift Lock / primeira pessoa continuam sob controle do próprio jogo.
    rmbOverride = UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter
    if rmbOverride then
        local token = rotationToken
        task.defer(function()
            if session.alive and rmbActive and token == rotationToken then applyLock() end
        end)
    end
end

local function stopRotate()
    if not rmbActive then return end
    rmbActive = false
    rmbOverride = false
    savedMousePos = nil
    rotationToken += 1
    local token, previousMode = rotationToken, lockedMode
    local shouldUnlock = lockedByScript
    lockedByScript, lockedMode = false, nil

    -- Soltar e mudar MouseBehavior no mesmo callback do input pode colidir
    -- com o código nativo do Android/Roblox. Libera após o evento terminar.
    if shouldUnlock then
        task.delay(UNLOCK_DELAY, function()
            if token ~= rotationToken or rmbActive or rightMouseDown() then return end
            if UIS.MouseBehavior == previousMode then
                pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
            end
        end)
    end
end

session.stop = function()
    if not session.alive then return end
    stopRotate()
    session.alive = false
    for _, connection in ipairs(session.connections) do connection:Disconnect() end
    table.clear(session.connections)
    pcall(function() gui:Destroy() end)
    if env[SESSION_KEY] == session then env[SESSION_KEY] = nil end
end

connect(UIS.InputBegan, function(input, gameProcessed)
    if not session.alive or not gui.Parent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if gameProcessed then
            rmbBlocked = true
        elseif not rmbActive then
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

connect(UIS.InputEnded, function(input)
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

-- Fallback para mouse externo cuja soltura não gera InputEnded no Android.
connect(RunService.Heartbeat, function(dt)
    if not session.alive then return end
    pollElapsed += dt
    if pollElapsed < POLL_INTERVAL then return end
    pollElapsed = 0
    if not UIS.MouseEnabled then
        stopRotate()
        rmbBlocked = false
        return
    end
    local down = rightMouseDown()
    if not down then
        stopRotate()
        rmbBlocked = false
    elseif not rmbActive and not rmbBlocked then
        startRotate()
    elseif rmbActive and rmbOverride then
        applyLock()
    end
end)

pcall(function() UIS.MouseIconEnabled = false end)

connect(RunService.RenderStepped, function()
    if not session.alive then return end
    if not gui.Parent or not cursor.Parent then
        session.stop()
        return
    end

    -- RenderStepped só atualiza o desenho. Nunca altera MouseBehavior.
    if cursorEnabled and UIS.MouseEnabled then
        if UIS.MouseIconEnabled then UIS.MouseIconEnabled = false end
        local pos = (rmbActive and rmbOverride and savedMousePos) or UIS:GetMouseLocation()
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
        if not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
    end
end)

print("[MOBHUB] Dark Lavender Cursor Hub carregado.")
print("[MOBHUB] Alt = GUI | Segure RMB = câmera (modo " .. lockMode .. ").")
