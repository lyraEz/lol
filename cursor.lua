--// MOBHUB - CURSOR PRESET
--// Cursor personalizado sem menu/UI de configuracao
--// Mantem o cursor visual acima das interfaces do jogo

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "MOBHUB_PresetCursor"
local CURSOR_SIZE = 32
local CURSOR_IMAGE = "rbxassetid://2128690040"

-- Remove execucoes anteriores para nao duplicar o cursor.
local function destroyOld(parent)
    if not parent then return end
    local old = parent:FindFirstChild(GUI_NAME)
    if old then
        old:Destroy()
    end
end

pcall(function() destroyOld(PlayerGui) end)
pcall(function() destroyOld(CoreGui) end)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 2147483647
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local cursor = Instance.new("ImageLabel")
cursor.Name = "Cursor"
cursor.BackgroundTransparency = 1
cursor.BorderSizePixel = 0
cursor.AnchorPoint = Vector2.new(0, 0)
cursor.Size = UDim2.fromOffset(CURSOR_SIZE, CURSOR_SIZE)
cursor.Image = CURSOR_IMAGE
cursor.ZIndex = 10
cursor.Active = false
cursor.Selectable = false
cursor.Parent = gui

-- Em executor, gethui() costuma ser a camada mais adequada.
-- Se nao existir, tenta CoreGui e por ultimo PlayerGui.
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

if not parented then
    gui.Parent = PlayerGui
end

-- Desativa apenas o icone nativo. Nao altera MouseBehavior,
-- portanto nao interfere no fix mobilador/controle de camera.
pcall(function()
    UIS.MouseIconEnabled = false
end)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not gui or not gui.Parent or not cursor or not cursor.Parent then
        if connection then
            connection:Disconnect()
        end
        return
    end

    -- Alguns jogos tentam religar o cursor padrao a cada frame.
    if UIS.MouseIconEnabled then
        pcall(function()
            UIS.MouseIconEnabled = false
        end)
    end

    local pos = UIS:GetMouseLocation()
    cursor.Position = UDim2.fromOffset(pos.X, pos.Y)
    cursor.Visible = UIS.MouseEnabled
end)

print("[MOBHUB] Cursor preset carregado.")
