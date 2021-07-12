local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Number = require(Knit.Shared.Number)
local String = require(Knit.Shared.String)

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoundInfo = ReplicatedStorage.Round
local Status = RoundInfo.Status
local Timer = RoundInfo.Time

local GameService = Knit.CreateService {
    Name = "GameService";
    Client = {};
}

local MINIGAMES = { "ObbyRunaway"}
local chosen;

function GameService:_startGame()
    chosen.Parent = workspace.Game
    local AllSpawns = chosen.Spawns:GetChildren()
    
    self:SetStatus("Teleporting players")
    local spawnPoint = AllSpawns[math.random(1, #AllSpawns)]
    local instanceNew = Instance.new("Part")
    instanceNew.Position = spawnPoint.Position + Vector3.new(0, 2, 0)
    spawnPoint:Destroy()

    print("Objective: ", chosen:GetAttribute("Objective"))
    self:SetStatus(chosen:GetAttribute("Objective"))
    wait(3)
    self:SetStatus("Game in progress")
    for i = chosen:GetAttribute("Length"), 1, -1 do
        wait(1)
        i -= 1
        Timer.Value = i
    end

    print("Name: " .. chosen:GetAttribute("Name"), "Objective: " .. chosen:GetAttribute("Objective"))
    workspace.Game:ClearAllChildren()
end

function GameService:_intermission()
    self:SetStatus("Intermission")
    for i = 10, 1, -1 do
        wait(1)
        i -= 1
        Timer.Value = i
    end
    self:SetStatus ("Choosing a minigame game")
    local chosenMinigame = MINIGAMES[math.random(1, #MINIGAMES)]
    local allMaps = ServerStorage.Assets.Maps[chosenMinigame]:GetChildren();
    chosen = allMaps[math.random(1, #allMaps)]:Clone()
    self:SetStatus("Minigame chosen: " .. chosenMinigame)
    if (not chosen) then return end
    print("A")
end

function GameService:_procces ()
    while wait(1) do
        print("Running game")
        self:_intermission()
        self:_startGame()
    end
end

function GameService:GetLength ()
    return Timer.Value
end

function GameService:GetStatus ()
    return Status.Value
end

function GameService.Client:GetLength()
    return self.Server:GetLength()
end

function GameService.Client:GetStatus()
    return self.Server:GetStatus()
end

function GameService:SetStatus (status)
    Status.Value = status
end

function GameService:KnitStart ()
    self:_procces()
end

return GameService