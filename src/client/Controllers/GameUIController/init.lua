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

    local GameUI = Knit.Player.PlayerGui.GameUI

    local MoneyLabel = GameUI.MoneyLabel

    local function displayCoins (coins)
        MoneyLabel.Text = "$" .. tostring(coins)
    end

    displayCoins(DataService.GetData("Coins"))

    DataService.CoinsChanged:Connect (displayCoins)

    local afkButton = GameUI:FindFirstChild("Buttons"):FindFirstChild("afkButton")
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

    local ResultsFrame = GameUI:FindFirstChild("EndResults")
    local usernameLabel = script.UsernameLabel
    ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
    ResultsFrame.earnedLabel.Text = ""

    --[[ local uiList = Instance.new ("UIListLayout")
    uiList.Parent = ResultsFrame.ResultList
    uiList.Padding = UDim.new (0, 3) ]]

    local function showEndResults (...)
        ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
        local endResult = ...

        print (endResult)

        Tween:Create (ResultsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 0.5, 0) }):Play ()

        local x = 0
        for i,v in pairs (endResult) do
            local userName = i
            local message = v.Message
            local won = v.Won

            local label = usernameLabel:Clone()
            label.Text = ((" %s (@%s)"):format(Knit.Player.DisplayName, userName))
            label.Parent = ResultsFrame.ResultList
            label.Position = UDim2.new (0, 0, 0, 25*x)

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
            x += 1
        end
       wait (10)
        Tween:Create (ResultsFrame, TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 1.5, 0) }):Play()
    end

    GameService.ShowResults:Connect(showEndResults)
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")
end


return GameUIController