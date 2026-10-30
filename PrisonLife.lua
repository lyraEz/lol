-- Lyra Prison Life hub v1.1.0
-- Designed for Prison Life (place 155615604) with the Lyra UI library.
-- Team ESP, combat camera assist, movement, navigation and player utilities.
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
    Title="Prison Life", Subtitle="lyraEz | hub v1.1.0",
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

PlayersTab:Section("Player actions","Search by name or partial username.")
PlayersTab:ButtonRow({
    {Title="Teleport to player",Icon="navigation",Callback=function()
        local p=findPlayer()
        local r=p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local me=getRoot()
            if me then
                last.position=me.CFrame
                me.CFrame=r.CFrame*CFrame.new(0,0,4)
                Window:Status("Teleported to "..p.Name,"success")
            end
        else Window:Status("Selected player is not spawned","warning")end
    end},
    {Title="Copy UserId",Icon="copy",Callback=function()
        local p=findPlayer()
        if p and type(setclipboard)=="function" then
            local ok=pcall(setclipboard,tostring(p.UserId))
            Window:Status(ok and "UserId copied" or "Clipboard unavailable",
                ok and "success" or "warning")
        end
    end}
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

-- Combat tools use client camera and normally equipped tools; no remote interception.
local UIS=game:GetService("UserInputService")
local Camera=workspace.CurrentCamera
local combat={
    aim=false,hold=false,held=false,trigger=false,showCircle=true,
    radius=180,smooth=0.24,part="Head",wall=true,team=true,
    guards=true,inmates=true,criminals=true,triggerCooldown=0.22}
local combatGui=Instance.new("ScreenGui")
combatGui.Name="LyraPrisonCombat"
combatGui.ResetOnSpawn=false
combatGui.IgnoreGuiInset=true
combatGui.DisplayOrder=20
combatGui.Parent=LocalPlayer:WaitForChild("PlayerGui")
local fovCircle=Instance.new("Frame")
fovCircle.Name="AimRadius"
fovCircle.AnchorPoint=Vector2.new(0.5,0.5)
fovCircle.BackgroundTransparency=1
fovCircle.BorderSizePixel=0
fovCircle.Parent=combatGui
local round=Instance.new("UICorner",fovCircle)
round.CornerRadius=UDim.new(1,0)
local line=Instance.new("UIStroke",fovCircle)
line.Color=Color3.fromRGB(191,164,250)
line.Transparency=0.12
line.Thickness=1.5
local function role(p)
    local text=(p.Team and p.Team.Name or p.TeamColor.Name):lower()
    if text:find("guard") or text:find("blue") then return "guards" end
    if text:find("inmate") or text:find("prison") or text:find("orange") then return "inmates" end
    if text:find("criminal") or text:find("red") then return "criminals" end
    return "other"
end
local function legalTarget(p)
    if p==LocalPlayer or (combat.team and p.Team and p.Team==LocalPlayer.Team) then return false end
    if not combat[role(p)] then return false end
    local model=p.Character
    local hum=model and model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health>0
end
local function pointer()
    local cameraNow=workspace.CurrentCamera
    if UIS.TouchEnabled and not UIS.MouseEnabled then
        return cameraNow.ViewportSize*0.5
    end
    local position=UIS:GetMouseLocation()
    return Vector2.new(position.X,position.Y)
end
local function visibleTarget(part,p)
    if not combat.wall then return true end
    local cameraNow=workspace.CurrentCamera
    local ray=RaycastParams.new()
    ray.FilterType=Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances=LocalPlayer.Character and {LocalPlayer.Character} or {}
    ray.IgnoreWater=true
    local from=cameraNow.CFrame.Position
    local trace=workspace:Raycast(from,part.Position-from,ray)
    return not trace or (p.Character and trace.Instance:IsDescendantOf(p.Character))
end
local function closestTarget()
    local cameraNow=workspace.CurrentCamera
    if not cameraNow then return nil end
    local pointerPos=pointer()
    local nearest,best=nil,combat.radius
    for _,p in ipairs(Players:GetPlayers()) do
        if legalTarget(p) then
            local model=p.Character
            local part=model and (model:FindFirstChild(combat.part) or model:FindFirstChild("HumanoidRootPart"))
            if part then
                local projected,onScreen=cameraNow:WorldToViewportPoint(part.Position)
                if onScreen and projected.Z>0 then
                    local distance=(Vector2.new(projected.X,projected.Y)-pointerPos).Magnitude
                    if distance<best and visibleTarget(part,p) then
                        best=distance
                        nearest=part
                    end
                end
            end
        end
    end
    return nearest,best
end
local CombatTab=Window:Tab({Title="Combat",Icon="crosshair"})
CombatTab:Section("Aim assist", "Client-side aim assistance. Camera tracking never changes shot data.")
CombatTab:Toggle({Title="Enable camera aim",Flag="pl_combat_aim",Callback=function(v)combat.aim=v end})
CombatTab:Toggle({Title="Hold E / right mouse to aim",Flag="pl_combat_hold",
    Description="Turn this off for always-on assist, including touch controls.",
    Callback=function(v)combat.hold=v end})
CombatTab:Toggle({Title="Trigger on crosshair",Flag="pl_combat_trigger",
    Description="Attempts to activate an already equipped tool near a target.",
    Callback=function(v)combat.trigger=v end})
CombatTab:Toggle({Title="Show FOV circle",Default=true,Flag="pl_combat_circle",
    Callback=function(v)combat.showCircle=v end})
CombatTab:Toggle({Title="Check walls",Default=true,Flag="pl_combat_walls",
    Callback=function(v)combat.wall=v end})
CombatTab:Toggle({Title="Ignore teammates",Default=true,Flag="pl_combat_team",
    Callback=function(v)combat.team=v end})
CombatTab:Dropdown({Title="Aim body part",Options={"Head","HumanoidRootPart"},Default="Head",
    Flag="pl_combat_part",Callback=function(v)combat.part=v end})
CombatTab:Slider({Title="Aim radius",Min=40,Max=500,Default=180,Suffix=" px",
    Flag="pl_combat_radius",Callback=function(v)combat.radius=v end})
CombatTab:Slider({Title="Aim smoothing",Min=5,Max=100,Default=24,Suffix=" %",
    Flag="pl_combat_smoothing",Callback=function(v)combat.smooth=v/100 end})
CombatTab:Section("Team filter", "Choose which teams can be targeted.")
CombatTab:Toggle({Title="Guards",Default=true,Flag="pl_target_guards",Callback=function(v)combat.guards=v end})
CombatTab:Toggle({Title="Inmates",Default=true,Flag="pl_target_inmates",Callback=function(v)combat.inmates=v end})
CombatTab:Toggle({Title="Criminals",Default=true,Flag="pl_target_criminals",Callback=function(v)combat.criminals=v end})
local lastActivation=0
Window:Connect(UIS.InputBegan,function(input,consumed)
    if consumed then return end
    if input.KeyCode==Enum.KeyCode.E or input.UserInputType==Enum.UserInputType.MouseButton2 then
        combat.held=true
    end
end)
Window:Connect(UIS.InputEnded,function(input)
    if input.KeyCode==Enum.KeyCode.E or input.UserInputType==Enum.UserInputType.MouseButton2 then
        combat.held=false
    end
end)
Window:Connect(RunService.RenderStepped,function(dt)
    if not alive then return end
    local cameraNow=workspace.CurrentCamera
    if not cameraNow then return end
    fovCircle.Visible=combat.showCircle and (combat.aim or combat.trigger)
    if fovCircle.Visible then
        local point=pointer()
        fovCircle.Size=UDim2.fromOffset(combat.radius*2,combat.radius*2)
        fovCircle.Position=UDim2.fromOffset(point.X,point.Y)
    end
    if not (combat.aim or combat.trigger) or (combat.hold and not combat.held) then return end
    local part,distance=closestTarget()
    if not part then return end
    if combat.aim then
        local destination=CFrame.lookAt(cameraNow.CFrame.Position,part.Position)
        cameraNow.CFrame=cameraNow.CFrame:Lerp(destination,math.clamp(combat.smooth*dt*60,0,0.98))
    end
    if combat.trigger and distance and distance<=18 and os.clock()-lastActivation>combat.triggerCooldown then
        local char=LocalPlayer.Character
        local tool=char and char:FindFirstChildOfClass("Tool")
        if tool then
            lastActivation=os.clock()
            pcall(function()tool:Activate()end)
        end
    end
end)

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
    if combatGui then combatGui:Destroy()end
    clearEsp()
    for key,value in pairs(original) do pcall(function()Lighting[key]=value end)end
    local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=h end
end


-- Mobility & survival: old movement state is restored when options are disabled or hub unloads.
local movement={speed=false,speedValue=16,jump=false,jumpValue=50,
    noclip=false,infiniteJump=false,antiSit=false,antiIdle=false,antiFall=false}
local oldCollision=setmetatable({}, {__mode="k"})
local function restoreCollision()
    for part,value in pairs(oldCollision) do
        if part and part.Parent then pcall(function()part.CanCollide=value end)end
        oldCollision[part]=nil
    end
end
local Mov=Window:Tab({Title="Movement",Icon="move"})
Mov:Section("Movement","Client-side adjustments, reapplied to each new character.")
Mov:Toggle({Title="Custom walkspeed",Flag="pl_move_speedon",
    Callback=function(v)movement.speed=v end})
Mov:Slider({Title="Walkspeed",Min=16,Max=120,Default=16,
    Flag="pl_move_speed",Callback=function(v)movement.speedValue=v end})
Mov:Toggle({Title="Custom jump power",Flag="pl_move_jumpon",
    Callback=function(v)movement.jump=v end})
Mov:Slider({Title="Jump power",Min=50,Max=175,Default=50,
    Flag="pl_move_jump",Callback=function(v)movement.jumpValue=v end})
Mov:Toggle({Title="Noclip (local collisions)",Flag="pl_move_noclip",Callback=function(v)
    movement.noclip=v
    if not v then restoreCollision() end
end})
Mov:Toggle({Title="Infinite jump",Flag="pl_move_inf",Callback=function(v)movement.infiniteJump=v end})
Mov:Toggle({Title="Anti sit",Flag="pl_move_antisit",Callback=function(v)movement.antiSit=v end})
Mov:Toggle({Title="Prevent falling off map",Flag="pl_move_antifall",
    Description="Returns you to your last safe position after falling below the map.",
    Callback=function(v)movement.antiFall=v end})
Mov:Button({Title="Reset movement",Icon="rotate-ccw",Callback=function()
    movement.speed=false;movement.jump=false;movement.noclip=false
    movement.infiniteJump=false;movement.antiSit=false;movement.antiFall=false
    restoreCollision()
    local model=LocalPlayer.Character
    local hum=model and model:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=16;hum.UseJumpPower=true;hum.JumpPower=50;hum.Sit=false end
    Window:Status("Movement restored", "success")
end})

-- Flight follows Humanoid.MoveDirection, so the virtual mobile joystick also works.
local fly={on=false,speed=60,up=false,down=false,root=nil,velocity=nil,gyro=nil}
local function clearFly()
    if fly.velocity then fly.velocity:Destroy();fly.velocity=nil end
    if fly.gyro then fly.gyro:Destroy();fly.gyro=nil end
    fly.root=nil
end
local function prepareFly(root)
    if fly.root==root and fly.velocity and fly.gyro then return end
    clearFly()
    fly.root=root
    local vel=Instance.new("BodyVelocity")
    vel.Name="LyraFlyVelocity"
    vel.MaxForce=Vector3.new(1e7,1e7,1e7)
    vel.P=2000
    vel.Velocity=Vector3.zero
    vel.Parent=root
    fly.velocity=vel
    local gyro=Instance.new("BodyGyro")
    gyro.Name="LyraFlyGyro"
    gyro.P=8000
    gyro.D=600
    gyro.MaxTorque=Vector3.new(1e6,1e6,1e6)
    gyro.CFrame=root.CFrame
    gyro.Parent=root
    fly.gyro=gyro
end
Mov:Section("Fly", "Camera-relative flight with mobile joystick support.")
Mov:Toggle({Title="Fly",Flag="pl_fly",Callback=function(v)
    fly.on=v
    if not v then clearFly() end
end})
Mov:Slider({Title="Fly speed",Min=15,Max=160,Default=60,Suffix=" studs/s",
    Flag="pl_fly_speed",Callback=function(v)fly.speed=v end})
Mov:Toggle({Title="Fly ascend",Flag="pl_fly_up",Callback=function(v)fly.up=v end})
Mov:Toggle({Title="Fly descend",Flag="pl_fly_down",Callback=function(v)fly.down=v end})
Window:Connect(UIS.InputBegan,function(input,processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.Space then fly.up=true end
    if input.KeyCode==Enum.KeyCode.LeftControl then fly.down=true end
end)
Window:Connect(UIS.InputEnded,function(input)
    if input.KeyCode==Enum.KeyCode.Space then fly.up=false end
    if input.KeyCode==Enum.KeyCode.LeftControl then fly.down=false end
end)
Window:Connect(RunService.Heartbeat,function()
    if not alive or not fly.on then return end
    local model=LocalPlayer.Character
    local hum=model and model:FindFirstChildOfClass("Humanoid")
    local root=model and model:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health<=0 then clearFly();return end
    prepareFly(root)
    local cam=workspace.CurrentCamera
    local dir=hum.MoveDirection
    local rise=(fly.up and 1 or 0)-(fly.down and 1 or 0)
    fly.velocity.Velocity=dir*fly.speed+Vector3.new(0,rise*fly.speed,0)
    if cam then
        local look=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z)
        if look.Magnitude>0.05 then fly.gyro.CFrame=CFrame.lookAt(root.Position,root.Position+look)end
    end
    hum.PlatformStand=false
end)

local lastSafe,moveClock= nil,0
Window:Connect(UIS.JumpRequest,function()
    if movement.infiniteJump then
        local model=LocalPlayer.Character
        local hum=model and model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Jumping)end
    end
end)
Window:Connect(RunService.Stepped,function()
    if not alive or not movement.noclip then return end
    local char=LocalPlayer.Character
    if not char then return end
    for _,part in ipairs(char:GetDescendants())do
        if part:IsA("BasePart") then
            if oldCollision[part]==nil then oldCollision[part]=part.CanCollide end
            part.CanCollide=false
        end
    end
end)
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    moveClock=moveClock+dt
    if moveClock<0.12 then return end
    moveClock=0
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health<=0 then return end
    if movement.speed then hum.WalkSpeed=movement.speedValue end
    if movement.jump then hum.UseJumpPower=true;hum.JumpPower=movement.jumpValue end
    if movement.antiSit then hum.Sit=false end
    if root.Position.Y>25 and hum.FloorMaterial~=Enum.Material.Air then lastSafe=root.CFrame end
    if movement.antiFall and root.Position.Y<-40 and lastSafe then
        root.CFrame=lastSafe*CFrame.new(0,4,0)
        root.AssemblyLinearVelocity=Vector3.zero
    end
end)
Window:Connect(LocalPlayer.CharacterAdded,function()
    restoreCollision()
    lastSafe=nil
end)

