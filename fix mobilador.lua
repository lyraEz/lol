local UserInputService = game:GetService("UserInputService")

-- Tempo que o botão direito precisa ficar pressionado para alternar o estado
local HOLD_TIME = 0.3

local LockEnabled = false
local HoldToken = 0

local function ApplyMouseState()
    if LockEnabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end

    HoldToken += 1
    local ThisHold = HoldToken

    task.delay(HOLD_TIME, function()
        if ThisHold ~= HoldToken then
            return
        end

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            LockEnabled = not LockEnabled
            ApplyMouseState()
        end
    end)
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldToken += 1
    end
end)

ApplyMouseState()
