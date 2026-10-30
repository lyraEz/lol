-- Lyra Prison Life hub v1.7.1
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
    Title="Prison Life", Subtitle="lyraEz | hub v1.7.1",
    Theme="Lavender", ChatCommand="prison", ConfigFile="LyraUI/PrisonLife",
    Status="Ready",
    OnDestroy=function() alive=false;cleanup() end,
})
local Home = Window:Tab({Title="Overview", Icon="home"})
Home:Section("Prison Life", "Mobile-friendly utilities powered by Lyra UI.")
Home:Paragraph("Map positions follow the classic map. Game updates may change destinations.")
Home:Paragraph("v1.7: independent ESP labels, team filters, health bars and optional avatar headshots on the radar.")
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

-- ESP display options are independent: an outline-only configuration works
-- without creating invisible/empty text boxes over players.
local espEnabled=false
local espTeamOnly=false
local espRange=800
local espRefresh=0.25
local espItems={}
local espOptions={
    highlight=true,outline=true,fill=true,name=true,username=false,
    team=true,distance=true,health=true,healthBar=false,weapon=false,
    fontSize=13,fillOpacity=82,hideThroughWalls=false,compact=true,
    guards=true,inmates=true,criminals=true,neutral=true
}
local function clearItem(p)
    local entry=espItems[p]
    if not entry then return end
    if entry.highlight then entry.highlight:Destroy() end
    if entry.gui then entry.gui:Destroy() end
    espItems[p]=nil
end
local function clearEsp()
    for p in pairs(espItems) do clearItem(p) end
end
local function getTeamColor(p)
    local name=p.Team and p.Team.Name:lower() or ""
    if name:find("guard") or name:find("blue") then return Color3.fromRGB(110,169,255) end
    if name:find("criminal") or name:find("red") then return Color3.fromRGB(255,105,132) end
    if name:find("inmate") or name:find("prison") or name:find("orange") then
        return Color3.fromRGB(255,184,87)
    end
    return Color3.fromRGB(207,191,250)
end
local function makeEspEntry(p,model,head)
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
    gui.Size=UDim2.fromOffset(240,72)
    gui.StudsOffsetWorldSpace=Vector3.new(0,3.35,0)
    gui.AlwaysOnTop=true
    gui.MaxDistance=espRange
    gui.Parent=LocalPlayer:WaitForChild("PlayerGui")
    local txt=Instance.new("TextLabel")
    txt.Name="Fields"
    txt.BackgroundTransparency=1
    txt.TextStrokeTransparency=0.35
    txt.TextSize=13
    txt.Font=Enum.Font.GothamBold
    txt.TextWrapped=true
    txt.TextYAlignment=Enum.TextYAlignment.Center
    txt.Size=UDim2.new(1,0,1,-12)
    txt.Parent=gui
    local barBg=Instance.new("Frame")
    barBg.Name="HealthBarBack"
    barBg.AnchorPoint=Vector2.new(0.5,1)
    barBg.Position=UDim2.new(0.5,0,1,-4)
    barBg.Size=UDim2.new(0.68,0,0,5)
    barBg.BackgroundColor3=Color3.fromRGB(37,32,50)
    barBg.BorderSizePixel=0
    barBg.Parent=gui
    local barBackCorner=Instance.new("UICorner",barBg)
    barBackCorner.CornerRadius=UDim.new(1,0)
    local healthFill=Instance.new("Frame")
    healthFill.Name="HealthFill"
    healthFill.Size=UDim2.fromScale(1,1)
    healthFill.BackgroundColor3=Color3.fromRGB(94,235,165)
    healthFill.BorderSizePixel=0
    healthFill.Parent=barBg
    local healthCorner=Instance.new("UICorner",healthFill)
    healthCorner.CornerRadius=UDim.new(1,0)
    local entry={model=model,highlight=h,gui=gui,text=txt,bar=barBg,fill=healthFill}
    espItems[p]=entry
    return entry
end
local function espTeamAllowed(p)
    local name=p.Team and p.Team.Name:lower() or ""
    if name:find("guard") or name:find("blue") then return espOptions.guards end
    if name:find("criminal") or name:find("red") then return espOptions.criminals end
    if name:find("inmate") or name:find("prison") or name:find("orange") then
        return espOptions.inmates
    end
    return espOptions.neutral
end
local function updateEsp()
    local myRoot=getRoot()
    if not espEnabled or not myRoot then clearEsp();return end
    for _,p in ipairs(Players:GetPlayers())do
        local model=p.Character
        local hum=model and model:FindFirstChildOfClass("Humanoid")
        local root=model and model:FindFirstChild("HumanoidRootPart")
        local head=model and model:FindFirstChild("Head")
        local dist=root and (root.Position-myRoot.Position).Magnitude or math.huge
        if p==LocalPlayer or not hum or hum.Health<=0 or not head
            or not espTeamAllowed(p) or dist>espRange
            or (espTeamOnly and p.Team and p.Team==LocalPlayer.Team) then
            clearItem(p)
        else
            local entry=espItems[p]
            if entry and entry.model~=model then clearItem(p);entry=nil end
            if not entry then entry=makeEspEntry(p,model,head) end
            local color=getTeamColor(p)
            local opt=espOptions
            entry.highlight.Enabled=opt.highlight and (opt.fill or opt.outline)
            entry.highlight.DepthMode=opt.hideThroughWalls
                and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            entry.highlight.FillColor=color
            entry.highlight.OutlineColor=color
            entry.highlight.FillTransparency=opt.fill and opt.fillOpacity/100 or 1
            entry.highlight.OutlineTransparency=opt.outline and 0.06 or 1
            local fields={}
            if opt.name then table.insert(fields,p.DisplayName) end
            if opt.username then table.insert(fields,"@"..p.Name) end
            if opt.team then table.insert(fields,p.Team and p.Team.Name or "Neutral") end
            if opt.distance then table.insert(fields,math.floor(dist).." studs") end
            if opt.health then
                table.insert(fields,math.ceil(hum.Health).."/"..math.ceil(hum.MaxHealth).." HP")
            end
            if opt.weapon then
                local tool=model:FindFirstChildOfClass("Tool")
                if tool then table.insert(fields,tool.Name) end
            end
            local text=table.concat(fields,opt.compact and "  |  " or "\n")
            entry.text.Text=text
            entry.text.TextSize=opt.fontSize
            entry.text.TextColor3=color
            entry.text.Visible=#fields>0
            entry.bar.Visible=opt.healthBar
            entry.fill.Size=UDim2.fromScale(math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1),1)
            local fraction=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
            entry.fill.BackgroundColor3=Color3.fromRGB(
                math.floor(230*(1-fraction)+80*fraction),
                math.floor(83*(1-fraction)+226*fraction),100)
            entry.gui.MaxDistance=espRange
            entry.gui.AlwaysOnTop=not opt.hideThroughWalls
            entry.gui.Size=UDim2.fromOffset(240,opt.compact and 66 or 114)
            entry.gui.Enabled=entry.text.Visible or opt.healthBar
        end
    end
end

