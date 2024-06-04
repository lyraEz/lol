local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
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
   Title = "Welcome to Shizukii Hub v2",
   Content = "Much Love ❤️. - Chead.y",
   Duration = 6.5,
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
 Rayfield:Notify({
	Title = "Notification",
	Content = "Hey! Thanks for choosing Shizukii Hub, I put lots of efforts in this. Enjoy!",
	Duration = 6.5,
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
 Rayfield:Notify({
   Title = "Warning!",
   Content = "Some of these script may crash your game or won't work. Thank you for using the hub",
   Duration = 6.5,
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

  local RandomTab = Window:CreateTab("Main Scripts 📜", 4483362458) 
   local HubsTab = Window:CreateTab("2nd Scripts Tab📜", 4483362458) 
 local ExpTab = Window:CreateTab("Experimental ") 
 local SupportTab = Window:CreateTab("Support Us!", 4483362458) 
 local CreditTab = Window:CreateTab("Credits", 4483362458)
 local ChangeTab = Window:CreateTab("Changelogs", 4483362458) 



local Paragraph = ExpTab:CreateParagraph({Title = "Dev Note", Content = "Experimental features it can crash your game."})
local Paragraph = ExpTab:CreateParagraph({Title = "Note", Content = "Hitbox + Esp is universal"})

 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot Mobile",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RedWirePlatinumTwo/RobloxScripts/main/Aimbot.lua"))()
    end,
 })
 local Button = ExpTab:CreateButton({
	Name = " Shizukii Aimbot pc",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/chead-z/lol/main/circle%20aim"))()
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



local Paragraph = CreditTab:CreateParagraph({Title = "Creator", Content = "By chead"})

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

local Paragraph = CreditTab:CreateParagraph({Title = "Special Thanks to:", Content = ""})

local Paragraph = CreditTab:CreateParagraph({Title = "Cherry", Content = "Testing script!"})

local Paragraph = CreditTab:CreateParagraph({Title = "Ui lib", Content = "Supporting!"})

local Paragraph = CreditTab:CreateParagraph({Title = "Dudyn", Content = "Release part py"})

local Paragraph = CreditTab:CreateParagraph({Title = "tskz", Content = "Unknown..."})
 


 local Button = HubsTab:CreateButton({
	Name = " R3THPRIV Hub | MM2",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/R3TH-PRIV/R3THPRIV/main/loader.lua'))()
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
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSick/HighlightMM2/main/Main"))()
    end,
		setclipboard("hlontop")
 })

     local Button = HubsTab:CreateButton({
    Name = " Bedol Hub | key",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/nqxlOfc/Loaders/main/Blade_Ball.lua'))() -- The function that takes place when the button is pressed
    end,
 })
     local Button = HubsTab:CreateButton({
    Name = " Dark Cheat | MM2",
    Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ECCeYtXA"))() -- The function that takes place when the button is pressed
    end,
 })
local Button = HubsTab:CreateButton({
	Name = " Da Hood Hub's",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/svan1lol/svanhub/main/svanhubdahood.lua", true))()
    end,
 })


 local Button = RandomTab:CreateButton({
	Name = " Redz Hub | blox fruits ",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Luarmor Hub",
	Callback = function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Miojo Hub (key)",
	Callback = function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/sumidassz/miojoHub/main/hub.lua", true))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Vecto Hub (key)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AAwful/VectorHub/main/Loader.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Yutv Hub (key)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AAwful/VectorHub/main/Loader.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Ry's Evade Gui",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/Script-Storages/main/Evade%20Gui.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Car Dealership Tycoon",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/car%20dealer", true))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " W-azure Hub",
	Callback = function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Break In Story | OP",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/Script-Storages/main/Break%20In%20Story.lua"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Muscle Legends | V.G",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/Atlas_hub/main/Muscle-Legends.txt"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " VAPE v4 | Bedwars",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/Script-Storages/main/VAPE%20V4%20%5Bbedwar%5D"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Arsenal Scripts | 2 Hubs included",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/test/main/Arsenal%20scripts1"))()
    end,
 })
 local Button = RandomTab:CreateButton({
	Name = " Vynixu Scripts | Doors",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RyAtlasX/test/main/Doors2"))()
    end,
 })
 
 local Button = HubsTab:CreateButton({
	Name = " Stretch Resolution",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ySixxNz/SIXHUB-UNIVERSAL/SixHub-Universal/SixHub-Universal"))()
    end,
 })

 local Button = HubsTab:CreateButton({
	Name = " Ez Hub",
	Callback = function()
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Ez%20Hub.txt"))()
    end,
 })
local Button = HubsTab:CreateButton({
		Name = " Visual Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0aefed07fd25b2369e282001ca3c2838.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Nexus Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/s-o-a-b/nexus/main/loadstring"))()
		end,
	})

local Paragraph = ChangeTab:CreateParagraph({Title = "Release v1.1", Content = "The Rayfield version of Shizukii Hub is here!"})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.2", Content = "Added selections, more script hubs, more scripts."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.3", Content = "Added more scripts and animation is fixed, And more..."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.4.4", Content = "Added Infamy script, Legend of speed back to the Shizukii hub, moved Solar to Utilites selection."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.5", Content = "Added Symphony and Eclipse Hub."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.6", Content = "Added Energize Animation Gui."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.7.2", Content = "Added Owlhub, Ez hub, Muscle Legends script."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.8", Content = "Added Support Tab, Credits Tab."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Demo v1.9", Content = "Changed somethings in 'Support Us!' tab"})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v1.9.2", Content = "Added Experiment Tab."})
local Paragraph = ChangeTab:CreateParagraph({Title = "Update v2", Content = "Huge Update! Renamed 'Random Scripts' to '2nd Scripts Tab'. added much new scripts! and more decorations! Made the buttons more specific! And More!!!."})
