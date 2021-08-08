local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

local MinigameService = Knit.CreateService {
    Name = "MinigameService";
    Client = {};
}

local GameService

local ServerStorage = game:GetService("ServerStorage")
local Assets = ServerStorage:FindFirstChild("Assets")
local MapsFolder = Assets:FindFirstChild("Maps")

local Minigames = { "ObbyRunaway" }

MINIGAME = ""
function MinigameService.ChooseMinigame ()
    local choseMinigame, chosenMap;
    choseMinigame = Minigames[math.random(1, #Minigames)]
    local maps = MapsFolder[choseMinigame]:GetChildren()
    chosenMap = maps[math.random(1, #maps)]

    chosenMap.Name = choseMinigame
    MINIGAME = choseMinigame
    return chosenMap:Clone()
end

function MinigameService:KnitStart()
end

function MinigameService:KnitInit()
    GameService = Knit.Services.GameService
end
return MinigameService