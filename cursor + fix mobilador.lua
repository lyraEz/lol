
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

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
-- PC: LockCenter enquanto segura RMB. CENTRO: LockCenter permanente (1ª pessoa).
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
local hint
local resetLockState

local function refresh()
    sizeText.Text = "Cursor size: " .. cursorSize
    lockText.Text = "Fix Mobilador: " .. (lockMode == "PC" and "RMB segurado" or "sempre centro")
    offsetText.Text = string.format("Hotspot offset: X %d  |  Y %d", offsetX, offsetY)
    cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
    if modeButton then
        modeButton.Text = lockMode == "PC" and "Modo: PC (segurar RMB)" or "Modo: CENTRO (1ª pessoa)"
    end
    if hint then
        hint.Text = "/e mob: hub  •  /e delta: ocultar Delta"
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
    if resetLockState then resetLockState() end
    lockMode = lockMode == "PC" and "CENTRO" or "PC"
    refresh()
    saveConfig()
end)

button("X−", 20, 238, 62, function() offsetX -= 1 refresh() saveConfig() end)
button("X+", 88, 238, 62, function() offsetX += 1 refresh() saveConfig() end)
button("Y−", 158, 238, 62, function() offsetY -= 1 refresh() saveConfig() end)
button("Y+", 226, 238, 62, function() offsetY += 1 refresh() saveConfig() end)

button("RESETAR CONFIGURAÇÕES", 20, 292, 308, function()
    if resetLockState then resetLockState() end
    cursorSize = DEFAULT_SIZE
    offsetX, offsetY = 0, 0
    cursorEnabled = true
    lockMode = "PC"
    -- A liberação do RMB cuida do unlock; nunca força aqui.
    refresh()
    saveConfig()
end)

hint = label("/e mob: hub  •  /e delta: Delta", 340, 11, false)
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

-- Controle de mouse: usa o fluxo nativo confirmado pelo usuário.
-- RenderStepped reimpõe LockCenter durante RMB. O modo CENTRO
-- representa APENAS_PRIMEIRA_PESSOA = true do script de referência.
local lastMouseBehavior = nil
local function unlockMouse()
    if lastMouseBehavior == Enum.MouseBehavior.LockCenter
        and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
        pcall(function()
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end)
    end
    lastMouseBehavior = nil
end

session.stop = function()
    if not session.alive then return end
    session.alive = false
    for _, connection in ipairs(session.connections) do
        connection:Disconnect()
    end
    table.clear(session.connections)
    unlockMouse()
    pcall(function() gui:Destroy() end)
    if env[SESSION_KEY] == session then env[SESSION_KEY] = nil end
end

resetLockState = function()
    unlockMouse()
end

pcall(function() UIS.MouseIconEnabled = false end)

connect(RunService.RenderStepped, function()
    if not session.alive then return end
    if not gui.Parent or not cursor.Parent then
        session.stop()
        return
    end

    if not UIS.MouseEnabled then
        cursor.Visible = false
        return
    end

    local rightHeld = false
    pcall(function()
        rightHeld = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end)

    -- O método funcional: alterna o MouseBehavior dentro de RenderStepped.
    -- O painel aberto libera o mouse para interagir com os controles.
    local lockRequested = not panel.Visible and (lockMode == "CENTRO" or rightHeld)
    local desired = lockRequested
        and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
    if UIS.MouseBehavior ~= desired then
        pcall(function() UIS.MouseBehavior = desired end)
    end
    lastMouseBehavior = desired

    if cursorEnabled then
        if UIS.MouseIconEnabled then
            pcall(function() UIS.MouseIconEnabled = false end)
        end
        local pos = UIS:GetMouseLocation()
        if lockRequested then
            local camera = workspace.CurrentCamera
            if camera then
                local view = camera.ViewportSize
                pos = Vector2.new(view.X * 0.5 - cursorSize * 0.5, view.Y * 0.5 - cursorSize * 0.5)
            end
        end
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
        if not UIS.MouseIconEnabled then
            pcall(function() UIS.MouseIconEnabled = true end)
        end
    end
end)

-- Delta: visível por padrão. Oculte somente com /e delta.
-- Sem botão na tela, bind B ou controle na hub.
local deltaRoot = CoreGui
if type(gethui) == "function" then
    local ok, root = pcall(gethui)
    if ok and root then deltaRoot = root end
