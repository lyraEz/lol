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

 
 local HubsTab = Window:CreateTab("Murder Mystery 2 ", 4483362458) 
 local Button = HubsTab:CreateButton({
	Name = " Symphony Hub| MM2",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/ThatSick/ArrayField/main/SymphonyHub.lua'))()
    end,
 })
 local Button = HubsTab:CreateButton({
	Name = " highlight Hub",
	Callback = function()
	Rayfield:Notify({
   Title = "Key copied from you clipboard",
   Content = "Have a good time",
   Duration = 1.5,
   Image = 4483362458,
   Actions = { --
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("chead")
      end
   },
},
})
		setclipboard("hlvipcomingsoon")
    end,
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSick/HighlightMM2/main/Main"))()
 })
local Button = HubsTab:CreateButton({
		Name = " Nexus Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/loadstring"))()
		end,
	})
local Button = Hubstab:CreateButton({
		name = " Yarm Hub"
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YARHM-12403"))()
		end,
})

 local HubsTab = Window:CreateTab("Blade ball ", 4483362458) 
     local Button = HubsTab:CreateButton({
    Name = " Bedol Hub | key",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/nqxlOfc/Loaders/main/Blade_Ball.lua'))() -- The function that takes place when the button is pressed
    end,
 }) 
 local Button = HubsTab:CreateButton({
	Name = " Redz Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
    end,
 })
local Button = HubsTab:CreateButton({
		Name = " Visual Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0aefed07fd25b2369e282001ca3c2838.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		name = " Gosse Hub"
		Callback =function()
			loadstring(game:HttpGet("https://scriptblox.com/raw/Blade-Ball-CLASSIC-Goose-Hub-13438"))()
		end,
	})

 local ExpTab = Window:CreateTab("Experimental ") 
local Paragraph = ExpTab:CreateParagraph({Title = "Dev Note", Content = "Experimental features it can crash your game."})
local Paragraph = ExpTab:CreateParagraph({Title = "Note", Content = "Hitbox + Esp is universal"})

 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot fov circle (without hub)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/chead-z/lol/main/aimbot%20fov%20circle.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot pc and mobile Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/chead-z/lol/main/Darkcheat%20aimbot.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Shizukii Hitbox + Esp",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/chead-z/lol/main/hitbox%20esp"))()
    end,
 })
local Button = ExpTab:CreateButton({
	Name = " Shizukii MM2 fun features 🤓",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/chead-z/lol/main/MM2fun.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = "Stretch Resolution ",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ySixxNz/SIXHUB-UNIVERSAL/SixHub-Universal/SixHub-Universal"))()
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
