-- Lyra Prison Life utilities v0.1
-- Designed for Prison Life (place 155615604) with the Lyra UI library.
-- Visual-only tools; no weapon remote calls or automatic targeting.
if game.PlaceId ~= 155615604 then
    warn("Lyra Prison Life: this is not Prison Life")
    return
end
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local last = {}
local original = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows}
local alive = true
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end
local function teleport(position)
    local root = getRoot()
    if root then
        last.position = root.CFrame
        root.CFrame = CFrame.new(position)
    end
end
local places = {
    {Name="Yard", Point=Vector3.new(736.467, 100, 2517.58)},
    {Name="Cells", Point=Vector3.new(919.555, 102, 2441.70)},
    {Name="Cafeteria", Point=Vector3.new(918.995, 102, 2325.73)},
    {Name="Kitchen", Point=Vector3.new(906.642, 102, 2237.67)},
    {Name="Armory", Point=Vector3.new(837.289, 102, 2270.99)},
    {Name="Guard Room", Point=Vector3.new(836.539, 102, 2320.60)},
    {Name="Surveillance", Point=Vector3.new(795.252, 102, 2327.72)},
    {Name="Break Room", Point=Vector3.new(800.090, 102, 2266.72)},
    {Name="Outside", Point=Vector3.new(451.668, 100, 2216.34)},
    {Name="Criminal Base", Point=Vector3.new(-975.845, 112, 2053.11)}
}
local libOk, Lyra = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lyraEz/lol/main/vendor/Lyra.lua"))()
end)
if not libOk then warn("Lyra UI failed to load: " .. tostring(Lyra)); return end
local Window = Lyra:CreateWindow({
    Title="Prison Life", Subtitle="lyraEz | utilities v0.1",
    Theme="Lavender", ChatCommand="prison", ConfigFile="LyraUI/PrisonLife",
    Status="Ready",
})
local Home = Window:Tab({Title="Overview", Icon="home"})
Home:Section("Prison Life", "Mobile-friendly utilities powered by Lyra UI.")
Home:Paragraph("Map positions follow the classic map. Game updates may change destinations.")
Home:Button({Title="Show current position", Icon="map-pin", Callback=function()
    local r = getRoot()
    Window:Notify({Title="Your position", Text=r and tostring(r.Position) or "No character", Kind="info"})
end})
local Map = Window:Tab({Title="Locations", Icon="map"})
Map:Section("Classic map", "Choose one destination. Coordinates may vary across game updates.")
local current = places[1]
local titles = {}
for _,place in ipairs(places) do table.insert(titles, place.Name) end
Map:Dropdown({Title="Destination", Options=titles, Default=titles[1], Callback=function(chosen)
    for _,place in ipairs(places) do
        if place.Name == chosen then current=place;break end
    end
end})
Map:Button({Title="Go to selected area", Icon="navigation", Primary=true, Callback=function()
    teleport(current.Point)
end})
Map:Button({Title="Return to previous location", Icon="undo", Callback=function()
    local root = getRoot()
    if root and last.position then
        local before = root.CFrame
        root.CFrame = last.position
        last.position = before
    end
end})
local PlayersTab = Window:Tab({Title="Players", Icon="users"})
PlayersTab:Section("Server roster", "Team and player information.")
local List = PlayersTab:List({EmptyTitle="No players"})
local function refresh()
    if not alive then return end
    local rows={}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(rows,{Title=p.DisplayName,Subtitle="@"..p.Name.." | "..(p.Team and p.Team.Name or "No team"),
            Current=p==LocalPlayer,
            Image="rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"})
    end
    List:Set(rows)
end
PlayersTab:Button({Title="Refresh player roster", Icon="refresh-cw", Callback=refresh})
refresh()
local Visuals = Window:Tab({Title="Visuals", Icon="eye"})
Visuals:Section("Client lighting", "Only your local display is affected.")
Visuals:Toggle({Title="Fullbright", Flag="prison_fullbright", Callback=function(enabled)
    if enabled then
        Lighting.Brightness=3;Lighting.ClockTime=14;Lighting.GlobalShadows=false
    else
        for key, value in pairs(original) do Lighting[key]=value end
    end
end})
Visuals:Slider({Title="Camera field of view",Min=50,Max=110,Default=70,Suffix="°",
    Flag="prison_fov",Callback=function(v)
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end
    end})
local Settings=Window:SettingsTab()
Settings:Button({Title="Restore lighting", Icon="rotate-ccw", Callback=function()
    for key,value in pairs(original) do Lighting[key]=value end
end})
Window:Notify({Title="Lyra Prison Life", Text="Utilities loaded. Use /e prison to reopen.", Kind="success"})
return Window