end
local deltaHidden = false
local deltaState = {}
local deltaScanElapsed = 0

local function deltaAsset(path)
    path = tostring(path):lower()
    if path:find("internals", 1, true)
        or path:find("assets/i", 1, true)
        or path:find("delta", 1, true) then return true end
    for i = 1, 18 do
        if path:find("i" .. i .. "%.") or path:match("i" .. i .. "$") then
            return true
        end
    end
    return false
end

local function rememberAndHide(obj, property)
    if not obj or not obj.Parent then return end
    if not deltaState[obj] then
        local ok, oldValue = pcall(function() return obj[property] end)
        if not ok then return end
        deltaState[obj] = {property = property, value = oldValue}
    end
    pcall(function() obj[property] = false end)
end

local function scanAndSuppressDelta()
    local roots = {CoreGui}
    if deltaRoot ~= CoreGui then table.insert(roots, deltaRoot) end
    local seen = {}

    for _, root in ipairs(roots) do
        for _, top in ipairs(root:GetChildren()) do
            if not seen[top] and top ~= gui and top.Name ~= "RobloxGui"
                and top.Name ~= GUI_NAME then
                seen[top] = true
                local hasIY = top:FindFirstChild("I") and top:FindFirstChild("Y")
                if not hasIY then
                    local foundDelta = false
                    for _, desc in ipairs(top:GetDescendants()) do
                        if (desc:IsA("ImageButton") or desc:IsA("ImageLabel"))
                            and deltaAsset(desc.Image) then
                            foundDelta = true
                            if not top:IsA("ScreenGui") then
                                rememberAndHide(desc, "Visible")
                                if desc:IsA("GuiButton") then
                                    pcall(function() desc.Active = false end)
                                end
                            end
                        end
                    end
                    if foundDelta and top:IsA("ScreenGui") then
                        rememberAndHide(top, "Enabled")
                    end
                end
            end
        end
    end

    local dc = CoreGui:FindFirstChild("DrawingContainer")
    if dc and dc:IsA("GuiObject") then
        rememberAndHide(dc, "Visible")
    end
end

local function setDeltaHidden(hidden)
    deltaHidden = hidden
    if not hidden then
        for obj, old in pairs(deltaState) do
            if obj and obj.Parent then
                pcall(function()
                    obj[old.property] = old.value
                end)
                if obj:IsA("GuiButton") then
                    pcall(function() obj.Active = true end)
                end
            end
        end
        table.clear(deltaState)
    else
        pcall(scanAndSuppressDelta)
    end
    print("[MOBHUB] Delta " .. (hidden and "escondido" or "visível"))
end

connect(RunService.Heartbeat, function(dt)
    if not session.alive or not deltaHidden then return end
    deltaScanElapsed += dt
    if deltaScanElapsed >= 0.15 then
        deltaScanElapsed = 0
        pcall(scanAndSuppressDelta)
    end
end)

local lastCommand, lastCommandAt = nil, 0
local function handleChatCommand(text)
    if not session.alive or type(text) ~= "string" then return end
    local command = text:lower():match("^%s*/e%s+(%a+)%s*$")
    if command ~= "mob" and command ~= "delta" then return end

    -- SendingMessage e Chatted podem disparar para a mesma mensagem.
    local now = os.clock()
    if lastCommand == command and now - lastCommandAt < 0.75 then return end
    lastCommand, lastCommandAt = command, now

    if command == "mob" then
        panel.Visible = not panel.Visible
        print("[MOBHUB] Hub " .. (panel.Visible and "aberta" or "escondida"))
    else
        setDeltaHidden(not deltaHidden)
    end
end

connect(LocalPlayer.Chatted, handleChatCommand)
pcall(function()
    connect(TextChatService.SendingMessage, function(message)
        handleChatCommand(message.Text)
    end)
end)

local oldStop = session.stop
session.stop = function()
    if not session.alive then return end
    setDeltaHidden(false)
    oldStop()
end

print("[MOBHUB] Fix Mobilador carregado. /e mob = hub | /e delta = Delta")
print("[MOBHUB] Modo PC: segurar RMB. Modo CENTRO: primeira pessoa permanente.")
