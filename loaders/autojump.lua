local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local autoJumpEnabled = false
local button = nil

local soundOn = Instance.new("Sound")
soundOn.SoundId = "rbxassetid://9112004149"
soundOn.Volume = 0.5

local soundOff = Instance.new("Sound")
soundOff.SoundId = "rbxassetid://9112004149"
soundOff.Volume = 0.5

soundOn.Parent = SoundService
soundOff.Parent = SoundService

local function createButton()
    if button and button.Parent then
        button:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoJumpGUI"
    gui.Parent = player.PlayerGui

    button = Instance.new("TextButton")
    button.Name = "AutoJumpButton"
    button.Size = UDim2.new(0, 100, 0, 100)
    button.Position = UDim2.new(0.8, 0, 0.7, 0)
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    button.Text = "AutoJump\nOFF"
    button.TextScaled = true
    button.TextColor3 = Color3.new(1, 1, 1)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = button

    local dragInput, dragStart, startPos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragStart = nil
                end
            end)
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    button.Activated:Connect(function()
        autoJumpEnabled = not autoJumpEnabled
        if autoJumpEnabled then
            soundOn:Play()
            button.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
            button.Text = "AutoJump\nON"
        else
            soundOff:Play()
            button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            button.Text = "AutoJump\nOFF"
        end
    end)

    button.Parent = gui
end

local function autoJump()
    if autoJumpEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

RunService.Heartbeat:Connect(autoJump)

player.CharacterAdded:Connect(function()
    if UserInputService.TouchEnabled then
        createButton()
    end
end)

if UserInputService.TouchEnabled then
    createButton()
end