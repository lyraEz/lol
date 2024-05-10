-- Credits: USER100300R from pastebin

if not game:IsLoaded() then game.Loaded:Wait() end
local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
local MM2 = Library:NewWindow("MM2 Mods")
 
local Mains = MM2:NewSection("Main")
local Sprayfunc = MM2:NewSection("Spray Paint Mods")
local Sprayfun = MM2:NewSection("Spray Paint Fun")
local Trapfunc = MM2:NewSection("Trap Perk Mods")
local Gunfunc = MM2:NewSection("Fake Gun Perk Mods")
local Stealthfunc = MM2:NewSection("Stealth Perk Mods")
local Multi = MM2:NewSection("MultiCrash")
local Opti = MM2:NewSection("Optimization")
local Farm = MM2:NewSection("For Farm")
 
if not workspace:FindFirstChild("KillpartsVisual") then
local folder = Instance.new("Folder", workspace)
folder.Name = "KillpartsVisual"
end
 
function CreateHighlight()
	for i, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("ESP_Highlight") then
			local esphigh = Instance.new("Highlight", v.Character)
            esphigh.Name = "ESP_Highlight"
            esphigh.FillColor = Color3.fromRGB(160, 160, 160)
            esphigh.OutlineTransparency = 1
            esphigh.FillTransparency = applyesptrans   
        end
	end
end
 
function UpdateHighlights()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("ESP_Highlight") then
			local Highlight = v.Character:FindFirstChild("ESP_Highlight")
			if v.Name == Sheriff and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(0, 0, 225)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Murder and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(225, 0, 0)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Hero and IsAlive(v) and v.Backpack:FindFirstChild("Gun") then
				Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Hero and IsAlive(v) and v.Character:FindFirstChild("Gun") then
				Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                Highlight.FillTransparency = applyesptrans
			elseif not IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(100, 100, 100)
                Highlight.FillTransparency = applyesptrans
			else
				Highlight.FillColor = Color3.fromRGB(0, 225, 0)
                Highlight.FillTransparency = applyesptrans
			end
		end
	end
end	
 
function IsAlive(Player)
	for i, v in pairs(roles) do
		if Player.Name == i then
			if not v.Killed and not v.Dead then
				return true
			else
				return false
			end
		end
	end
end
 
function HideHighlights()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("ESP_Highlight") then
			v.Character:FindFirstChild("ESP_Highlight"):Destroy()
		end
	end
end
 
applyesptrans = 0.5
Mains:CreateToggle("ESP Players", function(SeeRoles)
if SeeRoles then
SSeeRoles = true
while SSeeRoles == true do
    roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
	for i, v in pairs(roles) do
		if v.Role == "Murderer" then
			Murder = i
		elseif v.Role == "Sheriff" then
			Sheriff = i
		elseif v.Role == "Hero" then
			Hero = i
		end
	end
	CreateHighlight()
	UpdateHighlights()
        end
else
    SSeeRoles = false
    task.wait(0.2)
    HideHighlights()
end
end)
 
Mains:CreateToggle("ESP Gun Drop", function(SeeGun)
if SeeGun then
    SSeeGun = true
    while SSeeGun == true do
        repeat wait()
        until workspace:FindFirstChild("GunDrop")
        if workspace:FindFirstChild("GunDrop") and not workspace.GunDrop:FindFirstChild("Esp_gun") then
            if SSeeGun == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                	Title = "MM2 Mods",
                	Text = "Gun is Dropped",
                   Duration = 2
                })
                local espgunhigh = Instance.new("Highlight", workspace:FindFirstChild("GunDrop"))
                espgunhigh.Name = "Esp_gun"
                espgunhigh.FillColor = Color3.fromRGB(0, 0, 0)
                espgunhigh.OutlineTransparency = 1
                espgunhigh.FillTransparency = 0
            end
        end
    end
else
    SSeeGun = false
    task.wait(0.2)
    if workspace:FindFirstChild("GunDrop") and workspace.GunDrop:FindFirstChild("Esp_gun") then
        workspace.GunDrop:FindFirstChild("Esp_gun"):Destroy()
    end
end
end)
 
Mains:CreateSlider("ESP Transparency", 0, 1, 0.5, true, function(esptrans)
    applyesptrans = esptrans
end)

