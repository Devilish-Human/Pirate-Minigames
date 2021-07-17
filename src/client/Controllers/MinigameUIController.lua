-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local GameService

local MinigameUIController = Knit.CreateController { Name = "MinigameUIController" }

local PlayerGui = Knit.Player.PlayerGui
local minigameUI = PlayerGui:FindFirstChild("MinigameUI")

function MinigameUIController:_func_135459427()
    local ObjectiveUI = minigameUI.Objective

    GameService.ShowObjUI:Connect(function(retrievedData)
        local m_Objective = ObjectiveUI:FindFirstChild("m_Objective")
        local m_Name = ObjectiveUI:FindFirstChild("m_Name")

        m_Objective.Text = retrievedData[2]
        m_Name.Text = retrievedData[1]
    end)
    GameService.DisplayStatus:Connect(function(a)
        print(a)
    end)
end

function MinigameUIController:KnitStart()
    self:_func_135459427()
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return MinigameUIController