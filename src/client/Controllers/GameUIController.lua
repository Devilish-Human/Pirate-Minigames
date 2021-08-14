local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Prompt = require(Knit.Modules.Prompt)

local GameUIController = Knit.CreateController { Name = "GameUIController" }

local DataService

function GameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character

    local a = Knit.Player.PlayerGui.GameUI
    local MoneyLabel = a.MoneyLabel

    local coins = DataService.GetData("Coins")
    MoneyLabel.Text = "$" .. tostring(coins)

    DataService.CoinsChanged:Connect (function(_coins)
        MoneyLabel.Text = "$" .. tostring(_coins)
    end)

end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
end


return GameUIController