Mains:CreateButton("Create Fake Knife", function()
if game.Players.LocalPlayer.Character ~= nil then
local lp = game.Players.LocalPlayer
local tool;local handle;local knife;
local animation1 = Instance.new("Animation")
animation1.AnimationId = "rbxassetid://2467567750"
local animation2 = Instance.new("Animation")
animation2.AnimationId = "rbxassetid://1957890538"
local anims = {animation1,animation2}
tool = Instance.new("Tool")
tool.Name = "Fake Knife"
tool.Grip = CFrame.new(0, -1.16999984, 0.0699999481, 1, 0, 0, 0, 1, 0, 0, 0, 1)
tool.GripForward = Vector3.new(-0, -0, -1)
tool.GripPos = Vector3.new(0,-1.17,0.0699999)
tool.GripRight = Vector3.new(1,0,0)
tool.GripUp = Vector3.new(0,1,0)
handle = Instance.new("Part")
handle.Size = Vector3.new(0.310638815, 3.42103457, 1.08775854)
handle.Name = "Handle"
handle.Transparency = 1
handle.Parent = tool
tool.Parent = lp.Backpack
knife=lp.Character:WaitForChild("KnifeDisplay")
knife.Massless = true
lp:GetMouse().Button1Down:Connect(function()
if tool and  tool.Parent == lp.Character then
local an = lp.Character.Humanoid:LoadAnimation(anims[math.random(1,2)])
an:Play()
end
end)
local aa = Instance.new("Attachment",handle)
local ba = Instance.new("Attachment",knife)
local hinge = Instance.new("HingeConstraint",knife)
hinge.Attachment0=aa hinge.Attachment1=ba
hinge.LimitsEnabled = true
hinge.LowerAngle = 0
hinge.Restitution = 0
hinge.UpperAngle = 0
lp.Character:WaitForChild"UpperTorso":FindFirstChild("Weld"):Destroy()
game:GetService"RunService".Heartbeat:Connect(function()
setsimulationradius(1/0,1/0)
if tool.Parent == lp.Character then
knife.CFrame = handle.CFrame
else
knife.CFrame = lp.Character:WaitForChild"UpperTorso".CFrame
end
end)
end
end)
 
Mains:CreateButton("Break Gun", function()
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= game.Players.LocalPlayer and v.Backpack:FindFirstChild("Gun") and v.Character ~= nil then
        v.Backpack.Gun.KnifeServer.ShootGun:InvokeServer(1, 0, "AH")
    elseif v ~= game.Players.LocalPlayer and v.Character:FindFirstChild("Gun") and v.Character ~= nil then
        v.Character.Gun.KnifeServer.ShootGun:InvokeServer(1, 0, "AH")
    end
end
end)

gunshot = false
Mains:CreateToggle("Shoot [M]", function(gunsh)
if gunsh then
	gunshot = true
else
	gunshot = false
end
end)

knifethrow = false
Mains:CreateToggle("Throw [C]", function(throw)
if throw then
	knifethrow = true
else
	knifethrow = false
end
end)
 
Mains:CreateButton("(Dead) Grab Gun", function()
if game.Players.LocalPlayer.Character ~= nil then
local gundr = workspace:FindFirstChild("GunDrop")
if gundr then
    local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    repeat
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = gundr.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
        task.wait()
    until not gundr:IsDescendantOf(workspace)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
    oldpos = false
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(1)
end
end
end)
 