-- Combat tools use client camera and normally equipped tools; no remote interception.
local UIS=game:GetService("UserInputService")
local Camera=workspace.CurrentCamera
local combat={
    aim=false,hold=false,held=false,trigger=false,showCircle=true,
    radius=180,smooth=0.24,part="Head",wall=true,team=true,
    guards=true,inmates=true,criminals=true,triggerCooldown=0.22,
    maxDistance=800,selectedPlayer="",focusOnly=false,priority="Crosshair",
    sticky=false,lockedPlayer="",prediction=0}
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
local mobileAimButton
if UIS.TouchEnabled then
    mobileAimButton=Instance.new("TextButton")
    mobileAimButton.Name="MobileAimLock"
    mobileAimButton.Size=UDim2.fromOffset(104,46)
    mobileAimButton.Position=UDim2.new(1,-120,0.53,0)
    mobileAimButton.BackgroundColor3=Color3.fromRGB(38,29,59)
    mobileAimButton.BackgroundTransparency=0.08
    mobileAimButton.TextColor3=Color3.fromRGB(241,224,255)
    mobileAimButton.Font=Enum.Font.GothamBold
    mobileAimButton.TextSize=12
    mobileAimButton.Text="AIM: OFF"
    mobileAimButton.BorderSizePixel=0
    mobileAimButton.Visible=false
    mobileAimButton.Parent=combatGui
    local buttonCorner=Instance.new("UICorner",mobileAimButton)
    buttonCorner.CornerRadius=UDim.new(0,13)
    local buttonStroke=Instance.new("UIStroke",mobileAimButton)
    buttonStroke.Color=Color3.fromRGB(184,151,240)
    buttonStroke.Thickness=1.2
    Window:Connect(mobileAimButton.Activated,function()
        combat.held=not combat.held
        mobileAimButton.Text=combat.held and "AIM: ON" or "AIM: OFF"
        mobileAimButton.BackgroundColor3=combat.held
            and Color3.fromRGB(104,73,153) or Color3.fromRGB(38,29,59)
    end)
end
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
    if combat.focusOnly and (combat.selectedPlayer=="" or p.Name~=combat.selectedPlayer) then return false end
    local model=p.Character
    local hum=model and model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health>0
end
local function pointer()
    local cameraNow=workspace.CurrentCamera
    if UIS.TouchEnabled then
        return cameraNow.ViewportSize*0.5
    end
    local position=UIS:GetMouseLocation()
    return Vector2.new(position.X,position.Y)
end
local function visibleTarget(part,p,checkWalls)
    if checkWalls==false or (checkWalls==nil and not combat.wall) then return true end
    local cameraNow=workspace.CurrentCamera
    local ray=RaycastParams.new()
    ray.FilterType=Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances=LocalPlayer.Character and {LocalPlayer.Character} or {}
    ray.IgnoreWater=true
    local from=cameraNow.CFrame.Position
    local trace=workspace:Raycast(from,part.Position-from,ray)
    return not trace or (p.Character and trace.Instance:IsDescendantOf(p.Character))
end
local function closestTarget(maxDistance, radius, ignoreFov, checkWalls, bodyPart)
    local cameraNow=workspace.CurrentCamera
    if not cameraNow then return nil end
    local pointerPos=pointer()
    local nearest,best,bestPlayer=nil,radius or combat.radius,nil
    local ownRoot=getRoot()
    local bestScore=nil
    for _,p in ipairs(Players:GetPlayers()) do
        if legalTarget(p) then
            local model=p.Character
            local part=model and (model:FindFirstChild(bodyPart or combat.part) or model:FindFirstChild("HumanoidRootPart"))
            if part and ownRoot and (part.Position-ownRoot.Position).Magnitude<=(maxDistance or combat.maxDistance) then
                local worldDistance=(part.Position-ownRoot.Position).Magnitude
                local projected,onScreen=cameraNow:WorldToViewportPoint(part.Position)
                if ignoreFov or (onScreen and projected.Z>0) then
                    local distance=(Vector2.new(projected.X,projected.Y)-pointerPos).Magnitude
                    if (ignoreFov or distance<=(radius or combat.radius)) and visibleTarget(part,p,checkWalls) then
                        local humanoid=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                        local score=distance
                        if combat.priority=="Nearest" then score=worldDistance
                        elseif combat.priority=="Farthest" then score=-worldDistance
                        elseif combat.priority=="Lowest HP" then score=humanoid and humanoid.Health or math.huge
                        elseif combat.priority=="Highest HP" then score=-(humanoid and humanoid.Health or 0) end
                        if combat.sticky and p.Name==combat.lockedPlayer then score=score-1000000 end
                        if bestScore==nil or score<bestScore then
                            bestScore=score
                            best=distance
                            bestPlayer=p
                            nearest=part
                        end
                    end
                end
            end
        end
    end
    combat.lockedPlayer=(combat.sticky and bestPlayer and bestPlayer.Name) or ""
    return nearest,best
end

-- Silent aim: redirects the bullet data of legitimate ShootEvent calls only.
-- The hook stays dormant when disabled; unsupported executors keep regular gun behavior.
local silent={enabled=false,hitChance=95,available=false,reason="Not initialized",
    maxDistance=800,radius=180,prediction=0,ignoreFov=false,wall=true,part="Head"}
local function equippedFirearm()
    local char=LocalPlayer.Character
    if not char then return nil end
    for _,tool in ipairs(char:GetChildren())do
        if tool:IsA("Tool") and (tool:FindFirstChild("GunStates",true)
            or tool:FindFirstChild("GunInterface",true)
            or tool:GetAttribute("StoredAmmo")~=nil
            or tool:GetAttribute("CurrentAmmo")~=nil
            or tool:GetAttribute("Behavior")~=nil) then return tool end
    end
