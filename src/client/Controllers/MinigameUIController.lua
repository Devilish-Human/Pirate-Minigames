-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Roact = require(Knit.Shared.Roact)
local RBXWait = require(Knit.Shared.RBXWait)

local Status = require(Knit.RoactComponents.Status)


local TweenService = game:GetService("TweenService")

local GameService, DataService

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
    
    local m_Name_FadeOut = TweenService:Create(ObjectiveUI.m_Name, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    local m_Obj_FadeOut = TweenService:Create(ObjectiveUI.m_Objective, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})

    local m_Name_FadeIn = TweenService:Create(ObjectiveUI.m_Name, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 0})
    local m_Obj_FadeIn = TweenService:Create(ObjectiveUI.m_Objective, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 0})

    GameService.ShowObjUI:Connect(function(...)
        local mgName, mgObjective = ...
        ObjectiveUI.m_Name.Text = mgName
        ObjectiveUI.m_Objective.Text = mgObjective

        showObjective:Play()
        m_Obj_FadeIn:Play()
        m_Name_FadeIn:Play()
        wait(5)
        m_Obj_FadeOut:Play()
        m_Name_FadeOut:Play();
        hideObjective:Play()
    end)
    GameService.DisplayStatus:Connect(function(message)
        minigameUI.StatusLabel.Text = message
    end)

    local coins = DataService:GetData ("Coins")
    print("Coins:", coins)
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
    DataService = Knit.GetService("DataService")
end


return MinigameUIController