-- Team and equipment tools query the live game structure instead of creating fake items.

-- Vehicle/spawn navigation uses live objects where available.
Map:Section("Dynamic map points","Look up the current workspace instead of relying only on classic coordinates.")
local function findPart(name)
    local obj=workspace:FindFirstChild(name,true)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChildWhichIsA("BasePart",true)
end
Map:ButtonRow({
    {Title="Guard spawn",Icon="shield",Callback=function()
        local part=findPart("Guards Spawn") or findPart("Guard Spawn")
        if part then teleport(part.Position+Vector3.new(0,4,0))
        else teleport(Vector3.new(837.289,102,2270.99))end
    end},
    {Title="Criminal spawn",Icon="navigation",Callback=function()
        local part=findPart("Criminals Spawn")
        if part then teleport(part.Position+Vector3.new(0,4,0))
        else teleport(Vector3.new(-920,100,2138))end
    end},
})

local TeamTools=Window:Tab({Title="Teams & Gear",Icon="shield"})
TeamTools:Section("Teams","Server decides whether a team change is accepted. Criminals must cross their spawn.")
local remoteFolder=workspace:FindFirstChild("Remote")
local function remote(name)
    return (workspace:FindFirstChild("Remote") or remoteFolder)
        and (workspace:FindFirstChild("Remote") or remoteFolder):FindFirstChild(name)
