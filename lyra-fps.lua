--// LYRA-FPS
--// Otimizacao de desempenho para Roblox que nao altera o visual do jogo.
--//
--// O que este script faz:
--//   1. Desbloqueia o limite de FPS (setfpscap, com fallback via FFlag).
--//   2. Reduz o custo do jogo quando a janela esta sem foco (alt-tab).
--//   3. Congela a simulacao de efeitos (ParticleEmitter, Fire, Smoke,
--//      Sparkles) que estao tao longe que ocupam menos de 1 pixel na tela.
--//      O efeito continua desenhado exatamente onde estava; ao chegar perto
--//      ele volta a simular do ponto em que parou, sem "pop" nem recarga.
--//   4. Todo o trabalho do script roda com orcamento de tempo por frame,
--//      sem alocacoes por frame, para nao custar o FPS que ele tenta ganhar.
--//   5. HUD opcional (F7) com FPS, frame time, memoria e ping.
--//
--// O que este script NAO faz (de proposito):
--//   - Nao muda qualidade grafica, sombras, texturas, iluminacao, terreno,
--//     materiais, pos-processamento, decals ou qualquer coisa visivel.
--//   - Nao apaga instancias do jogo nem mexe em colisao/CanTouch/CanQuery,
--//     porque isso quebra a logica de muitos jogos.
--//
--// Para parar e restaurar tudo:  getgenv().LyraFPS.Stop()

--// =====================================================================
--// CONFIGURACAO
--// =====================================================================

local CONFIG = {
    -- Limite de FPS aplicado ao iniciar. Use a taxa do seu monitor
    -- (60, 75, 120, 144, 165, 240...) ou 0 para "sem limite" quando o
    -- executor suportar. Sem limite gera mais calor sem ganho visivel
    -- acima da taxa do monitor.
    FPS_CAP = 240,

    -- Quando a janela do Roblox perde o foco (alt-tab), o FPS cai para
    -- este valor e volta ao normal ao focar de novo. 0 desativa.
    UNFOCUSED_FPS_CAP = 30,

    -- Desliga a renderizacao 3D enquanto a janela esta sem foco.
    -- Fica desligado por padrao porque, em segundo monitor, voce ainda
    -- veria a tela parada.
    PAUSE_3D_WHEN_UNFOCUSED = false,

    -- Se o executor nao tiver setfpscap, tenta via setfflag.
    USE_FFLAG_FALLBACK = true,

    -- Congelamento de efeitos sub-pixel.
    EFFECT_SLEEPER = true,

    -- Tamanho projetado (em pixels) abaixo do qual o efeito congela e
    -- acima do qual ele volta. A faixa entre os dois evita liga/desliga.
    SLEEP_BELOW_PX = 0.5,
    WAKE_ABOVE_PX = 0.75,

    -- Multiplicador de seguranca aplicado ao tamanho estimado (cobre a
    -- distorcao nas bordas da tela, squash, bloom etc.).
    SIZE_SAFETY = 2.0,

    -- Cada efeito e reavaliado no maximo a cada SCAN_INTERVAL segundos.
    SCAN_INTERVAL = 0.25,

    -- Tempo maximo (ms) que o script pode gastar por frame.
    FRAME_BUDGET_MS = 0.35,
    INTAKE_BUDGET_MS = 0.25,

    -- Tamanho de cada efeito e recalculado a cada N segundos.
    SIZE_REFRESH = 4,

    -- Se o zoom da camera aumentar mais que isso (ex.: mira de sniper),
    -- uma nova varredura comeca imediatamente.
    ZOOM_RESCAN_RATIO = 1.15,

    -- HUD de desempenho.
    HUD_KEY = Enum.KeyCode.F7,
    HUD_START_VISIBLE = false,
    HUD_REFRESH = 0.5,

    -- Mensagens no console (F9).
    VERBOSE = true,
}

--// =====================================================================
--// SERVICOS E AMBIENTE
--// =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local osClock = os.clock
local mathMax = math.max
local mathAbs = math.abs
local mathTan = math.tan
local mathRad = math.rad
local mathFloor = math.floor

local TAG = "LyraFPS_Sleeping"
local ATTR = "LyraFPS_TimeScale"
local GUI_NAME = "LyraFPS_HUD"

local genv = (type(getgenv) == "function" and getgenv()) or _G

-- Encerra uma execucao anterior antes de iniciar outra.
if type(genv.LyraFPS) == "table" and type(genv.LyraFPS.Stop) == "function" then
    pcall(genv.LyraFPS.Stop)
