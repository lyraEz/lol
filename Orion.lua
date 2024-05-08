local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/thanhdat4461/OrionMoblie/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Shizukii Premium", HidePremium = false, SaveConfig = true, ConfigFolder = "Shizukii Loader"})

local Tab = Window:MakeTab({
	Name = "Main Scripts ",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Universal Scripts"
})
Tab:AddButton({
	Name = "Aimbot Pc + Mobile",
	Callback = function()
      		print(loadstring(game:HttpGet('https://raw.githubusercontent.com/pcallskeleton/CE-Technologies/main/script', true))())
  	end    
})


local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Tab:AddSlider({
	Name = "Resolution Stretcher",
	Min = 0.2,
	Max = 10,
	Default = 1,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Default 1",
	Callback = function(Value)
		print(ew Raw
Edited By: flownexploitss

Copy Script
Download
getgenv().Resolution = {
    [".gg/scripters"] = 
}

local Camera = workspace.CurrentCamera
if getgenv().gg_scripters == nil then
    game:GetService("RunService").RenderStepped:Connect(
        function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
        end
    )
end
getgenv().gg_scripters = "Aori0001")
	end    
})