end
local function requestTeam(color)
    local event=remote("TeamEvent")
    if not event or not event:IsA("RemoteEvent") then
        Window:Notify({Title="Teams",Text="TeamEvent unavailable in this server.",Kind="warning"})
        return
    end
    local ok,err=pcall(function()event:FireServer(color)end)
    Window:Notify({Title="Team requested",
        Text=ok and ("Requested "..color.."; server may refuse.") or tostring(err),
        Kind=ok and "info" or "warning"})
end
TeamTools:ButtonRow({
    {Title="Guards",Icon="shield",Callback=function()requestTeam("Bright blue")end},
    {Title="Inmates",Icon="users",Callback=function()requestTeam("Bright orange")end},
})
TeamTools:Button({Title="Criminal spawn",Icon="navigation",
    Description="Classic map. The game switches teams when you touch the spawn.",
    Callback=function()
        teleport(Vector3.new(-920,100,2138))
    end})
local weaponChoices={"M9","Remington 870","AK-47","MP5","M4A1","Taser","Hammer","Crude Knife"}
local selectedWeapon="M9"
local function findItem(name)
    local items=workspace:FindFirstChild("Prison_ITEMS")
    local giver=items and items:FindFirstChild("giver")
    if not giver then return nil end
    for _,child in ipairs(giver:GetChildren())do
        if child.Name:lower()==name:lower() then return child end
    end
    return nil
