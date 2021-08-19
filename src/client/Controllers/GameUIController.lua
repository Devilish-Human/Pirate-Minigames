local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Tween = game:GetService("TweenService")

local Prompt = require(Knit.Modules.Prompt)

local GameUIController = Knit.CreateController { Name = "GameUIController" }

local DataService, GameService

function GameUIController:GetGameUI ()
    return Knit.Player.PlayerGui.GameUI
end

function GameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character

    local a = Knit.Player.PlayerGui.GameUI
    local MoneyLabel = a.MoneyLabel

    local function displayCoins (coins)
        MoneyLabel.Text = "$" .. tostring(coins)
    end

    displayCoins(DataService.GetData("Coins"))

    DataService.CoinsChanged:Connect (displayCoins)

    local afkButton = a:FindFirstChild("Buttons"):FindFirstChild("afkButton")
    local isAFKToggled = Knit.Player:FindFirstChild("isAFK")

    local function updateAFK ()
        if (isAFKToggled.Value) then
            afkButton.TextLabel.Text = "AFK"
        else
            afkButton.TextLabel.Text = "Playing"
        end
    end

    afkButton.MouseButton1Click:Connect(function()
        GameService:ToggleAFK()
        updateAFK()
    end)

    local UI = a
    local ResultsFrame = UI:FindFirstChild("EndResults")
    ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
    ResultsFrame.earnedLabel.Text = ""

    GameService.ShowResults:Connect (function(endScreen)

        print (endScreen)
        Tween:Create (ResultsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 0.5, 0) }):Play ()

        for i,v in pairs (endScreen) do
            local userName = i
            local message = v.Message
            local won = v.Won
    
            local label = script.UsernameLabel:Clone()
            label.Text = " @" .. userName
            label.Parent = ResultsFrame.ResultList

            local earnedCoins = ResultsFrame.earnedLabel
            label.ResultLabel.Text = message
            
            if (won == true) then
                label.ResultLabel.TextColor3 = Color3.new (0, 1, 0)
            else
                label.ResultLabel.TextColor3 = Color3.new (1, 0, 0)
            end
            if (userName == Knit.Player.Name) then
                --label.TextColor3 = Color3.fromRGB(218, 145, 0)
                Tween:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB (218, 145, 0) }):Play()
            else
                Tween:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB (255, 255, 255) }):Play()
            end
            earnedCoins.Text = ("Earned +%s coins"):format(v.Coins)
        end
       wait (10)
        Tween:Create (ResultsFrame, TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 1.5, 0) }):Play()
    end)
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")
end


return GameUIController