end
local function startSilentHook()
    local remoteEvent=game:GetService("ReplicatedStorage"):FindFirstChild("GunRemotes") and game:GetService("ReplicatedStorage").GunRemotes:FindFirstChild("ShootEvent")
    if not remoteEvent or not remoteEvent:IsA("RemoteEvent") then
        return false,"ShootEvent remote is missing"
    end
    if type(hookmetamethod)~="function" or type(getnamecallmethod)~="function" then
        return false,"Executor doesn't support namecall hooks"
    end
    local global=type(getgenv)=="function" and getgenv() or _G
    local controller=global.LyraPrisonSilentController
    if type(controller)~="table" or controller.version~=3 then
        if type(controller)=="table" and type(controller.enable)=="function" then
            pcall(function()controller.enable(false)end)
        end
        controller={version=3,enabled=false,target=nil,chance=95,remote=remoteEvent,
            observed=0,adjusted=0,unsupported=0,errors=0,consecutiveErrors=0,
            lastFormat="none",lastTarget="none",lastError="none"}
        local oldNamecall
        local function rewriteShot(value,hitPart,hitPosition,depth)
            if type(value)~="table" or depth>4 then return value,0,nil end
            local copy={}
            for key,item in pairs(value)do copy[key]=item end
            -- Current GunRemotes protocol: {originVector3, hitPositionVector3, hitPart}.
            if typeof(value[1])=="Vector3" and typeof(value[2])=="Vector3"
                and typeof(value[3])=="Instance" and value[3]:IsA("BasePart") then
                copy[2]=hitPosition
                copy[3]=hitPart
                return copy,1,"vector-triple"
            end
            -- Older Prison Life remotes: {RayObject=Ray, Hit=BasePart, ...}.
            if typeof(value.RayObject)=="Ray" and typeof(value.Hit)=="Instance"
                and value.Hit:IsA("BasePart") then
                local oldRay=value.RayObject
                local origin=typeof(oldRay)=="Ray" and oldRay.Origin
                    or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)
                    or hitPosition
                local direction=hitPosition-origin
                if direction.Magnitude>0.01 then
                    copy.RayObject=Ray.new(origin,direction.Unit*math.max(direction.Magnitude,1000))
                    copy.Hit=hitPart
                    if value.Distance~=nil then copy.Distance=direction.Magnitude end
                    if value.Cframe~=nil then copy.Cframe=CFrame.lookAt(hitPosition,hitPosition+direction.Unit) end
                    return copy,1,"legacy-ray"
                end
            end
            local changed=0
            local detected=nil
            for key,item in pairs(value)do
                if type(item)=="table" then
                    local result,count,kind=rewriteShot(item,hitPart,hitPosition,depth+1)
                    if count>0 then
                        copy[key]=result
                        changed=changed+count
                        detected=kind
                    end
                end
            end
            return copy,changed,detected
        end
        local function interception(self,...)
            if self~=controller.remote or not controller.enabled
                or getnamecallmethod()~="FireServer"
                or (type(checkcaller)=="function" and checkcaller()) then
                return oldNamecall(self,...)
            end
            -- Never let a Lua error in target selection or payload rewriting
            -- interrupt the original weapon FireServer call.
            local original=table.pack(...)
            controller.observed=controller.observed+1
            local changedArgs=nil
            local ok,err=pcall(function()
                if type(original[1])~="table" then
                    controller.unsupported=controller.unsupported+1
                    controller.lastFormat="non-table payload"
                    return
                end
                if math.random(100)>controller.chance then return end
                local part=type(controller.target)=="function" and controller.target() or nil
                if not part or not part:IsA("BasePart") or not part.Parent then return end
                local destination=part.Position+part.AssemblyLinearVelocity*(controller.prediction or 0)
                if typeof(destination)~="Vector3" then return end
                local modified,count,format=rewriteShot(original[1],part,destination,0)
                if count>0 then
                    changedArgs=table.clone(original)
                    changedArgs[1]=modified
                    controller.lastFormat=format or "unknown"
                    controller.lastTarget=part.Parent.Name
                else
                    controller.unsupported=controller.unsupported+1
                    controller.lastFormat="unsupported payload"
                end
            end)
            if not ok then
                controller.errors=controller.errors+1
                controller.consecutiveErrors=controller.consecutiveErrors+1
                controller.lastError=tostring(err):sub(1,180)
                if controller.consecutiveErrors>=3 then
                    controller.enabled=false
                    controller.lastFormat="auto-bypass after errors"
                end
                return oldNamecall(self,table.unpack(original,1,original.n))
            end
            controller.consecutiveErrors=0
            if changedArgs then
                controller.adjusted=controller.adjusted+1
                return oldNamecall(self,table.unpack(changedArgs,1,changedArgs.n))
            end
            return oldNamecall(self,table.unpack(original,1,original.n))
        end
        local wrapped=type(newcclosure)=="function" and newcclosure(interception) or interception
        local ok,prior=pcall(function()return hookmetamethod(game,"__namecall",wrapped)end)
        if not ok or type(prior)~="function" then
            return false,ok and "Hook did not return a valid original function" or tostring(prior)
        end
        oldNamecall=prior
        controller.enable=function(value) controller.enabled=value end
        global.LyraPrisonSilentController=controller
    end
    controller.remote=remoteEvent
    controller.target=function()
        if not alive or not silent.enabled then return nil end
        return closestTarget(silent.maxDistance, silent.radius, silent.ignoreFov, silent.wall, silent.part)
    end
    controller.chance=silent.hitChance
    controller.prediction=silent.prediction
    controller.enable(true)
    silent.available=true
    silent.reason="ready"
    return true,"ready"
end

local CombatTab=Window:Tab({Title="Combat",Icon="crosshair"})
CombatTab:Section("Aim assist", "Client-side aim assistance. Camera tracking never changes shot data.")
CombatTab:Section("Silent aim", "PC and mobile: follows weapon ShootEvent rather than mouse clicks. Requires executor hook support.")
CombatTab:Toggle({Title="Enable silent aim",Flag="pl_combat_silent",Callback=function(value)
    if not value then
        silent.enabled=false
        local g=type(getgenv)=="function" and getgenv() or _G
        if g.LyraPrisonSilentController then g.LyraPrisonSilentController.enable(false) end
        Window:Status("Silent aim disabled","info")
        return
    end
    silent.enabled=true
    local ok,why=startSilentHook()
    if not ok then
        silent.enabled=false
        if not silent.lastWarning or os.clock()-silent.lastWarning>15 then
            silent.lastWarning=os.clock()
            Window:Notify({Title="Silent aim unavailable",Text=tostring(why),Kind="warning",Duration=6})
        else
            Window:Status("Silent aim unavailable: "..tostring(why),"warning")
        end
        task.defer(function()if alive then Window:SetFlag("pl_combat_silent",false)end end)
    else Window:Status("Silent hook installed. Fire your weapon to verify observed/changed shots.","success")end
end})
CombatTab:Slider({Title="Silent hit chance",Min=1,Max=100,Default=95,Suffix="%",
    Flag="pl_combat_hitchance",Callback=function(value)
        silent.hitChance=value
        local g=type(getgenv)=="function" and getgenv() or _G
        if g.LyraPrisonSilentController then g.LyraPrisonSilentController.chance=value end
    end})

CombatTab:Dropdown({Title="Silent target part",Options={"Head","HumanoidRootPart"},
    Default="Head",Flag="pl_silent_part",Callback=function(v)silent.part=v end})
CombatTab:Toggle({Title="Silent aim 360 (ignore FOV)",Flag="pl_silent_anywhere",
    Description="Ignore screen FOV, but still respect distance, team and priority.",
    Callback=function(v)silent.ignoreFov=v end})
CombatTab:Toggle({Title="Silent aim wall check",Default=true,Flag="pl_silent_wall",
    Callback=function(v)silent.wall=v end})
CombatTab:Slider({Title="Movement prediction",Min=0,Max=30,Default=0,Suffix=" / 100 s",
    Flag="pl_silent_prediction",Callback=function(v)
        silent.prediction=v/100
        local env=type(getgenv)=="function" and getgenv() or _G
        if env.LyraPrisonSilentController and env.LyraPrisonSilentController.version==3 then
            env.LyraPrisonSilentController.prediction=silent.prediction
        end
    end})
CombatTab:Button({Title="Emergency: restore normal shooting",Icon="refresh-cw",
    Description="Immediately disables silent interception. Original shots pass untouched.",
    Callback=function()
        local env=type(getgenv)=="function" and getgenv() or _G
        local hook=env.LyraPrisonSilentController
        silent.enabled=false
        if hook and type(hook.enable)=="function" then hook.enable(false)end
        Window:SetFlag("pl_combat_silent",false)
        Window:Notify({Title="Normal shooting",Text="Silent aim disabled; original weapon calls are unchanged.",Kind="success"})
    end})
CombatTab:Section("Silent aim diagnostics",
    "Observed means a game shot reached the hook. Adjusted means bullet data changed, not that the server registered damage.")
