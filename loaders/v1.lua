local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Scripts Loader",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionConfigs"
})

local ScriptsTab = Window:MakeTab({
    Name = "Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local function loadScript(url)
    loadstring(game:HttpGet(url, true))()
end

ScriptsTab:AddButton({
    Name = "Universal DarkCheatClient Aimbot",
    Callback = function()
        loadScript("https://scriptblox.com/raw/Universal-Script-Universal-DarkCheatClient-Aimbot-15362")
    end
})

ScriptsTab:AddButton({
    Name = "Katers NDS Hub",
    Callback = function()
        loadScript("https://rawscripts.net/raw/Natural-Disaster-Survival-Katers-NDS-Hub-19533")
    end
})

ScriptsTab:AddButton({
    Name = "Seven7 NDS",
    Callback = function()
        loadScript("https://rawscripts.net/raw/Natural-Disaster-Survival-Seven7-24001")
    end
})

ScriptsTab:AddButton({
    Name = "ScriptHub V3 Keyless",
    Callback = function()
        loadScript("https://rawscripts.net/raw/Universal-Script-ScriptHub-V3-Best-Mobile-ScriptHub-Keyless-16115")
    end
})

ScriptsTab:AddButton({
    Name = "Vehicle Fly GUI",
    Callback = function()
        loadScript("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
    end
})

ScriptsTab:AddButton({
    Name = "Shizukii",
    Callback = function()
        loadScript("https://raw.githubusercontent.com/chead-z/lol/main/Shizukii.lua")
    end
})

ScriptsTab:AddButton({
    Name = "Permanent Shiftlock V2",
    Callback = function()
        loadScript("https://raw.githubusercontent.com/Unknownproooolucky/Unknown-Hub-X-Universal-Games/main/Universal/Permanent-Shiftlock-V2")
    end
})

ScriptsTab:AddButton({
    Name = "Resolution Loader",
    Callback = function()
        loadScript("https://raw.githubusercontent.com/lyraEz/lol/refs/heads/main/loaders/resolution.lua")
    end
})

ScriptsTab:AddButton({
    Name = "RTX Script",
    Callback = function()
        getgenv().RTX_Name = 'rtxnamehere'
        loadScript("https://pastefy.app/xXkUxA0P/raw")
    end
})

ScriptsTab:AddButton({
    Name = "Shizukii Wallhop",
    Callback = function()
        loadScript("https://raw.githubusercontent.com/lyraEz/lol/refs/heads/main/loaders/Shizukii%20wallhop.lua")
    end
})

OrionLib:Init()