end
local function requestItem(name)
    local giver=findItem(name)
    local handler=remote("ItemHandler")
    local item=giver and giver:FindFirstChild("ITEMPICKUP",true)
    if not giver or not handler or not item then
        Window:Notify({Title="Gear",Text=name.." cannot be requested from this server.",Kind="warning"})
        return
    end
    if not handler:IsA("RemoteFunction") then return end
    local ok=pcall(function()handler:InvokeServer(item)end)
    Window:Notify({Title="Gear",Text=ok and ("Requested "..name.."; restrictions still apply.") or
        ("Could not request "..name),Kind=ok and "info" or "warning"})
end
TeamTools:Section("Weapons & items","Only items present in the live map. Paid equipment still requires ownership.")
TeamTools:Dropdown({Title="Weapon",Options=weaponChoices,Default="M9",
    Flag="pl_item",Callback=function(v)selectedWeapon=v end})
TeamTools:ButtonRow({
    {Title="Request",Icon="package",Primary=true,Callback=function()requestItem(selectedWeapon)end},
    {Title="Go to item",Icon="navigation",Callback=function()
        local item=findItem(selectedWeapon)
        local part=item and item:FindFirstChildWhichIsA("BasePart",true)
        if part then teleport(part.Position+Vector3.new(0,3,0))
        else Window:Status("Item spawn unavailable", "warning") end
    end},
})
TeamTools:Button({Title="Get starter weapons",Icon="crosshair",
    Description="Requests M9, Remington and AK-47 one at a time.",
    Callback=function()
        task.spawn(function()
            for _,name in ipairs({"M9","Remington 870","AK-47"})do
                if not alive then return end
                requestItem(name)
                task.wait(0.35)
            end
        end)
    end})
