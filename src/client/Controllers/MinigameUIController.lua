-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Roact = require(Knit.Shared.Roact)
local RBXWait = require(Knit.Shared.RBXWait)

local Status = require(Knit.RoactComponents.Status)


local TweenService = game:GetService("TweenService")

local GameService

local MinigameUIController = Knit.CreateController { Name = "MinigameUIController" }

local player = Knit.Player
local playerGui = player:FindFirstChild("PlayerGui")

local function func_135459427()
    wait(3)
    local ObjectiveUI = playerGui.MinigameUI:FindFirstChild("ObjectiveFrame")

    local showObjective = TweenService:Create(ObjectiveUI, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.88, 0)})
    local hideObjective = TweenService:Create(ObjectiveUI, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1.88, 0)})
    GameService.ShowObjUI:Connect(function()
        showObjective:Play()
        wait(5)
        hideObjective:Play()
    end)
    GameService.DisplayStatus:Connect(function(...)
        playerGui.MinigameUI:FindFirstChild("StatusLabel").Text = ("%s"):format(...)
    end)
end

function MinigameUIController:KnitStart()
    func_135459427()
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return MinigameUIController