Mains:CreateDropdown("Teleports", {"Lobby", "Map", "PlrY + 100", "PlrY - 100"}, 1, function(tppos)
if game.Players.LocalPlayer.Character ~= nil then
if tppos == "Lobby" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-111, 137, 37)
end
if tppos == "Map" then
for i, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v.Name == "Bank2" then
        local spawns = workspace["Bank2"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Bank2"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "BioLab" then
        local spawns = workspace["BioLab"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["BioLab"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "Factory" then
        local spawns = workspace["Factory"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Factory"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "Hospital3" then
        local spawns = workspace["Hospital3"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Hospital3"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "Hotel" then
        local spawns = workspace["Hotel"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Hotel"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "House2" then
        local spawns = workspace["House2"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["House2"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "Mansion2" then
        local spawns = workspace["Mansion2"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Mansion2"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "MilBase" then
        local spawns = workspace["MilBase"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["MilBase"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "nSOffice" then
        local spawns = workspace["nSOffice"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["nSOffice"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "PoliceStation" then
        local spawns = workspace["PoliceStation"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["PoliceStation"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "ResearchFacility" then
        local spawns = workspace["ResearchFacility"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["ResearchFacility"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    elseif v:IsA("Model") and v.Name == "Workplace" then
        local spawns = workspace["Workplace"].Spawns:GetChildren()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Workplace"].Spawns:GetChildren()[math.random(1,#spawns)].CFrame * CFrame.new(0, 2, 0)
    end
end
end
if tppos == "PlrY + 100" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
end
if tppos == "PlrY - 100" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -100, 0)
end
    end
end)

seedeadchat = false
Mains:CreateToggle("See Dead Chat", function(seechat)
if seechat then
	seedeadchat = true
else
	seedeadchat = false
end
end)

sprayroleinno = false
Mains:CreateToggle("Spray Innocents", function(sprayinno)
if sprayinno then
	sprayroleinno = true
else
	sprayroleinno = false
end
end)

sprayrolemurd = false
Mains:CreateToggle("Spray Murderer", function(spraymurd)
if spraymurd then
	sprayrolemurd = true
else
	sprayrolemurd = false
end
end)

sprayrolegun = false
Mains:CreateToggle("Spray Sheriff/Hero", function(spraygun)
if spraygun then
	sprayrolegun = true
else
	sprayrolegun  = false
end
end)
 
function UserFromBox(String)
	for i,v in pairs(game:GetService("Players"):GetPlayers()) do
		if (string.sub(string.lower(v.Name),1,string.len(String))) == string.lower(String) then
			return v
        end
	end
end

Sprayfunc:CreateButton("Spray Roles V1", function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local roles
if game.Players.LocalPlayer.Character ~= nil then
    roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
	for i, v in pairs(roles) do
		if v.Role == "Murderer" then
			Murder = i
		elseif v.Role == "Sheriff" then
			Sheriff = i
		elseif v.Role == "Hero" then
			Hero = i
		end
	end
	for _, v in pairs(Players:GetChildren()) do
		if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil then
			if v.Name == Sheriff and IsAlive(v) and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
    end
			elseif v.Name == Murder and IsAlive(v) and sprayrolemurd == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
    end
			elseif v.Name == Hero and IsAlive(v) and v.Backpack:FindFirstChild("Gun") and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
    end
			elseif v.Name == Hero and IsAlive(v) and v.Character:FindFirstChild("Gun") and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
    end
			elseif IsAlive(v) and sprayroleinno == true then 
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Front, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Back, 1.7, game.Players[v.Name].Character.HumanoidRootPart, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, 2.85, 0))
    end
			end
		end
	end
end
end)

Sprayfunc:CreateButton("Spray Roles V2", function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local roles
if game.Players.LocalPlayer.Character ~= nil then
    roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
	for i, v in pairs(roles) do
		if v.Role == "Murderer" then
			Murder = i
		elseif v.Role == "Sheriff" then
			Sheriff = i
		elseif v.Role == "Hero" then
			Hero = i
		end
	end
	for _, v in pairs(Players:GetChildren()) do
		if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil then
			if v.Name == Sheriff and IsAlive(v) and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901709669, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
    end
			elseif v.Name == Murder and IsAlive(v) and sprayrolemurd == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901712433, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
    end
			elseif v.Name == Hero and IsAlive(v) and v.Backpack:FindFirstChild("Gun") and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
    end
			elseif v.Name == Hero and IsAlive(v) and v.Character:FindFirstChild("Gun") and sprayrolegun == true then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(13901715538, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
    end
			elseif IsAlive(v) and sprayroleinno == true then 
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
		game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(5367813357, Enum.NormalId.Top, 5, workspace.Lobby.VoteIcons.VotePad2, game.Players[v.Name].Character.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0))
    end
			end
		end
	end
end
end)

Sprayfunc:CreateButton("Spray Tools", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.ReplicatedFirst:FindFirstChild("KillHighlight") then
    game.ReplicatedFirst:FindFirstChild("KillHighlight"):Destroy()
else
for i, v in pairs(workspace:GetDescendants()) do
    if v.Name == "KillHighlight" then
        v:Destroy()
    end
end
end
local killhigh = Instance.new("Highlight", game.ReplicatedFirst)
killhigh.Name = "KillHighlight"
killhigh.OutlineColor = Color3.fromRGB(255, 0, 0)
killhigh.OutlineTransparency = 1
killhigh.FillTransparency = 0.5

toolkill = Instance.new("Tool")
toolkill.RequiresHandle = false
toolkill.Name = "Destroy Player Tool"
toolkill.Parent = game.Players.LocalPlayer.Backpack
toolkill.Equipped:connect(function()
_G.targetkill = game:GetService("RunService").RenderStepped:Connect(function()
if game.Players.LocalPlayer:GetMouse().Target then
    local model = game.Players.LocalPlayer:GetMouse().Target:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChild("Humanoid") and model:FindFirstChild("DisplayName") then
        killhigh.Parent = model
    else
        killhigh.Parent = game.ReplicatedFirst
    end
end
end)
end)
toolkill.Unequipped:connect(function()
_G.targetkill:Disconnect()
killhigh.Parent = game.ReplicatedFirst
end)
toolkill.Activated:connect(function()
for i,v in pairs(game.Players:GetPlayers()) do
if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("KillHighlight") then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 15, v.Character.HumanoidRootPart, CFrame.new(0, math.huge, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 15, v.Character.HumanoidRootPart, CFrame.new(0, math.huge, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 15, v.Character.HumanoidRootPart, CFrame.new(0, math.huge, 0))
    end
end
end
end)
if game.ReplicatedFirst:FindFirstChild("FlingHighlight") then
    game.ReplicatedFirst:FindFirstChild("FlingHighlight"):Destroy()
else
for i, v in pairs(workspace:GetDescendants()) do
    if v.Name == "FlingHighlight" then
        v:Destroy()
    end
end
end
local flinghigh = Instance.new("Highlight", game.ReplicatedFirst)
flinghigh.Name = "FlingHighlight"
flinghigh.OutlineColor = Color3.fromRGB(255, 0, 0)
flinghigh.OutlineTransparency = 1
flinghigh.FillTransparency = 0.5

toolfling = Instance.new("Tool")
toolfling.RequiresHandle = false
toolfling.Name = "Fling Player Tool"
toolfling.Parent = game.Players.LocalPlayer.Backpack
toolfling.Equipped:connect(function()
_G.targetfling = game:GetService("RunService").RenderStepped:Connect(function()
if game.Players.LocalPlayer:GetMouse().Target then
    local model = game.Players.LocalPlayer:GetMouse().Target:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChild("Humanoid") and model:FindFirstChild("DisplayName") then
        flinghigh.Parent = model
    else
        flinghigh.Parent = game.ReplicatedFirst
    end
end
end)
end)
toolfling.Unequipped:connect(function()
_G.targetfling:Disconnect()
flinghigh.Parent = game.ReplicatedFirst
end)
toolfling.Activated:connect(function()
for i,v in pairs(game.Players:GetPlayers()) do
if v.Character ~= nil and v.Character:FindFirstChild("LeftHand") and v.Character:FindFirstChild("FlingHighlight") then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game.ReplicatedStorage.Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 7, v.Character.LeftHand, v.Character.HumanoidRootPart.CFrame * CFrame.new(10, 5, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 7, v.Character.LeftHand, v.Character.HumanoidRootPart.CFrame * CFrame.new(10, 5, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Back, 7, v.Character.LeftHand, v.Character.HumanoidRootPart.CFrame * CFrame.new(10, 5, 0))
    end
end
end
end)

toolgod = Instance.new("Tool")
toolgod.RequiresHandle = false
toolgod.Name = "Ghost Yourself Tool"
toolgod.Parent = game.Players.LocalPlayer.Backpack
toolgod.Activated:connect(function()
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Bottom,
    [3] = 6.331,
    [4] = game.Players.LocalPlayer.Character.HumanoidRootPart,
    [5] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10010, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
if game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight") then
    game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight"):Destroy()
end
		local localgod = Instance.new("Highlight", game.Players.LocalPlayer.Character)
        localgod.Name = "LocalGod_Highlight"
        localgod.FillColor = Color3.fromRGB(255, 215, 0)
        localgod.OutlineTransparency = 1
        localgod.FillTransparency = 0.65
wait(16.1)
        if localgod then
        localgod:Destroy()
        end
end)

toolungod = Instance.new("Tool")
toolungod.RequiresHandle = false
toolungod.Name = "UnGhost Yourself Tool"
toolungod.Parent = game.Players.LocalPlayer.Backpack
toolungod.Activated:connect(function()
if game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight") then
game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight"):Destroy()
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Bottom,
    [3] = 6.331,
    [4] = game.Players.LocalPlayer.Character.HumanoidRootPart,
    [5] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end)
end
end)
 
Sprayfunc:CreateTextbox("(Shift-Apply) Username", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
 
applyfling = 1
Sprayfunc:CreateSlider("Fling Strength", 1, 15, 1, false, function(flingstr)
    applyfling = flingstr
end)
 
Sprayfunc:CreateButton("Fling [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil and game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character:FindFirstChild("LeftHand") then
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Back,
    [3] = applyfling,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftHand,
    [5] = CFrame.new(0, 0, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
    end
    end
end)
 
Sprayfunc:CreateButton("Destroy [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil and game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character:FindFirstChild("HumanoidRootPart") then
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
    end
    end
end)
 
Sprayfunc:CreateButton("Ghost [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Bottom,
    [3] = 6.331,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame * CFrame.new(0, 10010, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
    end
    end
if game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text == game.Players.LocalPlayer.Name then
if game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight") then
    game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight"):Destroy()
end
		local localgod = Instance.new("Highlight", game.Players.LocalPlayer.Character)
        localgod.Name = "LocalGod_Highlight"
        localgod.FillColor = Color3.fromRGB(255, 215, 0)
        localgod.OutlineTransparency = 1
        localgod.FillTransparency = 0.65
wait(16.1)
        if localgod then
        localgod:Destroy()
        end
end
end)

Sprayfunc:CreateButton("Unghost yourself", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight") then
game.Players.LocalPlayer.Character:FindFirstChild("LocalGod_Highlight"):Destroy()
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Bottom,
    [3] = 6.331,
    [4] = game.Players.LocalPlayer.Character.HumanoidRootPart,
    [5] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
 
Sprayfunc:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplr = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplr:Disconnect()
end
end)
 
Sprayfunc:CreateButton("Fling All", function()
if game.Players.LocalPlayer.Character ~= nil then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("LeftHand") then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = applyfling,
    [4] = workspace[v.Name].LeftHand,
    [5] = CFrame.new(0, 0, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end
end)
 
Sprayfunc:CreateButton("Destroy All", function()
if game.Players.LocalPlayer.Character ~= nil then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[v.Name].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end
end)
 
Sprayfun:CreateButton("Minecraft Blocks", function()
if game.Players.LocalPlayer.Character ~= nil then
local mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Grass Block"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267183944, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267089525, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267183944, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267089525, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267183944, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267089525, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9267155990, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Oak Planks"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9359126658, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Cobblestone"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12616185407, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Stone"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(3162897225, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Diamond Ore"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(11425623081, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Diamond Block"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(4786858334, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position) * CFrame.new(-1.65, 1.65, 0))
    end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
 
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Lava (Kills)"
tool.Activated:connect(function()
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        local savepos = game.Players.LocalPlayer:GetMouse().Hit
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
local killpart = Instance.new("Part")
killpart.Name = "(Lava Visual Script) kill part"
killpart.Anchored = true
killpart.Size = Vector3.new(1, 1, 1)
killpart.Color = Color3.new(255, 0, 0)
killpart.Transparency = 0.5
killpart.CanCollide = false
killpart.Parent = workspace:FindFirstChild("KillpartsVisual")
killpart.CFrame = savepos + Vector3.new(0, 1.75, 0)
wait(15)
killpart:Destroy()
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        local savepos = game.Players.LocalPlayer:GetMouse().Hit
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(-1.65, 1.65, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
local killpart = Instance.new("Part")
killpart.Name = "(Lava Visual Script) kill part"
killpart.Anchored = true
killpart.Size = Vector3.new(1, 1, 1)
killpart.Color = Color3.new(255, 0, 0)
killpart.Transparency = 0.5
killpart.CanCollide = false
killpart.Parent = workspace:FindFirstChild("KillpartsVisual")
killpart.CFrame = savepos + Vector3.new(0, 1.75, 0)
wait(15)
killpart:Destroy()
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
    local savepos = game.Players.LocalPlayer:GetMouse().Hit
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Top, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 3.3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Bottom, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 0, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Back, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, 1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Front, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(0, 1.65, -1.65))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Right, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(1.65, 1.65, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9886286740, Enum.NormalId.Left, 3.5, workspace.Lobby.VoteIcons.VotePad2, CFrame.new(savepos.Position) * CFrame.new(-1.65, 1.65, 0))
local killpart = Instance.new("Part")
killpart.Name = "(Lava Visual Script) kill part"
killpart.Anchored = true
killpart.Size = Vector3.new(1, 1, 1)
killpart.Color = Color3.new(255, 0, 0)
killpart.Transparency = 0.5
killpart.CanCollide = false
killpart.Parent = workspace:FindFirstChild("KillpartsVisual")
killpart.CFrame = savepos + Vector3.new(0, 1.75, 0)
wait(15)
killpart:Destroy()
end
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end
end)
 
Sprayfun:CreateToggle("Lava Block Working", function(lava)
if lava then
_G.lavag = game:GetService("RunService").RenderStepped:Connect(function()
for i, p in pairs(workspace:FindFirstChild("KillpartsVisual"):GetDescendants()) do
if p.Name == "(Lava Visual Script) kill part" then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v ~= game.Players:FindFirstChild("corkscrew2L") and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-p.Position).Magnitude <= 3.6 then
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[v.Name].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end
end
end)
else
_G.lavag:Disconnect()
end
end)
 
Sprayfun:CreateTextbox("(Shift-Apply) Username", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
 
Ssprayid = 60484593
Sprayfun:CreateTextbox("(Shift-Apply) Decal Id", function(sprayid)
    Ssprayid = sprayid
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Decal Loaded",
    Duration = 2
})
end)
 
Sprayfun:CreateButton("(ID) Box [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
end
    end
    end
end)
 
Sprayfun:CreateButton("(ID) Pool [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 2048, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 2048, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 2048, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
        end
    end
    end
end)

Sprayfun:CreateButton("Ice Slip [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].RightUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Top, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Bottom, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].RightUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Top, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Bottom, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.85, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        local posofpl = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(0, Enum.NormalId.Top, 6.331, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].RightUpperLeg, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].LeftUpperLeg.CFrame * CFrame.new(0, -1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Top, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(7199393435, Enum.NormalId.Bottom, 3.5, workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart, posofpl * CFrame.new(0, -2.85, 0))
        end
    end
    end
end)

Sprayfun:CreateButton("Enis [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
targhumpart = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text).Character.HumanoidRootPart
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -10.15))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -10.15))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -2.9, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -0.6, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(3.65, -1.75, -2))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -3.15))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Back, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-2.5, -1.75, -0.85))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -4.5))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(9418596904, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -6.75))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Left, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(-1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Right, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(1.15, -1.75, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Top, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -0.6, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Bottom, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -2.9, -9))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2.5, targhumpart, targhumpart.CFrame * CFrame.new(0, -1.75, -10.15))
    end
end
end
end)
 
Sprayfun:CreateButton("Old Germany Flag [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        local humofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart
        local posofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))

game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        local humofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart
        local posofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))

game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
        end
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        local humofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart
        local posofplr = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
        if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Front, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))

