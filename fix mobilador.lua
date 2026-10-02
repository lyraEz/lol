local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuração: mude para 'true' se o seu jogo for estritamente em primeira pessoa
local APENAS_PRIMEIRA_PESSOA = false 

RunService.RenderStepped:Connect(function()
    -- Verifica se o dispositivo está reconhecendo o mouse
    if UserInputService.MouseEnabled then
        
        -- Se o jogo for 1ª pessoa ou o jogador estiver segurando o botão direito (girando a câmera)
        if APENAS_PRIMEIRA_PESSOA or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            -- Libera o cursor para clicar em menus/UI quando não estiver girando a câmera
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        
    end
end)