local autoGear=false
TeamTools:Toggle({Title="Get starter weapons after respawn",Flag="pl_autogear",
    Callback=function(v)autoGear=v end})
Window:Connect(LocalPlayer.CharacterAdded,function()
    if autoGear then
        task.delay(2,function()
            if alive then
                for _,name in ipairs({"M9","Remington 870","AK-47"})do
                    if not alive then break end
                    requestItem(name)
                    task.wait(0.35)
                end
            end
        end)
    end
end)

TeamTools:Section("Extra actions","Nearby items and guard-only arrest helper.")
TeamTools:Button({Title="Pick up nearby dropped item",Icon="package",
    Description="Looks for the closest loose item within 18 studs.",
    Callback=function()
        local items=workspace:FindFirstChild("Prison_ITEMS")
        local loose=items and items:FindFirstChild("single")
        local handler=remote("ItemHandler")
        local root=getRoot()
        if not loose or not handler or not root then
            Window:Status("Dropped item handler not available","warning");return
        end
        local bestItem,bestDist=nil,18
        for _,obj in ipairs(loose:GetChildren()) do
            local part=obj:FindFirstChildWhichIsA("BasePart",true)
            local pickup=obj:FindFirstChild("ITEMPICKUP",true)
            if part and pickup then
                local d=(part.Position-root.Position).Magnitude
                if d<bestDist then bestDist=d;bestItem=pickup end
            end
        end
        if bestItem and handler:IsA("RemoteFunction") then
            local ok=pcall(function()handler:InvokeServer(bestItem)end)
            Window:Status(ok and "Pickup requested" or "Pickup rejected",ok and "success" or "warning")
        else Window:Status("No dropped items nearby","info")end
    end})
local lastArrest=0
TeamTools:Button({Title="Arrest nearest (Guards)",Icon="shield",
    Description="Attempts one arrest within 12 studs; requires guard team.",
    Callback=function()
        if not LocalPlayer.Team or not LocalPlayer.Team.Name:lower():find("guard") then
            Window:Status("You must be a Guard","warning");return
        end
        if os.clock()-lastArrest<1.2 then return end
        local root=getRoot()
        local arrest=remote("arrest")
        if not root or not arrest or not arrest:IsA("RemoteFunction") then
            Window:Status("Arrest handler unavailable","warning");return
        end
        local target,best=nil,12
        for _,p in ipairs(Players:GetPlayers())do
            local model=p.Character
            local hum=model and model:FindFirstChildOfClass("Humanoid")
            local r=model and model:FindFirstChild("HumanoidRootPart")
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and r and hum and hum.Health>0 then
                local d=(r.Position-root.Position).Magnitude
                if d<best then best=d;target=model:FindFirstChild("Head") or r end
            end
        end
        if target then
            lastArrest=os.clock()
            local ok=pcall(function()arrest:InvokeServer(target)end)
            Window:Status(ok and "Arrest attempt sent" or "Arrest rejected",ok and "info" or "warning")
        else Window:Status("No nearby player to arrest","info")end
    end})


