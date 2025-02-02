local WallhopEnabled = true

local player = game.Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui")
if not playerGui then return end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Wallhop: ON"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Draggable = true
button.Active = true
button.AutoButtonColor = false

button.MouseButton1Click:Connect(function()
    WallhopEnabled = not WallhopEnabled
    button.Text = WallhopEnabled and "Wallhop: ON" or "Wallhop: OFF"
    button.BackgroundColor3 = WallhopEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if WallhopEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            WallhopEnabled = false
            workspace.CurrentCamera:PanUnits(1)
            wait(0.03)
            WallhopEnabled = true
            workspace.CurrentCamera:PanUnits(-1)
        end
    end
end)