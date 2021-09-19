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

local function createLabel()
    local UsernameLabel = Instance.new("TextLabel")
    local ResultLabel = Instance.new("TextLabel")

    UsernameLabel.Name = "UsernameLabel"
    UsernameLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    UsernameLabel.BorderSizePixel = 0
    UsernameLabel.Position = UDim2.new(0, 0, 0, 96)
    UsernameLabel.Size = UDim2.new(1, -10, 0.0500000007, 0)
    UsernameLabel.Font = Enum.Font.Ubuntu
    UsernameLabel.Text = "Trashy (@messiboy111)"
    UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsernameLabel.TextSize = 14.000
    UsernameLabel.TextStrokeColor3 = Color3.fromRGB(53, 53, 53)
    UsernameLabel.TextStrokeTransparency = 0.000
    UsernameLabel.TextWrapped = true
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left

    ResultLabel.Name = "ResultLabel"
    ResultLabel.Parent = UsernameLabel
    ResultLabel.BackgroundColor3 = Color3.fromRGB(168, 168, 168)
    ResultLabel.BackgroundTransparency = 1.000
    ResultLabel.BorderSizePixel = 0
    ResultLabel.Position = UDim2.new(0.790000021, 0, 0, 0)
    ResultLabel.Size = UDim2.new(0.200000003, 0, 1, 0)
    ResultLabel.Font = Enum.Font.SourceSansBold
    ResultLabel.Text = "Left the game."
    ResultLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ResultLabel.TextSize = 18.000
    ResultLabel.TextStrokeColor3 = Color3.fromRGB(43, 43, 43)
    ResultLabel.TextStrokeTransparency = 0.000
    ResultLabel.TextXAlignment = Enum.TextXAlignment.Right

    return UsernameLabel
end
function MinigameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character ~= nil

    local minigameUI = playerGui:FindFirstChild("MinigameUI")
    local ObjectiveUI = minigameUI:FindFirstChild("ObjectiveFrame")
    local ResultsFrame = minigameUI:FindFirstChild("EndResults")

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

    local usernameLabel = createLabel()
    ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
    ResultsFrame.earnedLabel.Text = ""

    GameService.ShowResults:Connect(function(...)
        ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
        local endResult = ...

        TweenService:Create (ResultsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 0.5, 0) }):Play ()

        local x = 0
        for i,v in pairs (endResult) do
            local userName = i
            local message = v.Message
            local won = v.Won

            local label = usernameLabel:Clone()
            label.Text = ""
            label.Parent = ResultsFrame.ResultList
            label.Position = UDim2.new (0, 0, 0, 32*x)
            
            if (game.Players:FindFirstChild(userName)) then
                label.Text = ((" %s (@%s)"):format(game.Players[userName].DisplayName, userName))
            else
                label.Text = ((" %s"):format(userName))
            end

            local earnedCoins = ResultsFrame.earnedLabel
            label.ResultLabel.Text = message

            if (won == true) then
                label.ResultLabel.TextColor3 = Color3.new (0, 1, 0)
            else
                label.ResultLabel.TextColor3 = Color3.new (1, 0, 0)
            end
            if (userName == Knit.Player.Name) then
                --label.TextColor3 = Color3.fromRGB(218, 145, 0)
                TweenService:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { BackgroundColor3 = Color3.fromRGB (218, 145, 0) }):Play()
            else
                TweenService:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB (255, 255, 255) }):Play()
            end
            earnedCoins.Text = ("Earned +%s coins"):format(v.Coins)
            x += 1
        end
        wait (5.5)
        TweenService:Create (ResultsFrame, TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 1.5, 0) }):Play()
    end)
end

function MinigameUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return MinigameUIController