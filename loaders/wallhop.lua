do local v0=game:GetService("TweenService");local v1=game:GetService("UserInputService");local v2=0.03;local v3=false;local v4=false;local v5=nil;local v6={};local v7=Instance.new("ScreenGui");local v8=Instance.new("Frame");local v9=Instance.new("TextButton");local v10=Instance.new("TextButton");local v11=Instance.new("TextButton");local v12=Instance.new("TextButton");local v13=Instance.new("TextButton");local v14=Instance.new("TextLabel");local v15=Instance.new("TextBox");local v16=Instance.new("TextLabel");local v17=Instance.new("Frame");v7.Parent=game:GetService("CoreGui");v8.Name="WallhopHub";v8.Parent=v7;v8.BackgroundColor3=Color3.fromRGB(30,30,30);v8.BackgroundTransparency=0.2;v8.BorderSizePixel=0;v8.Position=UDim2.new(0.3,0,0.2,0);v8.Size=UDim2.new(0,250,0,170);v8.Visible=true;v8.ClipsDescendants=true;v8.Active=true;local v29=Instance.new("UICorner");v29.CornerRadius=UDim.new(0,10);v29.Parent=v8;v9.Name="Header";v9.Parent=v8;v9.BackgroundColor3=Color3.fromRGB(20,20,20);v9.Size=UDim2.new(1,0,0,30);v9.Font=Enum.Font.SourceSans;v9.Text="Wallhop Hub";v9.TextColor3=Color3.fromRGB(255,255,255);v9.TextSize=18;v9.TextXAlignment=Enum.TextXAlignment.Center;v9.AutoButtonColor=false;local v44=Instance.new("UICorner");v44.CornerRadius=UDim.new(0,10);v44.Parent=v9;v10.Name="SettingsButton";v10.Parent=v9;v10.BackgroundTransparency=1;v10.Size=UDim2.new(0,40,0,30);v10.Position=UDim2.new(0,5,0,0);v10.Font=Enum.Font.SourceSansSemibold;v10.Text="config";v10.TextSize=16;v10.TextColor3=Color3.fromRGB(255,255,255);v10.AutoButtonColor=false;v11.Name="MinimizeButton";v11.Parent=v9;v11.BackgroundTransparency=1;v11.Size=UDim2.new(0,30,0,30);v11.Position=UDim2.new(1, -35,0,0);v11.Font=Enum.Font.SourceSansBold;v11.Text="-";v11.TextColor3=Color3.fromRGB(255,255,255);v11.TextSize=24;v11.AutoButtonColor=false;v12.Name="ToggleWallhop";v12.Parent=v8;v12.BackgroundColor3=Color3.fromRGB(50,50,50);v12.Position=UDim2.new(0.1,0,0.35,0);v12.Size=UDim2.new(0.8,0,0.2,0);v12.Font=Enum.Font.SourceSans;v12.Text="Toggle Wallhop: OFF";v12.TextColor3=Color3.fromRGB(255,255,255);v12.TextSize=16;local v78=Instance.new("UICorner");v78.CornerRadius=UDim.new(0,8);v78.Parent=v12;v13.Name="KeybindButton";v13.Parent=v8;v13.BackgroundColor3=Color3.fromRGB(50,50,50);v13.Position=UDim2.new(0.1,0,0.57,0);v13.Size=UDim2.new(0.8,0,0.15,0);v13.Font=Enum.Font.SourceSans;v13.Text="Keybind: None";v13.TextColor3=Color3.fromRGB(255,255,255);v13.TextSize=16;local v90=Instance.new("UICorner");v90.CornerRadius=UDim.new(0,8);v90.Parent=v13;v14.Name="WaitLabel";v14.Parent=v8;v14.BackgroundTransparency=1;v14.Position=UDim2.new(0.1,0,0.75,0);v14.Size=UDim2.new(0.5,0,0.1,0);v14.Font=Enum.Font.SourceSans;v14.Text="Wait Time:";v14.TextColor3=Color3.fromRGB(255,255,255);v14.TextSize=16;v15.Name="WaitBox";v15.Parent=v8;v15.BackgroundColor3=Color3.fromRGB(50,50,50);v15.Position=UDim2.new(0.55,0,0.75,0);v15.Size=UDim2.new(0.3,0,0.1,0);v15.Font=Enum.Font.SourceSans;v15.Text=tostring(v2);v15.TextColor3=Color3.fromRGB(255,255,255);v15.TextSize=16;local v111=Instance.new("UICorner");v111.CornerRadius=UDim.new(0,8);v111.Parent=v15;v16.Name="HintLabel";v16.Parent=v8;v16.BackgroundTransparency=1;v16.AnchorPoint=Vector2.new(1,1);v16.Position=UDim2.new(1, -5,1, -5);v16.Size=UDim2.new(0,150,0,20);v16.Font=Enum.Font.SourceSans;v16.Text="For more legit use 0.09";v16.TextColor3=Color3.fromRGB(150,150,150);v16.TextSize=14;v16.TextXAlignment=Enum.TextXAlignment.Right;v16.Visible=true;v17.Name="SettingsPanel";v17.Parent=v8;v17.BackgroundColor3=Color3.fromRGB(40,40,40);v17.BackgroundTransparency=0.1;v17.Size=UDim2.new(0,220,0,160);v17.Position=UDim2.new(0.5, -110,0.5, -80);v17.Visible=false;local v134=Instance.new("UICorner");v134.CornerRadius=UDim.new(0,8);v134.Parent=v17;local v137=Instance.new("UIStroke");v137.Thickness=2;v137.Color=Color3.fromRGB(60,60,60);v137.Parent=v17;local v141=Instance.new("TextButton");v141.Name="SettingsClose";v141.Parent=v17;v141.BackgroundTransparency=1;v141.Size=UDim2.new(0,20,0,20);v141.Position=UDim2.new(1, -25,0,5);v141.Font=Enum.Font.SourceSansBold;v141.Text="X";v141.TextColor3=Color3.fromRGB(255,255,255);v141.TextSize=20;v141.AutoButtonColor=false;v141.MouseButton1Click:Connect(function() playClickSound();v17.Visible=false;end);local v152=Instance.new("TextButton");v152.Name="ResetButton";v152.Parent=v17;v152.BackgroundColor3=Color3.fromRGB(50,50,50);v152.Size=UDim2.new(0,180,0,30);v152.Position=UDim2.new(0,20,0,40);v152.Font=Enum.Font.SourceSans;v152.Text="Reset Config";v152.TextColor3=Color3.fromRGB(255,255,255);v152.TextSize=16;local v162=Instance.new("UICorner");v162.CornerRadius=UDim.new(0,8);v162.Parent=v152;v152.MouseButton1Click:Connect(function() playClickSound();v2=0.03;v15.Text="0.03";v3=false;v12.Text="Toggle Wallhop: OFF";v5=nil;v13.Text="Keybind: None";notify("Config reset to default.",2);end);local v165=Instance.new("TextButton");v165.Name="SaveButton";v165.Parent=v17;v165.BackgroundColor3=Color3.fromRGB(50,50,50);v165.Size=UDim2.new(0,180,0,30);v165.Position=UDim2.new(0,20,0,80);v165.Font=Enum.Font.SourceSans;v165.Text="Save Config";v165.TextColor3=Color3.fromRGB(255,255,255);v165.TextSize=16;local v175=Instance.new("UICorner");v175.CornerRadius=UDim.new(0,8);v175.Parent=v165;v165.MouseButton1Click:Connect(function() playClickSound();v6.waitTime=v2;v6.boundKey=v5;notify("Config saved!\nWait Time: "   .. tostring(v2)   .. "\nKeybind: "   .. ((v5 and v5.Name) or "None") ,3);end);local v178=Instance.new("TextButton");v178.Name="HelpButton";v178.Parent=v17;v178.BackgroundColor3=Color3.fromRGB(50,50,50);v178.Size=UDim2.new(0,180,0,30);v178.Position=UDim2.new(0,20,0,120);v178.Font=Enum.Font.SourceSans;v178.Text="Join Discord";v178.TextColor3=Color3.fromRGB(255,255,255);v178.TextSize=16;local v188=Instance.new("UICorner");v188.CornerRadius=UDim.new(0,8);v188.Parent=v178;v178.MouseButton1Click:Connect(function() playClickSound();setclipboard("https://discord.gg/FA3eVAdtfw");notify("Discord link copied!\nJoin our Discord: discord.gg/FA3eVAdtfw",3);end);local v191=false;v10.MouseButton1Click:Connect(function() playClickSound();v191= not v191;v17.Visible=v191;end);function notify(v209,v210) v210=v210 or 2 ;local v211=Instance.new("ScreenGui");v211.Parent=game:GetService("CoreGui");local v213=Instance.new("Frame");v213.Parent=v211;v213.BackgroundColor3=Color3.fromRGB(30,30,30);v213.BackgroundTransparency=0.2;v213.Size=UDim2.new(0,200,0,50);v213.Position=UDim2.new(0.5, -100,0.9,0);local v219=Instance.new("UICorner");v219.CornerRadius=UDim.new(0,8);v219.Parent=v213;local v222=Instance.new("TextLabel");v222.Parent=v213;v222.Size=UDim2.new(1,0,1,0);v222.BackgroundTransparency=1;v222.Font=Enum.Font.SourceSans;v222.Text=v209;v222.TextColor3=Color3.fromRGB(255,255,255);v222.TextScaled=true;v222.TextWrapped=true;delay(v210,function() local v259=TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out);local v260=v0:Create(v213,v259,{BackgroundTransparency=1});v260:Play();v260.Completed:Connect(function() v211:Destroy();end);end);end function playClickSound() local v232=Instance.new("Sound");v232.SoundId="rbxassetid://1722389642";v232.Volume=1;v232.Parent=v8;v232:Play();v232.Ended:Connect(function() v232:Destroy();end);end local v192=Instance.new("Sound");v192.SoundId="rbxassetid://105273743776293";v192.Volume=1;v192.Parent=v8;v192:Play();v192.Ended:Connect(function() v192:Destroy();end);v1.JumpRequest:Connect(function() if v3 then v3=false;workspace.CurrentCamera:PanUnits(1);wait(v2);v3=true;workspace.CurrentCamera:PanUnits( -1);end end);v12.MouseButton1Click:Connect(function() playClickSound();v3= not v3;v12.Text="Toggle Wallhop: "   .. ((v3 and "ON") or "OFF") ;end);v15.FocusLost:Connect(function(v237) if v237 then local v263=tonumber(v15.Text);if (v263 and (v263>0)) then v2=v263;else v15.Text=tostring(v2);end end end);v13.MouseButton1Click:Connect(function() playClickSound();v13.Text="Press a key...";local v239=true;local v240;v240=v1.InputBegan:Connect(function(v261,v262) if (v239 and  not v262 and (v261.UserInputType==Enum.UserInputType.Keyboard)) then v5=v261.KeyCode;v13.Text="Keybind: "   .. v5.Name ;v239=false;v240:Disconnect();end end);end);v1.InputBegan:Connect(function(v241,v242) if ( not v242 and v5 and (v241.KeyCode==v5)) then v3= not v3;v12.Text="Toggle Wallhop: "   .. ((v3 and "ON") or "OFF") ;playClickSound();end end);local function v196() v4= not v4;local v243=(v4 and UDim2.new(0,250,0,30)) or UDim2.new(0,250,0,170) ;local v244=TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out);local v245=v0:Create(v8,v244,{Size=v243});v245:Play();v12.Visible= not v4;v13.Visible= not v4;v14.Visible= not v4;v15.Visible= not v4;v16.Visible= not v4;v10.Visible= not v4;v11.Text=(v4 and "+") or "-" ;end v11.MouseButton1Click:Connect(v196);local v197,v198,v199,v200;local function v201(v253) local v254=v253.Position-v199 ;v8.Position=UDim2.new(v200.X.Scale,v200.X.Offset + v254.X ,v200.Y.Scale,v200.Y.Offset + v254.Y );end v9.InputBegan:Connect(function(v256) if ((v256.UserInputType==Enum.UserInputType.MouseButton1) or (v256.UserInputType==Enum.UserInputType.Touch)) then v197=true;v199=v256.Position;v200=v8.Position;v256.Changed:Connect(function() if (v256.UserInputState==Enum.UserInputState.End) then v197=false;end end);end end);v9.InputChanged:Connect(function(v257) if ((v257.UserInputType==Enum.UserInputType.MouseMovement) or (v257.UserInputType==Enum.UserInputType.Touch)) then v198=v257;end end);v1.InputChanged:Connect(function(v258) if ((v258==v198) and v197) then v201(v258);end end); end
