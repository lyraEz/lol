local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Shizukii Hub V2 ",
    LoadingTitle = "Shizukii Hub V2  is loading..",
    LoadingSubtitle = "By chead.y ",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = Shizukii, -- Create a custom folder for your hub/game
       FileName = "Shizukii Hub"
    },
    Discord = {
       Enabled = true,
       Invite = "FA3eVAdtfw",
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 })
 Rayfield:Notify({
   Title = "Warning!",
   Content = "Some of these script may crash your game or won't work. Thank you for using the hub",
   Duration = 1,
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
	Name = " Eclipse Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/lol/main/loaders/eclios.lua'))()
    end,
 })
local Button = HubsTab:CreateButton({
		Name = " Shizukii Hub",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/lol/main/loaders/shizukii%20mm2.lua'))()
		end,
})
 local Button = HubsTab:CreateButton({
    Name = " Highlight Hub",
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

local HubsTab = Window:CreateTab("Blade Ball 📜", 4483362458) 
     local Button = HubsTab:CreateButton({
    Name = " DungKee Hub",
    Callback = function()
			xpcall(function()
loadstring(game:HttpGet("https://github.com/Stang001/pulawat/blob/main/BladeBall.lua?raw=true"))()
end,function()
warn("Script error!")
end)
    end,
 }) 
local Button = HubsTab:CreateButton({
		Name = " Chaotic Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/trashscript/main/chaotic.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Haloen V2 Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/MjHavin/Haloen-V2-by-mj-and-savvy/main/Hyo"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = "  FFJ V3 Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/BladeBallV3.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Ether Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/6w0s/_6w0s/main/Loader.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Nexam Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ea80f1b008dbe2b77b7ac8b3a525a180.lua"))()
		end,
	})
local HubsTab = Window:CreateTab("Blox Fruits 📜", 4483362458)
local Button = HubsTab:CreateButton({
		Name = "  Xero Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/devdoroz/bleachhack/main/newloader.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = "  Bluepray Hub",
		Callback = function()
			getgenv().Setting = {
    ["Team"] = "Pirates",
    ["Chat"] = {},
    ["Skip Race V4"] = true,
    ["Misc"] = {
        ["Enable Lock Bounty"] = false,
        ["Lock Bounty"] = {0, 300000000},
        ["Hide Health"] = {4500,5000},
        ["Lock Camera"] = true,
        ["Enable Cam Farm"] = false,
        ["White Screen"] = false,
        ["FPS Boost"] = false,
        ["Bypass TP"] = true,
        ["Random & Store Fruit"] = true
    },
    ["Item"] = {
        ["Melee"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 1},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0},
            ["C"] = {["Enable"] = true, ["Hold Time"] = 0}
        },
        ["Blox Fruit"] = {["Enable"] = false,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0},
            ["C"] = {["Enable"] = true, ["Hold Time"] = 0},
            ["V"] = {["Enable"] = true, ["Hold Time"] = 0},
            ["F"] = {["Enable"] = true, ["Hold Time"] = 0}
        },
        ["Sword"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.3},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.2}
        },
        ["Gun"] = {["Enable"] = false,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.5},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.3}
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ghost-1198/AutoBounty/main/AutoBounty.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = "  Redz Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Smile Hub",
		Callback = function()
			repeat wait() until game:IsLoaded()
_G.Team = "Pirates" -- Pirates / Marines
loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyLocDz/Blox-Fruit/main/TinhLinhHub.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Neva Hub",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2'))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Sitinks Hub",
		Callback = function()
			getgenv().Team = "Pirates"
getgenv().Executor = "Android" -- Android or PC --
loadstring(game:HttpGet("https://raw.githubusercontent.com/MinhNghia2k11/Main/main/SitinksHub.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Hades Hub",
		Callback = function()
			getgenv().Team = "Pirates" -- Pirates, Marines
getgenv().AntiCrash = false -- Anti Crash when load script/func idk
getgenv().BoostFps = false -- recommend if you have bad phone
loadstring(game:HttpGet("https://raw.githubusercontent.com/ItzWindy01/Loadstring/main/HadesGod.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " AnDepZai Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/main/AnDepZaiHubBeta.lua"))()
		end,
	})
local HubsTab = Window:CreateTab("Rivals  📜", 4483362458)
local Button = HubsTab:CreateButton({
		Name = " Nexam Hub Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/86c2ae2bea7bd8f522b1db3283b56967.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " InfiniX Hub",
		Callback = function()
			local __function = loadstring(game:HttpGet("https://github.com/Hosvile/InfiniX/releases/latest/download/main.lua", true))

__function(__function)
		end,
	})
local HubsTab = Window:CreateTab("Pet Simulator 99  📜", 4483362458)
local Button = HubsTab:CreateButton({
		Name = " Zap Hub",
		Callback = function()
			loadstring(game:HttpGet('https://zaphub.xyz/Exec'))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " W-Azure Hub",
		Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/4c8e3ee28e64ee380d7251b64c0801fb.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Redz Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/PetSimulator99/main/redz9999.lua"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Idiot Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Somerandomidiot/Lua/main/PS99_Protected.txt"))()
		end,
	})
local Button = HubsTab:CreateButton({
		Name = " Lenut Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/lenutjr/lenut/main/scripts"))()
		end,
	})
local HubsTab = Window:CreateTab("Flee the Facility  📜", 4483362458)
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
		Name = " Shizukii Wallhop Hub",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/lol/refs/heads/main/loaders/Shizukii%20wallhop.lua'))()
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
	Name = " Silent aim Hub",
	Callback = function()
		loadstring(game:HttpGet("https://rentry.co/s7dbgz3o/raw", true))()
			Rayfield:Notify({
	Title = "Note",
	Content = "This Silent aim no works all games :(",
	Duration = 6.5,
	Image = 4483362458,
	Actions = { -- Notification Buttons
		Ignore = { -- Variant 1
			Name = "SHUT UP",
			Callback = function()
				print("")
			end
		},
		Accept = { -- Variant 2
			Name = "Ok",
			Callback = function()
				print("")
			end
		},
	},
})
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
local Paragraph = SupportTab:CreateParagraph({Title = "Request script ", Content = "If you want a specific script on Shizukii, ask on our server or in my dm!"})

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
		setclipboard("https://github.com/lyraEz")
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
		setclipboard("https://discord.gg/FA3eVAdtfw")
    end,
 })
