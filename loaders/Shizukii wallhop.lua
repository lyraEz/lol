--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.8) ~  Much Love, Ferib 

]]--

local v0=game.Players.LocalPlayer;local v1=game:GetService("UserInputService");local v2=game:GetService("RunService");local function v3() local v4=Instance.new("ScreenGui");v4.Parent=v0:WaitForChild("PlayerGui");local v6=Instance.new("Frame");v6.Size=UDim2.new(0.2,0,0.3,0);v6.Position=UDim2.new(0.4,0,0.35,0);v6.BackgroundTransparency=0.3;v6.BackgroundColor3=Color3.fromRGB(30,30,30);v6.BorderColor3=Color3.fromRGB(0,0,0);v6.BorderSizePixel=2;v6.Active=true;v6.Draggable=true;v6.Parent=v4;local v16=Instance.new("ScrollingFrame");v16.Size=UDim2.new(1,0,0.9,0);v16.Position=UDim2.new(0,0,0,0);v16.CanvasSize=UDim2.new(0,0,1,0);v16.ScrollBarThickness=5;v16.BackgroundTransparency=1;v16.Parent=v6;local function v23(v81,v82,v83) local v84=Instance.new("TextButton");v84.Text=v81;v84.TextColor3=Color3.fromRGB(255,255,255);v84.Size=UDim2.new(0.8,0,0.2,0);v84.Position=v82;v84.BackgroundTransparency=0.3;v84.BackgroundColor3=Color3.fromRGB(50,50,50);v84.BorderColor3=Color3.fromRGB(0,0,0);v84.BorderSizePixel=2;v84.Font=Enum.Font.GothamBold;v84.TextScaled=true;v84.Parent=v83;return v84;end local v24=v23("Flick",UDim2.new(0.1,0,0.05,0),v16);local v25=v23("Autoflick: Off",UDim2.new(0.1,0,0.3,0),v16);local v26=Instance.new("TextBox");v26.Size=UDim2.new(0.8,0,0.2,0);v26.Position=UDim2.new(0.1,0,0.55,0);v26.BackgroundColor3=Color3.fromRGB(50,50,50);v26.TextColor3=Color3.fromRGB(255,255,255);v26.PlaceholderText="Interval (seconds)";v26.Parent=v16;local v33=v23("Wallhop: Off",UDim2.new(0.1,0,0.8,0),v16);local v34=v23("Shiftlock M",UDim2.new(0.1,0,1.05,0),v16);local v35=Instance.new("TextButton");v35.Text="-";v35.TextColor3=Color3.fromRGB(255,255,255);v35.Size=UDim2.new(0.1,0,0.1,0);v35.Position=UDim2.new(0.9, -5,0,5);v35.BackgroundTransparency=0.3;v35.BackgroundColor3=Color3.fromRGB(50,50,50);v35.BorderColor3=Color3.fromRGB(0,0,0);v35.BorderSizePixel=2;v35.Font=Enum.Font.GothamBold;v35.TextScaled=true;v35.Parent=v6;local v48=Instance.new("TextButton");v48.Text="Show";v48.TextColor3=Color3.fromRGB(255,255,255);v48.Size=UDim2.new(0.05,0,0.05,0);v48.Position=UDim2.new(0,5,0.5, -25);v48.BackgroundTransparency=0.3;v48.BackgroundColor3=Color3.fromRGB(30,30,30);v48.BorderColor3=Color3.fromRGB(0,0,0);v48.BorderSizePixel=2;v48.Font=Enum.Font.GothamBold;v48.TextScaled=true;v48.Visible=false;v48.Active=true;v48.Draggable=true;v48.Parent=v4;local v63=Instance.new("TextButton");v63.Text="Copy Discord Link";v63.TextColor3=Color3.fromRGB(255,255,255);v63.Size=UDim2.new(0.3,0,0.1,0);v63.Position=UDim2.new(0.7,0,0.9,0);v63.BackgroundTransparency=0.3;v63.BackgroundColor3=Color3.fromRGB(50,50,50);v63.BorderColor3=Color3.fromRGB(0,0,0);v63.BorderSizePixel=2;v63.Font=Enum.Font.GothamBold;v63.TextScaled=true;v63.Parent=v6;local v75=0;local v76={"Off","Mode logiT","Mode ray"};local v77=false;local v78=0.1;local function v79() local v97=workspace.CurrentCamera;local v98=v97.CFrame;local v99=v98 * CFrame.Angles(0,math.rad(90),0) ;v97.CFrame=v99;wait(0.05);v97.CFrame=v98;end v24.MouseButton1Click:Connect(v79);v25.MouseButton1Click:Connect(function() v77= not v77;v25.Text="Autoflick: "   .. ((v77 and "On") or "Off") ;if v77 then while v77 do v79();wait(v78);end end end);v26.FocusLost:Connect(function(v102) if v102 then local v120=tonumber(v26.Text);if (v120 and (v120>0)) then v78=v120;else v26.Text=tostring(v78);end end end);v33.MouseButton1Click:Connect(function() v75=(v75 + 1)%3 ;v33.Text="Wallhop: "   .. v76[v75 + 1 ] ;end);local function v80() while true do wait(0.05);if (v75>0) then local v121=v0.Character or v0.CharacterAdded:Wait() ;local v122=v121:FindFirstChild("Humanoid");local v123=v121:FindFirstChild("HumanoidRootPart");if (v122 and v123) then local v125=Ray.new(v123.Position,v123.CFrame.LookVector * 5 );local v126,v127=workspace:FindPartOnRayWithIgnoreList(v125,{v121});if (v126 and (v126.Position.Y>v123.Position.Y)) then v122.Jump=true;wait(0.15);if (v75==2) then wait(0.07);end v79();end end end end end coroutine.wrap(v80)();v35.MouseButton1Click:Connect(function() v6.Visible=false;v48.Visible=true;end);v48.MouseButton1Click:Connect(function() v6.Visible=true;v48.Visible=false;end);v34.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Unknownproooolucky/Unknown-Hub-X-Universal-Games/main/Universal/Permanent-Shiftlock-V2"))();end);v63.MouseButton1Click:Connect(function() local v108="https://discord.gg/FA3eVAdtfw";setclipboard(v108);local v109=Instance.new("TextLabel");v109.Text="Discord link copied to clipboard!";v109.Size=UDim2.new(0.3,0,0.1,0);v109.Position=UDim2.new(0.7,0,0.8,0);v109.BackgroundTransparency=0.5;v109.BackgroundColor3=Color3.fromRGB(0,255,0);v109.TextColor3=Color3.fromRGB(255,255,255);v109.Font=Enum.Font.GothamBold;v109.TextScaled=true;v109.Parent=v6;wait(2);v109:Destroy();end);end v3();
