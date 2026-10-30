-- Lyra Prison Life utilities v0.2
-- Designed for Prison Life (place 155615604) with the Lyra UI library.
-- Visual-only tools; no weapon remote calls or automatic targeting.
if game.PlaceId ~= 155615604 then
    warn("Lyra Prison Life: this is not Prison Life")
    return
end
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local last = {}
local original = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows}
local alive = true
local cleanup = function() end
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
    Title="Prison Life", Subtitle="lyraEz | utilities v0.2",
    Theme="Lavender", ChatCommand="prison", ConfigFile="LyraUI/PrisonLife",
    Status="Ready",
    OnDestroy=function() alive=false;cleanup() end,
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

local pickedPlayer=""
PlayersTab:Input({Title="Select player", Placeholder="Type username or display name",Callback=function(v)
    pickedPlayer=tostring(v or ""):lower()
end})
local function findPlayer()
    if pickedPlayer=="" then return nil end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and (p.Name:lower():sub(1,#pickedPlayer)==pickedPlayer
            or p.DisplayName:lower():sub(1,#pickedPlayer)==pickedPlayer) then return p end
    end
end
PlayersTab:ButtonRow({
    {Title="Spectate",Icon="eye",Callback=function()
        local p=findPlayer()
        local h=p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=h end
    end},
    {Title="Return camera",Icon="undo",Callback=function()
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=h end
    end},
})
Window:Connect(Players.PlayerAdded,function()task.defer(refresh)end)
Window:Connect(Players.PlayerRemoving,function()task.defer(refresh)end)

local espEnabled=false
local espTeamOnly=false
local espRange=800
local espItems={}
local function clearItem(p)
    local entry=espItems[p]
    if entry then
        entry.highlight:Destroy()
        entry.gui:Destroy()
        espItems[p]=nil
    end
end
local function clearEsp()
    for p in pairs(espItems) do clearItem(p) end
end
local function getTeamColor(p)
    local name=p.Team and p.Team.Name:lower() or ""
    if name:find("guard") then return Color3.fromRGB(110,169,255) end
    if name:find("criminal") then return Color3.fromRGB(255,105,132) end
    if name:find("inmate") or name:find("prison") then
        return Color3.fromRGB(255,184,87)
    end
    return Color3.fromRGB(207,191,250)
end
local function updateEsp()
    local myRoot=getRoot()
    if not espEnabled or not myRoot then clearEsp();return end
    for _,p in ipairs(Players:GetPlayers()) do
        local model=p.Character
        local hum=model and model:FindFirstChildOfClass("Humanoid")
        local root=model and model:FindFirstChild("HumanoidRootPart")
        local head=model and model:FindFirstChild("Head")
        local distance=root and (root.Position-myRoot.Position).Magnitude or math.huge
        if p==LocalPlayer or not hum or hum.Health<=0 or not head
            or distance>espRange
            or (espTeamOnly and p.Team~=nil and p.Team==LocalPlayer.Team) then
            clearItem(p)
        else
            local item=espItems[p]
            if item and item.model~=model then clearItem(p);item=nil end
            if not item then
                local h=Instance.new("Highlight")
                h.Name="LyraPrisonHighlight"
                h.Adornee=model
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency=0.82
                h.OutlineTransparency=0.06
                h.Parent=model
                local gui=Instance.new("BillboardGui")
                gui.Name="LyraPrisonTag"
                gui.Adornee=head
                gui.Size=UDim2.fromOffset(220,55)
                gui.StudsOffsetWorldSpace=Vector3.new(0,3,0)
                gui.AlwaysOnTop=true
                gui.Parent=LocalPlayer.PlayerGui
                local txt=Instance.new("TextLabel")
                txt.BackgroundTransparency=1
                txt.TextStrokeTransparency=0.3
                txt.TextSize=13
                txt.Font=Enum.Font.GothamBold
                txt.TextWrapped=true
                txt.Size=UDim2.fromScale(1,1)
                txt.Parent=gui
                item={model=model,highlight=h,gui=gui,text=txt}
                espItems[p]=item
            end
            local color=getTeamColor(p)
            item.highlight.FillColor=color
            item.highlight.OutlineColor=color
            item.text.TextColor3=color
            item.text.Text=p.DisplayName.."  |  "..(p.Team and p.Team.Name or "Neutral")
                .."\n"..math.floor(distance).." studs  |  "..math.floor(hum.Health).." HP"
        end
    end
end
local TeamESP=Window:Tab({Title="Team ESP", Icon="eye"})
TeamESP:Section("Teams and players","Client-side outlines, name, team, distance and health. Blue guards, orange inmates, red criminals.")
TeamESP:Toggle({Title="Enable team ESP",Flag="prison_team_esp",Callback=function(v)
    espEnabled=v
    if not v then clearEsp() end
end})
TeamESP:Toggle({Title="Ignore teammates",Flag="prison_team_ignore",Callback=function(v)espTeamOnly=v end})
TeamESP:Slider({Title="Maximum distance",Min=100,Max=2000,Default=800,Suffix=" studs",
    Flag="prison_team_distance",Callback=function(v)espRange=v end})
TeamESP:Button({Title="Clear visual highlights",Icon="trash",Callback=function()
    espEnabled=false;clearEsp()
end})
local lastEsp=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    lastEsp=lastEsp+dt
    if lastEsp>=0.45 then lastEsp=0;updateEsp() end
end)
Window:Connect(Players.PlayerRemoving,clearItem)
cleanup=function()
    clearEsp()
    for key,value in pairs(original) do pcall(function()Lighting[key]=value end)end
    local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=h end
end

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
