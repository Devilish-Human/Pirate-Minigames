-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local RBXWait = require(Knit.Shared.RBXWait)

local GameService

local MinigameUIController = Knit.CreateController { Name = "MinigameUIController" }

local player = Knit.Player
local playerGui = player:FindFirstChild("PlayerGui")

local function func_135459427()
    wait(3)
    local ObjectiveUI = playerGui.MinigameUI:FindFirstChild("ObjectiveFrame")

    --[[ GameService.ShowObjUI:Connect(function(retrievedData)
        local m_Objective = ObjectiveUI:FindFirstChild("m_Objective")
        local m_Name = ObjectiveUI:FindFirstChild("m_Name")

        m_Name.Text = retrievedData[1]
        m_Objective.Text = retrievedData[2]
    end) ]]
    GameService.DisplayStatus:Connect(function(a, b)
        playerGui.MinigameUI:FindFirstChild("StatusLabel").Text = ("%s (%s)"):format(a, b)
    end)
end

function MinigameUIController:KnitStart()
    func_135459427()
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return MinigameUIController