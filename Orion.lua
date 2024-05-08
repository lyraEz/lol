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
	Callback = function(loadstring(game:HttpGet("https://raw.githubusercontent.com/RedWirePlatinumTwo/RobloxScripts/main/Aimbot.lua"))())
      		print()
  	end    
})


local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://11583101826",
	PremiumOnly = false
})
