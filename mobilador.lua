--// =========================================================
--// MOBHUB
--// =========================================================
--// CEO / Criadores do Projeto
--// DEV: MODARO
--// Créditos: @MODARORX & @LUCZX_V7
--// =========================================================

--// RAYFIELD
local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// =========================================================
--// WINDOW
--// =========================================================

local Window = Rayfield:CreateWindow({
    Name = "MOBHUB",
    LoadingTitle = "MOBHUB",
    LoadingSubtitle = "by @MODARORX",

    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "MOBHUB"
    },

    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },

    KeySystem = false
})

--// =========================================================
--// TABS
--// =========================================================

local MobiladorTab = Window:CreateTab("MOBILADOR", 4483362458)
local OutrosTab = Window:CreateTab("OUTROS", 4483362458)
local CreditosTab = Window:CreateTab("Créditos", 4483362458)

-- ==========================================================
-- MOBILADOR
-- ==========================================================

MobiladorTab:CreateSection("Scripts")

MobiladorTab:CreateParagraph({
    Title = "MOBILADOR",
    Content = "Execute os scripts abaixo diretamente pelo MOBHUB."
})

-- ==========================================================
-- SCRIPT 1
-- ==========================================================

MobiladorTab:CreateButton({
    Name = "▶ Personalizar Cursor",

    Callback = function()

        local Success, ErrorMessage = pcall(function()

            loadstring(game:HttpGet(
                "https://pastebin.com/raw/nUsYzrRw"
            ))()

        end)

        if Success then

            Rayfield:Notify({
                Title = "MOBHUB",
                Content = "Script 1 executado com sucesso!",
                Duration = 4
            })

        else

            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o Script 1.",
                Duration = 5
            })

            warn("[MOBHUB] Script 1:", ErrorMessage)

        end

    end
})

-- ==========================================================
-- SCRIPT 2
-- ==========================================================

MobiladorTab:CreateButton({
    Name = "▶ Consertar Limite de Tela",

    Callback = function()

        local Success, ErrorMessage = pcall(function()

            loadstring(game:HttpGet(
                "https://pastebin.com/raw/aSKC7NL8"
            ))()

        end)

        if Success then

            Rayfield:Notify({
                Title = "MOBHUB",
                Content = "Script 2 executado com sucesso!",
                Duration = 4
            })

        else

            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o Script 2.",
                Duration = 5
            })

            warn("[MOBHUB] Script 2:", ErrorMessage)

        end

    end
})

-- ==========================================================
-- OUTROS
-- ==========================================================

OutrosTab:CreateSection("Movimento")

local CurrentSpeed = 16
local CurrentJump = 50

local function GetHumanoid()

    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    return Character:FindFirstChildOfClass("Humanoid")

end

-- ==========================================================
-- WALK SPEED
-- ==========================================================

OutrosTab:CreateSlider({

    Name = "Velocidade",

    Range = {0, 250},

    Increment = 1,

    Suffix = " Speed",

    CurrentValue = 16,

    Flag = "WalkSpeed",

    Callback = function(Value)

        CurrentSpeed = Value

        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end

    end

})

-- ==========================================================
-- JUMP POWER
-- ==========================================================

OutrosTab:CreateSlider({

    Name = "Tamanho do Pulo",

    Range = {0, 250},

    Increment = 1,

    Suffix = " JumpPower",

    CurrentValue = 50,

    Flag = "JumpPower",

    Callback = function(Value)

        CurrentJump = Value

        local Humanoid = GetHumanoid()

        if Humanoid then

            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value

        end

    end

})

-- ==========================================================
-- RESPAWN
-- ==========================================================

LocalPlayer.CharacterAdded:Connect(function(Character)

    local Humanoid = Character:WaitForChild(
        "Humanoid",
        10
    )

    if Humanoid then

        task.wait(0.2)

        Humanoid.WalkSpeed = CurrentSpeed

        Humanoid.UseJumpPower = true

        Humanoid.JumpPower = CurrentJump

    end

end)

-- ==========================================================
-- ESP
-- ==========================================================

OutrosTab:CreateSection("ESP")

local ESPEnabled = false
local ESPNameEnabled = false
local ESPLineEnabled = false