game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(12781220539, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 4, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(1302869037, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(6, 16, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 18, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(0, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(2, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(4, 2, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(8, 14, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 6, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 10, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 12, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(14033250886, Enum.NormalId.Back, 2, humofplr, posofplr * CFrame.new(-8, 14, 0))
        end
    end
    end
end)
 
Sprayfun:CreateButton("(ID) Box All", function()
if game.Players.LocalPlayer.Character ~= nil then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        local posofpl = workspace[v.Name].HumanoidRootPart.CFrame
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        local posofpl = workspace[v.Name].HumanoidRootPart.CFrame
game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        local posofpl = workspace[v.Name].HumanoidRootPart.CFrame
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 3.15, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Bottom, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -2.8, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Top, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, -3, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, 2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Front, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -2.86))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Back, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(0, 0.1, -3.1))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(2.86, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Right, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-3.1, 0.1, 0))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(Ssprayid, Enum.NormalId.Left, 6, workspace[v.Name].HumanoidRootPart, posofpl * CFrame.new(-2.86, 0.1, 0))
end
end
end
end
end)

lagstrength = 3000
Sprayfun:CreateSlider("Lag Strength", 500, 3000, 3000, false, function(lagstr)
    lagstrength = lagstr
end)

Sprayfun:CreateButton("Lag Players", function()
if game.Players.LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
end
if game.Players.LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
game.Players.LocalPlayer.Backpack.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Character
end
if game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Lagging Players with "..lagstrength.." strength",
    Duration = 2
})
game:GetService("ReplicatedStorage").Remotes.Inventory.Equip:FireServer("Shaded", "Weapons")
for i = 1, lagstrength do
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(-666, Enum.NormalId.Top, 5, game.Players.LocalPlayer.Character.KnifeDisplay, game.Players.LocalPlayer.Character.KnifeDisplay.CFrame)
end
game:GetService("ReplicatedStorage").Remotes.Inventory.Equip:FireServer("DefaultKnife", "Weapons")
game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
end
end)

