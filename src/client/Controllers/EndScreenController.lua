local Knit = require(game:GetService("ReplicatedStorage").Knit)

local EndScreenController = Knit.CreateController { Name = "EndScreenController" }

-- Services
local GameService

-- Controllers
local GameUIController

function EndScreenController:KnitStart ()
    repeat
        wait()
    until Knit.Player.Character

    local UI = GameUIController:GetGameUI ()

    GameService.ShowResults:Connect (function(endScreen)
        local ResultsFrame = UI:FindFirstChild("EndResults")
        ResultsFrame:WaitForChild("ResultList"):ClearAllChildren()
        ResultsFrame.Base.earnedLabel.Text = ""
        
        ResultsFrame:TweenPosition (UDim2.new (0.5, 0, 0.5, 0), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0.5)

        local x
        for i,v in pairs (endScreen) do
            local userName = i
            local message = v.Message
            local won = v.Won
    
            local label = game.ReplicatedStorage.UsernameLabel:Clone()
            label.Text = " " .. userName
            label.Position = UDim2.new (0, 0, 0, 25 * x)
            label.Parent = ResultsFrame.Base.ResultList
    
            local earnedCoins = ResultsFrame.Base.earnedLabel
    
            if (won) then
                label.ResultLabel.TextColor3 = Color3.fromRGB (85, 255, 0)
            else
                label.ResultLabel.TextColor3 = Color3.fromRGB(255, 10, 0)
            end
    
            if (userName == Knit.Player.Username) then
                label.TextColor3 = Color3.fromRGB(218, 145, 0)
            else
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
    
            if (x % 2 == 0) then
                label.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            else
                label.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
    
            earnedCoins.Text = ("Earned +%s coins"):format(v.Coins)
    
            x = x + 1
        end
        ResultsFrame:TweenPosition (UDim2.new (0.5, 0, -1.5, 0), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0.5)
    end)
end

function EndScreenController:KnitInit()
    GameService = Knit.GetService("GameService")

    GameUIController = Knit.GetController ("GameUIController")
end


return EndScreenController