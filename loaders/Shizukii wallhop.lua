local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Hub de gay
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local container = Instance.new("Frame")
container.Size = UDim2.new(0.2, 0, 0.2, 0)
container.Position = UDim2.new(0.4, 0, 0.4, 0)
container.BackgroundTransparency = 0.5
container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
container.BorderColor3 = Color3.fromRGB(100, 100, 100)
container.BorderSizePixel = 2
container.Active = true
container.Draggable = true
container.Parent = screenGui

local flickButton = Instance.new("TextButton")
flickButton.Text = "Flick"
flickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flickButton.Size = UDim2.new(0.8, 0, 0.2, 0)
flickButton.Position = UDim2.new(0.1, 0, 0.1, 0)
flickButton.BackgroundTransparency = 0.5
flickButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flickButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
flickButton.BorderSizePixel = 2
flickButton.Font = Enum.Font.GothamBold
flickButton.TextScaled = true
flickButton.Parent = container

local wallhopToggle = Instance.new("TextButton")
wallhopToggle.Text = "Wallhop: Off"
wallhopToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallhopToggle.Size = UDim2.new(0.8, 0, 0.2, 0)
wallhopToggle.Position = UDim2.new(0.1, 0, 0.6, 0)
wallhopToggle.BackgroundTransparency = 0.5
wallhopToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wallhopToggle.BorderColor3 = Color3.fromRGB(100, 100, 100)
wallhopToggle.BorderSizePixel = 2
wallhopToggle.Font = Enum.Font.GothamBold
wallhopToggle.TextScaled = true
wallhopToggle.Parent = container

local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
minimizeButton.Position = UDim2.new(0.9, -5, 0, 5)
minimizeButton.BackgroundTransparency = 0.5
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.BorderSizePixel = 2
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextScaled = true
minimizeButton.Parent = container

local showHubButton = Instance.new("TextButton")
showHubButton.Text = "Show"
showHubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
showHubButton.Size = UDim2.new(0.1, 0, 0.1, 0)
showHubButton.Position = UDim2.new(0.9, 0, 0.9, 0)
showHubButton.BackgroundTransparency = 0.5
showHubButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
showHubButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
showHubButton.BorderSizePixel = 2
showHubButton.Font = Enum.Font.GothamBold
showHubButton.TextScaled = true
showHubButton.Visible = false
showHubButton.Parent = screenGui

local wallhopEnabled = false

local function flick()
    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local newCFrame = originalCFrame * CFrame.Angles(0, math.rad(90), 0)
    camera.CFrame = newCFrame
    wait(0.05) 
    camera.CFrame = originalCFrame 
end

flickButton.MouseButton1Click:Connect(flick)

wallhopToggle.MouseButton1Click:Connect(function()
    wallhopEnabled = not wallhopEnabled
    wallhopToggle.Text = wallhopEnabled and "Wallhop: On" or "Wallhop: Off"
end)

local function wallhop()
    while true do
        wait(0.1)
        if wallhopEnabled then
            local ray = Ray.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.CFrame.lookVector * 5)
            local hit, position = workspace:FindPartOnRay(ray, character)

            if hit then
                humanoid.Jump = true
                wait(0.1)
                flick()
            end
        end
    end
end

coroutine.wrap(wallhop)()

minimizeButton.MouseButton1Click:Connect(function()
    container.Visible = false
    showHubButton.Visible = true
end)

showHubButton.MouseButton1Click:Connect(function()
    container.Visible = true
    showHubButton.Visible = false
end)
-- outro dis eu arrumo o wallhop e coloco o autoflick/jumpflick 