Sprayfun:CreateButton("Fake Knife [User]", function()
if game.Players.LocalPlayer.Character ~= nil then
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
		game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15093138669, Enum.NormalId.Right, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15096522641, Enum.NormalId.Left, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15093138669, Enum.NormalId.Right, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15096522641, Enum.NormalId.Left, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15093138669, Enum.NormalId.Right, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(15096522641, Enum.NormalId.Left, 3, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand, game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character.RightHand.CFrame * CFrame.new(0, 0, -0.7))
    end
end
end)
 
Sprayfun:CreateTextbox("(Shift-Apply) Username2", function(plrbear)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)Username2TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrbear))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
 
killitems = "Pizza"
Sprayfun:CreateDropdown("Choose Item", {"Pizza-killer", "FakeBomb-killer", "Teddy-killer", "GGSign-killer"}, 1, function(item)
if item == "Pizza-killer" then
killitems = "Pizza"
elseif item == "FakeBomb-killer" then
killitems = "FakeBomb"
elseif item == "Teddy-killer" then
killitems = "Teddy"
elseif item == "GGSign-killer" then
killitems = "GGSign"
end
end)
 
applyrangebear = 5
Sprayfun:CreateSlider("Item-killers Reach", 5, 20, 5, false, function(rangebear)
    applyrangebear = rangebear
end)
 
