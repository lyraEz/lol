local ScreenGui = Instance.new("ScreenGui")
local hub = Instance.new("Frame")
local header = Instance.new("TextButton")
local toggleButton = Instance.new("TextButton")
local waitLabel = Instance.new("TextLabel")
local waitBox = Instance.new("TextBox")

ScreenGui.Parent = game:GetService("CoreGui")

hub.Name = "WallhopHub"
hub.Parent = ScreenGui
hub.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hub.BackgroundTransparency = 0.2
hub.BorderSizePixel = 0
hub.Position = UDim2.new(0.3, 0, 0.2, 0)
hub.Size = UDim2.new(0, 250, 0, 170)
hub.Visible = true
hub.ClipsDescendants = true
hub.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = hub

header.Name = "Header"
header.Parent = hub
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.Size = UDim2.new(1, 0, 0, 30)
header.Font = Enum.Font.SourceSans
header.Text = "Wallhop Hub"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 18
header.AutoButtonColor = false

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

toggleButton.Name = "ToggleWallhop"
toggleButton.Parent = hub
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
toggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Text = "Toggle Wallhop: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

waitLabel.Name = "WaitLabel"
waitLabel.Parent = hub
waitLabel.BackgroundTransparency = 1
waitLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
waitLabel.Size = UDim2.new(0.5, 0, 0.15, 0)
waitLabel.Font = Enum.Font.SourceSans
waitLabel.Text = "Wait Time:"
waitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
waitLabel.TextSize = 16

waitBox.Name = "WaitBox"
waitBox.Parent = hub
waitBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
waitBox.Position = UDim2.new(0.55, 0, 0.6, 0)
waitBox.Size = UDim2.new(0.3, 0, 0.15, 0)
waitBox.Font = Enum.Font.SourceSans
waitBox.Text = "0.03"
waitBox.TextColor3 = Color3.fromRGB(255, 255, 255)
waitBox.TextSize = 16

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = waitBox

local waitTime = 0.03
local WallhopEnabled = false

game:GetService("UserInputService").JumpRequest:connect(function()
    if WallhopEnabled then
        WallhopEnabled = false
        workspace.CurrentCamera:PanUnits(1)
        wait(waitTime)
        WallhopEnabled = true
        workspace.CurrentCamera:PanUnits(-1)
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    WallhopEnabled = not WallhopEnabled
    toggleButton.Text = "Toggle Wallhop: " .. (WallhopEnabled and "ON" or "OFF")
end)

waitBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newWait = tonumber(waitBox.Text)
        if newWait and newWait > 0 then
            waitTime = newWait
        else
            waitBox.Text = tostring(waitTime)
        end
    end
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    hub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hub.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)