-- Local weapon config editor: does not spoof server ownership or bypass gun remotes.
local customGun=false
local originalGunStates=setmetatable({}, {__mode="k"})
local function tuneGun(tool)
    local module=tool:FindFirstChild("GunStates",true)
    if not module or not module:IsA("ModuleScript") then return false end
    local ok,config=pcall(require,module)
    if not ok or type(config)~="table" then return false end
    if not originalGunStates[module]then
        local copy={}
        for k,v in pairs(config)do copy[k]=v end
        originalGunStates[module]=copy
    end
    local old=originalGunStates[module]
    if customGun then
        local vals={Spread=0,ReloadTime=0.12,FireRate=0.075,AutoFire=true,Range=5000}
        for k,v in pairs(vals)do if old[k]~=nil then config[k]=v end end
    else
        for k,v in pairs(old)do config[k]=v end
    end
    return true
end
local function refreshGuns()
    local count=0
    for _,container in ipairs({LocalPlayer:FindFirstChild("Backpack") or LocalPlayer,LocalPlayer.Character or LocalPlayer})do
        for _,obj in ipairs(container:GetChildren())do
            if obj:IsA("Tool") and tuneGun(obj)then count=count+1 end
        end
    end
    return count
end
TeamTools:Section("Local gun tuning","Client-side GunStates only; server restrictions and ammunition limits still apply.")
TeamTools:Toggle({Title="Fast reload / low spread",Flag="pl_gun_tuning",Callback=function(v)
    customGun=v
    Window:Status("Processed "..refreshGuns().." local gun configurations", "info")
end})
TeamTools:Button({Title="Refresh gun tuning",Icon="refresh-cw",Callback=function()
    Window:Status("Processed "..refreshGuns().." gun configs","info")
end})
local reloadGunClock=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not customGun or not alive then return end
    reloadGunClock=reloadGunClock+dt
    if reloadGunClock>=1.5 then
        reloadGunClock=0
        refreshGuns()
    end
end)