Sprayfun:CreateToggle("Item-killers [User]", function(hungryb)
if hungryb then
local owner = game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.SprayPaintFunSection["(Shift-Apply)Username2TextBoxHolder"].TextBox.Text
local protect = game.Players.LocalPlayer.Name
_G.superted2 = game:GetService("RunService").RenderStepped:Connect(function()
if game.Players:FindFirstChild(owner) and game.Players:FindFirstChild(owner).Character ~= nil and game.Players:FindFirstChild(owner).Character:FindFirstChild(killitems) then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players:FindFirstChild(owner) and v ~= game.Players:FindFirstChild(protect) and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-game.Players:FindFirstChild(owner).Character:FindFirstChild("HumanoidRootPart").Position).Magnitude <= applyrangebear then
local args = {
    [1] = 0,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[v.Name].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
    end
    end
end
end)
else
_G.superted2:Disconnect()
end
end)
 
Trapfunc:CreateTextbox("(Shift-Apply) Username", function(plrtrap)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.TrapPerkModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrtrap))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
 
Trapfunc:CreateButton("Trap [User]", function()
if game.Players[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.TrapPerkModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].Character ~= nil then
local plrpos = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.TrapPerkModsSection["(Shift-Apply)UsernameTextBoxHolder"].TextBox.Text].HumanoidRootPart.CFrame
game:GetService("ReplicatedStorage").TrapSystem.PlaceTrap:InvokeServer(plrpos)
end
end)
 
Trapfunc:CreateButton("Trap all", function()
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
local plrallpos = workspace[v.Name].HumanoidRootPart.CFrame
game:GetService("ReplicatedStorage").TrapSystem.PlaceTrap:InvokeServer(plrallpos)
end
end
end)
 
