
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
local DEFAULT_CURSOR_ID = "11716559277"
local CURSOR_IMAGE_PREFIX = "rbxassetid://"
local DEFAULT_SIZE, MIN_SIZE, MAX_SIZE = 32, 12, 100

local cursorSize = DEFAULT_SIZE
local cursorAssetId = DEFAULT_CURSOR_ID
local offsetX, offsetY = 0, 0
local cursorEnabled = true
-- PC: segurar RMB para girar. CENTRO: clique RMB alterna trava/destrava.
-- Migração: versões antigas salvavam CENTRO como trava permanente.
local MOUSE_MODE_CONFIG_VERSION = 2
local lockMode = "PC"

local function configSnapshot()
    return {
        cursorSize = cursorSize,
        cursorAssetId = cursorAssetId,
        offsetX = offsetX,
        offsetY = offsetY,
        cursorEnabled = cursorEnabled,
        lockMode = lockMode,
        mouseModeConfigVersion = MOUSE_MODE_CONFIG_VERSION
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
        if type(data.cursorAssetId) == "string"
            and data.cursorAssetId:match("^%d+$")
            and #data.cursorAssetId <= 18 then
            cursorAssetId = data.cursorAssetId
        end
        offsetX = math.floor(tonumber(data.offsetX) or 0)
        offsetY = math.floor(tonumber(data.offsetY) or 0)
        if type(data.cursorEnabled) == "boolean" then cursorEnabled = data.cursorEnabled end
        if data.mouseModeConfigVersion == MOUSE_MODE_CONFIG_VERSION
            and (data.lockMode == "PC" or data.lockMode == "CENTRO") then
            lockMode = data.lockMode
        else
            -- Nunca reaplicar automaticamente a trava permanente das builds antigas.
            lockMode = "PC"
        end
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
cursor.Image = CURSOR_IMAGE_PREFIX .. cursorAssetId
cursor.ZIndex = 2147483647
cursor.Active = false
cursor.Selectable = false
cursor.Parent = gui

local panel = Instance.new("Frame")
panel.Name = "ConfigHub"
panel.Size = UDim2.fromOffset(350, 498)
panel.Position = UDim2.new(0.5, -175, 0.5, -249)
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
local offsetText = label("", 312, 13, true)
local modeButton
local hint
local resetLockState
local cursorIdInput
-- Estado declarado antes dos botões; a integração Delta é inicializada depois.
local deltaHidden = false
local setDeltaHidden
local deltaButton

local function refresh()
    sizeText.Text = "Cursor size: " .. cursorSize
    lockText.Text = "Fix Mobilador: " .. (lockMode == "PC" and "segurar RMB" or "clique RMB ON/OFF")
    offsetText.Text = string.format("Hotspot offset: X %d  |  Y %d", offsetX, offsetY)
    cursor.Size = UDim2.fromOffset(cursorSize, cursorSize)
    cursor.Image = CURSOR_IMAGE_PREFIX .. cursorAssetId
    if cursorIdInput and not cursorIdInput:IsFocused() then
        cursorIdInput.Text = cursorAssetId
    end
    if modeButton then
        modeButton.Text = lockMode == "PC" and "Modo: PC (segurar RMB)" or "Modo: CENTRO (RMB alterna)"
    end
    if deltaButton then
        deltaButton.Text = deltaHidden and "Delta: OCULTO  (mostrar)" or "Delta: VISÍVEL  (esconder)"
        deltaButton.BackgroundColor3 = deltaHidden
            and Color3.fromRGB(113, 55, 78) or Color3.fromRGB(77, 65, 123)
    end
    if hint then
        hint.Text = "Alt esquerdo / /e mob: hub  •  /e delta: Delta"
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

deltaButton = button("", 20, 202, 308, function()
    if setDeltaHidden then setDeltaHidden(not deltaHidden) end
end)

local cursorIdLabel = label("Cursor personalizado • Image Asset ID", 244, 12, true)
cursorIdInput = Instance.new("TextBox")
cursorIdInput.Name = "CursorAssetIdInput"
cursorIdInput.Position = UDim2.fromOffset(20, 272)
cursorIdInput.Size = UDim2.fromOffset(211, 34)
cursorIdInput.BackgroundColor3 = Color3.fromRGB(42, 30, 61)
cursorIdInput.BorderSizePixel = 0
cursorIdInput.ClearTextOnFocus = false
cursorIdInput.Font = Enum.Font.Gotham
cursorIdInput.Text = cursorAssetId
cursorIdInput.PlaceholderText = "ID da imagem"
cursorIdInput.TextColor3 = Color3.fromRGB(246, 240, 255)
cursorIdInput.PlaceholderColor3 = Color3.fromRGB(155, 131, 186)
cursorIdInput.TextSize = 13
cursorIdInput.TextXAlignment = Enum.TextXAlignment.Center
cursorIdInput.ZIndex = 1003
cursorIdInput.Parent = panel
local cursorIdCorner = Instance.new("UICorner")
cursorIdCorner.CornerRadius = UDim.new(0, 9)
cursorIdCorner.Parent = cursorIdInput

local function applyCursorId()
    local raw = cursorIdInput.Text:match("^%s*(.-)%s*$")
    local id = raw:match("^%d+$") and raw or raw:match("^rbxassetid://(%d+)$")
    if not id or #id > 18 then
        cursorIdInput.Text = cursorAssetId
        warn("[MOBHUB] Cursor ID inválido. Use apenas os dígitos do Asset ID.")
        return
    end
    cursorAssetId = id
    cursor.Image = CURSOR_IMAGE_PREFIX .. cursorAssetId
    cursorIdInput.Text = cursorAssetId
    saveConfig()
end

button("APLICAR", 239, 272, 89, function()
    applyCursorId()
    cursorIdInput:ReleaseFocus()
end)
connect(cursorIdInput.FocusLost, function()
    if session.alive then applyCursorId() end
end)

button("X−", 20, 342, 62, function() offsetX -= 1 refresh() saveConfig() end)
button("X+", 88, 342, 62, function() offsetX += 1 refresh() saveConfig() end)
button("Y−", 158, 342, 62, function() offsetY -= 1 refresh() saveConfig() end)
button("Y+", 226, 342, 62, function() offsetY += 1 refresh() saveConfig() end)

button("RESETAR CONFIGURAÇÕES", 20, 396, 308, function()
    if resetLockState then resetLockState() end
    cursorSize = DEFAULT_SIZE
    cursorAssetId = DEFAULT_CURSOR_ID
    offsetX, offsetY = 0, 0
    cursorEnabled = true
    lockMode = "PC"
    -- A liberação do RMB cuida do unlock; nunca força aqui.
    refresh()
    saveConfig()
end)

hint = label("Alt esquerdo / /e mob: hub  •  /e delta: Delta", 451, 10, false)
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

-- O fix da câmera usa LockCenter enquanto o RMB está pressionado
-- (ou no modo CENTRO ativado por clique). Jogos em primeira pessoa
-- controlam o próprio mouse, e não devemos forçar Default neles.
local rmbHeld = false
local rmbReleased = false
local rmbEndedSinceLastFrame = false
local physicalRmbWasDown = false
local centerLatched = false
local leftAltHeld = false
local currentLockRequested = false
local ownedMouseLock = false
local nativeFirstPersonLockAssisted = false

-- Ao sair de LockCenter, alguns clientes Android ainda reportam a
-- coordenada antiga (centro). Seguimos MouseMovement.Delta nesse intervalo
-- apenas para o desenho do cursor, sem teletransportar o mouse nativo.
local freeCursorBeforeLock = nil
local releaseCursorOverride = nil
local releaseRawMousePosition = nil
local mouseMoveDelta = Vector2.zero
local previousCustomLock = false
local nativeIconBeforeCustom = UIS.MouseIconEnabled
local customIconHidden = false

local function restoreNativeCursor()
    if customIconHidden then
        customIconHidden = false
        -- Devolve ao jogo o controle do cursor nativo quando nosso cursor
        -- não deve aparecer (ex.: FPS com mira própria).
        pcall(function() UIS.MouseIconEnabled = nativeIconBeforeCustom end)
    end
end

local function setCustomCursorIcon(shouldShow)
    if shouldShow then
        if not customIconHidden then
            nativeIconBeforeCustom = UIS.MouseIconEnabled
            customIconHidden = true
        end
        if UIS.MouseIconEnabled then
            pcall(function() UIS.MouseIconEnabled = false end)
        end
    else
        restoreNativeCursor()
    end
end

local function unlockMouse()
    currentLockRequested = false
    if (ownedMouseLock or nativeFirstPersonLockAssisted)
        and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
        pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
    end
    ownedMouseLock = false
    nativeFirstPersonLockAssisted = false
    previousCustomLock = false
    releaseCursorOverride = nil
    restoreNativeCursor()
end

local function rightMouseDown()
    local ok, down = pcall(function()
        return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end)
    return ok and down or false
end

local function gameIsFirstPerson(camera)
    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return true
    end
    if not camera then return false end
    -- Distância câmera-foco distingue a primeira pessoa da câmera padrão
    -- em terceira pessoa. CameraType.Scriptable pode usar Focus arbitrário,
    -- então nesse caso usamos somente o LockCenter nativo como indício.
    if camera.CameraType ~= Enum.CameraType.Scriptable then
        local distance = (camera.CFrame.Position - camera.Focus.Position).Magnitude
        return distance <= 1.15
    end
    return false
end

local function beginRmb()
    if rmbHeld then return end
    rmbHeld = true
    rmbReleased = false
    if not currentLockRequested then
        freeCursorBeforeLock = UIS:GetMouseLocation()
    end
    if lockMode == "CENTRO" and not panel.Visible then
        centerLatched = not centerLatched
    end
end

local function endRmb()
    rmbHeld = false
    -- InputEnded prevalece sobre polling atrasado no Android.
    rmbReleased = true
    rmbEndedSinceLastFrame = true
end

local function setHubVisible(visible)
    if panel.Visible == visible then return end
    panel.Visible = visible
    if visible then
        centerLatched = false
        endRmb()
    end
end

resetLockState = function()
    centerLatched = false
    endRmb()
    physicalRmbWasDown = rightMouseDown()
    freeCursorBeforeLock = nil
    unlockMouse()
end

connect(UIS.InputBegan, function(input)
    if not session.alive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if not panel.Visible then beginRmb() end
        return
    end
    if input.KeyCode == Enum.KeyCode.LeftAlt and not leftAltHeld then
        leftAltHeld = true
        if not UIS:GetFocusedTextBox() then
            setHubVisible(not panel.Visible)
        end
    end
end)

connect(UIS.InputEnded, function(input)
    if not session.alive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        endRmb()
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        leftAltHeld = false
    end
end)

connect(UIS.InputChanged, function(input)
    if not session.alive then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        mouseMoveDelta += input.Delta
    end
end)

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

connect(RunService.RenderStepped, function()
    if not session.alive then return end
    if not gui.Parent or not cursor.Parent then
        session.stop()
        return
    end

    if not UIS.MouseEnabled then
        if currentLockRequested then unlockMouse() end
        setCustomCursorIcon(false)
        cursor.Visible = false
        mouseMoveDelta = Vector2.zero
        return
    end

    local physicalDown = rightMouseDown()
    if physicalDown and not physicalRmbWasDown then
        if not rmbHeld and not rmbEndedSinceLastFrame then beginRmb() end
    elseif not physicalDown and physicalRmbWasDown then
        endRmb()
    end
    physicalRmbWasDown = physicalDown
    rmbEndedSinceLastFrame = false

    local rightHeld = rmbHeld or (physicalDown and not rmbReleased)
    local camera = workspace.CurrentCamera
    local firstPerson = gameIsFirstPerson(camera)

    -- Uma câmera personalizada pode não usar CameraMode/Focus. Se ela
    -- já prendeu o mouse sozinha sem intervenção nossa, respeite isso.
    local gameOwnedCenter = not ownedMouseLock
        and not nativeFirstPersonLockAssisted
        and not previousCustomLock
        and not panel.Visible
        and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter

    local nativeAiming = not panel.Visible and (firstPerson or gameOwnedCenter)
    local customLockRequested = not nativeAiming and not panel.Visible
        and ((lockMode == "PC" and rightHeld)
            or (lockMode == "CENTRO" and centerLatched))

    local lockRequested = nativeAiming or customLockRequested
    currentLockRequested = lockRequested

    if nativeAiming then
        -- FPS nativo: nunca impor MouseBehavior.Default. Em experiências
        -- first-person em que o core não o faz, LockCenter ajuda a câmera.
        if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            local ok = pcall(function()
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            end)
            if ok then nativeFirstPersonLockAssisted = true end
        end
        ownedMouseLock = false
        previousCustomLock = false
        releaseCursorOverride = nil
    elseif customLockRequested then
        if not previousCustomLock then
            freeCursorBeforeLock = freeCursorBeforeLock or UIS:GetMouseLocation()
            releaseCursorOverride = nil
        end
        if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            local ok = pcall(function()
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            end)
            if ok then ownedMouseLock = true end
        else
            ownedMouseLock = true
        end
        previousCustomLock = true
    else
        if previousCustomLock then
            -- Primeiro desbloqueio já devolve o cursor visual para a posição
            -- anterior ao lock, sem precisar clicar outra vez.
            releaseCursorOverride = freeCursorBeforeLock or UIS:GetMouseLocation()
            releaseRawMousePosition = UIS:GetMouseLocation()
            freeCursorBeforeLock = nil
        end
        previousCustomLock = false

        -- Não reescrever Default a cada frame se o Roblox tiver decidido
        -- controlar o mouse. Soltar apenas o lock que foi imposto por nós.
        if ownedMouseLock or nativeFirstPersonLockAssisted or panel.Visible then
            if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
                pcall(function()
                    UIS.MouseBehavior = Enum.MouseBehavior.Default
                end)
            end
        end
        ownedMouseLock = false
        nativeFirstPersonLockAssisted = false
    end

    local shouldDrawCursor = cursorEnabled and not nativeAiming
    setCustomCursorIcon(shouldDrawCursor)

    if shouldDrawCursor then
        local pos
        if customLockRequested and camera then
            local view = camera.ViewportSize
            pos = Vector2.new(
                view.X * 0.5 - cursorSize * 0.5,
                view.Y * 0.5 - cursorSize * 0.5
            )
        else
            local rawPosition = UIS:GetMouseLocation()
            if releaseCursorOverride and releaseRawMousePosition then
                if (rawPosition - releaseRawMousePosition).Magnitude > 2 then
                    -- Mouse real voltou a atualizar; não usar posição virtual.
                    releaseCursorOverride = nil
                else
                    local view = camera and camera.ViewportSize or Vector2.new(1920, 1080)
                    releaseCursorOverride = Vector2.new(
                        math.clamp(releaseCursorOverride.X + mouseMoveDelta.X, 0, view.X),
                        math.clamp(releaseCursorOverride.Y + mouseMoveDelta.Y, 0, view.Y)
                    )
                end
            end
            pos = releaseCursorOverride or rawPosition
        end
        cursor.Position = UDim2.fromOffset(pos.X + offsetX, pos.Y + offsetY)
        cursor.Visible = true
    else
        cursor.Visible = false
    end
    mouseMoveDelta = Vector2.zero
end)

-- Ocultação do Delta: detecção inicial apenas ao esconder e resposta a
-- alterações do executor por eventos (sem varredura a cada 0,15 segundo).
-- Não há botão flutuante nem bind de teclado: hub ou /e delta.
local deltaRoot = CoreGui
if type(gethui) == "function" then
    local ok, root = pcall(gethui)
    if ok and root then deltaRoot = root end
end

local deltaState = {}
local deltaObservers = {}

local function deltaAsset(path)
    path = tostring(path):lower()
    if path:find("internals", 1, true)
        or path:find("assets/i", 1, true)
        or path:find("delta", 1, true) then
        return true
    end
    for i = 1, 18 do
        if path:find("i" .. i .. "%.") or path:match("i" .. i .. "$") then
            return true
        end
    end
    return false
end

local function rememberAndHide(obj, property)
    if not deltaHidden or not obj or not obj.Parent then return end

    local original = deltaState[obj]
    if not original then
        original = {}
        deltaState[obj] = original
    end
    if original[property] == nil then
        local ok, value = pcall(function() return obj[property] end)
        if not ok then return end
        original[property] = value

        local observers = deltaObservers[obj]
        if not observers then
            observers = {}
            deltaObservers[obj] = observers
        end
        -- Se o Delta tentar se mostrar outra vez, ocultar somente esse
        -- objeto alterado, sem buscar todos os GUIs em Heartbeat.
        observers[property] = obj:GetPropertyChangedSignal(property):Connect(function()
            if not session.alive or not deltaHidden or not obj.Parent then return end
            if obj[property] == true then
                pcall(function() obj[property] = false end)
            end
        end)
    end

    pcall(function()
        if obj[property] ~= false then obj[property] = false end
    end)
end

local function inspectDeltaImage(obj)
    if not deltaHidden or not session.alive then return end
    if not (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then return end
    if not obj.Parent or obj:IsDescendantOf(gui) then return end
    if not deltaAsset(obj.Image) then return end

    local current = obj
    local foundScreenGui, outerGui = nil, nil
    while current and current ~= CoreGui and current ~= deltaRoot do
        if current.Name == "RobloxGui" or current == gui then return end
        if current:IsA("ScreenGui") then foundScreenGui = current end
        if current:IsA("GuiObject") then outerGui = current end
        current = current.Parent
    end
    if not current then return end

    local target = foundScreenGui or outerGui or obj
    if foundScreenGui and foundScreenGui:FindFirstChild("I")
        and foundScreenGui:FindFirstChild("Y") then return end

    if target:IsA("ScreenGui") then
        rememberAndHide(target, "Enabled")
    elseif target:IsA("GuiObject") then
        rememberAndHide(target, "Visible")
        if target:IsA("GuiButton") then
            rememberAndHide(target, "Active")
        end
    end
end

local function inspectDrawingContainer()
    local drawing = CoreGui:FindFirstChild("DrawingContainer")
    if drawing and drawing:IsA("GuiObject") then
        rememberAndHide(drawing, "Visible")
    end
end

local function scanOnce(root)
    if not root then return end
    -- Executado só ao escolher ESCONDER, não em cada frame.
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("ImageButton") or obj:IsA("ImageLabel") then
            inspectDeltaImage(obj)
        end
    end
end

local function restoreDelta()
    -- Desconectar antes de restaurar, para evitar que a própria restauração
    -- dispare a rotina de ocultação.
    for _, observers in pairs(deltaObservers) do
        for _, connection in pairs(observers) do
            connection:Disconnect()
        end
    end
    table.clear(deltaObservers)
    for obj, old in pairs(deltaState) do
        if obj.Parent then
            for property, value in pairs(old) do
                pcall(function() obj[property] = value end)
            end
        end
    end
    table.clear(deltaState)
end

setDeltaHidden = function(hidden)
    if not session.alive or deltaHidden == hidden then return end
    deltaHidden = hidden
    if hidden then
        scanOnce(CoreGui)
        if deltaRoot ~= CoreGui and not deltaRoot:IsDescendantOf(CoreGui) then
            scanOnce(deltaRoot)
        end
        inspectDrawingContainer()
    else
        restoreDelta()
    end
    refresh()
    print("[MOBHUB] Delta " .. (hidden and "escondido" or "visível"))
end

-- Novas interfaces criadas pelo executor são detectadas sem varredura
-- contínua. Somente imagens adicionadas precisam ser inspecionadas.
local function onGuiAdded(obj)
    if not session.alive or not deltaHidden then return end
    if obj.Name == "DrawingContainer" then
        inspectDrawingContainer()
    elseif obj:IsA("ImageButton") or obj:IsA("ImageLabel") then
        -- Permite que o executor atribua Image logo após fazer Parent.
        task.defer(function()
            if session.alive and deltaHidden and obj.Parent then
                inspectDeltaImage(obj)
            end
        end)
    end
end

connect(CoreGui.DescendantAdded, onGuiAdded)
if deltaRoot ~= CoreGui and not deltaRoot:IsDescendantOf(CoreGui) then
    connect(deltaRoot.DescendantAdded, onGuiAdded)
end

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
        setHubVisible(not panel.Visible)
        print("[MOBHUB] Hub " .. (panel.Visible and "aberta" or "escondida"))
    else
        if setDeltaHidden then setDeltaHidden(not deltaHidden) end
    end
end

-- Chat legado e mensagens regulares do chat novo.
connect(LocalPlayer.Chatted, handleChatCommand)
pcall(function()
    connect(TextChatService.SendingMessage, function(message)
        handleChatCommand(message.Text)
    end)
end)

-- No TextChatService, /e é consumido pelo RBXEmoteCommand e NÃO aparece
-- em SendingMessage. Escutamos o Triggered existente, sem alterar os emotes.
local emoteHooks = {}
local function hookEmoteCommand(instance)
    if not session.alive or instance.Name ~= "RBXEmoteCommand"
        or not instance:IsA("TextChatCommand") or emoteHooks[instance] then return end
    emoteHooks[instance] = true
    connect(instance.Triggered, function(textSource, fullText)
        if not session.alive then return end
        if textSource and textSource.UserId ~= LocalPlayer.UserId then return end
        handleChatCommand(fullText)
    end)
end
pcall(function()
    for _, child in ipairs(TextChatService:GetDescendants()) do
        hookEmoteCommand(child)
    end
    connect(TextChatService.DescendantAdded, hookEmoteCommand)
end)

local oldStop = session.stop
session.stop = function()
    if not session.alive then return end
    if deltaHidden then setDeltaHidden(false) end
    oldStop()
end

print("[MOBHUB] Fix Mobilador carregado. /e mob = hub | /e delta = Delta")
print("[MOBHUB] Modo PC: segurar RMB. Modo CENTRO: clique RMB alterna lock.")
