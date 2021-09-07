local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

local MinigameService = Knit.CreateService {
    Name = "MinigameService";
    Client = {};
}

local ServerStorage = game:GetService("ServerStorage")
local Assets = ServerStorage:FindFirstChild("Assets")
local MapsFolder = Assets:FindFirstChild("Maps")
local ScriptsFolder = Assets:FindFirstChild("MinigameScripts")

--local Minigames = { "ObbyRunaway", "Sweeper", "Swordvival" }
local Minigames = require (Knit.Modules.MinigameData)

local choseMinigame, chosenMap;
function MinigameService.ChooseMinigame ()
    choseMinigame = Minigames[math.random(1, #Minigames)]
    local maps = MapsFolder[choseMinigame]:GetChildren()
    chosenMap = maps[math.random(1, #maps)]

    local clone = chosenMap:Clone()
    clone.Name = choseMinigame

    local currentMScript = ScriptsFolder:FindFirstChild(choseMinigame):Clone()
    currentMScript.Name = "MinigameScript"
    currentMScript.Parent = clone
    return clone
end

function MinigameService:KnitStart()
end

return MinigameService