local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

return function (_, minigame)
    local MinigameService = Knit.GetService("MinigameService")
    local GameService = Knit.GetService("GameService")

    GameService.SetMinigame:Fire(minigame)

    print(minigame)
end