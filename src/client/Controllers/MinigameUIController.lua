-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Roact = require(Knit.Shared.Roact)
local RBXWait = require(Knit.Shared.RBXWait)

local TweenService = game:GetService("TweenService")

local GameService

local MinigameUIController = Knit.CreateController { Name = "MinigameUIController" }

local player = Knit.Player

local playerGui = player:FindFirstChild("PlayerGui")

function MinigameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character ~= nil

    local minigameUI = playerGui:FindFirstChild("MinigameUI")
    local ObjectiveUI = minigameUI:FindFirstChild("ObjectiveFrame")

    local showObjective = TweenService:Create(ObjectiveUI, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.88, 0), BackgroundTransparency = 0})
    local hideObjective = TweenService:Create(ObjectiveUI, TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 1.88, 0), BackgroundTransparency = 1})
    
    GameService.ShowObjUI:Connect(function(...)
        local mgName, mgObjective = ...
        ObjectiveUI.m_Name.Text = mgName
        ObjectiveUI.m_Objective.Text = mgObjective

        showObjective:Play()
        wait(3)
        hideObjective:Play()
    end)
    GameService.DisplayStatus:Connect(function(message)
        minigameUI.StatusLabel.Text = message
    end)
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return MinigameUIController