local GearStatus=TeamTools:Label("Inventory: scanning...")
TeamTools:Button({Title="Refresh inventory",Icon="refresh-cw",Callback=function()
    local backpack=LocalPlayer:FindFirstChild("Backpack")
    local total={}
    for _,container in ipairs({backpack,LocalPlayer.Character}) do
        if container then
            for _,obj in ipairs(container:GetChildren())do
                if obj:IsA("Tool")then table.insert(total,obj.Name)end
            end
        end
    end
    GearStatus:Set("Inventory ("..#total.."): "..(#total>0 and table.concat(total,", ") or "empty"))
end})


-- Extend shutdown to include temporary graphics changes.
local baseCleanup=cleanup
cleanup=function()
    restoreCollision()
    clearFly()
    customGun=false
    pcall(refreshGuns)
    local model=LocalPlayer.Character
    local hum=model and model:FindFirstChildOfClass("Humanoid")
    if hum then
        if movement.speed then hum.WalkSpeed=16 end
        if movement.jump then hum.UseJumpPower=true;hum.JumpPower=50 end
    end
    baseCleanup()
end


-- Lightweight 2D radar, local-only. Does not use Drawing or exploit-only APIs.
local radar={on=false,range=500,size=150,position="Top right",dots={},last=0}
local radarGui=Instance.new("ScreenGui")
radarGui.Name="LyraPrisonRadar"
radarGui.ResetOnSpawn=false
radarGui.IgnoreGuiInset=true
radarGui.DisplayOrder=15
radarGui.Parent=LocalPlayer:WaitForChild("PlayerGui")
local radarFrame=Instance.new("Frame")
radarFrame.Name="Radar"
radarFrame.AnchorPoint=Vector2.new(1,0)
radarFrame.Position=UDim2.new(1,-12,0,120)
radarFrame.Size=UDim2.fromOffset(150,150)
radarFrame.BackgroundColor3=Color3.fromRGB(21,19,33)
radarFrame.BackgroundTransparency=0.19
radarFrame.BorderSizePixel=0
radarFrame.Parent=radarGui
local radCorner=Instance.new("UICorner",radarFrame)
radCorner.CornerRadius=UDim.new(0,16)
local radStroke=Instance.new("UIStroke",radarFrame)
radStroke.Color=Color3.fromRGB(166,138,216)
radStroke.Transparency=0.35
local center=Instance.new("Frame")
center.Size=UDim2.fromOffset(8,8)
center.Position=UDim2.fromScale(0.5,0.5)
center.AnchorPoint=Vector2.new(0.5,0.5)
center.BackgroundColor3=Color3.fromRGB(250,244,255)
center.BorderSizePixel=0
center.ZIndex=4
center.Parent=radarFrame
local centerCorner=Instance.new("UICorner",center)
centerCorner.CornerRadius=UDim.new(1,0)
local radarTitle=Instance.new("TextLabel")
radarTitle.BackgroundTransparency=1
radarTitle.Font=Enum.Font.GothamBold
radarTitle.TextSize=11
radarTitle.TextColor3=Color3.fromRGB(226,205,252)
radarTitle.Text="PRISON RADAR"
radarTitle.Size=UDim2.new(1,0,0,19)
radarTitle.Position=UDim2.fromOffset(0,4)
radarTitle.ZIndex=5
radarTitle.Parent=radarFrame
radarFrame.Visible=false
local RadarTab=Window:Tab({Title="Radar",Icon="radar"})
RadarTab:Section("Team radar","Real-time relative positions on a mobile-friendly map overlay.")
RadarTab:Toggle({Title="Show radar",Flag="pl_radar",Callback=function(v)
    radar.on=v
    radarFrame.Visible=v
end})
RadarTab:Slider({Title="Radar range",Min=100,Max=2500,Default=500,Suffix=" studs",
    Flag="pl_radar_range",Callback=function(v)radar.range=v end})
RadarTab:Slider({Title="Radar size",Min=100,Max=230,Default=150,Suffix=" px",
    Flag="pl_radar_size",Callback=function(v)
        radar.size=v
        radarFrame.Size=UDim2.fromOffset(v,v)
    end})
local function updateRadarPosition(pos)
    radar.position=pos
    local points={
        ["Top right"]={Vector2.new(1,0),UDim2.new(1,-12,0,120)},
        ["Top left"]={Vector2.new(0,0),UDim2.new(0,12,0,120)},
        ["Bottom right"]={Vector2.new(1,1),UDim2.new(1,-12,1,-110)},
        ["Bottom left"]={Vector2.new(0,1),UDim2.new(0,12,1,-110)}
    }
    local selected=points[pos] or points["Top right"]
    radarFrame.AnchorPoint=selected[1]
    radarFrame.Position=selected[2]
end
RadarTab:Dropdown({Title="Overlay corner",
    Options={"Top right","Top left","Bottom right","Bottom left"},
    Default="Top right",Flag="pl_radar_pos",Callback=updateRadarPosition})
local function radarDot(player)
    local d=radar.dots[player]
    if d then return d end
    d=Instance.new("Frame")
    d.Name="PlayerMarker"
    d.Size=UDim2.fromOffset(6,6)
    d.AnchorPoint=Vector2.new(0.5,0.5)
    d.BackgroundColor3=getTeamColor(player)
    d.BorderSizePixel=0
    d.ZIndex=3
    d.Parent=radarFrame
    local dotRound=Instance.new("UICorner",d)
    dotRound.CornerRadius=UDim.new(1,0)
    radar.dots[player]=d
    return d
end
local function radarClear(player)
    if player then
        local d=radar.dots[player]
        if d then d:Destroy();radar.dots[player]=nil end
    else
        for p,d in pairs(radar.dots)do d:Destroy();radar.dots[p]=nil end
    end
end
Window:Connect(Players.PlayerRemoving,radarClear)
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive or not radar.on then return end
    radar.last=radar.last+dt
    if radar.last<0.22 then return end
    radar.last=0
    local root=getRoot()
    local cam=workspace.CurrentCamera
    if not root or not cam then radarClear();return end
    local right=cam.CFrame.RightVector
    local front=cam.CFrame.LookVector
    local maxPixels=(radar.size*0.5)-12
    for _,p in ipairs(Players:GetPlayers())do
        if p~=LocalPlayer then
            local c=p.Character
            local h=c and c:FindFirstChildOfClass("Humanoid")
            local r=c and c:FindFirstChild("HumanoidRootPart")
            local diff=r and r.Position-root.Position
            if not h or h.Health<=0 or not diff or diff.Magnitude>radar.range then
                radarClear(p)
            else
                local flat=Vector3.new(diff.X,0,diff.Z)
                local x=math.clamp(flat:Dot(right)/radar.range,-1,1)
                local y=math.clamp(flat:Dot(front)/radar.range,-1,1)
                local dot=radarDot(p)
                dot.Position=UDim2.new(0.5,x*maxPixels,0.5,-y*maxPixels)
                dot.BackgroundColor3=getTeamColor(p)
            end
        end
    end
end)
local radarBaseCleanup=cleanup
cleanup=function()
    radarClear()
    radarGui:Destroy()
    radarBaseCleanup()
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

