local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Janitor = require(Knit.Util.Janitor)

local Tween = game:GetService("TweenService")

local Prompt = require(Knit.Modules.Prompt)
local ConvertComma = require(Knit.Modules.ConvertComma)
local Icon = require(Knit.Shared.TopbarPlus)

local GameUIController = Knit.CreateController { Name = "GameUIController" }

local DataService, GameService

function GameUIController:GetGameUI ()
    return Knit.Player.PlayerGui.GameUI
end

local UIJanitor = Janitor.new()

function GameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character

    local GameUI = Knit.Player.PlayerGui.GameUI

    Icon.new()
        :setName("CoinIcon")
        :setImage(363483133)
        :setLabel(DataService.GetData("Coins"))
        :setRight()
        :lock()
        :give(function(icon)
            return DataService.CoinsChanged:Connect(function(coins)
                icon:setLabel(tostring(coins))
                if coins >= 1000 then
                    icon:setCaption(tostring(ConvertComma(coins)))
                end
            end)
        end)

    local afkButton = GameUI:FindFirstChild("Buttons"):FindFirstChild("afkButton")
    local isAFKToggled = Knit.Player:FindFirstChild("isAFK")

    local function updateAFK ()
        if (isAFKToggled.Value) then
            afkButton.TextLabel.Text = "AFK"
        else
            afkButton.TextLabel.Text = "Playing"
        end
    end

    UIJanitor:Add(afkButton.MouseButton1Click:Connect(function()
        GameService:ToggleAFK()
        updateAFK()
    end))

    local ResultsFrame = GameUI:FindFirstChild("EndResults")
    local usernameLabel = script.UsernameLabel
    ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
    ResultsFrame.earnedLabel.Text = ""

    --[[ local uiList = Instance.new ("UIListLayout")
    uiList.Parent = ResultsFrame.ResultList
    uiList.Padding = UDim.new (0, 3) ]]

    UIJanitor:Add(GameService.ShowResults:Connect(function(...)
        local NumberSpinner = require(Knit.Shared.NumberSpinner)
        local labelSpinner = NumberSpinner.new()

        ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
        local endResult = ...

        Tween:Create (ResultsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 0.5, 0) }):Play ()

        local x = 0
        for i,v in pairs (endResult) do
            local userName = i
            local message = v.Message
            local won = v.Won

            local label = usernameLabel:Clone()
            label.Text = ((" %s (@%s)"):format(game.Players[userName].DisplayName, userName))
            label.Parent = ResultsFrame.ResultList
            label.Position = UDim2.new (0, 0, 0, 32*x)

            local earnedCoins = ResultsFrame.earnedLabel
            label.ResultLabel.Text = message

            if (won == true) then
                label.ResultLabel.TextColor3 = Color3.new (0, 1, 0)
            else
                label.ResultLabel.TextColor3 = Color3.new (1, 0, 0)
            end
            if (userName == Knit.Player.Name) then
                --label.TextColor3 = Color3.fromRGB(218, 145, 0)
                Tween:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { BackgroundColor3 = Color3.fromRGB (218, 145, 0) }):Play()
            else
                Tween:Create (label, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { TextColor3 = Color3.fromRGB (255, 255, 255) }):Play()
            end
            labelSpinner.Commas = false
            labelSpinner.Decimals = 0
            labelSpinner.Duration = 0.24
            labelSpinner.Value = v.Coins
            earnedCoins.Text = ("Earned +%s coins"):format(v.Coins)
            x += 1
        end
       wait (5.5)
        Tween:Create (ResultsFrame, TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new (0.5, 0, 1.5, 0) }):Play()
    end))
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")

    UIJanitor:Cleanup()
end

return GameUIController