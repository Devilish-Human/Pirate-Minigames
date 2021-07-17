local Knit = require(game:GetService("ReplicatedStorage").Knit)

local MinigameService = Knit.CreateService {
    Name = "MinigameService";
    Client = {};
}

local ServerStorage = game:GetService("ServerStorage")
local Assets = ServerStorage:FindFirstChild("Assets")
local MapsFolder = Assets:FindFirstChild("Maps")

local Minigames = { "ObbyRunaway" }

function MinigameService.ChooseMinigame ()
    local choseMinigame, chosenMap;
    choseMinigame = Minigames[math.random(1, #Minigames)]
    local maps = MapsFolder[choseMinigame]:GetChildren()
    chosenMap = maps[math.random(1, #maps)]

    chosenMap.Name = choseMinigame
    return chosenMap
end

return MinigameService