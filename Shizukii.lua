local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Shizukii Hub V2 ",
    LoadingTitle = "Shizukii Hub V2  is loading..",
    LoadingSubtitle = "By chead.y and you! ",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = Shizukii, -- Create a custom folder for your hub/game
       FileName = "Shizukii Hub"
    },
    Discord = {
       Enabled = true,
       Invite = "yuaN9bG8Mm",
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 })
 Rayfield:Notify({
   Title = "Warning!",
   Content = "Some of these script may crash your game or won't work. Thank you for using the hub",
   Duration = 2.5,
   Image = 4483362458,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user Replied, Okay!")
      end
   },
},
})


warn("Please Support me i put alot of efforts in this.")
warn("<3")
 
 
 local HubsTab = Window:CreateTab("Murder Mystery 2 📜", 4483362458) 
local Button = HubsTab:CreateButton({
	Name = " Overdrive-H Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/Overdriver-H%20Hub.lua"))()
    end,
 })
 local Button = HubsTab:CreateButton({
	Name = " Symphony Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/ThatSick/ArrayField/main/SymphonyHub.lua'))()
    end,
 })
 local Button = HubsTab:CreateButton({
	Name = " eclipse Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/lol/main/loaders/eclios.lua'))()
    end,
 })
 local Button = HubsTab:CreateButton({
    Name = " highlight Hub",
    Callback = function()
        setclipboard("hlvipcomingsoon")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSick/HighlightMM2/main/Main"))()
    end
})
local Button = HubsTab:CreateButton({
		Name = " Nexus Hub",
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-MurderMystery2-Best-script-nexus-hub-no-key-15580"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Yarhm Hub",
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YARHM-12403"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " GG Hub",
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-GG-HUB-15602"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = "🔴 MM2 fun features🤓",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/MM2fun.lua"))()
		end,
	})

local HubsTab = Window:CreateTab("Blade ball 📜", 4483362458) 
     local Button = HubsTab:CreateButton({
    Name = " Bedol Hub | key",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/nqxlOfc/Loaders/main/Blade_Ball.lua'))() -- The function that takes place when the button is pressed
    end,
 }) 
local Button = HubsTab:CreateButton({
		Name = " Astra Hub",
		Callback = function()
			getgenv().Auth = "freenium_auth"
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b6cc646cf4d4eb44647236da9b7fa2f0.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Nexam Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/6af56c1753ac6679dee3acbd1fd952e5.lua"))()
		end,
	})
local HubsTab = Window:CreateTab("flee the facility  📜", 4483362458)
local Button = HubsTab:CreateButton({
		Name = " Yarhm Hub",
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YARHM-12403"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Simple Hub",
		Callback = function()
			loadstring(game:HttpGet('https://rentry.co/9uqkr/raw'))()
		end,
	})
 local ExpTab = Window:CreateTab("Experimental ") 
local Paragraph = ExpTab:CreateParagraph({Title = "Dev Note", Content = "Experimental features it can crash your game."})
local Paragraph = ExpTab:CreateParagraph({Title = "Note", Content = "All scripts is universal"})

 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot fov circle (without hub)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/aimbot%20fov%20circle.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot pc and mobile Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/darkcheat%20aimbot.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Shizukii Hitbox + Esp",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/hitbox.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Stretch Resolution",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ySixxNz/SIXHUB-UNIVERSAL/SixHub-Universal/SixHub-Universal"))()
    end,
 })
local Button = ExpTab:CreateButton({
	Name = " Hide Fluxus icon",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/Hide%20fluxus.lua"))()
    end,
 })
local Button = ExpTab:CreateButton({
	Name = "🔴 Stretch Resolution",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/loaders/resolution.lua"))()
    end,
 })
local SupportTab = Window:CreateTab("Support Us!", 4483362458) 
local Paragraph = SupportTab:CreateParagraph({Title = "Please paste one of these links in you browser", Content = "Follow us on Github or join our server will helps alot!"})
local Paragraph = SupportTab:CreateParagraph({Title = "Request script ", Content = "If you want a specific script on Shizukii, ask on our server or in my DM!"})

 local Button = SupportTab:CreateButton({
	Name = "🖤 Chead.y Dev Github",
	Callback = function()
 Rayfield:Notify({
   Title = "Notify",
   Content = "The link has been copied to you clipboard!",
   Duration = 6.5,
   Image = 4483362458,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})
		setclipboard("https://github.com/chead.y")
    end,
 })


 local Button = SupportTab:CreateButton({
	Name = "✔️ Shizukii Discord Server",
	Callback = function()
 Rayfield:Notify({
   Title = "Notify",
   Content = "The link has been copied to you clipboard!",
   Duration = 6.5,
   Image = 4483362458,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("chead")
      end
   },
},
})
		setclipboard("https://discord.gg/yuaN9bG8Mm")
    end,
 })