local shotStatus=CombatTab:Label("Enable silent aim, equip a gun and fire to inspect shot interception.")
CombatTab:Button({Title="Refresh shot diagnostics",Icon="refresh-cw",Callback=function()
    local env=type(getgenv)=="function" and getgenv() or _G
    local hook=env.LyraPrisonSilentController
    if not hook or hook.version~=2 then
        shotStatus:Set("Hook not installed in this session.")
        return
    end
    shotStatus:Set("Observed: "..tostring(hook.observed or 0)
        .." | adjusted: "..tostring(hook.adjusted or 0)
        .." | unsupported: "..tostring(hook.unsupported or 0)
        .." | format: "..tostring(hook.lastFormat or "none"))
end})
local shotStatusElapsed=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    shotStatusElapsed=shotStatusElapsed+dt
    if shotStatusElapsed<1.5 then return end
    shotStatusElapsed=0
    local env=type(getgenv)=="function" and getgenv() or _G
    local hook=env.LyraPrisonSilentController
    if hook and hook.version==3 and silent.enabled then
        shotStatus:Set("Shots: "..tostring(hook.observed or 0)
            .." | changed: "..tostring(hook.adjusted or 0)
            .." | unknown: "..tostring(hook.unsupported or 0)
            .." | payload: "..tostring(hook.lastFormat or "-"))
    end
end)

