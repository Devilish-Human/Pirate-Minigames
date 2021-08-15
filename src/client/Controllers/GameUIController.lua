local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Prompt = require(Knit.Modules.Prompt)

local GameUIController = Knit.CreateController { Name = "GameUIController" }

local DataService, GameService

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
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")
end


return GameUIController