local ESPObjects = {}

-- ==========================================================
-- REMOVE ESP
-- ==========================================================

local function RemoveESP(Player)

    local Data = ESPObjects[Player]

    if not Data then
        return
    end

    if Data.Highlight then
        Data.Highlight:Destroy()
    end

    if Data.Gui then
        Data.Gui:Destroy()
    end

    ESPObjects[Player] = nil

end

-- ==========================================================
-- CREATE ESP
-- ==========================================================

local function CreateESP(Player)

    if Player == LocalPlayer then
        return
    end

    RemoveESP(Player)

    local Data = {}

    -- Highlight
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "MOBHUB_ESP"

    Highlight.FillTransparency = 0.65

    Highlight.OutlineTransparency = 0

    Highlight.FillColor =
        Color3.fromRGB(255, 70, 70)

    Highlight.OutlineColor =
        Color3.fromRGB(255, 255, 255)

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Data.Highlight = Highlight

    -- ScreenGui
    local Gui = Instance.new("ScreenGui")

    Gui.Name = "MOBHUB_ESP_" .. Player.Name

    Gui.ResetOnSpawn = false

    Gui.IgnoreGuiInset = true

    Gui.DisplayOrder = 999998

    Gui.Parent =
        LocalPlayer:WaitForChild("PlayerGui")

    Data.Gui = Gui

    -- ======================================================
    -- NAME
    -- ======================================================

    local NameLabel = Instance.new("TextLabel")

    NameLabel.Name = "Name"

    NameLabel.AnchorPoint =
        Vector2.new(0.5, 1)

    NameLabel.Size =
        UDim2.fromOffset(220, 30)

    NameLabel.BackgroundTransparency = 1

    NameLabel.Text =
        Player.DisplayName

    NameLabel.TextColor3 =
        Color3.fromRGB(255,255,255)

    NameLabel.TextStrokeTransparency = 0

    NameLabel.Font =
        Enum.Font.GothamBold

    NameLabel.TextSize = 14

    NameLabel.Visible = false

    NameLabel.Parent = Gui

    Data.NameLabel = NameLabel

    -- ======================================================
    -- LINE
    -- ======================================================

    local Line = Instance.new("Frame")

    Line.Name = "Line"

    Line.AnchorPoint =
        Vector2.new(0, 0.5)

    Line.BackgroundColor3 =
        Color3.fromRGB(255,255,255)

    Line.BorderSizePixel = 0

    Line.Size =
        UDim2.fromOffset(0,2)

    Line.Visible = false

    Line.Parent = Gui

    Data.Line = Line

    ESPObjects[Player] = Data

    -- ======================================================
    -- UPDATE
    -- ======================================================

    Data.Update = function()

        local Character =
            Player.Character

        if not Character then

            Highlight.Parent = nil

            NameLabel.Visible = false

            Line.Visible = false

            return

        end

        local Root =
            Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local Humanoid =
            Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if not Root
            or not Humanoid
            or Humanoid.Health <= 0 then

            Highlight.Parent = nil

            NameLabel.Visible = false

            Line.Visible = false

            return

        end

        -- ESP
        if ESPEnabled then

            Highlight.Parent = Character

        else

            Highlight.Parent = nil

        end

        local Camera =
            workspace.CurrentCamera

        if not Camera then
            return
        end

        local ScreenPosition, OnScreen =
            Camera:WorldToViewportPoint(
                Root.Position
            )

        -- ==================================================
        -- NAME
        -- ==================================================

        if ESPNameEnabled and OnScreen then

            NameLabel.Visible = true

            NameLabel.Position =
                UDim2.fromOffset(
                    ScreenPosition.X,
                    ScreenPosition.Y - 35
                )

            NameLabel.Text =
                Player.DisplayName ..
                "  @" ..
                Player.Name

        else

            NameLabel.Visible = false

        end

        -- ==================================================
        -- LINE
        -- ==================================================

        if ESPLineEnabled and OnScreen then

            local Viewport =
                Camera.ViewportSize

            local Start =
                Vector2.new(
                    Viewport.X / 2,
                    Viewport.Y
                )

            local End =
                Vector2.new(
                    ScreenPosition.X,
                    ScreenPosition.Y
                )

            local Difference =
                End - Start

            local Length =
                Difference.Magnitude

            Line.Visible = true

            Line.Position =
                UDim2.fromOffset(
                    Start.X,
                    Start.Y
                )

            Line.Size =
                UDim2.fromOffset(
                    Length,
                    2
                )

            Line.Rotation =
                math.deg(
                    math.atan2(
                        Difference.Y,
                        Difference.X
                    )
                )

        else

            Line.Visible = false

        end

    end