-- Navigation extras: bookmark, undo and dynamic discovery of current map parts.
local savedBookmarks={}
local function statusPoint(label)
    local r=getRoot()
    Window:Notify({Title=label,Text=r and
        ("X "..math.floor(r.Position.X).." / Y "..math.floor(r.Position.Y).." / Z "..math.floor(r.Position.Z))
        or "No character spawned",Kind="info"})
end
Map:Section("Custom bookmarks","Stored until this hub is unloaded.")
local bookmarkSlot="1"
Map:Dropdown({Title="Bookmark slot",Options={"1","2","3","4","5"},Default="1",
    Callback=function(v)bookmarkSlot=v end})
Map:ButtonRow({
    {Title="Save here",Icon="bookmark",Callback=function()
        local r=getRoot()
        if r then savedBookmarks[bookmarkSlot]=r.CFrame;Window:Status("Saved slot "..bookmarkSlot,"success")end
    end},
    {Title="Go to slot",Icon="navigation",Callback=function()
        local c=savedBookmarks[bookmarkSlot]
        if c then
            local r=getRoot()
            if r then last.position=r.CFrame;r.CFrame=c end
        else Window:Status("Bookmark slot "..bookmarkSlot.." is empty","warning")end
    end},
})
Map:Button({Title="Copy current coordinates",Icon="copy",Callback=function()
    local r=getRoot()
    if r and type(setclipboard)=="function" then
        local p=r.Position
        local ok=pcall(setclipboard,string.format("Vector3.new(%.2f, %.2f, %.2f)",p.X,p.Y,p.Z))
        Window:Status(ok and "Coordinates copied" or "Clipboard unavailable",ok and "success" or "warning")
    else statusPoint("Current position")end
end})
Home:Section("Live status","Team and player count update without network requests.")
local statusLabel=Home:Label("Updating...")
local statusClock=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    statusClock=statusClock+dt
    if statusClock<2 then return end
    statusClock=0
    statusLabel:Set("Team: "..(LocalPlayer.Team and LocalPlayer.Team.Name or "None")
        .." | Players: "..#Players:GetPlayers().." | Place: "..game.PlaceId)
end)


-- Session and on-screen performance controls.
local TeleportService=game:GetService("TeleportService")
local misc=Window:Tab({Title="Session",Icon="settings-2"})
misc:Section("Session controls","Useful after respawning or switching servers.")
misc:ButtonRow({
    {Title="Rejoin",Icon="refresh-cw",Callback=function()
        local ok,err=pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)end)
        if not ok then Window:Status(tostring(err),"warning")end
    end},
    {Title="Respawn",Icon="rotate-ccw",Callback=function()
        local char=LocalPlayer.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health=0 end
    end}
})
local initialFov=workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
local lowGraphics=false
local graphicsCache=setmetatable({}, {__mode="k"})
local function setLowGraphics(enabled)
    lowGraphics=enabled
    if enabled then
        for _,obj in ipairs(workspace:GetDescendants())do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                if graphicsCache[obj]==nil then graphicsCache[obj]=obj.Enabled end
                obj.Enabled=false
            end
        end
    else
        for obj,value in pairs(graphicsCache)do
            if obj and obj.Parent then pcall(function()obj.Enabled=value end)end
        end
        table.clear(graphicsCache)
    end
end
misc:Toggle({Title="Reduce particles/trails",Flag="pl_lowfx",Callback=setLowGraphics})
misc:Button({Title="Restore visuals",Icon="rotate-ccw",Callback=function()
    setLowGraphics(false)
    for k,v in pairs(original)do Lighting[k]=v end
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=initialFov end
    Window:Status("Visual settings restored","success")
end})
misc:Button({Title="Unload hub",Icon="power",Callback=function()
    Window:Confirm({Title="Unload Prison Life hub?",Text="Stop scripts and remove highlights/UI.",
        Confirm="Unload",Callback=function()Window:Destroy()end})
end})

local priorCleanup=cleanup
cleanup=function()
    setLowGraphics(false)
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=initialFov end
    priorCleanup()
end

local Settings=Window:SettingsTab()
Settings:Button({Title="Restore lighting", Icon="rotate-ccw", Callback=function()
    for key,value in pairs(original) do Lighting[key]=value end
end})
Window:Notify({Title="Lyra Prison Life v1.1", Text="Combat, ESP, teams, gear, teleports and movement loaded.", Kind="success"})
return Window
