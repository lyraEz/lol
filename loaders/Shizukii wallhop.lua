local UIS = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flickEnabled = true
local autoJumpEnabled = false
local flickButton, autoJumpButton, minimizeButton
local dragging, dragStart, startPos
local guiMinimized = false

-- Create the GUI elements
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false -- Ensure the GUI won't reset when the player respawns
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local container = Instance.new("Frame")
container.Size = UDim2.new(0.3, 0, 0.2, 0)  -- Adjust size for the container
container.Position = UDim2.new(0.35, 0, 0.4, 0)  -- Center the container
container.BackgroundTransparency = 0.3  -- Adjust transparency
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark gray
container.BorderColor3 = Color3.fromRGB(100, 100, 100)  -- Border color
container.BorderSizePixel = 2
container.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "Shizukii"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, 0, 0.3, 0)  -- Adjust size for the title
title.Position = UDim2.new(0, 0, 0, 0)  -- Position at the top of the container
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = container

flickButton = Instance.new("TextButton")
flickButton.Text = "Flick"
flickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flickButton.Size = UDim2.new(0.4, 0, 0.3, 0)  -- Adjust size for the button
flickButton.Position = UDim2.new(0.05, 0, 0.6, 0)  -- Position within the container
flickButton.BackgroundTransparency = 0.3  -- Adjust transparency
flickButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Darker gray
flickButton.BorderColor3 = Color3.fromRGB(100, 100, 100)  -- Border color
flickButton.BorderSizePixel = 2
flickButton.Font = Enum.Font.GothamBold
flickButton.TextScaled = true
flickButton.AutoButtonColor = false
flickButton.Parent = container

autoJumpButton = Instance.new("TextButton")
autoJumpButton.Text = "Auto Jump"
autoJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoJumpButton.Size = UDim2.new(0.4, 0, 0.3, 0)  -- Adjust size for the button
autoJumpButton.Position = UDim2.new(0.55, 0, 0.6, 0)  -- Position within the container
autoJumpButton.BackgroundTransparency = 0.3  -- Adjust transparency
autoJumpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Darker gray
autoJumpButton.BorderColor3 = Color3.fromRGB(100, 100, 100)  -- Border color
autoJumpButton.BorderSizePixel = 2
autoJumpButton.Font = Enum.Font.GothamBold
autoJumpButton.TextScaled = true
autoJumpButton.AutoButtonColor = false
autoJumpButton.Parent = container

minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
minimizeButton.Position = UDim2.new(0.05, 0, -0.15, 0)
minimizeButton.BackgroundTransparency = 0.3
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.BorderSizePixel = 2
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextScaled = true
minimizeButton.Parent = container

local function createBorderAnimation(button)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    gradient.Rotation = 45
    gradient.Parent = button

    local function animateGradient()
        local start = tick()
        game:GetService("RunService").RenderStepped:Connect(function()
            gradient.Offset = Vector2.new(math.cos(tick() - start), math.sin(tick() - start))
        end)
    end

    animateGradient()
end

createBorderAnimation(flickButton)
createBorderAnimation(autoJumpButton)

local function flickCamera90Degrees()
    local currentCam = workspace.CurrentCamera
    local initialPos = currentCam.CFrame.Position
    local initialRot = currentCam.CFrame - initialPos
    currentCam.CFrame = CFrame.new(initialPos) * CFrame.Angles(0, math.rad(90), 0) * initialRot
    print("Camera flicked 90 degrees!")
end

local function flickCameraBack90Degrees()
    local currentCam = workspace.CurrentCamera
    local initialPos = currentCam.CFrame.Position
    local initialRot = currentCam.CFrame - initialPos
    currentCam.CFrame = CFrame.new(initialPos) * CFrame.Angles(0, math.rad(-90), 0) * initialRot
    print("Camera flicked back 90 degrees!")
end

local function flickCameraSequence()
    flickCamera90Degrees()
    wait(0.03)
    flickCameraBack90Degrees()
end

flickButton.MouseButton1Click:Connect(function()
    if flickEnabled then
        flickCameraSequence()
    end
end)

autoJumpButton.MouseButton1Click:Connect(function()
    autoJumpEnabled = not autoJumpEnabled
    if autoJumpEnabled then
        autoJumpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green when enabled
    else
        autoJumpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Default color when disabled
    end
end)

local function updateInput(input)
    local delta = input.Position - dragStart
    container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

container.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = container.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

container.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Auto Jump Functionality
local function enableAutoJump()
    game:GetService("RunService").RenderStepped:Connect(function()
        if autoJumpEnabled and humanoid and humanoid:GetState() == Enum.HumanoidStateType.Running then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function onCharacterAdded(character)
    humanoid = character:WaitForChild("Humanoid")
    enableAutoJump()
end

player.CharacterAdded:Connect(onCharacterAdded)
enableAutoJump()

minimizeButton.MouseButton1Click:Connect(function()
    guiMinimized = not guiMinimized
    if guiMinimized then
        container.Visible = false
    else
        container.Visible = true
    end
end)

--outro dia eu coloco o unlock cam e unlock Zoom