end

-- ==========================================================
-- REFRESH ESP
-- ==========================================================

local function RefreshESP()

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer then

            if not ESPObjects[Player] then

                CreateESP(Player)

            end

        end

    end

end

-- ==========================================================
-- PLAYER ADDED
-- ==========================================================

Players.PlayerAdded:Connect(function(Player)

    task.wait(0.5)

    CreateESP(Player)

end)

-- ==========================================================
-- PLAYER REMOVING
-- ==========================================================

Players.PlayerRemoving:Connect(function(Player)

    RemoveESP(Player)

end)

-- ==========================================================
-- ESP RENDER
-- ==========================================================

RunService.RenderStepped:Connect(function()

    for Player, Data in pairs(ESPObjects) do

        if Data.Update then

            Data.Update()

        end

    end

end)

-- ==========================================================
-- ESP TOGGLE
-- ==========================================================

OutrosTab:CreateToggle({

    Name = "ESP",

    CurrentValue = false,

    Flag = "ESP",

    Callback = function(Value)

        ESPEnabled = Value

        RefreshESP()

    end

})

-- ==========================================================
-- ESP NAME
-- ==========================================================

OutrosTab:CreateToggle({

    Name = "ESP NAME",

    CurrentValue = false,

    Flag = "ESPName",

    Callback = function(Value)

        ESPNameEnabled = Value

        RefreshESP()

    end

})

-- ==========================================================
-- ESP LINE
-- ==========================================================

OutrosTab:CreateToggle({

    Name = "ESP LINE",

    CurrentValue = false,

    Flag = "ESPLine",

    Callback = function(Value)

        ESPLineEnabled = Value

        RefreshESP()

    end

})

-- ==========================================================
-- RESET
-- ==========================================================

OutrosTab:CreateSection("Reset")

OutrosTab:CreateButton({

    Name = "↩ Restaurar Movimento",

    Callback = function()

        CurrentSpeed = 16

        CurrentJump = 50

        local Humanoid =
            GetHumanoid()

        if Humanoid then

            Humanoid.WalkSpeed = 16

            Humanoid.UseJumpPower = true

            Humanoid.JumpPower = 50

        end

        Rayfield:Notify({

            Title = "MOBHUB",

            Content =
                "Velocidade e pulo restaurados.",

            Duration = 3

        })

    end

})

-- ==========================================================
-- CRÉDITOS
-- ==========================================================

CreditosTab:CreateSection("MOBHUB")

CreditosTab:CreateParagraph({

    Title = "MOBHUB",

    Content =
        "Projeto desenvolvido para reunir ferramentas e scripts em uma única interface."

})

CreditosTab:CreateSection("CEOs / Criadores")

CreditosTab:CreateParagraph({

    Title = "CEOs",

    Content =
        "Créditos aos CEOs MODARO & LUCAS responsáveis pelo projeto MOBHUB."

})

CreditosTab:CreateSection("Desenvolvimento")

CreditosTab:CreateParagraph({

    Title = "DEV — MODARO",

    Content =
        "Desenvolvedor: MODARO\n\n" ..
        "Créditos: @MODARORX & @luczx_v7"

})

CreditosTab:CreateSection("Equipe")

CreditosTab:CreateParagraph({

    Title = "MOBHUB TEAM",

    Content =
        "Obrigado a todos que fazem parte do projeto e ajudam no desenvolvimento."

})

-- ==========================================================
-- FINAL
-- ==========================================================

Rayfield:Notify({

    Title = "MOBHUB",

    Content =
        "Hub carregado com sucesso!",

    Duration = 5

})

print("======================================")
print("             MOBHUB")
print("       DEV: MODARO")
print("       @MODARORX")
print("======================================")