end

local function log(...)
    if CONFIG.VERBOSE then
        print("[lyra-fps]", ...)
    end
end

local function warnLog(...)
    warn("[lyra-fps]", ...)
end

--// =====================================================================
--// DETECCAO DE CAPACIDADES DO EXECUTOR
--// =====================================================================

local function fn(name)
    local value = genv[name]
    if type(value) ~= "function" then
        local ok, env = pcall(getfenv, 0)
        if ok and type(env) == "table" then
            value = rawget(env, name)
        end
    end
    if type(value) == "function" then
        return value
    end
    return nil
end

local Caps = {
    setfpscap = fn("setfpscap"),
    getfpscap = fn("getfpscap"),
    setfflag = fn("setfflag"),
    getfflag = fn("getfflag"),
    gethui = fn("gethui"),
    isrbxactive = fn("isrbxactive") or fn("iswindowactive"),
}

--// =====================================================================
--// MAID (controle de conexoes)
--// =====================================================================

local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ items = {} }, Maid)
end

function Maid:Give(item)
    local items = self.items
    items[#items + 1] = item
    return item
end

function Maid:Clean()
    local items = self.items
    for i = #items, 1, -1 do
        local item = items[i]
        items[i] = nil
        local kind = typeof(item)
        if kind == "RBXScriptConnection" then
            item:Disconnect()
        elseif kind == "Instance" then
            pcall(item.Destroy, item)
        elseif kind == "function" then
            pcall(item)
        end
    end
end

local maid = Maid.new()
local running = true

--// =====================================================================
--// MODULO: LIMITE DE FPS
--// =====================================================================

local FpsCap = {
    original = nil,
    current = nil,
    method = "nenhum",
}

local FFLAG_TARGET_FPS = "DFIntTaskSchedulerTargetFps"

local function capValue(n)
    -- Alguns executores tratam 0 como "sem limite", outros como 0 FPS.
    if n == nil or n <= 0 then
        return 1e4
    end
    return n
end

function FpsCap.Init()
    if Caps.getfpscap then
        local ok, value = pcall(Caps.getfpscap)
        if ok and type(value) == "number" then
            FpsCap.original = value
        end
    end
    if FpsCap.original == nil and Caps.getfflag then
        local ok, value = pcall(Caps.getfflag, FFLAG_TARGET_FPS)
        if ok and tonumber(value) then
            FpsCap.original = tonumber(value)
        end
    end
    FpsCap.original = FpsCap.original or 60
end

function FpsCap.Set(n)
    local value = capValue(n)
    if Caps.setfpscap then
        local ok = pcall(Caps.setfpscap, value)
        if ok then
            FpsCap.current = value
            FpsCap.method = "setfpscap"
            return true
        end
    end
    if CONFIG.USE_FFLAG_FALLBACK and Caps.setfflag then
        local ok = pcall(Caps.setfflag, FFLAG_TARGET_FPS, tostring(mathFloor(value)))
        if ok then
            FpsCap.current = value
            FpsCap.method = "setfflag"
            return true
        end
    end
    return false
end

function FpsCap.Restore()
    if FpsCap.original then
        FpsCap.Set(FpsCap.original)
    end
end

--// =====================================================================
--// MODULO: JANELA SEM FOCO
--// =====================================================================

local Focus = {
    focused = true,
    paused3d = false,
}

local function setRendering(enabled)
    pcall(RunService.Set3dRenderingEnabled, RunService, enabled)
end

function Focus.OnReleased()
    Focus.focused = false
    if CONFIG.UNFOCUSED_FPS_CAP > 0 and FpsCap.current then
        FpsCap.Set(CONFIG.UNFOCUSED_FPS_CAP)
    end
    if CONFIG.PAUSE_3D_WHEN_UNFOCUSED then
        setRendering(false)
        Focus.paused3d = true
    end
end

function Focus.OnFocused()
    Focus.focused = true
    if CONFIG.UNFOCUSED_FPS_CAP > 0 and FpsCap.current then
        FpsCap.Set(CONFIG.FPS_CAP)
    end
    if Focus.paused3d then
        setRendering(true)
        Focus.paused3d = false
    end
end

function Focus.Init()
    maid:Give(UserInputService.WindowFocusReleased:Connect(Focus.OnReleased))
    maid:Give(UserInputService.WindowFocused:Connect(Focus.OnFocused))
end

function Focus.Restore()
    if Focus.paused3d then
        setRendering(true)
        Focus.paused3d = false
    end
end

--// =====================================================================
--// MODULO: CONGELAMENTO DE EFEITOS SUB-PIXEL
--// =====================================================================
--//
--// Para cada efeito em Workspace estimamos o maior tamanho que uma
--// particula pode ter (studs) e o quanto ela pode se aproximar da camera
--// a partir da origem do emissor. O tamanho projetado na tela e:
--//
--//     px = tamanho * focal / distancia * SIZE_SAFETY
--//
--// com focal = alturaDaTela / (2 * tan(FOV / 2)). Se px fica abaixo de
--// SLEEP_BELOW_PX, o efeito recebe TimeScale = 0: para de simular e de
--// emitir, mas as particulas existentes continuam desenhadas no mesmo
--// lugar. Ao voltar acima de WAKE_ABOVE_PX, o TimeScale original volta.
--//
--// Usamos TimeScale em vez de Enabled porque scripts de jogo alteram
--// Enabled com frequencia e porque congelar evita a "recarga" visivel de
--// um emissor desligado.

local Sleeper = {
    records = {},     -- [Instance] = record
    list = {},        -- array de records para varredura round-robin
    intake = {},      -- fila de instancias novas
    intakeHead = 1,
    cursor = 1,
    passStart = 0,
    passDone = false,
    sleepingCount = 0,
    lastFocal = 0,
}

local TRACKED = {
    ParticleEmitter = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
}

local function sequenceMax(seq)
    local best = 0
    local keypoints = seq.Keypoints
    for i = 1, #keypoints do
        local kp = keypoints[i]
        local v = kp.Value + kp.Envelope
        if v > best then
            best = v
        end
    end
    return best
end

local function numberRangeMax(range)
    return mathMax(mathAbs(range.Min), mathAbs(range.Max))
end

-- Retorna tamanho maximo da particula e alcance maximo a partir do
-- emissor (ambos em studs).
local function measureParticleEmitter(inst)
    local size = sequenceMax(inst.Size)
    local squash = 0
    local ok, seq = pcall(function()
        return inst.Squash
    end)
    if ok and seq then
        for _, kp in ipairs(seq.Keypoints) do
            local v = mathAbs(kp.Value) + kp.Envelope
            if v > squash then
                squash = v
            end
        end
    end
    size = size * (1 + squash)

    local life = numberRangeMax(inst.Lifetime)
    local speed = numberRangeMax(inst.Speed)
    local accel = inst.Acceleration.Magnitude
    local reach = speed * life + 0.5 * accel * life * life
    return size, reach
end

local function measureFire(inst)
    return inst.Size * 2, inst.Size * 2 + mathAbs(inst.Heat)
end

local function measureSmoke(inst)
    return inst.Size * 3, inst.Size * 3 + mathAbs(inst.RiseVelocity) * 5
end

local function measureSparkles(_)
    return 1.5, 5
end

local MEASURE = {
    ParticleEmitter = measureParticleEmitter,
    Fire = measureFire,
    Smoke = measureSmoke,
    Sparkles = measureSparkles,
}

-- Retorna posicao da origem do efeito e raio extra do volume de emissao.
local function anchorOf(inst)
    local parent = inst.Parent
    if parent == nil then
        return nil, 0
    end
    if parent:IsA("Attachment") then
        return parent.WorldPosition, 0
    end
    if parent:IsA("BasePart") then
        return parent.Position, parent.Size.Magnitude * 0.5
    end
    return nil, 0
end

local function writeTimeScale(rec, value)
    rec.writing = value
    local ok = pcall(function()
        rec.inst.TimeScale = value
    end)
    return ok
end

local function sleepRecord(rec)
    if rec.sleeping then
        return
    end
    local ok, current = pcall(function()
        return rec.inst.TimeScale
    end)
    if not ok then
        rec.unsupported = true
        return
    end
    if current == 0 then
        -- O proprio jogo ja congelou o efeito; nao ha o que ganhar.
        return
    end
    rec.desired = current
    if not writeTimeScale(rec, 0) then
        rec.unsupported = true
        return
    end
    rec.sleeping = true
    Sleeper.sleepingCount += 1

    -- Marca a instancia para que clones feitos pelo jogo enquanto ela
    -- esta congelada sejam restaurados (ver Sleeper.OnTaggedAdded).
    pcall(rec.inst.SetAttribute, rec.inst, ATTR, current)
    pcall(CollectionService.AddTag, CollectionService, rec.inst, TAG)

    -- Enquanto congelado, respeita qualquer TimeScale que o jogo definir.
    rec.watch = rec.inst:GetPropertyChangedSignal("TimeScale"):Connect(function()
        local inst = rec.inst
        local value = inst.TimeScale
        if value == 0 then
            return
        end
        rec.desired = value
        pcall(inst.SetAttribute, inst, ATTR, value)
        writeTimeScale(rec, 0)
    end)
end

local function wakeRecord(rec)
    if not rec.sleeping then
        return
    end
    rec.sleeping = false
    Sleeper.sleepingCount -= 1
    if rec.watch then
        rec.watch:Disconnect()
        rec.watch = nil
    end
    writeTimeScale(rec, rec.desired or 1)
    pcall(CollectionService.RemoveTag, CollectionService, rec.inst, TAG)
    pcall(rec.inst.SetAttribute, rec.inst, ATTR, nil)
end

local function track(inst)
    if Sleeper.records[inst] or not TRACKED[inst.ClassName] then
        return
    end
    local rec = {
        inst = inst,
        measure = MEASURE[inst.ClassName],
        size = 0,
        reach = 0,
        sizeAt = -1e9,
        sleeping = false,
        desired = nil,
        watch = nil,
        unsupported = false,
        index = 0,
    }
    local list = Sleeper.list
    list[#list + 1] = rec
    rec.index = #list
    Sleeper.records[inst] = rec
end

local function untrack(inst)
    local rec = Sleeper.records[inst]
    if not rec then
        return
    end
    wakeRecord(rec)
    Sleeper.records[inst] = nil

    -- Remocao O(1): troca com o ultimo elemento.
    local list = Sleeper.list
    local last = list[#list]
    local idx = rec.index
    list[idx] = last
    last.index = idx
    list[#list] = nil
    if Sleeper.cursor > #list then
        Sleeper.cursor = 1
    end
end

local function queue(inst)
    local intake = Sleeper.intake
    intake[#intake + 1] = inst
end

-- Clone de um efeito congelado (o jogo pode clonar uma peca distante).
-- O clone herda TimeScale = 0, entao restauramos o valor original.
function Sleeper.OnTaggedAdded(inst)
    local rec = Sleeper.records[inst]
    if rec and rec.sleeping then
        return
    end
    local ok, value = pcall(inst.GetAttribute, inst, ATTR)
    if ok and type(value) == "number" then
        pcall(function()
            if inst.TimeScale == 0 then
                inst.TimeScale = value
            end
        end)
    end
    pcall(inst.SetAttribute, inst, ATTR, nil)
    pcall(CollectionService.RemoveTag, CollectionService, inst, TAG)
end

local camPos = Vector3.zero
local focal = 1

local function refreshCamera()
    local cam = Workspace.CurrentCamera
    if not cam then
        return false
    end
    camPos = cam.CFrame.Position
    local viewport = cam.ViewportSize
    local fov = cam.FieldOfView
    if fov <= 0 or viewport.Y <= 0 then
        return false
    end
    focal = viewport.Y / (2 * mathTan(mathRad(fov) * 0.5))
    return true
end

local function evaluate(rec, now)
    if rec.unsupported then
        return
    end
    local inst = rec.inst

    if now - rec.sizeAt >= CONFIG.SIZE_REFRESH then
        local ok, size, reach = pcall(rec.measure, inst)
        if not ok then
            rec.unsupported = true
            return
        end
        rec.size = size
        rec.reach = reach
        rec.sizeAt = now
    end

    local pos, radius = anchorOf(inst)
    if not pos then
        if rec.sleeping then
            wakeRecord(rec)
        end
        return
    end

    local dist = (pos - camPos).Magnitude - radius - rec.reach
    if dist <= 1 then
        if rec.sleeping then
            wakeRecord(rec)
        end
        return
    end

    local px = rec.size * focal / dist * CONFIG.SIZE_SAFETY
    if rec.sleeping then
        if px > CONFIG.WAKE_ABOVE_PX then
            wakeRecord(rec)
        end
    elseif px < CONFIG.SLEEP_BELOW_PX then
        sleepRecord(rec)
    end
end

function Sleeper.Step(now)
    -- 1. Processa instancias novas dentro do orcamento.
    local intake = Sleeper.intake
    local head = Sleeper.intakeHead
    local count = #intake
    if head <= count then
        local deadline = osClock() + CONFIG.INTAKE_BUDGET_MS / 1000
        while head <= count do
            local inst = intake[head]
            intake[head] = nil
            head += 1
            if inst.Parent and inst:IsDescendantOf(Workspace) then
                track(inst)
            end
            if osClock() >= deadline then
                break
            end
        end
        if head > count then
            table.clear(intake)
            head = 1
        end
        Sleeper.intakeHead = head
    end

    -- 2. Varredura round-robin dentro do orcamento.
    local list = Sleeper.list
    local n = #list
    if n == 0 then
        return
    end
    if not refreshCamera() then
        return
    end

    if focal > Sleeper.lastFocal * CONFIG.ZOOM_RESCAN_RATIO then
        Sleeper.passDone = false
        Sleeper.cursor = 1
        Sleeper.passStart = now
    end
    Sleeper.lastFocal = focal

    if Sleeper.passDone then
        if now - Sleeper.passStart < CONFIG.SCAN_INTERVAL then
            return
        end
        Sleeper.passDone = false
        Sleeper.cursor = 1
        Sleeper.passStart = now
    end

    local deadline = osClock() + CONFIG.FRAME_BUDGET_MS / 1000
    local cursor = Sleeper.cursor
    while cursor <= n do
        evaluate(list[cursor], now)
        cursor += 1
        if osClock() >= deadline then
            break
        end
    end
    if cursor > n then
        Sleeper.passDone = true
        cursor = 1
    end
    Sleeper.cursor = cursor
end

function Sleeper.Init()
    -- Restaura sobras de uma execucao anterior que nao terminou limpa.
    for _, inst in ipairs(CollectionService:GetTagged(TAG)) do
        Sleeper.OnTaggedAdded(inst)
    end
    maid:Give(CollectionService:GetInstanceAddedSignal(TAG):Connect(Sleeper.OnTaggedAdded))

    maid:Give(Workspace.DescendantAdded:Connect(function(inst)
        if TRACKED[inst.ClassName] then
            queue(inst)
        end
    end))
    maid:Give(Workspace.DescendantRemoving:Connect(function(inst)
        if Sleeper.records[inst] then
            untrack(inst)
        end
    end))

    -- Carga inicial espalhada em varios frames.
    task.spawn(function()
        local descendants = Workspace:GetDescendants()
        local deadline = osClock() + 0.002
        for i = 1, #descendants do
            if not running then
                return
            end
            local inst = descendants[i]
            if TRACKED[inst.ClassName] then
                queue(inst)
            end
            if osClock() >= deadline then
                task.wait()
                deadline = osClock() + 0.002
            end
        end
    end)
end

function Sleeper.Restore()
    local list = Sleeper.list
    for i = 1, #list do
        wakeRecord(list[i])
    end
    table.clear(list)
    table.clear(Sleeper.records)
    table.clear(Sleeper.intake)
    Sleeper.intakeHead = 1
    Sleeper.cursor = 1
    Sleeper.sleepingCount = 0
end

--// =====================================================================
--// MODULO: MEDIDOR DE FPS E HUD
--// =====================================================================

local Meter = {
    frames = 0,
    windowStart = 0,
    fps = 0,
    worstDt = 0,
    windowWorst = 0,
}

function Meter.Step(dt, now)
    Meter.frames += 1
    if dt > Meter.windowWorst then
        Meter.windowWorst = dt
    end
    local elapsed = now - Meter.windowStart
    if elapsed >= CONFIG.HUD_REFRESH then
        Meter.fps = Meter.frames / elapsed
        Meter.worstDt = Meter.windowWorst
        Meter.frames = 0
        Meter.windowWorst = 0
        Meter.windowStart = now
        return true
    end
    return false
end

local Hud = {
    gui = nil,
    label = nil,
    visible = false,
}

-- Tenta gethui(), depois CoreGui e por ultimo PlayerGui.
local function parentGui(gui)
    local candidates = {}
    if Caps.gethui then
        local ok, ui = pcall(Caps.gethui)
        if ok and typeof(ui) == "Instance" then
            candidates[#candidates + 1] = ui
        end
    end
    local okCore, core = pcall(game.GetService, game, "CoreGui")
    if okCore and core then
        candidates[#candidates + 1] = core
    end
    candidates[#candidates + 1] = LocalPlayer:WaitForChild("PlayerGui")

    for _, parent in ipairs(candidates) do
        pcall(function()
            local old = parent:FindFirstChild(GUI_NAME)
            if old then
                old:Destroy()
            end
        end)
        if pcall(function()
            gui.Parent = parent
        end) and gui.Parent == parent then
            return true
        end
    end
    return false
end

function Hud.Build()
    local gui = Instance.new("ScreenGui")
    gui.Name = GUI_NAME
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 2147483646
    gui.Enabled = false

    local label = Instance.new("TextLabel")
    label.Name = "Stats"
    label.AnchorPoint = Vector2.new(1, 0)
    label.Position = UDim2.new(1, -10, 0, 10)
    label.Size = UDim2.fromOffset(210, 92)
    label.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
    label.BackgroundTransparency = 0.25
    label.BorderSizePixel = 0
    label.TextColor3 = Color3.fromRGB(225, 215, 255)
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Text = ""
    label.Parent = gui

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 6)
    pad.Parent = label

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label

    if not parentGui(gui) then
        gui:Destroy()
        error("nenhum container de GUI disponivel")
    end
    Hud.gui = gui
    Hud.label = label
    maid:Give(gui)
end

local function readPing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then
        return value
    end
    return nil
end

function Hud.Refresh()
    if not Hud.visible or not Hud.label then
        return
    end
    local mem = Stats:GetTotalMemoryUsageMb()
    local ping = readPing()
    Hud.label.Text = string.format(
        "LYRA-FPS\nFPS: %d\nPior frame: %.1f ms\nMemoria: %d MB\nPing: %s\nEfeitos congelados: %d/%d",
        mathFloor(Meter.fps + 0.5),
        Meter.worstDt * 1000,
        mathFloor(mem),
        ping and string.format("%d ms", mathFloor(ping + 0.5)) or "-",
        Sleeper.sleepingCount,
        #Sleeper.list
    )
end

function Hud.SetVisible(visible)
    Hud.visible = visible
    if Hud.gui then
        Hud.gui.Enabled = visible
    end
    if visible then
        Hud.Refresh()
    end
end

function Hud.Init()
    local ok, err = pcall(Hud.Build)
    if not ok then
        warnLog("HUD indisponivel:", err)
        return
    end
    Hud.SetVisible(CONFIG.HUD_START_VISIBLE)
    maid:Give(UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end
        if input.KeyCode == CONFIG.HUD_KEY then
            Hud.SetVisible(not Hud.visible)
        end
    end))
end

--// =====================================================================
--// LOOP PRINCIPAL
--// =====================================================================

local function onHeartbeat(dt)
    local now = osClock()
    if Meter.Step(dt, now) then
        Hud.Refresh()
    end
    if CONFIG.EFFECT_SLEEPER then
        Sleeper.Step(now)
    end
end

--// =====================================================================
--// INICIO E PARADA
--// =====================================================================

local function stop()
    if not running then
        return
    end
    running = false
    maid:Clean()
    Sleeper.Restore()
    Focus.Restore()
    FpsCap.Restore()
    if genv.LyraFPS and genv.LyraFPS.Stop == stop then
        genv.LyraFPS = nil
    end
    log("parado e restaurado")
end

local function start()
    FpsCap.Init()
    local capped = FpsCap.Set(CONFIG.FPS_CAP)

    Focus.Init()
    if Caps.isrbxactive then
        local okActive, active = pcall(Caps.isrbxactive)
        if okActive and active == false then
            Focus.OnReleased()
        end
    end

    if CONFIG.EFFECT_SLEEPER then
        Sleeper.Init()
    end

    Hud.Init()

    Meter.windowStart = osClock()
    maid:Give(RunService.Heartbeat:Connect(onHeartbeat))

    genv.LyraFPS = {
        Stop = stop,
        Config = CONFIG,
        Stats = function()
            return {
                fps = Meter.fps,
                worstFrameMs = Meter.worstDt * 1000,
                trackedEffects = #Sleeper.list,
                sleepingEffects = Sleeper.sleepingCount,
                fpsCapMethod = FpsCap.method,
                fpsCap = FpsCap.current,
            }
        end,
    }

    if capped then
        log(string.format("limite de FPS: %s (via %s)",
            CONFIG.FPS_CAP > 0 and tostring(CONFIG.FPS_CAP) or "sem limite",
            FpsCap.method))
    else
        warnLog("executor sem setfpscap/setfflag; use o limite de FPS do menu do Roblox")
    end
    log("congelamento de efeitos:", CONFIG.EFFECT_SLEEPER and "ativo" or "desligado")
    log("HUD:", CONFIG.HUD_KEY.Name, "| parar: getgenv().LyraFPS.Stop()")
end

local ok, err = pcall(start)
if not ok then
    warnLog("falha ao iniciar:", err)
    pcall(stop)
end
