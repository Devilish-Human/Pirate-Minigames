local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

return function (context)
    local MinigameService = Knit.GetService("MinigameService")
    print(MinigameService:ChooseMinigame())
end