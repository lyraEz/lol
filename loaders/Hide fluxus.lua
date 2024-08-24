
local TextChatService = game:GetService("TextChatService") 

local Players = game:GetService("Players") 

local Fluxus = gethui():FindFirstChild("FluxusAndroidUI")

getgenv().Cache = Cache

if Fluxus and not Cache then
	Cache = true
	
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = ",H/,S",
		Text = ",H to hide | ,S to show",
		Duration = 7.5,
	})
	
	local TCS, PLC
	TextChatService.OnIncomingMessage = function(message: TextChatMessage)
		if TCS then return end
		local properties = Instance.new("TextChatMessageProperties")
		PLC:Disconnect()
		if message.Text:lower() == ",H" then
			Fluxus.Enabled = false
			return
		elseif message.Text:lower() == ",S" then
			Fluxus.Enabled = true
			return
		end
		return properties 
	end

	PLC = Players.LocalPlayer.Chatted:Connect(function(message)
		TCS = true
		if message:lower() == ",H" then
			Fluxus.Enabled = false
			return
		elseif message:lower() == ",S" then
			Fluxus.Enabled = true
			return
		end
	end)
end
