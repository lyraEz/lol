--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.7) ~  Much Love, Ferib 

]]--

bit32={};local v0=32;local v1=2^v0 ;bit32.bnot=function(v14) v14=v14%v1 ;return (v1-1) -v14 ;end;bit32.band=function(v15,v16) if (v16==255) then return v15%256 ;end if (v16==65535) then return v15%65536 ;end if (v16==4294967295) then return v15%4294967296 ;end v15,v16=v15%v1 ,v16%v1 ;local v17=0;local v18=1;for v101=1,v0 do local v102,v103=v15%2 ,v16%2 ;v15,v16=math.floor(v15/2 ),math.floor(v16/2 );if ((v102 + v103)==2) then v17=v17 + v18 ;end v18=2 * v18 ;end return v17;end;bit32.bor=function(v19,v20) if (v20==255) then return (v19-(v19%256)) + 255 ;end if (v20==65535) then return (v19-(v19%65536)) + 65535 ;end if (v20==4294967295) then return 4294967295;end v19,v20=v19%v1 ,v20%v1 ;local v21=0;local v22=1;for v104=1,v0 do local v105,v106=v19%2 ,v20%2 ;v19,v20=math.floor(v19/2 ),math.floor(v20/2 );if ((v105 + v106)>=1) then v21=v21 + v22 ;end v22=2 * v22 ;end return v21;end;bit32.bxor=function(v23,v24) v23,v24=v23%v1 ,v24%v1 ;local v25=0;local v26=1;for v107=1,v0 do local v108,v109=v23%2 ,v24%2 ;v23,v24=math.floor(v23/2 ),math.floor(v24/2 );if ((v108 + v109)==1) then v25=v25 + v26 ;end v26=2 * v26 ;end return v25;end;bit32.lshift=function(v27,v28) if (math.abs(v28)>=v0) then return 0;end v27=v27%v1 ;if (v28<0) then return math.floor(v27 * (2^v28) );else return (v27 * (2^v28))%v1 ;end end;bit32.rshift=function(v29,v30) if (math.abs(v30)>=v0) then return 0;end v29=v29%v1 ;if (v30>0) then return math.floor(v29 * (2^ -v30) );else return (v29 * (2^ -v30))%v1 ;end end;bit32.arshift=function(v31,v32) if (math.abs(v32)>=v0) then return 0;end v31=v31%v1 ;if (v32>0) then local v134=0;if (v31>=(v1/2)) then v134=v1-(2^(v0-v32)) ;end return math.floor(v31 * (2^ -v32) ) + v134 ;else return (v31 * (2^ -v32))%v1 ;end end;local v9=game.Players.LocalPlayer;local v10=game:GetService("UserInputService");local v11=game:GetService("RunService");local function v12() local v33=Instance.new("ScreenGui");v33.Parent=v9:WaitForChild("PlayerGui");local v35=Instance.new("Frame");v35.Size=UDim2.new(0.2,0,0.3,0);v35.Position=UDim2.new(0.4,0,0.35,0);v35.BackgroundTransparency=0.3;v35.BackgroundColor3=Color3.fromRGB(30,30,30);v35.BorderColor3=Color3.fromRGB(0,0,0);v35.BorderSizePixel=2;v35.Active=true;v35.Draggable=true;v35.Parent=v33;local v45=Instance.new("ScrollingFrame");v45.Size=UDim2.new(1,0,0.9,0);v45.Position=UDim2.new(0,0,0,0);v45.CanvasSize=UDim2.new(0,0,1,0);v45.ScrollBarThickness=5;v45.BackgroundTransparency=1;v45.Parent=v35;local function v52(v110,v111,v112) local v113=Instance.new("TextButton");v113.Text=v110;v113.TextColor3=Color3.fromRGB(255,255,255);v113.Size=UDim2.new(0.8,0,0.2,0);v113.Position=v111;v113.BackgroundTransparency=0.3;v113.BackgroundColor3=Color3.fromRGB(50,50,50);v113.BorderColor3=Color3.fromRGB(0,0,0);v113.BorderSizePixel=2;v113.Font=Enum.Font.GothamBold;v113.TextScaled=true;v113.Parent=v112;return v113;end local v53=v52("Flick",UDim2.new(0.1,0,0.05,0),v45);local v54=v52("Wallhop: Off",UDim2.new(0.1,0,0.3,0),v45);local v55=v52("Shiftlock M",UDim2.new(0.1,0,0.55,0),v45);local v56=Instance.new("TextButton");v56.Text="-";v56.TextColor3=Color3.fromRGB(255,255,255);v56.Size=UDim2.new(0.1,0,0.1,0);v56.Position=UDim2.new(0.9, -5,0,5);v56.BackgroundTransparency=0.3;v56.BackgroundColor3=Color3.fromRGB(50,50,50);v56.BorderColor3=Color3.fromRGB(0,0,0);v56.BorderSizePixel=2;v56.Font=Enum.Font.GothamBold;v56.TextScaled=true;v56.Parent=v35;local v69=Instance.new("TextButton");v69.Text="Show";v69.TextColor3=Color3.fromRGB(255,255,255);v69.Size=UDim2.new(0.05,0,0.05,0);v69.Position=UDim2.new(0,5,0.5, -25);v69.BackgroundTransparency=0.3;v69.BackgroundColor3=Color3.fromRGB(30,30,30);v69.BorderColor3=Color3.fromRGB(0,0,0);v69.BorderSizePixel=2;v69.Font=Enum.Font.GothamBold;v69.TextScaled=true;v69.Visible=false;v69.Active=true;v69.Draggable=true;v69.Parent=v33;local v84=Instance.new("TextButton");v84.Text="Discord Link";v84.TextColor3=Color3.fromRGB(255,255,255);v84.Size=UDim2.new(0.3,0,0.1,0);v84.Position=UDim2.new(0.7,0,0.9,0);v84.BackgroundTransparency=0.3;v84.BackgroundColor3=Color3.fromRGB(50,50,50);v84.BorderColor3=Color3.fromRGB(0,0,0);v84.BorderSizePixel=2;v84.Font=Enum.Font.GothamBold;v84.TextScaled=true;v84.Parent=v35;local v96="Off";local v97=false;local function v98() local v126=workspace.CurrentCamera;local v127=v126.CFrame;local v128=v127 * CFrame.Angles(0,math.rad(90),0) ;v126.CFrame=v128;wait(0.05);v126.CFrame=v127;end v53.MouseButton1Click:Connect(v98);v54.MouseButton1Click:Connect(function() if (v96=="Off") then v96="Stable";v54.Text="Wallhop: Stable";elseif (v96=="Stable") then v96="Beta";v54.Text="Wallhop: Beta";else v96="Off";v54.Text="Wallhop: Off";end end);local function v99() while true do wait(0.1);local v135=v9.Character or v9.CharacterAdded:Wait() ;local v136=v135:FindFirstChild("Humanoid");local v137=v135:FindFirstChild("HumanoidRootPart");if ((v96=="Stable") and v136 and v137) then local v139=v137.Position;local v140=v137.CFrame.LookVector * 5 ;local v141=Ray.new(v139,v140);local v142,v143=workspace:FindPartOnRayWithIgnoreList(v141,{v135});if (v142 and (v142.Position.Y>v137.Position.Y)) then v136.Jump=true;wait(0.1);v98();end elseif (v96=="Beta") then if (v136 and v137) then local v147=v137.Position;local v148=v137.CFrame.LookVector * 5 ;local v149=Ray.new(v147,v148);local v150,v151=workspace:FindPartOnRay(v149,v135);if (v150 and (v150.Position.Y>v137.Position.Y)) then v136.Jump=true;wait(0.1);v98();end end end end end coroutine.wrap(v99)();v56.MouseButton1Click:Connect(function() v35.Visible=false;v69.Visible=true;end);v69.MouseButton1Click:Connect(function() v35.Visible=true;v69.Visible=false;end);v55.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Unknownproooolucky/Unknown-Hub-X-Universal-Games/main/Universal/Permanent-Shiftlock-V2"))();end);v84.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/FA3eVAdtfw");game.StarterGui:SetCore("SendNotification",{Title="Success",Text="Discord link copied!",Duration=2});end);end local function v13(v100) v12();end v9.CharacterAdded:Connect(v13);if v9.Character then v12();end
