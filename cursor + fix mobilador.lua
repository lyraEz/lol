--// MOBHUB - CURSOR + FIX MOBILADOR
--// Combina cursor personalizado com toggle de MouseBehavior por segurada

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local HOLD_TIME = 0.3
local GUI_NAME = "MOBHUB_CursorFixMobilador"
local CURSOR_SIZE = 32
local CURSOR_IMAGE = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"

--// FIX MOBILADOR
local LockEnabled = false
local HoldToken = 0

local function ApplyMouseState()
    UIS.MouseBehavior = LockEnabled
        and Enum.MouseBehavior.LockCenter
        or Enum.MouseBehavior.Default
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end

    HoldToken += 1
    local thisHold = HoldToken

    task.delay(HOLD_TIME, function()
        if thisHold ~= HoldToken then
            return
        end

        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            LockEnabled = not LockEnabled
            ApplyMouseState()
        end
    end)
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldToken += 1
    end
end)

ApplyMouseState()

--// CURSOR
local function destroyOld(parent)
    if not parent then return end
    local old = parent:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
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
cursor.ZIndex = 2147483647
cursor.Active = false
cursor.Selectable = false
cursor.Parent = gui

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

pcall(function()
    UIS.MouseIconEnabled = false
end)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not gui.Parent or not cursor.Parent then
        if connection then connection:Disconnect() end
        return
    end

    if UIS.MouseIconEnabled then
        pcall(function()
            UIS.MouseIconEnabled = false
        end)
    end

    local pos = UIS:GetMouseLocation()
    cursor.Position = UDim2.fromOffset(pos.X, pos.Y)
    cursor.Visible = UIS.MouseEnabled
end)

print("[MOBHUB] Cursor + Fix Mobilador carregado.")
