local player = game:GetService("Players").LocalPlayer

local function applyKorbloxLeg(char)
    repeat wait() until char:FindFirstChild("Right Leg")

    local rightLeg = char:FindFirstChild("Right Leg")
    if rightLeg then
        rightLeg.Transparency = 1

        local korbloxLeg = Instance.new("Part")
        korbloxLeg.Name = "KorbloxLeg"
        korbloxLeg.Size = Vector3.new(1, 1, 1)
        korbloxLeg.Position = rightLeg.Position
        korbloxLeg.Anchored = false
        korbloxLeg.CanCollide = false
        korbloxLeg.Parent = char

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshId = "http://www.roblox.com/asset/?id=902942093"
        mesh.TextureId = "http://roblox.com/asset/?id=902843398"
        mesh.Scale = Vector3.new(0.8, 0.8, 0.8)
        mesh.Parent = korbloxLeg

        local weld = Instance.new("Weld")
        weld.Part0 = rightLeg
        weld.Part1 = korbloxLeg
        weld.C0 = CFrame.new(0, 0.8, 0)
        weld.Parent = korbloxLeg
    end
end

if player.Character then
    applyKorbloxLeg(player.Character)
end

player.CharacterAdded:Connect(function(char)
    applyKorbloxLeg(char)
end)