Trapfunc:CreateButton("Trap Tool", function()
if game.Players.LocalPlayer.Character ~= nil then
local mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Place Traps"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,0,0)
game:GetService("ReplicatedStorage").TrapSystem.PlaceTrap:InvokeServer(pos)
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end
end)
 
Gunfunc:CreateButton("Create Fake Gun", function()
if game.Players.LocalPlayer.Character ~= nil then
game:GetService("ReplicatedStorage").Remotes.Gameplay.FakeGun:FireServer(true)
end
end)
 
Gunfunc:CreateToggle("Create Fake Guns", function(autogun)
if autogun then
Aautogun = true
while Aautogun == true do
if game.Players.LocalPlayer.Character ~= nil then
game:GetService("ReplicatedStorage").Remotes.Gameplay.FakeGun:FireServer(true)
wait(0.075)
end
end
else
Aautogun = false
end
end)

Gunfunc:CreateButton("Anti Fake Lag", function()
for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if v.Name == "LugerChroma" then
		if v:FindFirstChild("Handle"):FindFirstChild("Chroma") then
			v.Handle:FindFirstChild("Chroma"):Destroy()
		end
		if v:FindFirstChild("Handle"):FindFirstChild("Mesh") then
			v.Handle:FindFirstChild("Mesh"):Destroy()
		end
		if v:FindFirstChild("Handle").Transparency == 0 then
			v.Handle.Transparency = 1
			v.GripPos = Vector3.new(0, -5, 0)
		end
    end
end
end)

Gunfunc:CreateButton("Anti Fake Lag 2", function()
for i, v in pairs(workspace:GetDescendants()) do
    if v.Name == "LugerChroma" then
		if v:FindFirstChild("Handle"):FindFirstChild("Mesh") then
			v:FindFirstChild("Handle"):FindFirstChild("Chroma"):Destroy()
			v:FindFirstChild("Handle"):FindFirstChild("Mesh"):Destroy()
		end
    end
end
for i, v in pairs(game.Players:GetPlayers()) do
    if v.Backpack:FindFirstChild("LugerChroma") then
		if v.Backpack:FindFirstChild("LugerChroma"):FindFirstChild("Handle"):FindFirstChild("Chroma") then
			v.Backpack:FindFirstChild("LugerChroma").Handle:FindFirstChild("Chroma"):Destroy()
		end
		if v.Backpack:FindFirstChild("LugerChroma"):FindFirstChild("Handle"):FindFirstChild("Mesh") then
			v.Backpack:FindFirstChild("LugerChroma").Handle:FindFirstChild("Mesh"):Destroy()
		end
    end
end
end)

Gunfunc:CreateButton("Clear Fake Guns", function()
if game.Players.LocalPlayer.Character ~= nil then
for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	if v.Name == "LugerChroma" then
		v:Destroy()
	end
end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetDescendants()) do
	if v.Name == "LugerChroma" then
		v:Destroy()
	end
end
end
end)
 
Stealthfunc:CreateToggle("Invisible", function(invis)
if invis then
    if game.Players.LocalPlayer.Character ~= nil then
game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
    end
else
    if game.Players.LocalPlayer.Character ~= nil then  
game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
    end
end
end)
 
Opti:CreateToggle("Anti Display/Pet", function(antidp)
if antidp then
_G.antidisplaypet = game:GetService("RunService").RenderStepped:Connect(function()
for i, v in pairs(game.Players:GetPlayers()) do
    if v.Character ~= nil and v.Character:FindFirstChild("GunDisplay") then
        v.Character:FindFirstChild("GunDisplay"):Destroy()
    elseif v.Character ~= nil and v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("KnifeDisplay") then
        v.Character:FindFirstChild("KnifeDisplay"):Destroy()
	end
    if v.Character ~= nil and v.Character:FindFirstChild("Pet") then
        v.Character:FindFirstChild("Pet"):Destroy()
	end
end
end)
else
_G.antidisplaypet:Disconnect()
end
end)

Opti:CreateToggle("Anti Chroma Tool", function(antir)
if antir then
_G.antirealchroma = game:GetService("RunService").RenderStepped:Connect(function()
for i, v in pairs(game.Players:GetPlayers()) do
	if v.Character:FindFirstChild("Knife"):FindFirstChild("Handle"):FindFirstChild("Chroma") then
		v.Character:FindFirstChild("Knife"):FindFirstChild("Handle"):FindFirstChild("Chroma"):Destroy()
	elseif v.Character:FindFirstChild("Gun"):FindFirstChild("Handle"):FindFirstChild("Chroma") then
		v.Character:FindFirstChild("Gun"):FindFirstChild("Handle"):FindFirstChild("Chroma"):Destroy()
	end
end
end)
else
_G.antirealchroma:Disconnect()
end
end)
 
