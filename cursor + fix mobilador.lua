
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
local deltaBind = "B"

local function configSnapshot()
    return {
        cursorSize = cursorSize,
        offsetX = offsetX,
        offsetY = offsetY,
        cursorEnabled = cursorEnabled,
        lockMode = lockMode,
        deltaBind = deltaBind
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
        if type(data.deltaBind) == "string" and Enum.KeyCode[data.deltaBind] and #data.deltaBind <= 12 then deltaBind = data.deltaBind end
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
panel.Size = UDim2.fromOffset(350, 413)
panel.Position = UDim2.new(0.5, -175, 0.5, -206)
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
local deltaBindButton
local waitingForBind = false

local function refresh()
    sizeText.Text = "Cursor size: " .. cursorSize
    lockText.Text = "Fix Mobilador: " .. (lockMode == "PC" and "segurar RMB" or "RMB alterna o centro")
    offsetText.Text = string.format("Hotspot offset: X %d  |  Y %d", offsetX, offsetY)
    cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
    if modeButton then
        modeButton.Text = lockMode == "PC" and "Modo: PC (segurar)" or "Modo: CENTRO (clique ON/OFF)"
    end
    if deltaBindButton then deltaBindButton.Text = waitingForBind and "Pressione uma tecla..." or ("Delta: " .. deltaBind .. " (alterar)") end
    if hint then
        hint.Text = lockMode == "PC"
            and "Alt: GUI  •  Segure RMB: câmera"
            or "Alt: GUI  •  RMB: travar / liberar centro"
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

deltaBindButton = button("", 20, 200, 308, function()
    waitingForBind = true
    refresh()
end)

modeButton = button("", 20, 164, 308, function()
    if resetLockState then resetLockState() end
    lockMode = lockMode == "PC" and "CENTRO" or "PC"
    refresh()
    saveConfig()
end)

button("X−", 20, 262, 62, function() offsetX -= 1 refresh() saveConfig() end)
button("X+", 88, 262, 62, function() offsetX += 1 refresh() saveConfig() end)
button("Y−", 158, 262, 62, function() offsetY -= 1 refresh() saveConfig() end)
button("Y+", 226, 262, 62, function() offsetY += 1 refresh() saveConfig() end)

button("RESETAR CONFIGURAÇÕES", 20, 315, 308, function()
    if resetLockState then resetLockState() end
    cursorSize = DEFAULT_SIZE
    offsetX, offsetY = 0, 0
    cursorEnabled = true
    lockMode = "PC"
    deltaBind = "B"
    -- A liberação do RMB cuida do unlock; nunca força aqui.
    refresh()
    saveConfig()
end)

hint = label("Alt: GUI  •  RMB: câmera  •  /e mob: Delta", 364, 11, false)
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

-- Máquina de estados: PC = botão pressionado; CENTRO = clique alterna.
local keyDebounce = {}
local pcHeld, centerEnabled = false, false
local rmbDown, rmbBlocked = false, false
local savedMousePos = nil
local ownedMode = nil
local generation = 0
local centerSyncElapsed = 0
local CENTER_SYNC_INTERVAL = 0.1
local POST_INPUT_DELAY = 0.12

local function ownMouseLock(mode)
    if not session.alive or not UIS.MouseEnabled then return false end
    if UIS.MouseBehavior == mode then return true end
    local ok = pcall(function()
        UIS.MouseBehavior = mode
    end)
    if ok then ownedMode = mode end
    return ok
end

local function releaseOwnedLock()
    local previouslyOwned = ownedMode
    ownedMode = nil
    if not previouslyOwned then return end
    local current = UIS.MouseBehavior
    if current == previouslyOwned then
        pcall(function()
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end)
    end
end

local function requestRelease()
    generation += 1
    local token = generation
    task.delay(POST_INPUT_DELAY, function()
        if not session.alive or generation ~= token or rmbDown then return end
        if centerEnabled or pcHeld then return end
        releaseOwnedLock()
    end)
end

local function finishPC()
    if not pcHeld then return end
    pcHeld = false
    savedMousePos = nil
    requestRelease()
end

local function onMouseDown(gameProcessed)
    if rmbDown then return end -- debouncing de InputBegan duplicado
    rmbDown = true
    rmbBlocked = gameProcessed == true
    if rmbBlocked or not UIS.MouseEnabled then return end

    generation += 1
    local token = generation
    if lockMode == "CENTRO" then
        centerEnabled = not centerEnabled
        centerSyncElapsed = 0
        -- Lock e unlock ocorrem somente depois de InputEnded.
        -- Evita competir com a captura de RMB feita pelo cliente Android.
        return
    end

    if pcHeld then return end
    pcHeld = true
    savedMousePos = UIS:GetMouseLocation()
    local wasLockedCenter = UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
    if not wasLockedCenter then
        task.defer(function()
            if session.alive and generation == token and pcHeld and rmbDown then
                -- LockCenter fornece deltas relativos sem bater na borda, se o Android suportar.
                ownMouseLock(Enum.MouseBehavior.LockCenter)
            end
        end)
    end
end

local function onMouseUp()
    if not rmbDown then return end
    rmbDown = false
    if rmbBlocked then
        rmbBlocked = false
        return
    end

    if lockMode == "PC" then
        finishPC()
        return
    end

    generation += 1
    local token = generation
    if centerEnabled then
        -- Clique 1: prende no centro APÓS a liberação física do RMB.
        task.delay(POST_INPUT_DELAY, function()
            if not session.alive or generation ~= token or not centerEnabled or rmbDown then return end
            ownMouseLock(Enum.MouseBehavior.LockCenter)
        end)
    else
        -- Clique 2: devolve o cursor ao modo livre.
        task.delay(POST_INPUT_DELAY, function()
            if not session.alive or generation ~= token or centerEnabled or rmbDown then return end
            releaseOwnedLock()
        end)
    end
end

resetLockState = function()
    pcHeld = false
    centerEnabled = false
    savedMousePos = nil
    generation += 1
    centerSyncElapsed = 0
    local token = generation
    task.delay(POST_INPUT_DELAY, function()
        if not session.alive or generation ~= token or rmbDown then return end
        releaseOwnedLock()
    end)
end

session.stop = function()
    if not session.alive then return end
    session.alive = false
    pcHeld, centerEnabled = false, false
    generation += 1
    for _, connection in ipairs(session.connections) do
        connection:Disconnect()
    end
    table.clear(session.connections)
    -- Executar novamente deve liberar o lock antigo e não criar handlers duplicados.
    releaseOwnedLock()
    pcall(function() gui:Destroy() end)
    if env[SESSION_KEY] == session then env[SESSION_KEY] = nil end
end

connect(UIS.InputBegan, function(input, gameProcessed)
    if not session.alive or not gui.Parent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        onMouseDown(gameProcessed)
        return
    end
    local key = input.KeyCode
    if waitingForBind and key ~= Enum.KeyCode.Unknown then
        deltaBind = key.Name
        waitingForBind = false
        refresh()
        saveConfig()
        return
    end
    if key.Name == deltaBind and not gameProcessed then
        if session.toggleDelta then session.toggleDelta() end
        return
    end
    if (key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt) and not keyDebounce[key] then
        keyDebounce[key] = true
        panel.Visible = not panel.Visible
    end
end)

connect(UIS.InputEnded, function(input)
    if not session.alive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        onMouseUp()
        return
    end
    local key = input.KeyCode
    if key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt then
        keyDebounce[key] = nil
    end
end)

-- Se o Roblox sobrescrever LockCenter, recupera apenas quando o RMB está
-- solto e num intervalo limitado. Nunca disputa o mouse dentro do clique.
connect(RunService.Heartbeat, function(dt)
    if not session.alive then return end
    if not ((lockMode == "CENTRO" and centerEnabled and not rmbDown) or (lockMode == "PC" and pcHeld and rmbDown)) or not UIS.MouseEnabled then
        centerSyncElapsed = 0
        return
    end
    centerSyncElapsed += dt
    if centerSyncElapsed < CENTER_SYNC_INTERVAL then return end
    centerSyncElapsed = 0
    if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        ownMouseLock(Enum.MouseBehavior.LockCenter)
    end
end)

pcall(function() UIS.MouseIconEnabled = false end)

connect(RunService.RenderStepped, function()
    if not session.alive then return end
    if not gui.Parent or not cursor.Parent then
        session.stop()
        return
    end

    if cursorEnabled and UIS.MouseEnabled then
        if UIS.MouseIconEnabled then UIS.MouseIconEnabled = false end
        local pos
        if (lockMode == "CENTRO" and centerEnabled) or (lockMode == "PC" and pcHeld) then
            local camera = workspace.CurrentCamera
            if camera then
                local view = camera.ViewportSize
                pos = Vector2.new(view.X * 0.5 - cursorSize * 0.5, view.Y * 0.5 - cursorSize * 0.5)
            end
        elseif pcHeld and savedMousePos then
            pos = savedMousePos
        end
        pos = pos or UIS:GetMouseLocation()
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
        if not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
    end
end)

-- Delta: sem botão flutuante; alterna com bind ou /e mob.
local deltaRoot = (type(gethui) == "function" and gethui()) or CoreGui
local deltaHidden = false
local deltaState = {}
local deltaScanElapsed = 0
local function deltaAsset(path)
    path = tostring(path):lower()
    if path:find("internals", 1, true) or path:find("assets/i", 1, true)
        or path:find("delta", 1, true) then return true end
    for i = 1, 18 do
        if path:find("i" .. i .. "%.") or path:match("i" .. i .. "$") then return true end
    end
    return false
end
local function deltaCandidates()
    local found = {}
    for _, root in ipairs({deltaRoot, CoreGui}) do
        for _, top in ipairs(root:GetChildren()) do
            if top ~= gui and top.Name ~= "RobloxGui" and not found[top] then
                local isDelta = false
                for _, desc in ipairs(top:GetDescendants()) do
                    if (desc:IsA("ImageButton") or desc:IsA("ImageLabel")) and deltaAsset(desc.Image) then
                        isDelta = true
                        break
                    end
                end
                if isDelta then found[top] = true end
            end
        end
    end
    return found
end
local function setDeltaHidden(hidden)
    deltaHidden = hidden
    if not hidden then
        for obj, original in pairs(deltaState) do
            if obj and obj.Parent then
                pcall(function()
                    if original.property == "Enabled" then obj.Enabled = original.value
                    else obj.Visible = original.value end
                end)
            end
        end
        table.clear(deltaState)
        return
    end
end
local function toggleDelta()
    setDeltaHidden(not deltaHidden)
    print("[MOBHUB] Delta " .. (deltaHidden and "oculto" or "visível"))
end
local function suppressDelta()
    for top in pairs(deltaCandidates()) do
        if top:IsA("ScreenGui") then
            if not deltaState[top] then deltaState[top] = {property = "Enabled", value = top.Enabled} end
            if top.Enabled then top.Enabled = false end
        elseif top:IsA("GuiObject") then
            if not deltaState[top] then deltaState[top] = {property = "Visible", value = top.Visible} end
            if top.Visible then top.Visible = false end
        end
    end
    local dc = CoreGui:FindFirstChild("DrawingContainer")
    if dc and dc:IsA("GuiObject") then
        if not deltaState[dc] then deltaState[dc] = {property = "Visible", value = dc.Visible} end
        if dc.Visible then dc.Visible = false end
    end
end
session.toggleDelta = toggleDelta
connect(RunService.Heartbeat, function(dt)
    if not session.alive or not deltaHidden then return end
    deltaScanElapsed += dt
    if deltaScanElapsed >= 0.1 then
        deltaScanElapsed = 0
        pcall(suppressDelta)
    end
end)
connect(LocalPlayer.Chatted, function(message)
    if message:lower():match("^%s*/e%s+mob%s*$") then toggleDelta() end
end)
local oldStop = session.stop
session.stop = function()
    if not session.alive then return end
    setDeltaHidden(false)
    oldStop()
end

print("[MOBHUB] Cursor + Fix Mobilador carregado (modo " .. lockMode .. ").")
print("[MOBHUB] PC = segurar RMB; CENTRO = clicar uma vez para travar, outra para liberar.")