CombatTab:Toggle({Title="Enable camera aim",Flag="pl_combat_aim",Callback=function(v)combat.aim=v end})
CombatTab:Toggle({Title="Hold E / RMB or mobile AIM button",Flag="pl_combat_hold",
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
CombatTab:Section("Target selection", "Separate maximum ranges for aim and silent aim; shared priority and player focus.")
CombatTab:Toggle({Title="Sticky target",Flag="pl_target_sticky",
    Description="Prefer the same valid player until they leave range or are eliminated.",
    Callback=function(v)
        combat.sticky=v
        if not v then combat.lockedPlayer="" end
    end})
CombatTab:Slider({Title="Camera aim prediction",Min=0,Max=25,Default=0,Suffix=" / 100 s",
    Flag="pl_aim_prediction",Callback=function(v)combat.prediction=v/100 end})

CombatTab:Slider({Title="Aimbot max distance",Min=50,Max=2500,Default=800,Suffix=" studs",
    Flag="pl_aim_world_range",Callback=function(v)combat.maxDistance=v end})
CombatTab:Slider({Title="Silent max distance",Min=50,Max=2500,Default=800,Suffix=" studs",
    Flag="pl_silent_world_range",Callback=function(v)silent.maxDistance=v end})
CombatTab:Slider({Title="Silent FOV radius",Min=30,Max=500,Default=180,Suffix=" px",
    Flag="pl_silent_radius",Callback=function(v)silent.radius=v end})
CombatTab:Dropdown({Title="Target priority",
    Options={"Crosshair","Nearest","Farthest","Lowest HP","Highest HP"},
    Default="Crosshair",Flag="pl_target_priority",
    Callback=function(v)combat.priority=v end})
local focusOptions={"Auto (all players)"}
local playerFocus=CombatTab:Dropdown({Title="Focused player",Options=focusOptions,
    Default=focusOptions[1],Flag="pl_target_focus",
    Callback=function(label)
        combat.selectedPlayer=(label=="Auto (all players)" and "" or label)
    end})
local function refreshFocusList()
    local names={"Auto (all players)"}
    for _,p in ipairs(Players:GetPlayers())do
        if p~=LocalPlayer then table.insert(names,p.Name)end
    end
    table.sort(names,function(a,b)
        if a=="Auto (all players)" then return true end
        if b=="Auto (all players)" then return false end
        return a:lower()<b:lower()
    end)
    playerFocus:SetOptions(names,true)
    if combat.selectedPlayer~="" and not Players:FindFirstChild(combat.selectedPlayer) then
        combat.selectedPlayer=""
        playerFocus:Set("Auto (all players)")
    end
    Window:Status("Player list updated: "..(#names-1).." players","info")
end
CombatTab:Button({Title="Refresh player dropdown",Icon="refresh-cw",
    Callback=refreshFocusList})
CombatTab:Toggle({Title="Target only focused player",Flag="pl_focus_only",
    Description="When on, Auto means no valid target until you pick a player.",
    Callback=function(v)combat.focusOnly=v end})
Window:Connect(Players.PlayerAdded,function()task.defer(refreshFocusList)end)
Window:Connect(Players.PlayerRemoving,function()task.defer(refreshFocusList)end)
refreshFocusList()
local focusStatus=CombatTab:Label("Focus: Auto | Priority: Crosshair")
local focusUpdate=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    focusUpdate=focusUpdate+dt
    if focusUpdate<0.75 then return end
    focusUpdate=0
    if combat.selectedPlayer=="" then
        focusStatus:Set("Focus: Auto | Priority: "..combat.priority)
        return
    end
    local p=Players:FindFirstChild(combat.selectedPlayer)
    local r=p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    local h=p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
    local mine=getRoot()
    if not p or not r or not h or not mine then
        focusStatus:Set("Focus @"..combat.selectedPlayer..": unavailable")
    else
        focusStatus:Set("Focus @"..p.Name.." | "..math.floor((r.Position-mine.Position).Magnitude)
            .." studs | "..math.floor(h.Health).." HP")
    end
end)

CombatTab:Section("Team filter", "Choose which teams can be targeted.")
CombatTab:Toggle({Title="Guards",Default=true,Flag="pl_target_guards",Callback=function(v)combat.guards=v end})
CombatTab:Toggle({Title="Inmates",Default=true,Flag="pl_target_inmates",Callback=function(v)combat.inmates=v end})
CombatTab:Toggle({Title="Criminals",Default=true,Flag="pl_target_criminals",Callback=function(v)combat.criminals=v end})
local lastActivation=0
local aimPartCache=nil
local aimDistCache=nil
local aimScanElapsed=0
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
    if mobileAimButton then
        mobileAimButton.Visible=combat.aim and combat.hold and not Window.Visible
    end
    fovCircle.Visible=combat.showCircle and (combat.aim or combat.trigger or silent.enabled) and not Window.Visible
    if fovCircle.Visible then
        local point=pointer()
        local visualRadius=math.min((silent.enabled and not combat.aim and not combat.trigger) and silent.radius or combat.radius,240)
        fovCircle.Size=UDim2.fromOffset(visualRadius*2,visualRadius*2)
        fovCircle.Position=UDim2.fromOffset(point.X,point.Y)
    end
    if not (combat.aim or combat.trigger) or (combat.hold and not combat.held) then return end
    aimScanElapsed=aimScanElapsed+dt
    if aimScanElapsed>=0.07 or (aimPartCache and not aimPartCache.Parent) then
        aimScanElapsed=0
        aimPartCache,aimDistCache=closestTarget()
    end
    local part,distance=aimPartCache,aimDistCache
    if not part or not part.Parent then return end
    if combat.aim then
        local predicted=part.Position+part.AssemblyLinearVelocity*combat.prediction
        local destination=CFrame.lookAt(cameraNow.CFrame.Position,predicted)
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
TeamESP:Slider({Title="ESP refresh",Min=2,Max=12,Default=4,Suffix=" fps",
    Flag="pl_esp_refresh",Callback=function(v)espRefresh=1/v end})
TeamESP:Section("What to display", "Each option is independent. Keep only highlights or combine as many fields as you like.")
TeamESP:Toggle({Title="Character highlights",Default=true,Flag="pl_esp_highlight",
    Callback=function(v)espOptions.highlight=v end})
TeamESP:Toggle({Title="Highlight outlines",Default=true,Flag="pl_esp_outlines",
    Callback=function(v)espOptions.outline=v end})
TeamESP:Toggle({Title="Highlight fill",Default=true,Flag="pl_esp_fill",
    Callback=function(v)espOptions.fill=v end})
TeamESP:Toggle({Title="Player display names",Default=true,Flag="pl_esp_names",
    Callback=function(v)espOptions.name=v end})
TeamESP:Toggle({Title="Username (@user)",Flag="pl_esp_usernames",
    Callback=function(v)espOptions.username=v end})
TeamESP:Toggle({Title="Team names",Default=true,Flag="pl_esp_teams",
    Callback=function(v)espOptions.team=v end})
TeamESP:Toggle({Title="Distance in studs",Default=true,Flag="pl_esp_distance",
    Callback=function(v)espOptions.distance=v end})
TeamESP:Toggle({Title="Health numbers",Default=true,Flag="pl_esp_health",
    Callback=function(v)espOptions.health=v end})
TeamESP:Toggle({Title="Health bars",Flag="pl_esp_healthbar",
    Callback=function(v)espOptions.healthBar=v end})
TeamESP:Toggle({Title="Equipped tool name",Flag="pl_esp_equipped",
    Callback=function(v)espOptions.weapon=v end})
TeamESP:Section("Team filters", "Show or hide each team separately.")
TeamESP:Toggle({Title="Show Guards",Default=true,Flag="pl_esp_filter_guards",
    Callback=function(v)espOptions.guards=v end})
TeamESP:Toggle({Title="Show Inmates",Default=true,Flag="pl_esp_filter_inmates",
    Callback=function(v)espOptions.inmates=v end})
TeamESP:Toggle({Title="Show Criminals",Default=true,Flag="pl_esp_filter_criminals",
    Callback=function(v)espOptions.criminals=v end})
TeamESP:Toggle({Title="Show neutral players",Default=true,Flag="pl_esp_filter_neutral",
    Callback=function(v)espOptions.neutral=v end})
TeamESP:Section("Appearance", "Control visual density, opacity and visibility.")
TeamESP:Toggle({Title="Compact one-line labels",Default=true,Flag="pl_esp_compact",
    Callback=function(v)espOptions.compact=v end})
TeamESP:Toggle({Title="Hide ESP behind walls",Flag="pl_esp_occluded",
    Description="Applies occlusion to highlights. Text labels remain visible if enabled.",
    Callback=function(v)espOptions.hideThroughWalls=v end})
TeamESP:Slider({Title="Label font size",Min=9,Max=19,Default=13,Suffix=" px",
    Flag="pl_esp_font",Callback=function(v)espOptions.fontSize=v end})
TeamESP:Slider({Title="Highlight fill transparency",Min=0,Max=100,Default=82,Suffix="%",
    Flag="pl_esp_opacity",Callback=function(v)espOptions.fillOpacity=v end})
TeamESP:ButtonRow({
    {Title="Highlights only",Icon="eye",Callback=function()
        for _,pair in ipairs({
            {"pl_esp_highlight",true},{"pl_esp_outlines",true},{"pl_esp_fill",true},
            {"pl_esp_names",false},{"pl_esp_usernames",false},{"pl_esp_teams",false},
            {"pl_esp_distance",false},{"pl_esp_health",false},
            {"pl_esp_healthbar",false},{"pl_esp_equipped",false}
        })do Window:SetFlag(pair[1],pair[2])end
        Window:SetFlag("prison_team_esp",true)
    end},
    {Title="All details",Icon="users",Callback=function()
        for _,name in ipairs({"pl_esp_highlight","pl_esp_outlines","pl_esp_fill",
            "pl_esp_names","pl_esp_usernames","pl_esp_teams","pl_esp_distance",
            "pl_esp_health","pl_esp_healthbar","pl_esp_equipped"})do
            Window:SetFlag(name,true)
        end
        Window:SetFlag("prison_team_esp",true)
    end}
})
TeamESP:Button({Title="Disable ESP and clear objects",Icon="trash",Callback=function()
    Window:SetFlag("prison_team_esp",false)
    espEnabled=false
    clearEsp()
end})
local lastEsp=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    lastEsp=lastEsp+dt
    if lastEsp>=espRefresh then lastEsp=0;updateEsp() end
end)
Window:Connect(Players.PlayerRemoving,clearItem)
cleanup=function()
    silent.enabled=false
    local shared=type(getgenv)=="function" and getgenv() or _G
    if shared.LyraPrisonSilentController then
        pcall(function()shared.LyraPrisonSilentController.enable(false)end)
    end
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
local weaponChoices={"M9","Remington 870","AK-47","MP5","M4A1","Taser",
    "FAL","M700","Revolver","C4 Explosive","Riot Shield","Lunch","Hammer","Crude Knife"}
local selectedWeapon="M9"
local function findItem(name)
    local items=workspace:FindFirstChild("Prison_ITEMS")
    local giver=items and items:FindFirstChild("giver")
    if not giver then return nil end
    local root=getRoot()
    local chosen,distance=nil,math.huge
    for _,child in ipairs(giver:GetChildren())do
        if child.Name:lower()==name:lower() then
            local part=child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart",true)
            local value=(root and part) and (root.Position-part.Position).Magnitude or 0
            if value<distance then chosen,distance=child,value end
        end
    end
    return chosen
end
local function inventoryHas(name)
    local backpack=LocalPlayer:FindFirstChild("Backpack")
    local char=LocalPlayer.Character
    return (backpack and backpack:FindFirstChild(name)) or (char and char:FindFirstChild(name))
end
local pickupBusy=false
local function requestItem(name)
    if inventoryHas(name) then
        Window:Status(name.." already in your inventory","success")
        return true
    end
    local giver=findItem(name)
    if not giver then
        Window:Notify({Title="Weapon spawn missing",Text=name.." is not currently loaded.",Kind="warning"})
        return false
    end
    if pickupBusy then
        Window:Status("Another pickup is in progress. Try again shortly.","warning")
        return false
    end
    pickupBusy=true
    task.spawn(function()
        local pickup=giver:FindFirstChild("ITEMPICKUP",true)
        local handler=remote("ItemHandler")
        local mode="proximity"
        local oldRoot=getRoot()
        local returnPosition=oldRoot and oldRoot.CFrame
        local success=true
        if pickup and handler and handler:IsA("RemoteFunction") then
            mode="remote"
            success=pcall(function()handler:InvokeServer(pickup)end)
        else
            local part=giver:IsA("BasePart") and giver or giver:FindFirstChildWhichIsA("BasePart",true)
            if not part then
                Window:Status(name..": no pickup part found","warning")
                pickupBusy=false
                return
            end
            local root=getRoot()
            if not root then
                Window:Status("Spawn your character before requesting items","warning")
                pickupBusy=false
                return
            end
            local offset=root.Position-part.Position
            local flat=Vector3.new(offset.X,0,offset.Z)
            local towardPlayer=flat.Magnitude>0.01 and flat.Unit or Vector3.new(0,0,1)
            root.CFrame=CFrame.new(part.Position+towardPlayer*1.6+Vector3.new(0,2,0))
            root.AssemblyLinearVelocity=Vector3.zero
            task.wait(0.25)
            local prompt=giver:FindFirstChildWhichIsA("ProximityPrompt",true)
            local click=giver:FindFirstChildWhichIsA("ClickDetector",true)
            if prompt and prompt.Enabled then
                if type(fireproximityprompt)=="function" then
                    pcall(fireproximityprompt,prompt)
                else
                    pcall(function()
                        prompt:InputHoldBegin()
                        task.wait(math.max(prompt.HoldDuration,0.1))
                        prompt:InputHoldEnd()
                    end)
                end
            elseif click and type(fireclickdetector)=="function" then
                pcall(fireclickdetector,click)
            elseif type(firetouchinterest)=="function" then
                pcall(function()
                    firetouchinterest(root,part,0)
                    task.wait(0.15)
                    firetouchinterest(root,part,1)
                end)
            end
        end
        local deadline=os.clock()+2.2
        while alive and not inventoryHas(name) and os.clock()<deadline do task.wait(0.12) end
        local delivered=inventoryHas(name)~=nil
        if mode=="proximity" and returnPosition and oldRoot and oldRoot.Parent then
            oldRoot.CFrame=returnPosition
        end
        pickupBusy=false
        if not alive then return end
        if delivered then
            Window:Notify({Title="Weapon received",Text=name.." is now in inventory.",Kind="success"})
        else
            Window:Notify({Title="Weapon not received",Text=name.." ("..mode.."). The server may require proximity, team or a gamepass.",Kind="warning"})
        end
    end)
    return true
end
local function requestStarterWeapons()
    task.spawn(function()
        for _,name in ipairs({"M9","Remington 870","AK-47"})do
            if not alive then return end
            while alive and pickupBusy do task.wait(0.15)end
            if not alive then return end
            requestItem(name)
            task.wait(0.2)
        end
    end)
end
TeamTools:Section("Weapons & items","Only items present in the live map. Paid equipment still requires ownership.")
TeamTools:Button({Title="Diagnose weapon availability",Icon="refresh-cw",Callback=function()
    local container=workspace:FindFirstChild("Prison_ITEMS")
    local giver=container and container:FindFirstChild("giver")
    local handler=remote("ItemHandler")
    local available=0
    if giver then for _,obj in ipairs(giver:GetChildren())do
        if obj:FindFirstChild("ITEMPICKUP",true) then available=available+1 end
    end end
    Window:Notify({Title="Weapon system",
        Text="Remote: "..(handler and handler.ClassName or "missing")..
             " | item giver: "..(giver and "present" or "missing")..
             " | pickup points: "..available,
        Kind=handler and giver and "info" or "warning",Duration=9})
end})
local weaponDropdown=TeamTools:Dropdown({Title="Weapon",Options=weaponChoices,Default="M9",
    Flag="pl_item",Callback=function(v)selectedWeapon=v end})
TeamTools:Button({Title="Refresh available weapons",Icon="refresh-cw",Callback=function()
    local options,seen={},{}
    local giver=workspace:FindFirstChild("Prison_ITEMS")
    giver=giver and giver:FindFirstChild("giver")
    if giver then
        for _,obj in ipairs(giver:GetChildren())do
            if not seen[obj.Name]then seen[obj.Name]=true;table.insert(options,obj.Name)end
        end
    end
    local backpack=LocalPlayer:FindFirstChild("Backpack")
    for _,container in ipairs({backpack,LocalPlayer.Character})do
        if container then
            for _,obj in ipairs(container:GetChildren())do
                if obj:IsA("Tool") and not seen[obj.Name]then
                    seen[obj.Name]=true;table.insert(options,obj.Name)
                end
            end
        end
    end
    if #options==0 then
        Window:Status("No weapon entries currently loaded","warning")
        return
    end
    table.sort(options)
    weaponDropdown:SetOptions(options,false)
    selectedWeapon=weaponDropdown:Get() or options[1]
    Window:Status("Found "..#options.." available item names","success")
end})
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
    Callback=requestStarterWeapons})
local autoGear=false
TeamTools:Toggle({Title="Get starter weapons after respawn",Flag="pl_autogear",
    Callback=function(v)autoGear=v end})
Window:Connect(LocalPlayer.CharacterAdded,function()
    if autoGear then
        task.delay(2,function()if alive then requestStarterWeapons()end end)
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
    if not module or not module:IsA("ModuleScript") then return false,"GunStates missing" end
    local ok,config=pcall(require,module)
    if not ok or type(config)~="table" then return false,"GunStates require failed" end
    if not originalGunStates[module]then
        local copy={}
        for k,v in pairs(config)do copy[k]=v end
        originalGunStates[module]=copy
    end
    if customGun then
        local mods={Spread=0,ReloadTime=0.1,FireRate=0.065,AutoFire=true,
            Range=5000,MaxAmmo=999,CurrentAmmo=999,StoredAmmo=999}
        for key,newValue in pairs(mods)do
            local oldValue=originalGunStates[module][key]
            if oldValue~=nil and type(oldValue)==type(newValue) then config[key]=newValue end
        end
    else
        for k,v in pairs(originalGunStates[module])do config[k]=v end
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
local radar={on=false,range=500,size=170,position="Top right",dots={},last=0,
    showAllies=true,showNames=false,showAvatars=true,showDistances=false,
    showTeams=false,nameFormat="Display name",avatarSize=23,rotate=true,
    showWithHub=false,dotSize=7,refresh=0.0833,emphasizeFocus=true,
    guards=true,inmates=true,criminals=true,neutral=true}
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
radarFrame.Size=UDim2.fromOffset(170,170)
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
radarFrame.Active=true
radarFrame.ClipsDescendants=true
local function radarRing(scale)
    local circle=Instance.new("Frame")
    circle.Name="RangeRing"
    circle.AnchorPoint=Vector2.new(0.5,0.5)
    circle.Position=UDim2.fromScale(0.5,0.5)
    circle.Size=UDim2.fromScale(scale,scale)
    circle.BackgroundTransparency=1
    circle.BorderSizePixel=0
    circle.ZIndex=2
    circle.Parent=radarFrame
    local round=Instance.new("UICorner",circle)
    round.CornerRadius=UDim.new(1,0)
    local stroke=Instance.new("UIStroke",circle)
    stroke.Color=Color3.fromRGB(151,119,199)
    stroke.Thickness=1
    stroke.Transparency=0.72
end
radarRing(0.47)
radarRing(0.85)
local horizontal=Instance.new("Frame")
horizontal.Size=UDim2.new(0.84,0,0,1)
horizontal.Position=UDim2.fromScale(0.08,0.5)
horizontal.BorderSizePixel=0
horizontal.BackgroundColor3=Color3.fromRGB(164,142,197)
horizontal.BackgroundTransparency=0.83
horizontal.ZIndex=2
horizontal.Parent=radarFrame
local vertical=Instance.new("Frame")
vertical.Size=UDim2.new(0,1,0.84,0)
vertical.Position=UDim2.fromScale(0.5,0.08)
vertical.BorderSizePixel=0
vertical.BackgroundColor3=Color3.fromRGB(164,142,197)
vertical.BackgroundTransparency=0.83
vertical.ZIndex=2
vertical.Parent=radarFrame
local radarRangeLabel=Instance.new("TextLabel")
radarRangeLabel.Name="RangeText"
radarRangeLabel.Position=UDim2.new(0.06,0,1,-20)
radarRangeLabel.Size=UDim2.new(0.9,0,0,16)
radarRangeLabel.BackgroundTransparency=1
radarRangeLabel.TextXAlignment=Enum.TextXAlignment.Left
radarRangeLabel.Font=Enum.Font.Gotham
radarRangeLabel.TextSize=10
radarRangeLabel.TextColor3=Color3.fromRGB(197,183,218)
radarRangeLabel.Text="Range: 500"
radarRangeLabel.ZIndex=5
radarRangeLabel.Parent=radarFrame

radarFrame.Visible=false
local RadarTab=Window:Tab({Title="Radar",Icon="radar"})
RadarTab:Section("Team radar","Real-time relative positions on a mobile-friendly map overlay.")
RadarTab:Toggle({Title="Show radar",Flag="pl_radar",Callback=function(v)
    radar.on=v
    radarFrame.Visible=v
end})
RadarTab:Slider({Title="Radar range",Min=100,Max=2500,Default=500,Suffix=" studs",
    Flag="pl_radar_range",Callback=function(v)radar.range=v;radarRangeLabel.Text="Range: "..v.." studs" end})
RadarTab:Slider({Title="Radar size",Min=110,Max=260,Default=170,Suffix=" px",
    Flag="pl_radar_size",Callback=function(v)
        radar.size=v
        radarFrame.Size=UDim2.fromOffset(v,v)
    end})
RadarTab:Section("Display", "Choose the radar layout without covering the game controls.")
RadarTab:Toggle({Title="Show teammates",Default=true,Flag="pl_radar_allies",
    Callback=function(v)radar.showAllies=v end})
RadarTab:Toggle({Title="Player names on radar",Flag="pl_radar_names",
    Description="When off, no name is shown, including focused players.",
    Callback=function(v)radar.showNames=v end})
RadarTab:Dropdown({Title="Player name format",
    Options={"Display name","Username","Both"},Default="Display name",
    Flag="pl_radar_name_format",Callback=function(v)radar.nameFormat=v end})
RadarTab:Toggle({Title="Show player headshots",Default=true,Flag="pl_radar_avatars",
    Description="Use Roblox avatar thumbnails instead of plain team dots.",
    Callback=function(v)radar.showAvatars=v end})
RadarTab:Toggle({Title="Show distances",Flag="pl_radar_distances",
    Callback=function(v)radar.showDistances=v end})
RadarTab:Toggle({Title="Show team in label",Flag="pl_radar_team_names",
    Callback=function(v)radar.showTeams=v end})
RadarTab:Toggle({Title="Highlight focused player",Default=true,Flag="pl_radar_focus_emphasis",
    Callback=function(v)radar.emphasizeFocus=v end})
RadarTab:Slider({Title="Headshot size",Min=16,Max=36,Default=23,Suffix=" px",
    Flag="pl_radar_avatar_size",Callback=function(v)radar.avatarSize=v end})
RadarTab:Section("Team filter", "Choose which teams appear on the map.")
RadarTab:Toggle({Title="Guards on radar",Default=true,Flag="pl_radar_guards",
    Callback=function(v)radar.guards=v end})
RadarTab:Toggle({Title="Inmates on radar",Default=true,Flag="pl_radar_inmates",
    Callback=function(v)radar.inmates=v end})
RadarTab:Toggle({Title="Criminals on radar",Default=true,Flag="pl_radar_criminals",
    Callback=function(v)radar.criminals=v end})
RadarTab:Toggle({Title="Neutral players on radar",Default=true,Flag="pl_radar_neutral",
    Callback=function(v)radar.neutral=v end})
RadarTab:Section("Radar behavior", "Control orientation, dragging and overlay visibility.")
RadarTab:Toggle({Title="Rotate with camera",Default=true,Flag="pl_radar_rotate",
    Callback=function(v)radar.rotate=v end})
RadarTab:Toggle({Title="Keep radar visible with hub",Flag="pl_radar_overui",
    Callback=function(v)radar.showWithHub=v end})
RadarTab:Slider({Title="Marker size",Min=4,Max=13,Default=7,Suffix=" px",
    Flag="pl_radar_marker",Callback=function(v)radar.dotSize=v end})
RadarTab:Slider({Title="Radar refresh",Min=8,Max=30,Default=12,Suffix=" fps",
    Flag="pl_radar_refresh",Callback=function(v)radar.refresh=1/v end})
RadarTab:ButtonRow({
    {Title="Headshots only",Icon="user",Callback=function()
        Window:SetFlag("pl_radar_avatars",true)
        Window:SetFlag("pl_radar_names",false)
        Window:SetFlag("pl_radar_distances",false)
        Window:SetFlag("pl_radar_team_names",false)
    end},
    {Title="Classic dots",Icon="server",Callback=function()
        Window:SetFlag("pl_radar_avatars",false)
        Window:SetFlag("pl_radar_names",false)
        Window:SetFlag("pl_radar_distances",false)
        Window:SetFlag("pl_radar_team_names",false)
    end}
})
RadarTab:Paragraph("Blue = guards  |  Orange = inmates  |  Red = criminals. The bright marker shows your focused player.")

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
-- Drag the radar on PC or Android. Changing the preset corner resets its position.
local dragging=false
local dragInput=nil
local dragStart=nil
local frameStart=nil
Window:Connect(radarFrame.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.Touch
        or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true
        dragInput=input
        dragStart=Vector2.new(input.Position.X,input.Position.Y)
        frameStart=radarFrame.AbsolutePosition
    end
end)
Window:Connect(UIS.InputChanged,function(input)
    if not dragging or not dragStart then return end
    if input.UserInputType~=Enum.UserInputType.MouseMovement
        and input~=dragInput then return end
    local pos=Vector2.new(input.Position.X,input.Position.Y)
    local delta=pos-dragStart
    local view=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
        or Vector2.new(1920,1080)
    radarFrame.AnchorPoint=Vector2.new(0,0)
    radarFrame.Position=UDim2.fromOffset(
        math.clamp(frameStart.X+delta.X,0,math.max(0,view.X-radar.size)),
        math.clamp(frameStart.Y+delta.Y,0,math.max(0,view.Y-radar.size)))
end)
Window:Connect(UIS.InputEnded,function(input)
    if input==dragInput or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=false
        dragInput=nil
    end
end)

local radarInfo=RadarTab:Label("Radar inactive")
local function radarDot(player)
    local marker=radar.dots[player]
    if marker then return marker end
    marker=Instance.new("Frame")
    marker.Name="PlayerMarker"
    marker.Size=UDim2.fromOffset(radar.dotSize,radar.dotSize)
    marker.AnchorPoint=Vector2.new(0.5,0.5)
    marker.BackgroundColor3=getTeamColor(player)
    marker.BorderSizePixel=0
    marker.ZIndex=4
    marker.Parent=radarFrame
    local dotRound=Instance.new("UICorner",marker)
    dotRound.CornerRadius=UDim.new(1,0)
    local markStroke=Instance.new("UIStroke",marker)
    markStroke.Color=getTeamColor(player)
    markStroke.Thickness=1.8
    markStroke.Transparency=0.22
    -- The URL stays static per player; there is no image fetching in the update loop.
    -- Colored dot is still visible if Roblox thumbnail images are unavailable.
    local photo=Instance.new("ImageLabel")
    photo.Name="Headshot"
    photo.BackgroundTransparency=1
    photo.BorderSizePixel=0
    photo.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"
    photo.ScaleType=Enum.ScaleType.Crop
    photo.AnchorPoint=Vector2.new(0.5,0.5)
    photo.Position=UDim2.fromScale(0.5,0.5)
    photo.Size=UDim2.new(1,-3,1,-3)
    photo.Visible=radar.showAvatars
    photo.ZIndex=5
    photo.Parent=marker
    local imageCorner=Instance.new("UICorner",photo)
    imageCorner.CornerRadius=UDim.new(1,0)
    local label=Instance.new("TextLabel")
    label.Name="RadarName"
    label.AnchorPoint=Vector2.new(0.5,0)
    label.Position=UDim2.new(0.5,0,1,3)
    label.Size=UDim2.fromOffset(116,39)
    label.TextXAlignment=Enum.TextXAlignment.Center
    label.TextYAlignment=Enum.TextYAlignment.Top
    label.BackgroundTransparency=1
    label.Font=Enum.Font.GothamBold
    label.TextSize=10
    label.TextStrokeTransparency=0.18
    label.TextWrapped=true
    label.Visible=false
    label.ZIndex=6
    label.Parent=marker
    radar.dots[player]=marker
    return marker
end
local function radarClear(player)
    if player then
        local dot=radar.dots[player]
        if dot then dot:Destroy();radar.dots[player]=nil end
    else
        for p,dot in pairs(radar.dots)do
            dot:Destroy()
            radar.dots[p]=nil
        end
    end
end
Window:Connect(Players.PlayerRemoving,radarClear)
local function radarTeamAllowed(p)
    local team=p.Team and p.Team.Name:lower() or ""
    if team:find("guard") or team:find("blue") then return radar.guards end
    if team:find("criminal") or team:find("red") then return radar.criminals end
    if team:find("inmate") or team:find("prison") or team:find("orange") then
        return radar.inmates
    end
    return radar.neutral
end
local radarSummaryClock=0
Window:Connect(RunService.Heartbeat,function(dt)
    if not alive then return end
    radarFrame.Visible=radar.on and (radar.showWithHub or not Window.Visible)
    if not radar.on then return end
    radar.last=radar.last+dt
    if radar.last<(radar.refresh or 0.05) then return end
    radar.last=0
    local root=getRoot()
    local cam=workspace.CurrentCamera
    if not root or not cam then radarClear();return end
    local forward=radar.rotate and cam.CFrame.LookVector or Vector3.new(0,0,-1)
    local front=Vector3.new(forward.X,0,forward.Z)
    front=front.Magnitude>0.01 and front.Unit or Vector3.new(0,0,-1)
    local right=Vector3.new(-front.Z,0,front.X)
    local maxMarker=radar.showAvatars and radar.avatarSize or radar.dotSize
    local maxPixels=math.max(10,(radar.size*0.5)-maxMarker*0.5-10)
    local shown=0
    for _,p in ipairs(Players:GetPlayers())do
        if p~=LocalPlayer then
            local c=p.Character
            local h=c and c:FindFirstChildOfClass("Humanoid")
            local r=c and c:FindFirstChild("HumanoidRootPart")
            local diff=r and (r.Position-root.Position)
            local flat=diff and Vector3.new(diff.X,0,diff.Z)
            local sameTeam=LocalPlayer.Team and p.Team==LocalPlayer.Team
            if not h or h.Health<=0 or not flat or flat.Magnitude>radar.range
                or (not radar.showAllies and sameTeam) or not radarTeamAllowed(p) then
                radarClear(p)
            else
                shown=shown+1
                local x=flat:Dot(right)/radar.range
                local y=flat:Dot(front)/radar.range
                local mag=math.sqrt(x*x+y*y)
                if mag>1 then x=x/mag; y=y/mag end
                local dot=radarDot(p)
                dot.Position=UDim2.new(0.5,x*maxPixels,0.5,-y*maxPixels)
                local focused=radar.emphasizeFocus
                    and combat.selectedPlayer~="" and p.Name==combat.selectedPlayer
                local markerSize=radar.showAvatars and radar.avatarSize or radar.dotSize
                if focused then markerSize=markerSize+4 end
                dot.Size=UDim2.fromOffset(markerSize,markerSize)
                local teamColor=getTeamColor(p)
                dot.BackgroundColor3=teamColor
                local stroke=dot:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color=focused and Color3.fromRGB(245,222,255) or teamColor
                    stroke.Transparency=focused and 0 or 0.16
                    stroke.Thickness=focused and 2.8 or 1.8
                end
                local photo=dot:FindFirstChild("Headshot")
                if photo then photo.Visible=radar.showAvatars end
                local label=dot:FindFirstChild("RadarName")
                if label then
                    local fields={}
                    if radar.showNames then
                        if radar.nameFormat=="Username" then
                            table.insert(fields,"@"..p.Name)
                        elseif radar.nameFormat=="Both" then
                            table.insert(fields,p.DisplayName.." (@"..p.Name..")")
                        else
                            table.insert(fields,p.DisplayName)
                        end
                    end
                    if radar.showDistances then
                        table.insert(fields,math.floor(flat.Magnitude).." studs")
                    end
                    if radar.showTeams then
                        table.insert(fields,p.Team and p.Team.Name or "Neutral")
                    end
                    label.Visible=#fields>0
                    label.Text=table.concat(fields,"\n")
                    label.TextColor3=focused and Color3.fromRGB(245,222,255) or teamColor
                end
            end
        end
    end
    radarSummaryClock=radarSummaryClock+(radar.refresh or 0.05)
    if radarSummaryClock>=1 then
        radarSummaryClock=0
        radarTitle.Text=radar.rotate and "PRISON RADAR · CAMERA" or "PRISON RADAR · NORTH"
        radarInfo:Set("Tracking "..shown.." players within "..radar.range.." studs")
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

-- Quick chat commands for phone users and keyboard players.
Window:Command("pltp",function(text)
    local q=tostring(text or ""):lower():gsub("^%s+",""):gsub("%s+$","")
    local aliases={yard="Yard",cells="Cells",cafe="Cafeteria",armory="Armory",
        police="Guard Room",criminal="Criminal Base",outside="Outside"}
    local label=aliases[q]
    if not label then
        for _,place in ipairs(places)do
            if place.Name:lower()==q then label=place.Name;break end
        end
    end
    if not label then Window:Status("Unknown destination: "..q,"warning");return end
    for _,place in ipairs(places)do
        if place.Name==label then teleport(place.Point);break end
    end
end)
Window:Command("plesp",function()
    Window:SetFlag("prison_team_esp",not espEnabled)
end)
Window:Command("plfly",function()
    Window:SetFlag("pl_fly",not fly.on)
end)
Window:Command("plgear",requestStarterWeapons)
Window:Command("plhelp",function()
    Window:Notify({Title="Prison commands",
        Text="/e pltp yard | /e plesp | /e plfly | /e plgear | /e prison",
        Kind="info",Duration=9})
end)
Home:Guide({Title="Commands",Lines={
    "/e prison - reopen the hub on any screen.",
    "/e pltp yard / cells / armory / criminal / outside - locations.",
    "/e plesp - toggle team highlights; /e plfly - toggle flight.",
    "/e plgear - request basic weapons; /e plhelp - command list.",
    "Some features depend on server checks or executor support."
}})
Mov:Button({Title="Stop flight immediately",Icon="power",Callback=function()
    fly.on=false
    clearFly()
    Window:SetFlag("pl_fly",false)
end})

Window:Notify({Title="Lyra Prison Life v1.7.1", Text="Combat, ESP, teams, gear, teleports and movement loaded.", Kind="success"})
return Window