Opti:CreateToggle("Anti Spray", function(antisumlags)
if antisumlags then
_G.antisumlags = game:GetService("RunService").RenderStepped:Connect(function()
if workspace:FindFirstChild("Spray") then
for _, v in pairs(workspace:GetDescendants()) do
    if v.Name == "Spray" then
        v:Destroy()
    end
end
end
end)
else
_G.antisumlags:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username1", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username1TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username1TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username1TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username2", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username2TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm2 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username2TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username2TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
		game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm2:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username3", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username3TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm3 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username3TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username3TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm3:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username4", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username4TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm4 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username4TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username4TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm4:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username5", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username5TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm5 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username5TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username5TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm5:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username6", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username6TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm6 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username6TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username6TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm6:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username7", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username7TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm7 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username7TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username7TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm7:Disconnect()
end
end)
 
Multi:CreateTextbox("(Shift-Apply) Username8", function(plrspray)
game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username8TextBoxHolder"].TextBox.Text = tostring(UserFromBox(plrspray))
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Full Player Name Added",
    Duration = 2
})
end)
Multi:CreateToggle("Crash/Lag [User]", function(lagdest)
if lagdest then
_G.lagplrm8 = game:GetService("RunService").RenderStepped:Connect(function()
local p = game.Players:FindFirstChild(game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username8TextBoxHolder"].TextBox.Text)
if p and p.Character ~= nil or p.CharacterAdded:wait() and p.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character ~= nil then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[game:GetService("CoreGui").WizardLibrary.Container.MM2ModsWindow.Body.MultiCrashSection["(Shift-Apply)Username8TextBoxHolder"].TextBox.Text].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
end
end
end)
else
_G.lagplrm8:Disconnect()
end
end)

fendround = false
foldgod = false
finvisp = false
Farm:CreateToggle("On Full End Round", function(endround)
if endround then
    fendround = true
    game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Enabled. Waiting for the next round to start",
    Duration = 2
    })
else
    fendround = false
end
end)

Farm:CreateToggle("Old God Mode", function(oldgod)
if oldgod then
    foldgod = true
else
    foldgod = false
end
end)

Farm:CreateToggle("Invisible Perk", function(invisp)
if invisp then
    finvisp = true
else
    finvisp = false
end
end)

game:GetService("ReplicatedStorage").Remotes.Gameplay.Fade.OnClientEvent:Connect(function()
if seedeadchat == true then
task.wait(0.5)
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/join dead", "normalchat")
end
if fendround == true then
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
wait(1)
if foldgod == true then
loadstring(game:HttpGet("https://pastebin.com/raw/FwfNEqYz", true))()
end
if finvisp == true then
game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(true)
end
wait(16.5)
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true or game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == false
wait(1)
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= game.Players.LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") then
local args = {
    [1] = 80373024,
    [2] = Enum.NormalId.Back,
    [3] = 15,
    [4] = workspace[v.Name].HumanoidRootPart,
    [5] = CFrame.new(0, math.huge, 0)
}
    if game:GetService("Players").LocalPlayer.Backpack.Toys:FindFirstChild("SprayPaint") then
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer("SprayPaint")
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Backpack.SprayPaint.Parent = game.Players.LocalPlayer.Character
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
        game.Players.LocalPlayer.Character.SprayPaint.Parent = game:GetService("Players").LocalPlayer.Backpack
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("SprayPaint") then
        game:GetService("Players").LocalPlayer.Character.SprayPaint.Remote:FireServer(unpack(args))
    end
    end
end
end
end)
game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade.OnClientEvent:Connect(function()
if finvisp == true then
game:GetService("ReplicatedStorage").Remotes.Gameplay.Stealth:FireServer(false)
end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
if input.KeyCode == Enum.KeyCode.Tab then
    if game:GetService("CoreGui").WizardLibrary.Container.Visible == true then
    game:GetService("CoreGui").WizardLibrary.Container.Visible = false
    elseif game:GetService("CoreGui").WizardLibrary.Container.Visible == false then
    game:GetService("CoreGui").WizardLibrary.Container.Visible = true
    end
end

if input.KeyCode == Enum.KeyCode.M then
if gunshot == true then
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Character ~= nil and v.Character:FindFirstChild("Gun") then
        v.Character.Gun.KnifeServer.ShootGun:InvokeServer(1, game.Players.LocalPlayer:GetMouse().Hit.Position, "AH")
    end
end
end
end

if input.KeyCode == Enum.KeyCode.C then
if knifethrow == true then
if game.Players.LocalPlayer.Character:FindFirstChild("Knife") then
game:GetService("Players").LocalPlayer.Character.Knife.Throw:FireServer(CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position), game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") then
game:GetService("Players").LocalPlayer.Backpack.Knife.Throw:FireServer(CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position), game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
end
end
end
end)
 
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Loaded. Last Update: 11.02.2024.",
    Duration = 2
})
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MM2 Mods",
	Text = "Press Tab to Close/Open GUI.",
    Duration = 2
})